package com.cand.backend.service;

import com.cand.backend.entity.User;

import jakarta.transaction.Transactional;

public interface OtpService {

    String generateOtp();

    @Transactional
    void saveOtp(User user, String otp);
}
