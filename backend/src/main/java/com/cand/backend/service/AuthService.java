package com.cand.backend.service;

import java.util.Optional;

import com.cand.backend.dto.request.RegisterRequest;
import com.cand.backend.entity.User;

public interface AuthService {

    User authenticate(String email, String password);

    Optional<String> verifyOtp(String email, String otp);

    User register(RegisterRequest request);
}
