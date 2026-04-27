package com.cand.backend.service;

import java.util.List;
import java.util.UUID;
import com.cand.backend.dto.UserProfileRequest;
import com.cand.backend.entity.User;

public interface UserService {
    // --- PHẦN AUTH (Của nhóm) ---
    User authenticate(String email, String password);
    void saveOtp(User user, String otp);
    boolean verifyOtp(String email, String otp);
    void sendOtpEmail(String to, String otp);

    // --- PHẦN TSK-007 (Của Phi Hùng - Dùng UUID) ---
    User createUserProfile(UserProfileRequest request);
    List<User> getAllProfiles();
    User getProfileById(UUID id);
    User updateProfile(UUID id, UserProfileRequest request);
    void deleteProfile(UUID id);
    List<User> getAllUsers();
}