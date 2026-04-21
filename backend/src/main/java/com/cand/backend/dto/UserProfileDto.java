package com.cand.backend.dto;

import lombok.Data;
import java.time.LocalDate;
import com.cand.backend.model.User;

@Data
public class UserProfileDto {
    private Long id;
    private String name;
    private String staffCode;
    private LocalDate dateOfBirth;
    private String gender;
    private String rank;
    private String position;
    private String unitName;
    private String roleName;
    private String status;
    private String qrSecretKey;

    // Hàm tiện ích giúp copy dữ liệu từ Entity sang DTO một cách an toàn
    public static UserProfileDto fromEntity(User user) {
        UserProfileDto dto = new UserProfileDto();
        dto.setId(user.getId());
        dto.setName(user.getName());
        dto.setStaffCode(user.getStaffCode());
        dto.setDateOfBirth(user.getDateOfBirth());
        dto.setGender(user.getGender());
        dto.setRank(user.getRank());
        dto.setPosition(user.getPosition());
        dto.setStatus(user.getStatus());
        dto.setQrSecretKey(user.getQrSecretKey());
        
        if (user.getUnit() != null) dto.setUnitName(user.getUnit().getUnitName());
        if (user.getRole() != null) dto.setRoleName(user.getRole().getRoleName());
        
        return dto;
    }
}