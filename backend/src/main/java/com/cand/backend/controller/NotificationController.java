package com.cand.backend.controller;

import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.cand.backend.entity.Notification;
import com.cand.backend.entity.User;
import com.cand.backend.security.CustomUserDetails;
import com.cand.backend.service.NotificationService;
import com.cand.backend.service.UserService;

@RestController
@RequestMapping("/api/notifications")
public class NotificationController {
    @Autowired
    private NotificationService notificationService;

    @Autowired
    private UserService userService;

    // API dành cho Cán bộ / Đoàn viên để phát hành thông báo cho đơn vị
    @PostMapping("/publish")
    public ResponseEntity<?> publishNotification(@RequestBody Notification notification) {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String email = ((CustomUserDetails) principal).getUsername();
        User user = userService.getUserByEmail(email);
        notification.setSenderId(user.getId());

        Notification newNotification = notificationService.publishNotification(notification);
        return ResponseEntity.ok(newNotification);
    }

    // API dành cho Đoàn viên để lấy hòm thư thông báo của mình
    @GetMapping("/inbox")
    public ResponseEntity<?> getInbox() {
        try {
            Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
            String email = ((CustomUserDetails) principal).getUsername();
            User user = userService.getUserByEmail(email);
            return ResponseEntity.ok(notificationService.getInbox(user.getId()));
        } catch (Exception e) {
            System.out.println("Error fetching inbox: " + e.getMessage());
            return ResponseEntity.status(401).body("Unauthorized");
        }

    }

    // API để đánh dấu thông báo đã đọc
    @PostMapping("/{notificationId}/mark-as-read")
    public ResponseEntity<?> markAsRead(@PathVariable Long notificationId, @RequestAttribute("userId") UUID userId) {
        // Trong thực tế, userId nên được trích xuất từ JWT Security Context
        // UUID userId = SecurityUtils.getCurrentUserId();
        notificationService.markAsRead(userId, notificationId);
        return ResponseEntity.ok("Thông báo đã được đánh dấu là đã đọc");
    }
}
