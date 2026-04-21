package com.cand.backend.dto;

import lombok.Data;
import java.time.LocalDate;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

@Data
public class UserProfileRequest {
    
    @NotBlank(message = "Họ và Tên không được để trống")
    private String name;

    @NotBlank(message = "Mã cán bộ không được để trống")
    private String staffCode;

    private LocalDate dateOfBirth;

    @Size(min = 12, max = 12, message = "Căn cước công dân phải đủ 12 số")
    private String identityNumber;

    private String gender;
    private String hometown;
    private String rank;
    private String position;
    private String phoneNumber;
    

    private Long unitId; 
    private Long roleId; 
}