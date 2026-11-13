package LibraryManagement;

import java.io.File;
import java.nio.file.Files;
import java.util.Base64;
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
        return DBConnection.getFirstNonEmptyEnv("MAIL_USERNAME", "BREVO_SENDER_EMAIL", "MAIL_FROM");
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

    public static boolean sendEmail(String to, String subject, String messageText) {
        return sendEmailWithAttachment(to, subject, messageText, null);
    }

    public static boolean sendEmailWithAttachment(String to, String subject, String messageText, String attachmentPath) {
        lastError = null;
        if (!isMailEnabled() || to == null || to.trim().isEmpty()) {
            System.out.println("Email sending skipped for: " + to);
            return true;
        }

        // 1. Brevo HTTPS REST API (Port 443 - works on Render Free Tier without SMTP blocks)
        String brevoKey = DBConnection.getFirstNonEmptyEnv("BREVO_API_KEY", "BREVO_KEY", "SENDINBLUE_API_KEY", "SENDINBLUE_KEY");
        if (brevoKey != null && !brevoKey.trim().isEmpty()) {
            return sendViaBrevo(to, subject, messageText, attachmentPath, brevoKey.trim());
        }

        // 2. Resend HTTPS REST API (Port 443)
        String resendKey = DBConnection.getFirstNonEmptyEnv("RESEND_API_KEY", "RESEND_KEY");
        if (resendKey != null && !resendKey.trim().isEmpty()) {
            return sendViaResend(to, subject, messageText, resendKey.trim());
        }

        // 3. Fallback to standard SMTP (May be blocked on cloud free tiers like Render)
        return sendViaSmtp(to, subject, messageText, attachmentPath);
    }

    private static boolean sendViaBrevo(String to, String subject, String messageText, String attachmentPath, String apiKey) {
        try {
            java.net.URL url = new java.net.URL("https://api.brevo.com/v3/smtp/email");
            java.net.HttpURLConnection conn = (java.net.HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("api-key", apiKey);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("accept", "application/json");
            conn.setDoOutput(true);
            conn.setConnectTimeout(10000);
            conn.setReadTimeout(10000);

            String senderEmail = DBConnection.getFirstNonEmptyEnv("BREVO_SENDER_EMAIL", "MAIL_FROM", "MAIL_USERNAME");
            if (senderEmail == null || senderEmail.trim().isEmpty()) {
                senderEmail = "chowdhuryayush7@gmail.com";
            }
            String senderName = DBConnection.getFirstNonEmptyEnv("BREVO_SENDER_NAME", "MAIL_SENDER_NAME");
            if (senderName == null || senderName.trim().isEmpty()) {
                senderName = "Library Management System";
            }

            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"sender\":{\"name\":\"").append(jsonEscape(senderName)).append("\",\"email\":\"").append(jsonEscape(senderEmail.trim())).append("\"},");
            json.append("\"to\":[{\"email\":\"").append(jsonEscape(to.trim())).append("\"}],");
            json.append("\"subject\":\"").append(jsonEscape(subject)).append("\",");
            json.append("\"textContent\":\"").append(jsonEscape(messageText)).append("\",");
            json.append("\"htmlContent\":\"<div style='font-family:sans-serif;line-height:1.6;'>").append(jsonEscape(messageText).replace("\\n", "<br/>")).append("</div>\"");

            if (attachmentPath != null) {
                File file = new File(attachmentPath);
                if (file.exists() && file.isFile()) {
                    byte[] fileBytes = Files.readAllBytes(file.toPath());
                    String base64Content = Base64.getEncoder().encodeToString(fileBytes);
                    json.append(",\"attachment\":[{\"name\":\"").append(jsonEscape(file.getName())).append("\",\"content\":\"").append(base64Content).append("\"}]");
                }
            }

            json.append("}");

            try (java.io.OutputStream os = conn.getOutputStream()) {
                os.write(json.toString().getBytes("utf-8"));
            }

            int code = conn.getResponseCode();
            if (code >= 200 && code < 300) {
                System.out.println("[BREVO] Email successfully sent to: " + to + " (HTTP " + code + ")");
                lastError = null;
                return true;
            }

            StringBuilder errBody = new StringBuilder();
            java.io.InputStream es = conn.getErrorStream();
            if (es != null) {
                try (java.io.BufferedReader br = new java.io.BufferedReader(new java.io.InputStreamReader(es, "utf-8"))) {
                    String line;
                    while ((line = br.readLine()) != null) {
                        errBody.append(line);
                    }
                }
            }
            lastError = "Brevo HTTP " + code + ": " + errBody.toString();
            System.err.println("[BREVO ERROR] HTTP " + code + " | Sender: " + senderEmail + " | To: " + to + " | Response: " + errBody);
            return false;

        } catch (Exception e) {
            lastError = "Brevo API: " + e.getMessage();
            e.printStackTrace();
            return false;
        }
    }

    private static boolean sendViaResend(String to, String subject, String messageText, String apiKey) {
        try {
            java.net.URL url = new java.net.URL("https://api.resend.com/emails");
            java.net.HttpURLConnection conn = (java.net.HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Authorization", "Bearer " + apiKey);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);
            conn.setConnectTimeout(10000);
            conn.setReadTimeout(10000);

            String fromEmail = DBConnection.getEnvOrDefault("MAIL_FROM", "onboarding@resend.dev");
            String safeSubject = jsonEscape(subject);
            String safeText = jsonEscape(messageText);
            String json = "{\"from\":\"" + fromEmail + "\",\"to\":[\"" + jsonEscape(to.trim()) + "\"],\"subject\":\"" + safeSubject + "\",\"text\":\"" + safeText + "\"}";

            try (java.io.OutputStream os = conn.getOutputStream()) {
                os.write(json.getBytes("utf-8"));
            }

            int code = conn.getResponseCode();
            if (code >= 200 && code < 300) {
                System.out.println("[RESEND] Email successfully sent to: " + to);
                lastError = null;
                return true;
            }

            StringBuilder errBody = new StringBuilder();
            java.io.InputStream es = conn.getErrorStream();
            if (es != null) {
                try (java.io.BufferedReader br = new java.io.BufferedReader(new java.io.InputStreamReader(es, "utf-8"))) {
                    String line;
                    while ((line = br.readLine()) != null) errBody.append(line);
                }
            }
            lastError = "Resend API returned HTTP " + code + ": " + errBody;
            System.err.println("[RESEND ERROR] HTTP " + code + " | " + errBody);
            return false;

        } catch (Exception e) {
            lastError = "Resend API: " + e.getMessage();
            e.printStackTrace();
            return false;
        }
    }

    private static boolean sendViaSmtp(String to, String subject, String messageText, String attachmentPath) {
        try {
            String user = getMailUser();
            if (user == null) user = "librarysystemxyz@gmail.com";
            String pass = getMailPass();
            Session session = createSession(user, pass);

            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(user));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(to.trim()));
            message.setSubject(subject);

            if (attachmentPath != null) {
                MimeBodyPart textPart = new MimeBodyPart();
                textPart.setText(messageText);

                Multipart multipart = new MimeMultipart();
                multipart.addBodyPart(textPart);

                File file = new File(attachmentPath);
                if (file.exists() && file.isFile()) {
                    MimeBodyPart attachPart = new MimeBodyPart();
                    attachPart.attachFile(file);
                    multipart.addBodyPart(attachPart);
                }
                message.setContent(multipart);
            } else {
                message.setText(messageText);
            }

            Transport.send(message);
            System.out.println("[SMTP] Email successfully sent to: " + to);
            lastError = null;
            return true;

        } catch (Exception e) {
            String rawErr = (e.getMessage() != null) ? e.getMessage() : e.getClass().getSimpleName();
            if (rawErr.contains("Couldn't connect to host") || rawErr.contains("timeout")) {
                lastError = "Render blocks outbound SMTP port " + getMailPort() + " on free tier. Set BREVO_API_KEY in Environment.";
            } else {
                lastError = rawErr;
            }
            System.err.println("[SMTP ERROR] Sending failed to " + to + " via " + getMailHost() + ":" + getMailPort() + ": " + lastError);
            e.printStackTrace();
            return false;
        }
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

    private static String jsonEscape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "")
                .replace("\t", "\\t");
    }
}
