package org.atsign.atlogin.util;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * Bean type class to handle a KeyPair
 */
public class KeyPair {
    public String key;
    public String value;

    public String toJson() throws JsonProcessingException {
        ObjectMapper mapper = new ObjectMapper();
        ObjectNode node = mapper.createObjectNode();
        node.put("key", this.key);
        node.put("value", this.value);
        return mapper.writeValueAsString(node);
    }
}
