import java.util.Properties;

import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class SendEmail {
    public static final String email = "cbahelpv2@gmail.com";
    public static final String password = "kpkmvdrifblnukoy";

    public static Session getSession() {
        Properties properties = new Properties();
        properties.setProperty("mail.smtp.host", "smtp.gmail.com");
        properties.setProperty("mail.smtp.port", "587");
        properties.setProperty("mail.smtp.socketFactory.port", "465");
        properties.setProperty("mail.smtp.ssl.trust", "smtp.gmail.com");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.auth", "true");

        Session session = Session.getDefaultInstance(properties, new javax.mail.Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(email, password);
            }
        });

        return session;
    }

    public static MimeMessage constructMessage(String toemail, String subject, String body)
            throws AddressException, MessagingException {
        MimeMessage message = new MimeMessage(getSession());
        message.setFrom(new InternetAddress(email)); // From address
        message.setRecipients(MimeMessage.RecipientType.TO, InternetAddress.parse(toemail)); // To address
        message.setSubject(subject); // Subject
        message.setText(body);
        return message;
    }

    public static void sendError(String fromemail) {

        try {
            MimeMessage message = constructMessage(fromemail, "Bed Availability",
                    "Invalid format.Use the above format to perform search request\nName: {Hospital Name}\nLocation: {Hospital Location}\nNormal Beds > {Bed count}\nOxygen Beds > {Bed count}\nICU Beds > {Bed count}");
            Transport.send(message);
            System.out.println("MAIL SENT");
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    public static void noBeds(String fromemail) {
        try {
            MimeMessage message = constructMessage(fromemail, "Bed Availability", "No Beds Available");
            Transport.send(message);
            System.out.println("MAIL SENT");
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    public static void sendMessage(String fromemail, String url) {
        try {
            String body = "Use the above link to view the bed availability:" + url;
            MimeMessage message = constructMessage(fromemail, "Bed Availability", body);
            Transport.send(message);
            System.out.println("MAIL SENT");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
