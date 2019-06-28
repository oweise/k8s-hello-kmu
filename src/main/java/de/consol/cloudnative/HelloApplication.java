package de.consol.cloudnative;

import de.consol.cloudnative.config.ConfigComponentScan;
import de.consol.cloudnative.data.dao.DaoComponentScan;
import de.consol.cloudnative.front.web.WebComponentScan;
import de.consol.cloudnative.service.ServiceComponentScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan(basePackageClasses = {
        ConfigComponentScan.class,
        WebComponentScan.class,
        DaoComponentScan.class,
        ServiceComponentScan.class
})
public class HelloApplication {

    public static void main(String[] args) {
        SpringApplication.run(HelloApplication.class, args);
    }
}
