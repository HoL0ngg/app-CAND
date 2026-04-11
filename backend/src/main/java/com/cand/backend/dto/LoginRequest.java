package com.cand.backend.dto;

import lombok.Data;

@Data // Dùng Lombok để tự tạo Getter/Setter
public class LoginRequest {
    private String email;
    private String password;
}