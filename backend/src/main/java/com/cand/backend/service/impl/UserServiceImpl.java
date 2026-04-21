package com.cand.backend.service.impl;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.cand.backend.entity.User;
import com.cand.backend.entity.Role;
import com.cand.backend.entity.Unit;
import com.cand.backend.repository.UserRepository;
import com.cand.backend.repository.UnitRepository;
import com.cand.backend.dto.UserProfileRequest;
import com.cand.backend.service.UserService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor // Tự tạo Constructor cho các biến final bên dưới
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final UnitRepository unitRepository;

    @Override
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    @Override
    @Transactional
    public User createUserProfile(UserProfileRequest request) {
        if (userRepository.existsByStaffCode(request.getStaffCode())) {
            throw new RuntimeException("Mã cán bộ đã tồn tại!");
        }

        Unit unit = unitRepository.findById(request.getUnitId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đơn vị"));

        User newUser = new User();
        newUser.setName(request.getName());
        newUser.setStaffCode(request.getStaffCode());
        newUser.setDateOfBirth(request.getDateOfBirth());
        newUser.setIdentityNumber(request.getIdentityNumber());
        newUser.setGender(request.getGender());
        newUser.setHometown(request.getHometown());
        newUser.setRank(request.getRank());
        newUser.setPosition(request.getPosition());
        newUser.setPhoneNumber(request.getPhoneNumber());
        newUser.setUnit(unit);
        
        // Gán Role Enum trực tiếp
        newUser.setRole(request.getRole() != null ? request.getRole() : Role.ROLE_DOAN_VIEN);
        newUser.setQrSecretKey(UUID.randomUUID().toString() + "-" + request.getStaffCode());
        newUser.setStatus("ACTIVE");

        return userRepository.save(newUser);
    }

    @Override
    public List<User> getAllProfiles() {
        return userRepository.findAll().stream()
                .filter(u -> u.getDeletedAt() == null)
                .toList();
    }

    @Override
    public User getProfileById(UUID id) {
        return userRepository.findById(id)
                .filter(u -> u.getDeletedAt() == null)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hồ sơ"));
    }

    @Override
    @Transactional
    public User updateProfile(UUID id, UserProfileRequest request) {
        User existingUser = getProfileById(id);
        
        existingUser.setName(request.getName());
        existingUser.setDateOfBirth(request.getDateOfBirth());
        existingUser.setGender(request.getGender());
        existingUser.setHometown(request.getHometown());
        existingUser.setRank(request.getRank());
        existingUser.setPosition(request.getPosition());
        existingUser.setPhoneNumber(request.getPhoneNumber());

        if (request.getUnitId() != null) {
            Unit unit = unitRepository.findById(request.getUnitId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy đơn vị"));
            existingUser.setUnit(unit);
        }

        if (request.getRole() != null) {
            existingUser.setRole(request.getRole());
        }

        return userRepository.save(existingUser);
    }

    @Override
    @Transactional
    public void deleteProfile(UUID id) {
        User user = getProfileById(id);
        user.setDeletedAt(LocalDateTime.now());
        user.setStatus("DELETED");
        userRepository.save(user);
    }
}