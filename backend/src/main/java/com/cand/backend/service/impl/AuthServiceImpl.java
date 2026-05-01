package com.cand.backend.service.impl;

import java.time.LocalDateTime;
import java.util.Optional;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.cand.backend.dto.request.RegisterRequest;
import com.cand.backend.entity.Role;
import com.cand.backend.exception.AuthException;
import com.cand.backend.entity.User;
import com.cand.backend.repository.UserRepository;
import com.cand.backend.security.JwtTokenProvider;
import com.cand.backend.service.AuthService;

import jakarta.transaction.Transactional;

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
    @Transactional
    public User authenticate(String email, String password) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new AuthException("Sai tài khoản hoặc mật khẩu"));

        if (!passwordEncoder.matches(password, user.getPassword())) {
            throw new AuthException("Sai tài khoản hoặc mật khẩu");
        }
        return user;
    }

    @Override
    @Transactional
    public Optional<String> verifyOtp(String email, String otp) {
        if (email == null || otp == null) {
            return Optional.empty();
        }

        String normalizedEmail = email.trim();
        String normalizedOtp = otp.trim();

        User user = userRepository.findByEmail(normalizedEmail).orElse(null);
        if (user == null || user.getOtp() == null || user.getOtpExpiryTime() == null) {
            return Optional.empty();
        }
        if (!user.getOtp().equals(normalizedOtp) ||
                !user.getOtpExpiryTime().isAfter(LocalDateTime.now())) {
            return Optional.empty();
        }

        user.setOtp(null);
        user.setOtpExpiryTime(null);
        userRepository.save(user);
        return Optional.of(jwtTokenProvider.generateToken(user.getEmail()));
    }

    @Override
    @Transactional
    public User register(RegisterRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new AuthException("Email đã tồn tại trong hệ thống");
        }

        User user = new User();
        user.setUsername(request.getName());
        user.setFirstName(request.getFirstName());
        user.setLastName(request.getLastName());
        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setRole(request.getRole() != null ? request.getRole() : Role.ROLE_DOAN_VIEN);

        return userRepository.save(user);
    }
}
