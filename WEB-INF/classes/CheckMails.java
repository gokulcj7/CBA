import java.io.IOException;
import java.io.*;
import java.sql.SQLException;

import java.util.Properties;

import javax.mail.*;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Flags.Flag;
import javax.mail.search.FlagTerm;

import org.json.JSONException;

public class CheckMails {

    static Properties properties = null;
    private static Session session = null;
    private static Store store = null;
    private static Folder inbox = null;
    private static String userName = "cbahelpv2@gmail.com";
    private static String password = "kpkmvdrifblnukoy";
    public static String fromemail = "";
    public static int error = 0;
    public static int check1 = 0;
    public static String url1 = "";

    public static String processMessageBody(Message message) throws JSONException, SQLException {
        String res = "";
        try {
            Object content = message.getContent();
            if (content instanceof String) {
                System.out.println(content);
            } else if (content instanceof Multipart) {
                Multipart multiPart = (Multipart) content;
                res = procesMultiPart(multiPart);
            } else if (content instanceof InputStream) {
                try (InputStream inStream = (InputStream) content) {
                    int ch;
                    while ((ch = inStream.read()) != -1) {
                        System.out.write(ch);
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        } catch (MessagingException e) {
            e.printStackTrace();
        }

        return res;
    }

    public static String procesMultiPart(Multipart content) throws JSONException, SQLException {
        String res = "";
        try {
            int multiPartCount = content.getCount();
            for (int i = 0; i < multiPartCount; i++) {
                BodyPart bodyPart = content.getBodyPart(i);
                Object o;
                o = bodyPart.getContent();
                if (o instanceof String) {
                    // System.out.println(o);
                    ParseData.getData(o);
                    break;
                } else if (o instanceof Multipart) {
                    procesMultiPart((Multipart) o);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        } catch (MessagingException e) {
            e.printStackTrace();
        }
        return res;
    }

    public static void receiveUrl(String url, int check) {

        if (check == 2)
            SendEmail.sendMessage(fromemail, url);
        if (check == 1)
            SendEmail.noBeds(fromemail);
        if (check == 0)
            SendEmail.sendError(fromemail);

    }

    public static void mailThread() {
        Thread readMail = new Thread(new Runnable() {
            @Override
            public void run() {
                System.out.println("Mail thread started");
                while (true) {
                    properties = new Properties();
                    properties.setProperty("mail.host", "imap.gmail.com");
                    properties.setProperty("mail.port", "995");
                    properties.setProperty("mail.transport.protocol", "imaps");
                    session = Session.getInstance(properties,
                            new javax.mail.Authenticator() {
                                protected PasswordAuthentication getPasswordAuthentication() {
                                    return new PasswordAuthentication(userName, password);
                                }
                            });

                    try {
                        store = session.getStore("imaps");
                        store.connect();
                        inbox = store.getFolder("INBOX");
                        inbox.open(Folder.READ_WRITE);
                        Message messages[] = inbox.search(new FlagTerm(
                                new Flags(Flag.SEEN), false));

                        Message message = messages[0];
                        Address[] from = message.getFrom();
                        String femail[] = from[0].toString().split("<");
                        femail[1] = femail[1].substring(0, femail[1].length() - 1);
                        fromemail = femail[1];

                        if (message.getSubject().equals("Search Beds")) {
                            processMessageBody(message);
                            inbox.setFlags(new Message[] { message }, new Flags(Flags.Flag.SEEN), true);
                        }
                        inbox.close(true);
                        store.close();
                    } catch (Exception e) {

                    }
                    try {
                        Thread.sleep(10000);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
            }
        });
        readMail.start();
    }

}
