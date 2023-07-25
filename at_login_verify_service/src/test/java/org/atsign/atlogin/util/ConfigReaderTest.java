package org.atsign.atlogin.util;

import org.junit.Test;

import java.io.IOException;

import static org.junit.Assert.assertEquals;

public class ConfigReaderTest {

    @Test
    public void getRootDomain() throws IOException {
        assertEquals("root.atsign.org", ConfigReader.getProperty("rootServer", "domain"));
    }

    @Test
    public void getRootPort() throws IOException {
        assertEquals("64", ConfigReader.getProperty("rootServer", "port"));
    }
}
