package com.cand.backend.exception;

public class AuthException extends RuntimeException {
    public AuthException(String message) {
        super(message);
    }
}
