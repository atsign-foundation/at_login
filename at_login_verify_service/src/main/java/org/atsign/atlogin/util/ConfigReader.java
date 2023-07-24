package org.atsign.atlogin.util;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.dataformat.yaml.YAMLFactory;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

/**
 * Loads, reads and returns properties from the configuration file in the resources
 */
public class ConfigReader {
    private static final ObjectMapper mapper = new ObjectMapper(new YAMLFactory());
    private static HashMap config;

    public static String getProperty(String property, String subProperty) throws IOException {
        if (config == null) {
            loadConfig();
        }
        @SuppressWarnings("unchecked")
        Map<String, String> propertyMap = (Map<String, String>) config.get(property);
        return propertyMap.get(subProperty);
    }

    public static String getProperty(String property) throws IOException {
        if (config == null) {
            loadConfig();
        }
        return (String) config.get(property);
    }

    /**
     * Loads configuration properties from the yaml provided in the java/src/main/resources
     * Stores these key-value pairs in the config map
     */
    public static void loadConfig() throws IOException {
        InputStream inputStream = ClassLoader.getSystemResourceAsStream("config.yaml");
        config = mapper.readValue(inputStream, HashMap.class);
    }
}