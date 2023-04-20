package org.atsign.atlogin.service;

import javax.net.SocketFactory;
import javax.net.ssl.SSLSocketFactory;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.Socket;
import java.util.Scanner;

import static org.atsign.atlogin.util.AtLoginUtil.formatAtsign;
import static org.atsign.atlogin.util.AtLoginUtil.validateParameter;

public class AtLoginServiceImpl implements AtLoginService {
    String rootHost;
    String rootPort;

    public AtLoginServiceImpl(String rootHost, String rootPort) {
        this.rootHost = rootHost;
        this.rootPort = rootPort;
    }

    public boolean verifyKey(String atsign, String key, String value) throws IOException {
        validateParameter(atsign, "atsign");
        validateParameter(key, "key");
        validateParameter(value, "value");

        Socket secondarySocket = getSecondarySocket(atsign);
        // lookup for key
        String response = executeCommand("lookup:" + key + formatAtsign(atsign, true),
                new PrintWriter(secondarySocket.getOutputStream()),
                new Scanner((Readable) secondarySocket));
        response = response.replaceFirst("@data:", "");

        return response.equals(value);
    }

    private Socket getSecondarySocket(String atsign) throws IOException {
        // create socket to RootServer
        Socket rootSocket = createSocket(rootHost, rootPort);

        // get secondary address
        String response = executeCommand(formatAtsign(atsign, false),
                new PrintWriter(rootSocket.getOutputStream()),
                new Scanner((Readable) rootSocket));

        response = response.replace("@", "");
        String secondaryHost = response.split(":")[0];
        String secondaryPort = response.split(":")[1];

        // create socket for SecondaryServer
        return createSocket(secondaryHost, secondaryPort);
    }

    private Socket createSocket(String host, String port) throws IOException {
        SocketFactory socketFactory = SSLSocketFactory.getDefault();
        return socketFactory.createSocket(host, Integer.parseInt(port));
    }

    private String executeCommand(String command, PrintWriter socketWriter, Scanner socketScanner) {
        // input atsign into the rootServer
        socketWriter.write(command + "\n");
        socketWriter.flush();
        // fetch secondary address from root server
        String response = socketScanner.nextLine();
        System.out.println("Got response: " + response);
        return response;
    }
}