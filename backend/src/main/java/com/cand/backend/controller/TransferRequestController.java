package com.cand.backend.controller;

import com.cand.backend.dto.request.TransferRequestDto;
import com.cand.backend.dto.response.TransferResponseDto;
import com.cand.backend.security.CustomUserDetails;
import com.cand.backend.service.TransferRequestService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/transfer")
@RequiredArgsConstructor
public class TransferRequestController {

    private final TransferRequestService transferService;

    // Đoàn viên gửi yêu cầu
    @PostMapping("/submit")
    public ResponseEntity<TransferResponseDto> submitRequest(@RequestBody TransferRequestDto requestDto) {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        UUID userId = ((CustomUserDetails) principal).getUser().getId();
        return ResponseEntity.ok(transferService.submitRequest(requestDto, userId));
    }

    // Đơn vị đi phê duyệt
    @PostMapping("/{id}/approve-source")
    public ResponseEntity<TransferResponseDto> approveBySource(
            @PathVariable Long id) {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        UUID approverId = ((CustomUserDetails) principal).getUser().getId();
        return ResponseEntity.ok(transferService.approveBySource(id, approverId));
    }

    // Đơn vị đến phê duyệt (Hoàn tất)
    @PostMapping("/{id}/approve-destination")
    public ResponseEntity<TransferResponseDto> approveByDestination(
            @PathVariable Long id) {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        UUID approverId = ((CustomUserDetails) principal).getUser().getId();
        return ResponseEntity.ok(transferService.approveByDestination(id, approverId));
    }

    // Từ chối yêu cầu
    @PostMapping("/{id}/reject")
    public ResponseEntity<TransferResponseDto> rejectRequest(
            @PathVariable Long id,
            @RequestParam String reason) {
        return ResponseEntity.ok(transferService.rejectRequest(id, reason));
    }

    // Lấy danh sách yêu cầu ở đơn vị hiện tại (Cán bộ / Đoàn viên)
    @GetMapping("/from-requests")
    public ResponseEntity<List<TransferResponseDto>> getAllFromRequests() {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Long unitId = ((CustomUserDetails) principal).getUser().getUnit().getId();
        return ResponseEntity.ok(transferService.getAllFromRequests(unitId));
    }

    @GetMapping("/to-requests")
    public ResponseEntity<List<TransferResponseDto>> getAllToRequests() {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Long unitId = ((CustomUserDetails) principal).getUser().getUnit().getId();
        return ResponseEntity.ok(transferService.getAllToRequests(unitId));
    }
}
