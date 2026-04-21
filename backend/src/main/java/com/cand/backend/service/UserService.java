package com.cand.backend.service;

import java.time.LocalDateTime;
import java.util.UUID;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.cand.backend.model.User;
import com.cand.backend.model.Unit;
import com.cand.backend.model.Role;
import com.cand.backend.repository.UserRepository;
import com.cand.backend.repository.UnitRepository;
import com.cand.backend.repository.RoleRepository;
import com.cand.backend.dto.UserProfileRequest;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private JavaMailSender mailSender;
    @Autowired
    private BCryptPasswordEncoder passwordEncoder;
    
    //IMPORT THÊM REPOSITORY CỦA TSK-007
    @Autowired
    private UnitRepository unitRepository;
    @Autowired
    private RoleRepository roleRepository;

    public User authenticate(String email, String password) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Email không tồn tại trên hệ thống!"));

        if (passwordEncoder.matches(password, user.getPassword())) {
            return user;
        } else {
            throw new RuntimeException("Mật khẩu không chính xác!");
        }
    }

    public void saveOtp(User user, String otp) {
        user.setOtp(otp);
        user.setOtpExpiryTime(LocalDateTime.now().plusMinutes(5)); // Hết hạn sau 5 phút
        userRepository.save(user);
    }

    public boolean verifyOtp(String email, String otp) {
        User user = userRepository.findByEmail(email).orElse(null);
        if (user != null && user.getOtp().equals(otp) &&
                user.getOtpExpiryTime().isAfter(LocalDateTime.now())) {

            user.setOtp(null);
            userRepository.save(user);
            return true;
        }
        return false;
    }

    public void sendOtpEmail(String to, String otp) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(to);
        message.setSubject("Mã xác thực OTP của bạn");
        message.setText("Mã OTP của bạn là: " + otp + ". Hiệu lực trong 5 phút.");
        mailSender.send(message);
    }

    // PHẦN 2: NGHIỆP VỤ HỒ SƠ ĐOÀN VIÊN (TSK-007 CỦA BẠN)
    public User createUserProfile(UserProfileRequest request) {
        if (userRepository.existsByStaffCode(request.getStaffCode())) {
            throw new RuntimeException("Mã cán bộ đã tồn tại trong hệ thống!");
        }
        if (userRepository.existsByIdentityNumber(request.getIdentityNumber())) {
            throw new RuntimeException("Số CCCD đã tồn tại trong hệ thống!");
        }

        Unit unit = unitRepository.findById(request.getUnitId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy Đơn vị với ID: " + request.getUnitId()));
        
        Role role = roleRepository.findById(request.getRoleId())
                .orElseThrow(() -> new RuntimeException("Không tìm thấy Vai trò với ID: " + request.getRoleId()));

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
        newUser.setRole(role);

        newUser.setQrSecretKey(generateQrSecretKey(request.getStaffCode()));

        newUser.setStatus("ACTIVE");
        
        newUser.setPassword(passwordEncoder.encode(request.getIdentityNumber()));

        return userRepository.save(newUser);
    }

    private String generateQrSecretKey(String staffCode) {
        return UUID.randomUUID().toString() + "-" + staffCode;
    }

    // PHẦN 3: ĐỌC, CẬP NHẬT VÀ XÓA HỒ SƠ (R-U-D)
    // 1. READ - Lấy danh sách tất cả đoàn viên 
    public List<User> getAllProfiles() {
        return userRepository.findAll().stream()
                .filter(user -> user.getDeletedAt() == null) 
                .toList();
    }

    // 2. READ - Lấy chi tiết 1 hồ sơ theo ID
    public User getProfileById(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hồ sơ với ID: " + id));
        if (user.getDeletedAt() != null) {
            throw new RuntimeException("Hồ sơ này đã bị xóa!");
        }
        return user;
    }

    // 3. UPDATE 
    public User updateProfile(Long id, UserProfileRequest request) {
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
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy Đơn vị"));
            existingUser.setUnit(unit);
        }
        if (request.getRoleId() != null) {
            Role role = roleRepository.findById(request.getRoleId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy Vai trò"));
            existingUser.setRole(role);
        }

        return userRepository.save(existingUser);
    }

    // 4. DELETE 
    public void deleteProfile(Long id) {
        User existingUser = getProfileById(id);
        existingUser.setDeletedAt(LocalDateTime.now()); 
        existingUser.setStatus("DELETED");
        userRepository.save(existingUser);
    }
}