package com.cand.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.cand.backend.model.Role;

public interface RoleRepository extends JpaRepository<Role, Long> {
}