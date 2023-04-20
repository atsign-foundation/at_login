package org.atsign.atlogin.service;

import org.atsign.atlogin.util.AtLoginUtil;
import org.atsign.atlogin.util.KeyPair;

import java.io.IOException;
import java.util.UUID;

/**
 * Contains methods to help login with an atSign
 */
public interface AtLoginService {

    /**
     * Verifies if the given <code>key</code> is present with the given value <code>value</code> for the <code>atSign</code>
     *
     * @param atSign
     * @param key
     * @param value
     * @return true if the value is present in the secondary, else returns false
     * @throws <code>Exception</code> the value cannot be looked up due to any network related issues
     */
    boolean verifyKey(String atSign, String key, String value) throws IOException;

    /**
     * Creates a KeyPair for the given atsign that can be used as authentication token.
     * Generates a random UUID that is later formatted into an AtKey format
     *
     * @param atSign
     * @return A KeyPair class with Key and Value that are ready to be put into an atSign secondary
     */
    default KeyPair generateAuthenticationKeyAndValue(String atSign) {
        // Create a key in the format <entity>.<namespace> format
        // UUID is the entity and .atLogin is the namespace
        String partKey = UUID.randomUUID() + ".atlogin";
        KeyPair keyValue = new KeyPair();
        keyValue.key = AtLoginUtil.formatAsHiddenPublicKey(partKey, atSign);
        keyValue.value = UUID.randomUUID().toString();
        return keyValue;
    }

}
