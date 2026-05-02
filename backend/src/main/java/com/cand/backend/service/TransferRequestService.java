package com.cand.backend.service;

import com.cand.backend.dto.request.TransferRequestDto;
import com.cand.backend.dto.response.TransferResponseDto;

import java.util.List;
import java.util.UUID;

/**
 * Interface định nghĩa nghiệp vụ chuyển sinh hoạt Đoàn.
 * Tuân thủ quy tắc 2 cấp phê duyệt (Đơn vị đi -> Đơn vị đến).
 */
public interface TransferRequestService {

    /**
     * Đoàn viên thực hiện gửi yêu cầu chuyển sinh hoạt.
     */
    TransferResponseDto submitRequest(TransferRequestDto requestDto, UUID userId);

    /**
     * Cấp 1: Đơn vị đi thực hiện phê duyệt.
     */
    TransferResponseDto approveBySource(Long requestId, UUID approverId);

    /**
     * Cấp 2: Đơn vị đến phê duyệt và hoàn tất quy trình chuyển đơn vị.
     */
    TransferResponseDto approveByDestination(Long requestId, UUID approverId);

    /**
     * Từ chối yêu cầu chuyển sinh hoạt.
     */
    TransferResponseDto rejectRequest(Long requestId, String reason);

    /**
     * Lấy toàn bộ danh sách yêu cầu.
     */
    List<TransferResponseDto> getAllFromRequests(Long unitId);

    List<TransferResponseDto> getAllToRequests(Long unitId);

}
