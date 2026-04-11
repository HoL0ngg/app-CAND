package com.cand.backend.service;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.cand.backend.model.User;
import com.cand.backend.repository.UserRepository;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private JavaMailSender mailSender;
    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    public User authenticate(String email, String password) {
        // Tìm user, nếu không thấy thì ném ra lỗi
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Email không tồn tại trên hệ thống!"));

        // Kiểm tra mật khẩu (mật khẩu gửi lên vs mật khẩu đã mã hóa trong DB)
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

            // Xóa OTP sau khi dùng xong để bảo mật
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
}