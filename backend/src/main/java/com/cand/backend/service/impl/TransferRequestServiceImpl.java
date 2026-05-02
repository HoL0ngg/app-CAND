package com.cand.backend.service.impl;

import com.cand.backend.dto.request.TransferRequestDto;
import com.cand.backend.dto.response.TransferResponseDto;
import com.cand.backend.entity.TransferRequest;
import com.cand.backend.entity.TransferStatus;
import com.cand.backend.entity.Unit;
import com.cand.backend.entity.User;
import com.cand.backend.entity.UserUnitHistory;
import com.cand.backend.repository.TransferRequestRepository;
import com.cand.backend.repository.UserRepository;
import com.cand.backend.repository.UnitRepository;
import com.cand.backend.repository.UserUnitHistoryRepository;
import com.cand.backend.service.TransferRequestService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class TransferRequestServiceImpl implements TransferRequestService {

        private final TransferRequestRepository transferRepository;
        private final UserRepository userRepository;
        private final UnitRepository unitRepository;
        private final UserUnitHistoryRepository historyRepository;

        @Override
        @Transactional
        public TransferResponseDto submitRequest(TransferRequestDto requestDto, UUID userId) {
                User user = userRepository.findById(userId)
                                .orElseThrow(() -> new RuntimeException("Không tìm thấy đoàn viên"));
                Unit toUnit = unitRepository.findById(requestDto.getToUnitId())
                                .orElseThrow(() -> new RuntimeException("Không tìm thấy đơn vị đích"));

                // Khởi tạo yêu cầu với trạng thái PENDING
                TransferRequest request = TransferRequest.builder()
                                .user(user)
                                .fromUnit(user.getUnit()) // Lấy đơn vị hiện tại làm đơn vị đi
                                .toUnit(toUnit)
                                .reason(requestDto.getReason())
                                .documentUrl(requestDto.getDocumentUrl())
                                .status(TransferStatus.PENDING)
                                .requestTime(LocalDateTime.now())
                                .build();

                TransferRequest savedRequest = transferRepository.save(request);
                return mapToResponseDto(savedRequest);
        }

        @Override
        @Transactional
        public TransferResponseDto approveBySource(Long requestId, UUID approverId) {
                TransferRequest request = transferRepository.findById(requestId)
                                .orElseThrow(() -> new RuntimeException("Không tìm thấy yêu cầu"));

                User approver = userRepository.findById(approverId)
                                .orElseThrow(() -> new RuntimeException("Không tìm thấy người duyệt"));

                if (request.getStatus() != TransferStatus.PENDING) {
                        throw new RuntimeException("Trạng thái không hợp lệ để duyệt");
                }

                request.setStatus(TransferStatus.SOURCE_APPROVED);
                request.setApproverSource(approver);
                return mapToResponseDto(transferRepository.save(request));
        }

        @Override
        @Transactional
        public TransferResponseDto approveByDestination(Long requestId, UUID approverId) {
                TransferRequest request = transferRepository.findById(requestId)
                                .orElseThrow(() -> new RuntimeException("Không tìm thấy yêu cầu"));

                User approver = userRepository.findById(approverId)
                                .orElseThrow(() -> new RuntimeException("Không tìm thấy người duyệt"));

                if (request.getStatus() != TransferStatus.SOURCE_APPROVED) {
                        throw new RuntimeException("Cần đơn vị đi duyệt trước");
                }

                // Cập nhật trạng thái yêu cầu đã hoàn tất
                request.setStatus(TransferStatus.DESTINATION_APPROVED);
                request.setApproverDestination(approver);
                request.setCompletionTime(LocalDateTime.now());

                // Chuyển đơn vị trực tiếp cho Đoàn viên
                User user = request.getUser();
                user.setUnit(request.getToUnit());
                userRepository.save(user);

                // Ghi log vào Lịch sử đơn vị
                UserUnitHistory history = UserUnitHistory.builder()
                                .user(user)
                                .unit(request.getToUnit())
                                .transferRequest(request)
                                .assignmentType("CHUYEN_SINH_HOAT")
                                .startDate(LocalDateTime.now())
                                .build();
                historyRepository.save(history);

                return mapToResponseDto(transferRepository.save(request));
        }

        @Override
        @Transactional
        public TransferResponseDto rejectRequest(Long requestId, String reason) {
                TransferRequest request = transferRepository.findById(requestId)
                                .orElseThrow(() -> new RuntimeException("Không tìm thấy yêu cầu"));

                request.setStatus(TransferStatus.REJECTED);
                request.setRejectionReason(reason);
                return mapToResponseDto(transferRepository.save(request));
        }

        @Override
        public List<TransferResponseDto> getAllFromRequests(Long unitId) {
                return transferRepository.findByFromUnitId(unitId)
                                .stream()
                                .map(this::mapToResponseDto)
                                .collect(Collectors.toList());
        }

        @Override
        public List<TransferResponseDto> getAllToRequests(Long unitId) {
                return transferRepository.findByToUnitId(unitId)
                                .stream()
                                .map(this::mapToResponseDto)
                                .collect(Collectors.toList());
        }

        // Chuyển đổi từ Entity sang DTO
        private TransferResponseDto mapToResponseDto(TransferRequest request) {
                return TransferResponseDto.builder()
                                .id(request.getId())
                                .userId(request.getUser().getId())
                                .userName(request.getUser().getFirstName() + " " + request.getUser().getLastName())
                                .fromUnitName(request.getFromUnit() != null ? request.getFromUnit().getUnitName()
                                                : "Không xác định")
                                .toUnitName(request.getToUnit() != null ? request.getToUnit().getUnitName()
                                                : "Không xác định")
                                .status(request.getStatus())
                                .reason(request.getReason())
                                .rejectionReason(request.getRejectionReason())
                                .requestTime(request.getRequestTime())
                                .completionTime(request.getCompletionTime())
                                .documentUrl(request.getDocumentUrl())
                                .build();
        }
}
