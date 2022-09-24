import javax.servlet.*;
import javax.servlet.annotation.WebListener;

@WebListener
public class TestListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent arg0) {
        CheckMails.mailThread();
    }
}
