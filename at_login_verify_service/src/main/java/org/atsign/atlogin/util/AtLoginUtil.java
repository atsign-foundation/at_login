package org.atsign.atlogin.util;

public class AtLoginUtil {

    public static String formatAsHiddenPublicKey(String key, String atSign) {
        return "__" + key + formatAtsign(atSign, true);
    }

    /**
     * Formats the atsign as per the requirement of the caller
     *
     * @param atsign       the atsign that is to be formatted
     * @param keepAtSymbol specifies the format requirement of the caller.
     *                     When true: ensures atsign starts with an "@".
     *                     When false: ensures atsign does not start with "@".
     */
    public static String formatAtsign(String atsign, boolean keepAtSymbol) {
        if (keepAtSymbol && !atsign.startsWith("@")) {
            return '@' + atsign;
        } else if (!keepAtSymbol && atsign.startsWith("@")) {
            return atsign.replaceAll("@", "");
        }
        return atsign;
    }

    /**
     * Ensure that the parameter is not null or does not contain an empty value
     *
     * @param parameter is the parameter that is to be validated
     * @param paramName is the name of the parameter
     * <p>
     * throws IllegalArgumentException if the parameter is null or empty
     * Does not throw any exception or return anything when the param is valid
     */
    public static void validateParameter(String parameter, String paramName) {
        if (parameter == null || parameter.equals("")) {
            throw new IllegalArgumentException("Invalid argument provided for parameter: " + paramName);
        }
    }

    public static String formatKey(String key, String atsign){
        if(key.contains("public:")){
            key = key.replace("public:", "");
        }
        if(!key.contains(atsign)){
            return key + formatAtsign(atsign, true);
        }
        return  key;
    }
}
