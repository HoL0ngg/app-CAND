package com.cand.backend.repository;

import com.cand.backend.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface UserRepository extends JpaRepository<User, UUID> {
    Optional<User> findByUsername(String username);
    Optional<User> findByEmail(String email);

    // CÁC HÀM BỔ SUNG CHO TSK-007 (HỒ SƠ ĐOÀN VIÊN)
    Optional<User> findByStaffCode(String staffCode); 
    
    Boolean existsByStaffCode(String staffCode); 
    
    Boolean existsByIdentityNumber(String identityNumber); 
}
