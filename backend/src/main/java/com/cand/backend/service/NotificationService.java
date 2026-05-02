package com.cand.backend.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cand.backend.entity.Notification;
import com.cand.backend.entity.Notification_User;
// import com.cand.backend.enums.NotificationRecipientType;
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

    /**
     * Gửi thông báo với lựa chọn: gửi nội bộ và/hoặc gửi tới các đơn vị cấp dưới
     * được chọn
     *
     * @param notification               Đối tượng thông báo
     * @param sendInternal               Nếu true -> gửi tới tất cả user trong
     *                                   recipientUnitId
     * @param subordinateUnitIdsSelected Danh sách ID các đơn vị cấp dưới do client
     *                                   chọn
     */
    @Transactional
    public Notification publishNotificationWithRecipients(Notification notification, boolean sendInternal,
            List<Long> subordinateUnitIdsSelected) {
        Notification newNotification = notificationRepository.save(notification);

        Long baseUnitId = notification.getRecipientUnitId();

        // Gom danh sách user ids từ các nguồn theo request
        List<UUID> recipientIds = new ArrayList<>();

        if (sendInternal && baseUnitId != null) {
            recipientIds.addAll(userRepository.findUserIdsByUnitId(baseUnitId));
        }

        if (subordinateUnitIdsSelected != null) {
            for (Long subUnitId : subordinateUnitIdsSelected) {
                if (subUnitId != null) {
                    recipientIds.addAll(userRepository.findUserIdsByUnitId(subUnitId));
                }
            }
        }

        // Loại bỏ nulls và trùng lặp
        List<UUID> distinctRecipientIds = recipientIds.stream().filter(Objects::nonNull).distinct()
                .collect(Collectors.toList());

        // Tạo danh sách Notification_User
        List<Notification_User> notificationUsers = distinctRecipientIds.stream()
                .map(userId -> {
                    Notification_User nu = new Notification_User();
                    nu.setNotificationId(newNotification.getId());
                    nu.setUserId(userId);
                    nu.setIsRead(false);
                    return nu;
                })
                .collect(Collectors.toList());

        notificationUserRepository.saveAll(notificationUsers);

        // TODO: Gọi Firebase để tạo Push Notification
        // pushNotificationService.sendPushNotification(distinctRecipientIds,
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
