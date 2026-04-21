package com.cand.backend.service;

public interface EmailService {

    void sendOtpEmail(String to, String otp);
}
