package com.cand.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.cand.backend.model.User;

public interface UserRepository extends JpaRepository<User, Long> {

}
