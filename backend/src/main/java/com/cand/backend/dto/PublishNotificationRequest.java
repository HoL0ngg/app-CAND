package com.cand.backend.dto;

import com.cand.backend.enums.NotificationRecipientType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PublishNotificationRequest {
    private String title;
    private String content;
    private String priority; // Khẩn cấp / Bình thường
    private Long recipientUnitId; // ID đơn vị nhận thông báo
    private NotificationRecipientType recipientType; // Loại gửi: SAME_UNIT hoặc SUBORDINATE_UNITS
}
