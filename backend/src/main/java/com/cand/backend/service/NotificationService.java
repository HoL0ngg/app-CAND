package com.cand.backend.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cand.backend.entity.Notification;
import com.cand.backend.entity.Notification_User;
import com.cand.backend.repository.NotificationRepository;
import com.cand.backend.repository.Notification_UserRepository;
import com.cand.backend.repository.UserRepository;

import jakarta.transaction.Transactional;

@Service
public class NotificationService {

    @Autowired
    private NotificationRepository notificationRepository;

    @Autowired
    private Notification_UserRepository notificationUserRepository;

    @Autowired
    private UserRepository userRepository;

    // Sẽ gọi Firebase để tạo Push Notification ở đây
    // @Autowired
    // private PushNotificationService pushNotificationService;

    public Notification publishNotification(Notification notification) {
        Notification newNotification = notificationRepository.save(notification);

        // List<UUID> recipientIds =
        // userRepository.findIdByDonViId(notification.getRecipientUnitId());

        // List<Notification_User> notificationUsers = recipientIds.stream()
        // .map(userId -> {
        // Notification_User nu = new Notification_User();
        // nu.setNotificationId(newNotification.getId());
        // nu.setUserId(userId);
        // nu.setIsRead(false);
        // return nu;
        // })
        // .collect(Collectors.toList());

        // notificationUserRepository.saveAll(notificationUsers);

        // Giả định thôi
        // pushNotificationService.sendPushNotification(recipientIds,
        // newNotification.getTitle(),
        // newNotification.getContent());

        return newNotification;
    }

    @Transactional
    public void markAsRead(UUID userId, Long notificationId) {
        Notification_User nu = notificationUserRepository.findByUserIdAndNotificationId(userId, notificationId);
        if (nu != null && !nu.getIsRead()) {
            nu.setIsRead(true);
            nu.setReadAt(LocalDateTime.now());
            notificationUserRepository.save(nu);
        }
    }

    /**
     * Lấy danh sách hòm thư cho Cán bộ / Đoàn viên
     */
    public List<Notification_User> getInbox(UUID userId) {
        return notificationUserRepository.findByUserIdOrderByCreatedAtDesc(userId);

    }
}
