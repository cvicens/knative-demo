package com.example.demo;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * GreeterController
 */
@RestController
public class GreeterController {

    // uncomment this line for new revison rollout change
    @Value("${MESSAGE_PREFIX}")
    private String prefix;

    @GetMapping("/")
    public String greet() {
        // uncomment this line for new revison rollout change
        return prefix + "Java::Knative on OpenShift";
        //return "Java::Knative on OpenShift";
    }
}