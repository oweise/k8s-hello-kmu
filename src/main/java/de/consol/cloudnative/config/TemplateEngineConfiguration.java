package de.consol.cloudnative.config;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.thymeleaf.spring5.ISpringTemplateEngine;
import org.thymeleaf.spring5.SpringTemplateEngine;
import org.thymeleaf.spring5.templateresolver.SpringResourceTemplateResolver;
import org.thymeleaf.templatemode.TemplateMode;

import static java.nio.charset.StandardCharsets.UTF_8;
import static org.thymeleaf.templatemode.TemplateMode.HTML;
import static org.thymeleaf.templatemode.TemplateMode.TEXT;

@Configuration
public class TemplateEngineConfiguration {

    public static final String TEXT_TEMPLATE_ENGINE = "text-template-engine";
    public static final String TEXT_TEMPLATE_RESOLVER = "text-template-resolver";

    @Bean
    public SpringResourceTemplateResolver htmlTemplateResolver(final ApplicationContext context) {
        return getTemplateResolver(context, ".html", HTML);
    }

    @Bean
    @Qualifier(TEXT_TEMPLATE_ENGINE)
    public ISpringTemplateEngine textTemplateEngine(
            @Qualifier(TEXT_TEMPLATE_RESOLVER) final SpringResourceTemplateResolver resolver
    ) {
        final SpringTemplateEngine engine = new SpringTemplateEngine();
        engine.setTemplateResolver(resolver);
        return engine;
    }

    @Bean
    @Qualifier(TEXT_TEMPLATE_RESOLVER)
    public SpringResourceTemplateResolver textTemplateResolver(final ApplicationContext context) {
        return getTemplateResolver(context, "", TEXT);
    }

    private SpringResourceTemplateResolver getTemplateResolver(
            final ApplicationContext context,
            final String suffix,
            final TemplateMode templateMode
    ) {
        final SpringResourceTemplateResolver templateResolver = new SpringResourceTemplateResolver();
        templateResolver.setApplicationContext(context);
        templateResolver.setPrefix("classpath:/templates/");
        templateResolver.setSuffix(suffix);
        templateResolver.setTemplateMode(templateMode);
        templateResolver.setCharacterEncoding(UTF_8.name());
        return templateResolver;
    }
}
