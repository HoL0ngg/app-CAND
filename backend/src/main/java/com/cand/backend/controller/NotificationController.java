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

import com.cand.backend.dto.PublishNotificationRequest;
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

    /**
     * API gửi thông báo với linh hoạt lựa chọn loại người nhận
     * Client có thể chọn gửi cùng đơn vị hoặc gửi xuống cấp dưới
     */
    @PostMapping("/publish")
    public ResponseEntity<?> publishNotification(@RequestBody PublishNotificationRequest request) {
        try {
            // Lấy thông tin người gửi từ security context
            Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
            String email = ((CustomUserDetails) principal).getUsername();
            User sender = userService.getUserByEmail(email);
            Long senderUnitId = sender.getUnit().getId();

            // Nếu gửi nội bộ, recipientUnitId sẽ là đơn vị của người gửi
            // Tạo đối tượng notification từ request
            Notification notification = new Notification();
            notification.setTitle(request.getTitle());
            notification.setContent(request.getContent());
            notification.setPriority(request.getPriority());
            notification.setSenderId(sender.getId());
            notification.setRecipientUnitId(senderUnitId);

            // Gửi thông báo với lựa chọn gửi nội bộ và danh sách đơn vị cấp dưới được chọn
            Notification newNotification = notificationService.publishNotificationWithRecipients(
                    notification,
                    request.isSendInternal(),
                    request.getSelectedSubordinateUnitIds());

            return ResponseEntity.ok(newNotification);
        } catch (Exception e) {
            return ResponseEntity.status(400).body("Lỗi khi gửi thông báo: " + e.getMessage());
        }
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
