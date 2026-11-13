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

    public static String getMailUser() {
        return DBConnection.getEnvOrDefault("MAIL_USERNAME", "librarysystemxyz@gmail.com");
    }

    public static String getMailPass() {
        return DBConnection.getEnvOrDefault("MAIL_PASSWORD", "gwqs dles giwy rxvc");
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
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", getMailHost());
        props.put("mail.smtp.port", getMailPort());
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        // Strict socket timeouts to avoid blocking server threads (4 seconds max)
        props.put("mail.smtp.connectiontimeout", "4000");
        props.put("mail.smtp.timeout", "4000");
        props.put("mail.smtp.writetimeout", "4000");

        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(user, pass);
            }
        });
    }

    public static boolean sendEmail(String to, String subject, String messageText) {
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
            return true;
        } catch (Exception e) {
            System.err.println("Email sending failed to " + to + ": " + e.getMessage());
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
