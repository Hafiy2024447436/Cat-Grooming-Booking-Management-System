package catBooking.util;

import java.util.Properties;

import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

/**
 * SMTP email helper.
 *
 * Cloud credentials are read from environment variables and are never stored
 * in the source code:
 *   SMTP_HOST, SMTP_PORT, SMTP_USERNAME, SMTP_PASSWORD,
 *   SMTP_FROM_EMAIL, SMTP_FROM_NAME, SMTP_SSL, SMTP_STARTTLS
 */
public final class EmailUtil {

    private static final String DEFAULT_SMTP_HOST = "smtp.gmail.com";
    private static final String DEFAULT_SMTP_PORT = "465";
    private static final String DEFAULT_FROM_NAME = "Meowy Groom";

    private EmailUtil() {
        // Utility class
    }

    public static boolean sendOtpEmail(String toEmail, String otpCode) {
        String subject = "Meowy Groom Password Reset OTP";

        String body = "Hello,\n\n"
                + "Your password reset OTP code is: " + otpCode + "\n\n"
                + "This OTP is valid for 5 minutes.\n"
                + "If you did not request a password reset, please ignore this email.\n\n"
                + "Thank you,\n"
                + "Meowy Groom";

        return sendPlainEmail(toEmail, subject, body);
    }

    public static boolean sendStaffAccountEmail(String toEmail, String username, String temporaryPassword) {
        String subject = "Meowy Groom Staff Account Created";

        String body = "Hello,\n\n"
                + "Your Meowy Groom staff account has been created.\n\n"
                + "Username: " + username + "\n"
                + "Temporary Password: " + temporaryPassword + "\n\n"
                + "Please login using this temporary password and change your password immediately.\n\n"
                + "Thank you,\n"
                + "Meowy Groom";

        return sendPlainEmail(toEmail, subject, body);
    }

    private static boolean sendPlainEmail(String toEmail, String subject, String body) {
        if (isBlank(toEmail) || isBlank(subject) || isBlank(body)) {
            System.err.println("Email configuration error: recipient, subject, or body is empty.");
            return false;
        }

        String smtpHost = env("SMTP_HOST", DEFAULT_SMTP_HOST);
        String smtpPort = env("SMTP_PORT", DEFAULT_SMTP_PORT);
        String smtpUsername = env("SMTP_USERNAME", null);
        String smtpPassword = env("SMTP_PASSWORD", null);
        String fromEmail = env("SMTP_FROM_EMAIL", smtpUsername);
        String fromName = env("SMTP_FROM_NAME", DEFAULT_FROM_NAME);

        if (isBlank(smtpUsername) || isBlank(smtpPassword) || isBlank(fromEmail)) {
            System.err.println(
                    "Email is not configured. Set SMTP_USERNAME, SMTP_PASSWORD, and optionally SMTP_FROM_EMAIL.");
            return false;
        }

        // Gmail app passwords are often displayed in groups separated by spaces.
        smtpPassword = smtpPassword.replace(" ", "").trim();

        boolean sslEnabled = envBoolean("SMTP_SSL", "465".equals(smtpPort));
        boolean startTlsEnabled = envBoolean("SMTP_STARTTLS", !sslEnabled);

        Properties props = new Properties();
        props.put("mail.smtp.host", smtpHost);
        props.put("mail.smtp.port", smtpPort);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.ssl.enable", Boolean.toString(sslEnabled));
        props.put("mail.smtp.starttls.enable", Boolean.toString(startTlsEnabled));
        props.put("mail.smtp.connectiontimeout", "15000");
        props.put("mail.smtp.timeout", "15000");
        props.put("mail.smtp.writetimeout", "15000");

        if (sslEnabled) {
            props.put("mail.smtp.ssl.trust", smtpHost);
        }

        Session session = Session.getInstance(props);
        session.setDebug(false);

        Transport transport = null;

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail, fromName));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail.trim()));
            message.setSubject(subject);
            message.setText(body);

            transport = session.getTransport("smtp");
            transport.connect(smtpHost, smtpUsername, smtpPassword);
            transport.sendMessage(message, message.getAllRecipients());

            System.out.println("Email sent successfully to: " + toEmail.trim());
            return true;

        } catch (MessagingException e) {
            System.err.println("Unable to send email: " + e.getMessage());
            return false;

        } catch (Exception e) {
            System.err.println("Unexpected email error: " + e.getMessage());
            return false;

        } finally {
            try {
                if (transport != null && transport.isConnected()) {
                    transport.close();
                }
            } catch (MessagingException e) {
                System.err.println("Unable to close SMTP connection: " + e.getMessage());
            }
        }
    }

    private static String env(String name, String defaultValue) {
        String value = System.getenv(name);
        return isBlank(value) ? defaultValue : value.trim();
    }

    private static boolean envBoolean(String name, boolean defaultValue) {
        String value = System.getenv(name);
        return isBlank(value) ? defaultValue : Boolean.parseBoolean(value.trim());
    }

    private static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
