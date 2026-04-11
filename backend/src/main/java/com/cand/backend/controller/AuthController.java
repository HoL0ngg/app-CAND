package com.cand.backend.controller;

import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.cand.backend.dto.JwtResponse;
import com.cand.backend.dto.LoginRequest;
import com.cand.backend.dto.OtpRequest;
import com.cand.backend.model.User;
import com.cand.backend.security.JwtTokenProvider;
import com.cand.backend.service.UserService;

@RestController
@RequestMapping("/api/auth")
public class AuthController {
    @Autowired
    private UserService userService;
    @Autowired
    private JwtTokenProvider jwtTokenProvider;

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest loginRequest) {
        User user = userService.authenticate(loginRequest.getEmail(), loginRequest.getPassword());
        if (user != null) {
            // Tạo OTP ngẫu nhiên 6 số
            String otp = String.valueOf(new Random().nextInt(899999) + 100000);
            userService.saveOtp(user, otp);
            userService.sendOtpEmail(user.getEmail(), otp);

            return ResponseEntity.ok("OTP đã được gửi vào Email của bạn.");
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Sai tài khoản hoặc mật khẩu");
    }

    @PostMapping("/verify-otp")
    public ResponseEntity<?> verifyOtp(@RequestBody OtpRequest otpRequest) {
        boolean isValid = userService.verifyOtp(otpRequest.getEmail(), otpRequest.getOtp());

        if (isValid) {
            // Tạo JWT Token ở đây
            String token = jwtTokenProvider.generateToken(otpRequest.getEmail());
            return ResponseEntity.ok(new JwtResponse(token));
        }
        return ResponseEntity.badRequest().body("Mã OTP không chính xác hoặc đã hết hạn");
    }
}
