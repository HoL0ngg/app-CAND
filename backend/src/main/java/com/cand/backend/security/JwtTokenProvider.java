package com.cand.backend.security;

import io.jsonwebtoken.*;
import org.springframework.stereotype.Component;
import java.util.Date;

@Component
public class JwtTokenProvider {

    private final String JWT_SECRET = "chuoi_bi_mat_cua_long_2026"; // Nên để vào application.properties
    private final long JWT_EXPIRATION = 604800000L; // 7 ngày tính bằng milisecond

    // Tạo ra token từ thông tin email người dùng
    public String generateToken(String email) {
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + JWT_EXPIRATION);

        return Jwts.builder()
                .setSubject(email)
                .setIssuedAt(now)
                .setExpiration(expiryDate)
                .signWith(SignatureAlgorithm.HS512, JWT_SECRET)
                .compact();
    }

    // Các hàm bổ sung: validateToken, getEmailFromJWT (bạn sẽ cần khi làm phân
    // quyền)
}