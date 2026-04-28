package com.cand.backend.dto;

import lombok.Data;
import java.time.LocalDate;
import com.cand.backend.entity.Role; 
import jakarta.validation.constraints.NotBlank;

@Data 
public class UserProfileRequest {
    
    @NotBlank(message = "Họ và Tên không được để trống")
    private String name;
    private String staffCode;
    private LocalDate dateOfBirth;
    private String identityNumber;
    private String gender;
    private String hometown;
    private String rank;
    private String position;
    private String phoneNumber;
    
    private Long unitId; 
    private Role role; 
}