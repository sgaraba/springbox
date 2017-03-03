package io.springbox.recommendations;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.neo4j.config.EnableNeo4jRepositories;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.oauth2.config.annotation.web.configuration.ResourceServerConfigurerAdapter;

@SpringBootApplication
@ComponentScan({ "io.springbox.recommendations", "io.springbox.recommendations.config" })
@EnableDiscoveryClient
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class SpringboxRecommendationsApplication extends ResourceServerConfigurerAdapter{

    public static void main(String[] args) {
        SpringApplication.run(SpringboxRecommendationsApplication.class, args);
    }

    @Override
    public void configure(HttpSecurity http) throws Exception {
        http.authorizeRequests().anyRequest().permitAll();

            /*    .antMatchers(HttpMethod.POST, "/recommendations*//**").authenticated()
                .antMatchers(HttpMethod.POST,"/people*//**").authenticated()
                .antMatchers(HttpMethod.POST,"/movie*//**").authenticated()
                .antMatchers(HttpMethod.GET,"/does*//**//*").authenticated()
                .and().authorizeRequests()
                .anyRequest().permitAll();
*/

    }
}
