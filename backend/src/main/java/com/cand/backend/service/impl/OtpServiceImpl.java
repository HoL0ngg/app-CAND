package com.cand.backend.service.impl;

import java.time.LocalDateTime;
import java.util.Random;

import org.springframework.stereotype.Service;

import com.cand.backend.entity.User;
import com.cand.backend.repository.UserRepository;
import com.cand.backend.service.OtpService;

@Service
public class OtpServiceImpl implements OtpService {

    private static final int OTP_EXPIRY_MINUTES = 5;

    private final UserRepository userRepository;
    private final Random random = new Random();

    public OtpServiceImpl(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public String generateOtp() {
        return String.valueOf(random.nextInt(899999) + 100000);
    }

    @Override
    public void saveOtp(User user, String otp) {
        user.setOtp(otp);
        user.setOtpExpiryTime(LocalDateTime.now().plusMinutes(OTP_EXPIRY_MINUTES));
        userRepository.save(user);
    }
}
