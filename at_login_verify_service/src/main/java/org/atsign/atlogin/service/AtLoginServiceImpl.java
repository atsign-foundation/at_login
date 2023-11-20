package org.atsign.atlogin.service;

import javax.net.SocketFactory;
import javax.net.ssl.SSLSocketFactory;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.Socket;
import java.net.SocketException;
import java.util.Scanner;

import static org.atsign.atlogin.util.AtLoginUtil.*;

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
        // lookup for a key
        String response;
        try {
            response = executeCommand("lookup:" + formatKey(key, atsign),
                    new PrintWriter(secondarySocket.getOutputStream()),
                    new Scanner(secondarySocket.getInputStream()));
            response = response.replaceFirst("@data:", "");
        } catch (Exception e){
            System.out.println("[Verify Service] Caught Exception: " + e);
            throw new SocketException("Unable to lookup key" + key + "on secondary");
        }
        System.out.println(response);
        System.out.println("[Verify Service] Created socket to secondary server successfully");
        return response.equals(value);
    }

    @Override
    public boolean validateSignature(String key, String signature) {
        return false;
    }

    private Socket getSecondarySocket(String atsign) throws SocketException {
        // create socket to RootServer
        Socket rootSocket;
        try {
            rootSocket = createSocket(rootHost, rootPort);
        } catch (Exception e){
            System.out.println("[Verify Service] Caught Exception: " + e);
            throw new SocketException("Unable to connect to root secondary");
        }
        System.out.println("[Verify Service] Opened a socket to RootServer successfully");
        // get secondary address
        String response;
        try {
            response = executeCommand(formatAtsign(atsign, false),
                    new PrintWriter(rootSocket.getOutputStream()),
                    new Scanner(rootSocket.getInputStream()));
        } catch (Exception e){
            System.out.println("[Verify Service] Caught Exception: " + e);
            throw new SocketException("Unable to find address for atsign: " + atsign);
        }
        response = response.replace("@", "");
        String secondaryHost = response.split(":")[0];
        String secondaryPort = response.split(":")[1];

        // create socket for SecondaryServer
        Socket secondarySocket;
        try {
            secondarySocket = createSocket(secondaryHost, secondaryPort);
        } catch (Exception e){
            System.out.println("[Verify Service] Caught Exception: " + e);
            throw new SocketException("Unable to connect to secondary server for: " + atsign);
        }
        return  secondarySocket;
    }

    private Socket createSocket(String host, String port) throws SocketException {
        SocketFactory socketFactory = SSLSocketFactory.getDefault();
        Socket socket;
        try {
            socket = socketFactory.createSocket(host, Integer.parseInt(port));
        } catch (Exception e){
            System.out.println("[Verify Service] Caught exception: " + e);
            throw new SocketException("Unable to create socket for: host=" + host + "port=" + port);
        }
        return socket;
    }

    private String executeCommand(String command, PrintWriter socketWriter, Scanner socketScanner) {
        // input atsign into the rootServer
        String command1 = command + "\n";
        System.out.println("[Verify Service] Executing command :" + command1);
        socketWriter.write(command1);
        socketWriter.flush();
        // fetch secondary address from root server
        String response = socketScanner.nextLine();
        System.out.println("[Verify Service] Got response: " + response);
        return response;
    }
}