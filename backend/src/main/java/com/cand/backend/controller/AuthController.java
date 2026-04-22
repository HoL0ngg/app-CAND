package com.cand.backend.controller;

import java.util.Optional;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.cand.backend.dto.request.LoginRequest;
import com.cand.backend.dto.request.OtpRequest;
import com.cand.backend.dto.request.RegisterRequest;
import com.cand.backend.dto.response.JwtResponse;
import com.cand.backend.entity.User;
import com.cand.backend.service.AuthService;
import com.cand.backend.service.EmailService;
import com.cand.backend.service.OtpService;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;
    private final OtpService otpService;
    private final EmailService emailService;

    public AuthController(AuthService authService, OtpService otpService, EmailService emailService) {
        this.authService = authService;
        this.otpService = otpService;
        this.emailService = emailService;
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody RegisterRequest registerRequest) {
        User user = authService.register(registerRequest);
        return ResponseEntity.ok("Đăng ký thành công tài khoản: " + user.getEmail());
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest loginRequest) {
        User user = authService.authenticate(loginRequest.getEmail(), loginRequest.getPassword());
        String otp = otpService.generateOtp();
        otpService.saveOtp(user, otp);
        emailService.sendOtpEmail(user.getEmail(), otp);
        return ResponseEntity.ok("OTP đã được gửi vào Email của bạn.");
    }

    @PostMapping("/verify-otp")
    public ResponseEntity<?> verifyOtp(@RequestBody OtpRequest otpRequest) {
        Optional<String> token = authService.verifyOtp(otpRequest.getEmail(), otpRequest.getOtp());
        if (token.isPresent()) {
            return ResponseEntity.ok(new JwtResponse(token.get()));
        }
        return ResponseEntity.badRequest().body("Mã OTP không chính xác hoặc đã hết hạn");
    }
}
