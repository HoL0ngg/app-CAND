package com.cand.backend.service;

import com.cand.backend.entity.User;

public interface OtpService {

    String generateOtp();

    void saveOtp(User user, String otp);
}
