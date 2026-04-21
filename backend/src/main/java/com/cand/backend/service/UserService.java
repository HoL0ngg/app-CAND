package com.cand.backend.service;

import java.util.List;
import java.util.UUID;

import com.cand.backend.dto.UserProfileRequest;
import com.cand.backend.entity.User;

public interface UserService {
    User createUserProfile(UserProfileRequest request);
    List<User> getAllProfiles();
    User getProfileById(UUID id);
    User updateProfile(UUID id, UserProfileRequest request);
    void deleteProfile(UUID id);
    List<User> getAllUsers();
}
