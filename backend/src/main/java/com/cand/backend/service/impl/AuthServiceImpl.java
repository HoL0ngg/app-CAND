package com.cand.backend.service.impl;

import java.time.LocalDateTime;
import java.util.Optional;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.cand.backend.exception.AuthException;
import com.cand.backend.entity.User;
import com.cand.backend.repository.UserRepository;
import com.cand.backend.security.JwtTokenProvider;
import com.cand.backend.service.AuthService;

@Service
public class AuthServiceImpl implements AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtTokenProvider;

    public AuthServiceImpl(
            UserRepository userRepository,
            PasswordEncoder passwordEncoder,
            JwtTokenProvider jwtTokenProvider) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtTokenProvider = jwtTokenProvider;
    }

    @Override
    public User authenticate(String email, String password) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new AuthException("Sai tài khoản hoặc mật khẩu"));

        if (!passwordEncoder.matches(password, user.getPassword())) {
            throw new AuthException("Sai tài khoản hoặc mật khẩu");
        }
        return user;
    }

    @Override
    public Optional<String> verifyOtp(String email, String otp) {
        User user = userRepository.findByEmail(email).orElse(null);
        if (user == null || user.getOtp() == null || user.getOtpExpiryTime() == null) {
            return Optional.empty();
        }
        if (!user.getOtp().equals(otp) || !user.getOtpExpiryTime().isAfter(LocalDateTime.now())) {
            return Optional.empty();
        }

        user.setOtp(null);
        user.setOtpExpiryTime(null);
        userRepository.save(user);
        return Optional.of(jwtTokenProvider.generateToken(email));
    }
}
