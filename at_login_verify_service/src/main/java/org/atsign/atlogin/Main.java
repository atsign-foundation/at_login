package org.atsign.atlogin;

import org.atsign.atlogin.rest.AtLoginRestImpl;
import org.atsign.atlogin.rest.AtLoginRestWrapper;
import org.atsign.atlogin.service.AtLoginService;
import org.atsign.atlogin.service.AtLoginServiceImpl;
import org.atsign.atlogin.util.ConfigReader;
import org.atsign.atlogin.util.KeyPair;

import java.io.IOException;

public class Main {

    public static void main(String[] args) throws IOException {
        String rootHost = ConfigReader.getProperty("rootServer", "domain");
        String rootPort = ConfigReader.getProperty("rootServer", "port");
        AtLoginRestWrapper restWrapper = new AtLoginRestImpl(rootHost, rootPort);
        if ("startRest".equals(args[0])) {
            restWrapper.start();
        } else if ("generateAuthKeyValue".equals(args[0])) {
            AtLoginService atLogin = new AtLoginServiceImpl(rootHost, rootPort);
            KeyPair keyPair = atLogin.generateAuthenticationKeyAndValue(args[1]);
            System.out.println(keyPair.toJson());
        } else if ("verify".equals(args[0])) {
            AtLoginService atLogin = new AtLoginServiceImpl(rootHost, rootPort);
            if (atLogin.verifyKey(args[0], args[1], args[2])) {
                System.out.println("Verified");
            } else {
                System.out.println("Verification Failed");
            }
        }

    }
}
