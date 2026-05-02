package com.cand.backend.dto.request;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TransferRequestDto {

    // ID đơn vị đích muốn chuyển
    private Long toUnitId;

    // Lý do chuyển sinh hoạt
    private String reason;

    // URL minh chứng
    private String documentUrl;
}