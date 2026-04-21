package com.cand.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.cand.backend.model.Unit;

public interface UnitRepository extends JpaRepository<Unit, Long> {
}