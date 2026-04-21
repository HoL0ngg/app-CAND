package com.cand.backend.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.cand.backend.entity.User;
import com.cand.backend.repository.UserRepository;
import com.cand.backend.service.UserService;

@Service
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;

    public UserServiceImpl(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }
}
