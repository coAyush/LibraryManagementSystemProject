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
        String pass = DBConnection.getEnvOrDefault("MAIL_PASSWORD", "gwqsdlesgiwyrxvc");
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
            lastError = (e.getMessage() != null) ? e.getMessage() : e.getClass().getSimpleName();
            System.err.println("Email sending failed to " + to + " via " + getMailHost() + ":" + getMailPort() + ": " + lastError);
            e.printStackTrace();
            return false;
        }
    }

    public static boolean sendEmailWithAttachment(String to, String subject, String messageText, String attachmentPath) {
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
