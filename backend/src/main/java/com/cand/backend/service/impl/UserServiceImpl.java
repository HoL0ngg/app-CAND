package com.cand.backend.service.impl;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.cand.backend.entity.User;
import com.cand.backend.entity.Role;
import com.cand.backend.entity.Unit;
import com.cand.backend.repository.UserRepository;
import com.cand.backend.repository.UnitRepository;
import com.cand.backend.dto.UserProfileRequest;
import com.cand.backend.service.UserService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final UnitRepository unitRepository;
    private final JavaMailSender mailSender;
    private final BCryptPasswordEncoder passwordEncoder;

    // ==========================================
    // LOGIC XÁC THỰC & OTP (Phần Auth của nhóm)
    // ==========================================

    @Override
    public User authenticate(String email, String password) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Email không tồn tại trên hệ thống!"));

        if (passwordEncoder.matches(password, user.getPassword())) {
            return user;
        } else {
            throw new RuntimeException("Mật khẩu không chính xác!");
        }
    }

    @Override
    public void saveOtp(User user, String otp) {
        user.setOtp(otp);
        user.setOtpExpiryTime(LocalDateTime.now().plusMinutes(5));
        userRepository.save(user);
    }

    @Override
    public boolean verifyOtp(String email, String otp) {
        User user = userRepository.findByEmail(email).orElse(null);
        if (user != null && user.getOtp() != null && user.getOtp().equals(otp) &&
                user.getOtpExpiryTime().isAfter(LocalDateTime.now())) {
            user.setOtp(null);
            userRepository.save(user);
            return true;
        }
        return false;
    }

    @Override
    public void sendOtpEmail(String to, String otp) {
        if (mailSender != null) {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setTo(to);
            message.setSubject("Mã xác thực OTP của bạn");
            message.setText("Mã OTP của bạn là: " + otp + ". Hiệu lực trong 5 phút.");
            mailSender.send(message);
        }
    }

    // ==========================================
    // LOGIC QUẢN LÝ HỒ SƠ (Phần TSK-007 của Hùng)
    // ==========================================

    @Override
    @Transactional
    public User createUserProfile(UserProfileRequest request) {
        // 1. Kiểm tra trùng lặp
        if (userRepository.existsByStaffCode(request.getStaffCode())) {
            throw new RuntimeException("Mã cán bộ đã tồn tại!");
        }
        if (userRepository.existsByIdentityNumber(request.getIdentityNumber())) {
            throw new RuntimeException("Số CCCD đã tồn tại!");
        }

        // 2. Tìm đơn vị
        Unit unit = unitRepository.findById(request.getUnitId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy Đơn vị"));

        // 3. Tạo User mới
        User newUser = new User();
        newUser.setName(request.getName());
        newUser.setStaffCode(request.getStaffCode());
        newUser.setDateOfBirth(request.getDateOfBirth());
        newUser.setIdentityNumber(request.getIdentityNumber());
        newUser.setGender(request.getGender());
        newUser.setHometown(request.getHometown());
        newUser.setRank(request.getRank());
        newUser.setPosition(request.getPosition());
        newUser.setPhoneNumber(request.getPhoneNumber());
        newUser.setUnit(unit);
        
        // Gán Role (Ưu tiên dùng Enum từ Request, nếu null thì mặc định là Đoàn viên)
        newUser.setRole(request.getRole() != null ? request.getRole() : Role.ROLE_DOAN_VIEN);
        
        // 4. Tạo các thông số mặc định
        newUser.setQrSecretKey(generateQrSecretKey(request.getStaffCode()));
        newUser.setStatus("ACTIVE");
        
        // Mật khẩu mặc định là số CCCD (đã mã hóa)
        newUser.setPassword(passwordEncoder.encode(request.getIdentityNumber()));

        return userRepository.save(newUser);
    }

    @Override
    public List<User> getAllProfiles() {
        return userRepository.findAll().stream()
                .filter(user -> user.getDeletedAt() == null) 
                .toList();
    }

    @Override
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    @Override
    public User getProfileById(UUID id) {
        return userRepository.findById(id)
                .filter(u -> u.getDeletedAt() == null)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hồ sơ hoặc hồ sơ đã bị xóa!"));
    }

    @Override
    @Transactional
    public User updateProfile(UUID id, UserProfileRequest request) {
        User existingUser = getProfileById(id);

        existingUser.setName(request.getName());
        existingUser.setDateOfBirth(request.getDateOfBirth());
        existingUser.setGender(request.getGender());
        existingUser.setHometown(request.getHometown());
        existingUser.setRank(request.getRank());
        existingUser.setPosition(request.getPosition());
        existingUser.setPhoneNumber(request.getPhoneNumber());

        if (request.getUnitId() != null) {
            Unit unit = unitRepository.findById(request.getUnitId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy đơn vị"));
            existingUser.setUnit(unit);
        }

        if (request.getRole() != null) {
            existingUser.setRole(request.getRole());
        }

        return userRepository.save(existingUser);
    }

    @Override
    @Transactional
    public void deleteProfile(UUID id) {
        User user = getProfileById(id);
        user.setDeletedAt(LocalDateTime.now()); 
        user.setStatus("DELETED");
        userRepository.save(user);
    }

    // Hàm bổ trợ tạo mã QR
    private String generateQrSecretKey(String staffCode) {
        return UUID.randomUUID().toString() + "-" + staffCode;
    }
}