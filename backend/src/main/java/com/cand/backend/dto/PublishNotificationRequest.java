package com.cand.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PublishNotificationRequest {
    private String title;
    private String content;
    private String priority; // Khẩn cấp / Bình thường

    // Nếu true -> gửi nội bộ trong recipientUnitId
    private boolean sendInternal;

    // Danh sách ID các đơn vị cấp dưới được chọn để gửi tới (không bắt buộc)
    private List<Long> selectedSubordinateUnitIds;
}
