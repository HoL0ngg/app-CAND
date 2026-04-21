package com.cand.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class UserProfileResponse {
    private String message;
    private Long userId; 
    private String qrSecretKey;
    private String staffCode;
}