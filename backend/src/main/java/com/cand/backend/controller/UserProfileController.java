package com.cand.backend.controller;

import java.util.stream.Collectors;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import jakarta.validation.Valid;

import com.cand.backend.dto.UserProfileDto;
import com.cand.backend.dto.UserProfileRequest;
import com.cand.backend.dto.UserProfileResponse; 
import com.cand.backend.model.User;
import com.cand.backend.service.UserService;

@RestController
@RequestMapping("/api/v1/profiles")
public class UserProfileController {

    @Autowired
    private UserService userService;

    // API Tạo mới hồ sơ Đoàn viên (Create) 
    @PostMapping("/create")
    public ResponseEntity<?> createProfile(@Valid @RequestBody UserProfileRequest request) {
        try {
            User createdUser = userService.createUserProfile(request);
            
            UserProfileResponse response = new UserProfileResponse(
                "Tạo hồ sơ đoàn viên thành công!",
                createdUser.getId(),
                createdUser.getQrSecretKey(),
                createdUser.getStaffCode()
            );

            return ResponseEntity.status(HttpStatus.CREATED).body(response);
            
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
    // API Lấy danh sách toàn bộ hồ sơ (Read All)
    @GetMapping("/all")
    public ResponseEntity<?> getAllProfiles() {
        List<UserProfileDto> dtoList = userService.getAllProfiles().stream()
                .map(UserProfileDto::fromEntity)
                .collect(Collectors.toList());
        return ResponseEntity.ok(dtoList);
    }

    // API Xem chi tiết 1 hồ sơ (Read One)
    @GetMapping("/{id}")
    public ResponseEntity<?> getProfile(@PathVariable Long id) {
        try {
            User user = userService.getProfileById(id);
            return ResponseEntity.ok(UserProfileDto.fromEntity(user));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }

    // API Cập nhật hồ sơ (Update)
    @PutMapping("/update/{id}")
    public ResponseEntity<?> updateProfile(@PathVariable Long id, @Valid @RequestBody UserProfileRequest request) {
        try {
            User updatedUser = userService.updateProfile(id, request);
            UserProfileResponse response = new UserProfileResponse(
                "Cập nhật hồ sơ thành công!",
                updatedUser.getId(),
                updatedUser.getQrSecretKey(),
                updatedUser.getStaffCode()
            );
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }

    // API Xóa hồ sơ (Delete)
    @DeleteMapping("/delete/{id}")
    public ResponseEntity<?> deleteProfile(@PathVariable Long id) {
        try {
            userService.deleteProfile(id);
            return ResponseEntity.ok("{\"message\": \"Đã xóa hồ sơ thành công!\"}");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }  
}