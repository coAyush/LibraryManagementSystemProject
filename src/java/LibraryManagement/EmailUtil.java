package LibraryManagement;

import java.io.File;
import java.util.Properties;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

public class EmailUtil {

    private static volatile String lastError = null;

    public static String getLastError() {
        return lastError;
    }

    public static String getMailUser() {
        return DBConnection.getEnvOrDefault("MAIL_USERNAME", "librarysystemxyz@gmail.com");
    }

    public static String getMailPass() {
        String pass = DBConnection.getEnvOrDefault("MAIL_PASSWORD", "ouuqfuobuqhfwpov");
        return pass != null ? pass.replaceAll("\\s+", "") : "";
    }

    public static String getMailHost() {
        return DBConnection.getEnvOrDefault("MAIL_HOST", "smtp.gmail.com");
    }

    public static String getMailPort() {
        return DBConnection.getEnvOrDefault("MAIL_PORT", "587");
    }

    public static boolean isMailEnabled() {
        String enabled = DBConnection.getEnvOrDefault("MAIL_ENABLED", "true");
        return !"false".equalsIgnoreCase(enabled);
    }

    private static Session createSession(final String user, final String pass) {
        String host = getMailHost();
        String port = getMailPort();

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", port);
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.smtp.ssl.trust", "*");

        if ("465".equals(port)) {
            props.put("mail.smtp.ssl.enable", "true");
            props.put("mail.smtp.socketFactory.port", "465");
            props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        } else {
            props.put("mail.smtp.starttls.enable", "true");
        }

        // 10 second socket timeout for cloud network latency
        props.put("mail.smtp.connectiontimeout", "10000");
        props.put("mail.smtp.timeout", "10000");
        props.put("mail.smtp.writetimeout", "10000");

        final String cleanPass = pass != null ? pass.replaceAll("\\s+", "") : "";

        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(user, cleanPass);
            }
        });
    }

    public static boolean sendEmail(String to, String subject, String messageText) {
        lastError = null;
        if (!isMailEnabled() || to == null || to.trim().isEmpty()) {
            System.out.println("Email sending skipped for: " + to);
            return true;
        }

        // 1. If RESEND_API_KEY is configured, send via HTTPS port 443 (never blocked by cloud firewalls)
        if (DBConnection.getFirstNonEmptyEnv("RESEND_API_KEY", "RESEND_KEY") != null) {
            return sendViaResend(to, subject, messageText);
        }

        // 2. Otherwise send via standard SMTP
        try {
            String user = getMailUser();
            String pass = getMailPass();
            Session session = createSession(user, pass);

            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(user));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(to.trim()));
            message.setSubject(subject);
            message.setText(messageText);

            Transport.send(message);
            System.out.println("Email successfully sent to: " + to);
            return true;
        } catch (Exception e) {
            String rawErr = (e.getMessage() != null) ? e.getMessage() : e.getClass().getSimpleName();
            if (rawErr.contains("Couldn't connect to host") || rawErr.contains("timeout")) {
                lastError = "Render blocks outbound SMTP port " + getMailPort() + " on free tier";
            } else {
                lastError = rawErr;
            }
            System.err.println(
                    "Email sending failed to " + to + " via " + getMailHost() + ":" + getMailPort() + ": " + lastError);
            e.printStackTrace();
            return false;
        }
    }

    private static boolean sendViaResend(String to, String subject, String messageText) {
        String apiKey = DBConnection.getFirstNonEmptyEnv("RESEND_API_KEY", "RESEND_KEY");
        if (apiKey == null || apiKey.trim().isEmpty()) {
            return false;
        }
        try {
            java.net.URL url = new java.net.URL("https://api.resend.com/emails");
            java.net.HttpURLConnection conn = (java.net.HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Authorization", "Bearer " + apiKey.trim());
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);
            conn.setConnectTimeout(8000);
            conn.setReadTimeout(8000);

            String fromEmail = DBConnection.getEnvOrDefault("MAIL_FROM", "onboarding@resend.dev");
            String safeSubject = subject.replace("\"", "\\\"");
            String safeText = messageText.replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
            String json = "{\"from\":\"" + fromEmail + "\",\"to\":[\"" + to + "\"],\"subject\":\"" + safeSubject + "\",\"text\":\"" + safeText + "\"}";

            try (java.io.OutputStream os = conn.getOutputStream()) {
                byte[] input = json.getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            int code = conn.getResponseCode();
            if (code >= 200 && code < 300) {
                System.out.println("Email successfully sent via Resend API (HTTPS port 443) to: " + to);
                return true;
            } else {
                lastError = "Resend API returned HTTP " + code;
                System.err.println("Resend API failed: " + lastError);
                return false;
            }
        } catch (Exception e) {
            lastError = "Resend API: " + e.getMessage();
            e.printStackTrace();
            return false;
        }
    }

    public static boolean sendEmailWithAttachment(String to, String subject, String messageText,
            String attachmentPath) {
        if (!isMailEnabled() || to == null || to.trim().isEmpty()) {
            System.out.println("Email sending skipped for: " + to);
            return true;
        }
        try {
            String user = getMailUser();
            String pass = getMailPass();
            Session session = createSession(user, pass);

            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(user));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(to.trim()));
            message.setSubject(subject);

            MimeBodyPart textPart = new MimeBodyPart();
            textPart.setText(messageText);

            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(textPart);

            if (attachmentPath != null) {
                File file = new File(attachmentPath);
                if (file.exists()) {
                    MimeBodyPart attachPart = new MimeBodyPart();
                    attachPart.attachFile(file);
                    multipart.addBodyPart(attachPart);
                } else {
                    System.err.println("Attachment not found on disk: " + attachmentPath);
                }
            }

            message.setContent(multipart);
            Transport.send(message);
            return true;
        } catch (Exception e) {
            System.err.println("Email with attachment sending failed to " + to + ": " + e.getMessage());
            return false;
        }
    }
}
