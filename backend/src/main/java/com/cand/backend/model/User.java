package com.cand.backend.model;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "Nguoi_dung")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(columnDefinition = "UUID")
    // Sử dụng UUID cho ID để tăng tính bảo mật và đồng bộ theo sơ đồ thiết kế
    private UUID id;

    @Column(name = "ten_dang_nhap", unique = true, length = 100, nullable = false)
    private String username;

    @Column(name = "mat_khau", nullable = false)
    private String password;

    @Column(name = "ten", length = 100)
    private String firstName;

    @Column(name = "ho", length = 100)
    private String lastName;

    @Column(name = "ngay_sinh")
    private LocalDate dateOfBirth;

    @Column(name = "so_cccd", length = 12)
    private String identityCardNumber;

    @Column(name = "gioi_tinh", length = 20)
    private String gender;

    @Column(name = "email", length = 255)
    private String email;

    @Column(name = "so_dien_thoai", length = 20)
    private String phoneNumber;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "don_vi_id")
    private Unit unit; // Đơn vị hiện tại (cập nhật sau khi hoàn tất chuyển sinh hoạt)

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "vai_tro_id")
    private Role role;

    @Column(name = "trang_thai", length = 50)
    private String status;

    @CreationTimestamp
    @Column(name = "tao_luc", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "cap_nhat_luc")
    private LocalDateTime updatedAt;

    @Column(name = "xoa_luc")
    private LocalDateTime deletedAt;

    @Column(name = "otp")
    private String otp;

    @Column(name = "otp_expiry_time")
    private LocalDateTime otpExpiryTime;

    @Column(name = "two_factor_enabled")
    private boolean twoFactorEnabled = false;

}