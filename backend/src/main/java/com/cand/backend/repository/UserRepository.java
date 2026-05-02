package com.cand.backend.repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.cand.backend.entity.User;

@Repository
public interface UserRepository extends JpaRepository<User, UUID> {
    Optional<User> findByUsername(String username);

    Optional<User> findByEmail(String email);

    // Kiểm tra xem email đã tồn tại hay chưa (dùng cho lúc đăng ký)
    boolean existsByEmail(String email);

    // Tìm tất cả users trong cùng một đơn vị
    @Query("SELECT u.id FROM User u WHERE u.unit.id = :unitId")
    List<UUID> findUserIdsByUnitId(@Param("unitId") Long unitId);

    // Tìm tất cả users trong các đơn vị cấp dưới (con) của một đơn vị cha
    @Query("SELECT u.id FROM User u JOIN Unit unit ON u.unit.id = unit.id WHERE unit.parentUnit.id = :parentUnitId")
    List<UUID> findUserIdsInSubordinateUnits(@Param("parentUnitId") Long parentUnitId);
}