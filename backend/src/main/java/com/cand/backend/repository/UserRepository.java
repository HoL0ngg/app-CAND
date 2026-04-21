package com.cand.backend.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.cand.backend.model.User;

public interface UserRepository extends JpaRepository<User, Long> {
    // Tìm kiếm người dùng bằng email để kiểm tra đăng nhập
    Optional<User> findByEmail(String email);

    // Kiểm tra xem email đã tồn tại hay chưa (dùng cho lúc đăng ký)
    Boolean existsByEmail(String email);

    // CÁC HÀM BỔ SUNG CHO TSK-007 (HỒ SƠ ĐOÀN VIÊN)
    Optional<User> findByStaffCode(String staffCode); 
    
    Boolean existsByStaffCode(String staffCode); 
    
    Boolean existsByIdentityNumber(String identityNumber); 
}
