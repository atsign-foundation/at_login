package org.atsign.atlogin.rest;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.log4j.BasicConfigurator;
import org.atsign.atlogin.service.AtLoginServiceImpl;
import org.atsign.atlogin.util.ErrorResponse;
import org.atsign.atlogin.util.KeyPair;
import org.atsign.atlogin.util.SuccessResponse;
import spark.Spark;

import java.util.Map;

@SuppressWarnings("unchecked")
public class AtLoginRestImpl implements AtLoginRestWrapper {
    static final ObjectMapper mapper = new ObjectMapper();
    String rootHost;
    String rootPort;

    public AtLoginRestImpl(String rootHost, String rootPort) {
        this.rootHost = rootHost;
        this.rootPort = rootPort;
    }

    public void start() {
        BasicConfigurator.configure();
        Spark.init();
        Spark.awaitInitialization();

        Spark.post("/generate", ((request, response) -> generateUuidKeypair(String.valueOf(request.body()))));
        Spark.post("/verify", ((request, response) -> verify(request.body())));
        Spark.post("/stop", (request, response) -> stop());
    }

    private boolean stop() {
        Spark.stop();
        return true;
    }

    private String verify(String body) throws JsonProcessingException {
        Map<String, String> postParams;
        boolean isVerified;
        try {
            postParams = processRequestBody(body);
        } catch (Exception e) {
            return new ErrorResponse("Failed processing request body", e.toString()).toJson();
        }

        AtLoginServiceImpl loginService = new AtLoginServiceImpl(rootHost, rootPort);
        try {
            isVerified = loginService.verifyKey(postParams.get("atsign"), postParams.get("key"), postParams.get("value"));
        } catch (Exception e) {
            return new ErrorResponse("Error while verifying", e.toString()).toJson();
        }

        return new SuccessResponse(isVerified).toJson();
    }

    private String generateUuidKeypair(String jsonBody) throws JsonProcessingException {
        AtLoginServiceImpl loginService = new AtLoginServiceImpl(rootHost, rootPort);
        Map<String, String> postBody = processRequestBody(jsonBody);
        System.out.println("Generating UUID Keypair for " + postBody.get("atsign"));
        KeyPair keyPair = loginService.generateAuthenticationKeyAndValue(postBody.get("atsign"));
        return keyPair.toJson();
    }

    private Map<String, String> processRequestBody(String jsonBody) throws JsonProcessingException {
        Map<String, String> parmsMap;
        parmsMap = mapper.readValue(jsonBody, Map.class);
        System.out.println("Request Params are: " + parmsMap);

        return parmsMap;
    }
}
