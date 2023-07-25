package org.atsign.atlogin.service;

import org.mockito.Mock;

import java.io.PrintWriter;
import java.net.Socket;
import java.util.Scanner;

public class AtLoginServiceTest {


}

class MockSocket{
    @Mock
    Socket socket;

    @Mock
    PrintWriter writer;

    @Mock
    Scanner input;
}
