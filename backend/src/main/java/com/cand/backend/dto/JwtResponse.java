package com.cand.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor // Quan trọng: Để có thể dùng new JwtResponse(token)
public class JwtResponse {
    private String token;
}