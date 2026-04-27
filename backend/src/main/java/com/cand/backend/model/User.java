package com.cand.backend.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.EnumType;
import lombok.Data;

@Entity
@Table(name = "users")
@Data
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(nullable = false)
    private String name;
    private String email;
    private String password;

    private String otp;
    private LocalDateTime otpExpiryTime;
    private boolean isTwoFactorEnabled = false;

    // PHẦN 2: HỒ SƠ ĐOÀN VIÊN
    @Column(name = "staff_code", unique = true)
    private String staffCode; 

    @Column(name = "date_of_birth")
    private LocalDate dateOfBirth;

    @Column(name = "identity_number", length = 12)
    private String identityNumber; 

    private String gender; 
    private String hometown; 
    
    @Column(name = "rank_name") 
    private String rank; 
    
    private String position;
    
    @Column(name = "phone_number")
    private String phoneNumber;

    // --- LIÊN KẾT ĐỐI TƯỢNG (ASSOCIATION) ---
    @ManyToOne
    @JoinColumn(name = "unit_id")
    private Unit unit;

    @Enumerated(EnumType.STRING)
    @Column(name = "role_name")
    private Role role;

    // --- NGHIỆP VỤ QR & TRẠNG THÁI ---
    @Column(name = "qr_secret_key")
    private String qrSecretKey;

    private String status; 

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt; 
}
