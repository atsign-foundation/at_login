package org.atsign.atlogin.util;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * Wrapper class for REST-Response in case of failure
 */
public class ErrorResponse {
    String error;
    String cause;

    public ErrorResponse(String error, String cause) {
        this.error = error;
        this.cause = cause;
    }

    public String toJson() throws JsonProcessingException {
        ObjectMapper mapper = new ObjectMapper();
        ObjectNode node = mapper.createObjectNode();
        node.put("responseType", "failure");
        node.put("error", error);
        node.put("cause", cause);
        node.put("verificationStatus", "false");
        return mapper.writerWithDefaultPrettyPrinter().writeValueAsString(node);
    }
}
