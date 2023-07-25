package org.atsign.atlogin.util;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * Wrapper class for REST-Response for a successful API call
 */
public class SuccessResponse {
    boolean verifyStatus;

    public SuccessResponse(boolean verifyStatus) {
        this.verifyStatus = verifyStatus;
    }

    public String toJson() throws JsonProcessingException {
        ObjectMapper mapper = new ObjectMapper();
        ObjectNode node = mapper.createObjectNode();
        node.put("responseType", "success");
        node.put("verificationStatus", verifyStatus);
        return mapper.writerWithDefaultPrettyPrinter().writeValueAsString(node);
    }
}
