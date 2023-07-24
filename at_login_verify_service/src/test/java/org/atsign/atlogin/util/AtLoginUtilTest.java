package org.atsign.atlogin.util;

import org.junit.Test;

import static org.atsign.atlogin.util.AtLoginUtil.*;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertThrows;

public class AtLoginUtilTest {

    @Test
    public void formatAsHiddenPublicKeyTest(){
        assertEquals ("__test_key@alice", formatAsHiddenPublicKey("test_key", "alice"));
        assertEquals ("__test_key1@bob", formatAsHiddenPublicKey("test_key1", "@bob"));
    }

    @Test
    public void formatAtsignTest(){
        assertEquals ("@alice", formatAtsign("alice", true));
        assertEquals ("@alice", formatAtsign("@alice", true));

        assertEquals ("bob", formatAtsign("bob", false));
        assertEquals ("bob", formatAtsign("@bob", false));
    }

    @Test
    public void formatKeyTest(){
        assertEquals ("test_key@charles", formatKey("test_key", "charles"));
        assertEquals ("test_key@charles", formatKey("test_key", "@charles"));

        assertEquals ("__test_key@charles", formatKey("__test_key@charles", "charles"));
        assertEquals ("__test_key@charles", formatKey("__test_key@charles", "@charles"));

        assertEquals ("__test_key@charles", formatKey("public:__test_key", "charles"));
        assertEquals ("test_key@charles", formatKey("public:test_key", "@charles"));
    }

    @Test
    public void validateParamTest(){
        assertThrows(IllegalArgumentException.class,
                () -> validateParameter("", "testParam"));
        assertThrows(IllegalArgumentException.class,
                () -> validateParameter(null, "testParam"));

    }

}
