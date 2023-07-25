package org.atsign.atlogin.rest;

public interface AtLoginRestWrapper {

    /**
     * Starts the REST-Service for AtKey verification.
     * Service runs on port=4567 by default.
     * To stop this service call host:4567/stop
     */
    void start();
}
