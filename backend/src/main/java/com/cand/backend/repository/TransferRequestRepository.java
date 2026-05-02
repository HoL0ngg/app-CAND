package com.cand.backend.repository;

import com.cand.backend.entity.TransferRequest;
import com.cand.backend.entity.User;
import com.cand.backend.entity.TransferStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface TransferRequestRepository extends JpaRepository<TransferRequest, Long> {
    List<TransferRequest> findByUser(User user);

    List<TransferRequest> findByStatus(TransferStatus status);

    List<TransferRequest> findByToUnitId(Long unitId);

    List<TransferRequest> findByFromUnitId(Long unitId);
}
