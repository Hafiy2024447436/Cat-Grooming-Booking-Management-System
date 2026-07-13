package catBooking.config;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.jsp.JspFactory;
import org.apache.jasper.runtime.JspFactoryImpl;

@WebListener
public class JspFactoryInitListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        if (JspFactory.getDefaultFactory() == null) {
            JspFactory.setDefaultFactory(new JspFactoryImpl());
        }
    }
}
