-- ============================================================
-- SCHEMA + SEED DATA
-- Ứng dụng Quản lý Đoàn Thanh niên CAND
-- PostgreSQL
-- ============================================================

-- Extension hỗ trợ UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


-- ============================================================
-- DROP TABLES (theo thứ tự FK để tránh lỗi)
-- ============================================================
DROP TABLE IF EXISTS Ma_xac_thuc_OTP           CASCADE;
DROP TABLE IF EXISTS Thong_bao_nguoi_dung       CASCADE;
DROP TABLE IF EXISTS Thong_bao                  CASCADE;
DROP TABLE IF EXISTS Lich_truc                  CASCADE;
DROP TABLE IF EXISTS Lich_su_don_vi_nguoi_dung  CASCADE;
DROP TABLE IF EXISTS Yeu_cau_chuyen_sinh_hoat   CASCADE;
DROP TABLE IF EXISTS Nguoi_dung                 CASCADE;
DROP TABLE IF EXISTS Don_vi                     CASCADE;
DROP TABLE IF EXISTS Vai_tro                    CASCADE;


-- ============================================================
-- 1. VAI_TRO
-- ============================================================
CREATE TABLE Vai_tro (
    id          BIGSERIAL       PRIMARY KEY,
    ten_vai_tro VARCHAR(100)    NOT NULL UNIQUE,
    mo_ta       TEXT,
    tao_luc     TIMESTAMP       NOT NULL DEFAULT NOW(),
    cap_nhat_luc TIMESTAMP      NOT NULL DEFAULT NOW()
);


-- ============================================================
-- 2. DON_VI
-- ============================================================
CREATE TABLE Don_vi (
    id              BIGSERIAL       PRIMARY KEY,
    ten_don_vi      VARCHAR(255)    NOT NULL,
    ma_don_vi       VARCHAR(100)    NOT NULL UNIQUE,
    don_vi_cha_id   BIGINT          REFERENCES Don_vi(id),
    cap_don_vi      VARCHAR(50)     NOT NULL,
    trang_thai      VARCHAR(50)     NOT NULL DEFAULT 'HOAT_DONG',
    tao_luc         TIMESTAMP       NOT NULL DEFAULT NOW(),
    cap_nhat_luc    TIMESTAMP       NOT NULL DEFAULT NOW(),
    xoa_luc         TIMESTAMP
);


-- ============================================================
-- 3. NGUOI_DUNG
-- ============================================================
CREATE TABLE Nguoi_dung (
    id                  UUID            PRIMARY KEY DEFAULT uuid_generate_v4(),
    ten_dang_nhap       VARCHAR(100)    NOT NULL UNIQUE,
    mat_khau_hash       TEXT            NOT NULL,
    ten                 VARCHAR(100)    NOT NULL,
    ho                  VARCHAR(100)    NOT NULL,
    ngay_sinh           DATE,
    so_cccd             VARCHAR(12),
    gioi_tinh           VARCHAR(20),
    que_quan            VARCHAR(255),
    cap_bac             VARCHAR(100),
    chuc_vu             VARCHAR(255),
    don_vi_id           BIGINT          REFERENCES Don_vi(id),
    vai_tro_id          BIGINT          REFERENCES Vai_tro(id),
    so_dien_thoai       VARCHAR(20),
    email               VARCHAR(255),
    khoa_bi_mat_qr      VARCHAR(255),
    token_sinh_trac_hoc TEXT,
    trang_thai          VARCHAR(50)     NOT NULL DEFAULT 'HOAT_DONG',
    tao_luc             TIMESTAMP       NOT NULL DEFAULT NOW(),
    cap_nhat_luc        TIMESTAMP       NOT NULL DEFAULT NOW(),
    xoa_luc             TIMESTAMP
);


-- ============================================================
-- 4. YEU_CAU_CHUYEN_SINH_HOAT
-- ============================================================
CREATE TABLE Yeu_cau_chuyen_sinh_hoat (
    id                          BIGSERIAL   PRIMARY KEY,
    nguoi_dung_id               UUID        NOT NULL REFERENCES Nguoi_dung(id),
    tu_don_vi_id                BIGINT      NOT NULL REFERENCES Don_vi(id),
    den_don_vi_id               BIGINT      NOT NULL REFERENCES Don_vi(id),
    trang_thai                  VARCHAR(50) NOT NULL DEFAULT 'PENDING',
    ly_do                       TEXT        NOT NULL,
    nguoi_duyet_don_vi_id       UUID        REFERENCES Nguoi_dung(id),
    nguoi_duyet_den_don_vi_id   UUID        REFERENCES Nguoi_dung(id),
    ly_do_tu_choi               TEXT,
    gui_yeu_cau_luc             TIMESTAMP   NOT NULL DEFAULT NOW(),
    hoan_tat_luc                TIMESTAMP,
    tao_luc                     TIMESTAMP   NOT NULL DEFAULT NOW(),
    cap_nhat_luc                TIMESTAMP   NOT NULL DEFAULT NOW(),
    xoa_luc                     TIMESTAMP
);


-- ============================================================
-- 5. LICH_SU_DON_VI_NGUOI_DUNG
-- ============================================================
CREATE TABLE Lich_su_don_vi_nguoi_dung (
    id                  BIGSERIAL   PRIMARY KEY,
    nguoi_dung_id       UUID        NOT NULL REFERENCES Nguoi_dung(id),
    don_vi_id           BIGINT      NOT NULL REFERENCES Don_vi(id),
    yeu_cau_chuyen_id   BIGINT      REFERENCES Yeu_cau_chuyen_sinh_hoat(id),
    loai_phan_cong      VARCHAR(50) NOT NULL,
    ghi_chu             TEXT,
    bat_dau_luc         TIMESTAMP   NOT NULL,
    ket_thuc_luc        TIMESTAMP,
    tao_luc             TIMESTAMP   NOT NULL DEFAULT NOW(),
    cap_nhat_luc        TIMESTAMP   NOT NULL DEFAULT NOW()
);


-- ============================================================
-- 6. LICH_TRUC
-- ============================================================
CREATE TABLE Lich_truc (
    id              BIGSERIAL       PRIMARY KEY,
    nguoi_dung_id   UUID            NOT NULL REFERENCES Nguoi_dung(id),
    don_vi_id       BIGINT          NOT NULL REFERENCES Don_vi(id),
    ngay_truc       DATE            NOT NULL,
    ca_truc         VARCHAR(20)     NOT NULL,
    dia_diem        VARCHAR(255),
    trang_thai      VARCHAR(50)     NOT NULL DEFAULT 'CHO_XAC_NHAN',
    tao_luc         TIMESTAMP       NOT NULL DEFAULT NOW(),
    cap_nhat_luc    TIMESTAMP       NOT NULL DEFAULT NOW()
);


-- ============================================================
-- 7. THONG_BAO
-- ============================================================
CREATE TABLE Thong_bao (
    id              BIGSERIAL       PRIMARY KEY,
    tieu_de         VARCHAR(255)    NOT NULL,
    noi_dung        TEXT            NOT NULL,
    nguoi_gui_id    UUID            NOT NULL REFERENCES Nguoi_dung(id),
    don_vi_nhan_id  BIGINT          REFERENCES Don_vi(id),   -- NULL = gửi tất cả
    muc_do_uu_tien  VARCHAR(20)     NOT NULL DEFAULT 'TRUNG_BINH',
    tao_luc         TIMESTAMP       NOT NULL DEFAULT NOW(),
    cap_nhat_luc    TIMESTAMP       NOT NULL DEFAULT NOW(),
    xoa_luc         TIMESTAMP
);


-- ============================================================
-- 8. THONG_BAO_NGUOI_DUNG (trạng thái đọc - bảng trung gian)
-- ============================================================
CREATE TABLE Thong_bao_nguoi_dung (
    id              BIGSERIAL   PRIMARY KEY,
    thong_bao_id    BIGINT      NOT NULL REFERENCES Thong_bao(id),
    nguoi_dung_id   UUID        NOT NULL REFERENCES Nguoi_dung(id),
    da_doc          BOOLEAN     NOT NULL DEFAULT FALSE,
    doc_luc         TIMESTAMP,
    UNIQUE (thong_bao_id, nguoi_dung_id)
);


-- ============================================================
-- 9. MA_XAC_THUC_OTP
-- ============================================================
CREATE TABLE Ma_xac_thuc_OTP (
    id              BIGSERIAL   PRIMARY KEY,
    nguoi_dung_id   UUID        NOT NULL REFERENCES Nguoi_dung(id),
    ma_otp          VARCHAR(10) NOT NULL,
    het_han_luc     TIMESTAMP   NOT NULL,
    da_su_dung      BOOLEAN     NOT NULL DEFAULT FALSE,
    loai            VARCHAR(50) NOT NULL,
    tao_luc         TIMESTAMP   NOT NULL DEFAULT NOW(),
    cap_nhat_luc    TIMESTAMP   NOT NULL DEFAULT NOW()
);


-- ============================================================
-- INDEXES
-- ============================================================
CREATE INDEX idx_nguoi_dung_don_vi     ON Nguoi_dung(don_vi_id);
CREATE INDEX idx_nguoi_dung_vai_tro    ON Nguoi_dung(vai_tro_id);
CREATE INDEX idx_don_vi_cha            ON Don_vi(don_vi_cha_id);
CREATE INDEX idx_yccsh_nguoi_dung      ON Yeu_cau_chuyen_sinh_hoat(nguoi_dung_id);
CREATE INDEX idx_yccsh_trang_thai      ON Yeu_cau_chuyen_sinh_hoat(trang_thai);
CREATE INDEX idx_ls_nguoi_dung         ON Lich_su_don_vi_nguoi_dung(nguoi_dung_id);
CREATE INDEX idx_lich_truc_ngay        ON Lich_truc(ngay_truc);
CREATE INDEX idx_lich_truc_nguoi_dung  ON Lich_truc(nguoi_dung_id);
CREATE INDEX idx_thong_bao_don_vi      ON Thong_bao(don_vi_nhan_id);
CREATE INDEX idx_tbnd_nguoi_dung       ON Thong_bao_nguoi_dung(nguoi_dung_id);
CREATE INDEX idx_otp_nguoi_dung        ON Ma_xac_thuc_OTP(nguoi_dung_id);


-- ============================================================
-- SEED DATA
-- ============================================================

-- ------------------------------------------------------------
-- 1. VAI TRO
-- ------------------------------------------------------------
INSERT INTO Vai_tro (id, ten_vai_tro, mo_ta, tao_luc, cap_nhat_luc) VALUES
(1, 'Lanh_dao',        'Lãnh đạo cấp trên, có quyền xem báo cáo và dữ liệu toàn hệ thống', NOW(), NOW()),
(2, 'Bi_thu_chi_doan', 'Bí thư Chi đoàn, quản lý dữ liệu và phê duyệt trong phạm vi đơn vị', NOW(), NOW()),
(3, 'Doan_vien',       'Đoàn viên, chỉ được xem hồ sơ cá nhân và lịch công tác', NOW(), NOW());

-- Đồng bộ sequence
SELECT setval(pg_get_serial_sequence('Vai_tro', 'id'), (SELECT MAX(id) FROM Vai_tro));


-- ------------------------------------------------------------
-- 2. DON VI
-- ------------------------------------------------------------
INSERT INTO Don_vi (id, ten_don_vi, ma_don_vi, don_vi_cha_id, cap_don_vi, trang_thai, tao_luc, cap_nhat_luc, xoa_luc) VALUES
(1, 'Đoàn cơ sở Công an TP.HCM',        'DCSCA-HCM', NULL, 'Doan_co_so', 'HOAT_DONG', NOW(), NOW(), NULL),
(2, 'Chi đoàn Phòng Cảnh sát Hình sự',  'CD-CSHS',   1,    'Chi_doan',   'HOAT_DONG', NOW(), NOW(), NULL),
(3, 'Chi đoàn Phòng Cảnh sát Giao thông','CD-CSGT',   1,    'Chi_doan',   'HOAT_DONG', NOW(), NOW(), NULL),
(4, 'Chi đoàn Phòng Cảnh sát Kinh tế',  'CD-CSKT',   1,    'Chi_doan',   'HOAT_DONG', NOW(), NOW(), NULL);

SELECT setval(pg_get_serial_sequence('Don_vi', 'id'), (SELECT MAX(id) FROM Don_vi));


-- ------------------------------------------------------------
-- 3. NGUOI DUNG
-- mat_khau_hash = bcrypt của 'Password@123'
-- ------------------------------------------------------------
INSERT INTO Nguoi_dung (
    id, ten_dang_nhap, mat_khau_hash,
    ten, ho, ngay_sinh, so_cccd, gioi_tinh, que_quan,
    cap_bac, chuc_vu, don_vi_id, vai_tro_id,
    so_dien_thoai, email, khoa_bi_mat_qr, token_sinh_trac_hoc,
    trang_thai, tao_luc, cap_nhat_luc, xoa_luc
) VALUES
-- Lãnh đạo
('a1b2c3d4-0001-0001-0001-000000000001',
 'nguyen.van.an', '$2b$12$KIX8k3n4Q2z5yW1mP7oR4.hT9Lq0Xv6Ew3Jd2Nc8Sp1Yu5Ag7Fb.',
 'An', 'Nguyễn Văn', '1975-03-15', '079075003001', 'Nam', 'Hà Nội',
 'Thượng tá', 'Trưởng Đoàn cơ sở', 1, 1,
 '0901000001', 'nguyen.van.an@congan.vn', 'QR_SECRET_001', NULL,
 'HOAT_DONG', NOW(), NOW(), NULL),

-- Bí thư Chi đoàn CSHS
('a1b2c3d4-0002-0002-0002-000000000002',
 'tran.thi.bich', '$2b$12$KIX8k3n4Q2z5yW1mP7oR4.hT9Lq0Xv6Ew3Jd2Nc8Sp1Yu5Ag7Fb.',
 'Bích', 'Trần Thị', '1990-07-22', '079090007002', 'Nữ', 'TP.HCM',
 'Trung úy', 'Bí thư Chi đoàn', 2, 2,
 '0902000002', 'tran.thi.bich@congan.vn', 'QR_SECRET_002', NULL,
 'HOAT_DONG', NOW(), NOW(), NULL),

-- Bí thư Chi đoàn CSGT
('a1b2c3d4-0003-0003-0003-000000000003',
 'le.minh.duc', '$2b$12$KIX8k3n4Q2z5yW1mP7oR4.hT9Lq0Xv6Ew3Jd2Nc8Sp1Yu5Ag7Fb.',
 'Đức', 'Lê Minh', '1988-11-05', '079088011003', 'Nam', 'Bình Dương',
 'Thiếu úy', 'Bí thư Chi đoàn', 3, 2,
 '0903000003', 'le.minh.duc@congan.vn', 'QR_SECRET_003', NULL,
 'HOAT_DONG', NOW(), NOW(), NULL),

-- Đoàn viên Chi đoàn CSHS
('a1b2c3d4-0004-0004-0004-000000000004',
 'pham.quoc.hung', '$2b$12$KIX8k3n4Q2z5yW1mP7oR4.hT9Lq0Xv6Ew3Jd2Nc8Sp1Yu5Ag7Fb.',
 'Hùng', 'Phạm Quốc', '1998-04-10', '079098004004', 'Nam', 'Đồng Nai',
 'Hạ sĩ', 'Chiến sĩ', 2, 3,
 '0904000004', 'pham.quoc.hung@congan.vn', 'QR_SECRET_004', NULL,
 'HOAT_DONG', NOW(), NOW(), NULL),

-- Đoàn viên Chi đoàn CSHS (người sẽ xin chuyển)
('a1b2c3d4-0005-0005-0005-000000000005',
 'hoang.thi.lan', '$2b$12$KIX8k3n4Q2z5yW1mP7oR4.hT9Lq0Xv6Ew3Jd2Nc8Sp1Yu5Ag7Fb.',
 'Lan', 'Hoàng Thị', '1999-09-18', '079099009005', 'Nữ', 'Long An',
 'Hạ sĩ', 'Chiến sĩ', 2, 3,
 '0905000005', 'hoang.thi.lan@congan.vn', 'QR_SECRET_005', NULL,
 'HOAT_DONG', NOW(), NOW(), NULL),

-- Đoàn viên Chi đoàn CSGT
('a1b2c3d4-0006-0006-0006-000000000006',
 'vo.thanh.son', '$2b$12$KIX8k3n4Q2z5yW1mP7oR4.hT9Lq0Xv6Ew3Jd2Nc8Sp1Yu5Ag7Fb.',
 'Sơn', 'Võ Thanh', '1997-12-25', '079097012006', 'Nam', 'Tiền Giang',
 'Thượng binh', 'Chiến sĩ', 3, 3,
 '0906000006', 'vo.thanh.son@congan.vn', 'QR_SECRET_006', NULL,
 'HOAT_DONG', NOW(), NOW(), NULL);


-- ------------------------------------------------------------
-- 4. LICH SU DON VI NGUOI DUNG (phân công ban đầu)
-- ------------------------------------------------------------
INSERT INTO Lich_su_don_vi_nguoi_dung (
    id, nguoi_dung_id, don_vi_id, yeu_cau_chuyen_id,
    loai_phan_cong, ghi_chu, bat_dau_luc, ket_thuc_luc,
    tao_luc, cap_nhat_luc
) VALUES
(1, 'a1b2c3d4-0001-0001-0001-000000000001', 1, NULL, 'BO_NHIEM', 'Bổ nhiệm ban đầu',             '2020-01-01', NULL,           NOW(), NOW()),
(2, 'a1b2c3d4-0002-0002-0002-000000000002', 2, NULL, 'BO_NHIEM', 'Bổ nhiệm Bí thư Chi đoàn CSHS','2021-06-01', NULL,           NOW(), NOW()),
(3, 'a1b2c3d4-0003-0003-0003-000000000003', 3, NULL, 'BO_NHIEM', 'Bổ nhiệm Bí thư Chi đoàn CSGT','2021-06-01', NULL,           NOW(), NOW()),
(4, 'a1b2c3d4-0004-0004-0004-000000000004', 2, NULL, 'PHAN_CONG', NULL,                           '2022-03-15', NULL,           NOW(), NOW()),
(5, 'a1b2c3d4-0005-0005-0005-000000000005', 2, NULL, 'PHAN_CONG', NULL,                           '2022-03-15', NULL,           NOW(), NOW()),
(6, 'a1b2c3d4-0006-0006-0006-000000000006', 3, NULL, 'PHAN_CONG', NULL,                           '2022-05-01', NULL,           NOW(), NOW());

SELECT setval(pg_get_serial_sequence('Lich_su_don_vi_nguoi_dung', 'id'), (SELECT MAX(id) FROM Lich_su_don_vi_nguoi_dung));


-- ------------------------------------------------------------
-- 5. YEU CAU CHUYEN SINH HOAT
-- ------------------------------------------------------------
INSERT INTO Yeu_cau_chuyen_sinh_hoat (
    id, nguoi_dung_id, tu_don_vi_id, den_don_vi_id,
    trang_thai, ly_do,
    nguoi_duyet_don_vi_id, nguoi_duyet_den_don_vi_id, ly_do_tu_choi,
    gui_yeu_cau_luc, hoan_tat_luc, tao_luc, cap_nhat_luc, xoa_luc
) VALUES
-- APPROVED: Lan chuyển CSHS → CSGT
(1, 'a1b2c3d4-0005-0005-0005-000000000005', 2, 3,
 'SOURCE_APPROVED',
 'Gia đình chuyển công tác về khu vực phụ trách của Chi đoàn CSGT, đề nghị chuyển sinh hoạt để thuận tiện công tác.',
 'a1b2c3d4-0002-0002-0002-000000000002',
 'a1b2c3d4-0003-0003-0003-000000000003',
 NULL,
 '2024-10-01 08:30:00', '2024-10-10 15:00:00',
 '2024-10-01 08:30:00', '2024-10-10 15:00:00', NULL),

-- PENDING: Hùng xin chuyển CSHS → CSKT
(2, 'a1b2c3d4-0004-0004-0004-000000000004', 2, 4,
 'PENDING',
 'Được điều chuyển nhiệm vụ sang Phòng Cảnh sát Kinh tế theo quyết định nội bộ.',
 'a1b2c3d4-0002-0002-0002-000000000002',
 NULL, NULL,
 '2025-01-15 09:00:00', NULL,
 '2025-01-15 09:00:00', '2025-01-15 09:00:00', NULL);

SELECT setval(pg_get_serial_sequence('Yeu_cau_chuyen_sinh_hoat', 'id'), (SELECT MAX(id) FROM Yeu_cau_chuyen_sinh_hoat));

-- Lịch sử chuyển đơn vị cho Lan (sau khi APPROVED)
INSERT INTO Lich_su_don_vi_nguoi_dung (
    id, nguoi_dung_id, don_vi_id, yeu_cau_chuyen_id,
    loai_phan_cong, ghi_chu, bat_dau_luc, ket_thuc_luc,
    tao_luc, cap_nhat_luc
) VALUES
(7, 'a1b2c3d4-0005-0005-0005-000000000005', 2, 1,
 'CHUYEN_DI', 'Chuyển sinh hoạt sang Chi đoàn CSGT',
 '2022-03-15', '2024-10-10 15:00:00', NOW(), NOW()),
(8, 'a1b2c3d4-0005-0005-0005-000000000005', 3, 1,
 'CHUYEN_DEN', 'Tiếp nhận từ Chi đoàn CSHS',
 '2024-10-10 15:00:00', NULL, NOW(), NOW());

SELECT setval(pg_get_serial_sequence('Lich_su_don_vi_nguoi_dung', 'id'), (SELECT MAX(id) FROM Lich_su_don_vi_nguoi_dung));


-- ------------------------------------------------------------
-- 6. LICH TRUC
-- ------------------------------------------------------------
INSERT INTO Lich_truc (
    id, nguoi_dung_id, don_vi_id,
    ngay_truc, ca_truc, dia_diem, trang_thai,
    tao_luc, cap_nhat_luc
) VALUES
(1, 'a1b2c3d4-0004-0004-0004-000000000004', 2, '2025-04-28', 'SANG',     'Trụ sở Phòng CSHS - 268 Trần Hưng Đạo',  'DA_XAC_NHAN',  NOW(), NOW()),
(2, 'a1b2c3d4-0005-0005-0005-000000000005', 3, '2025-04-28', 'CHIEU',    'Trụ sở Phòng CSGT - 459 Trần Hưng Đạo',  'DA_XAC_NHAN',  NOW(), NOW()),
(3, 'a1b2c3d4-0006-0006-0006-000000000006', 3, '2025-04-29', 'SANG',     'Chốt kiểm soát Ngã tư Bình Phước',        'CHO_XAC_NHAN', NOW(), NOW()),
(4, 'a1b2c3d4-0004-0004-0004-000000000004', 2, '2025-04-30', 'TOAN_NGAY','Trụ sở Phòng CSHS - 268 Trần Hưng Đạo',  'CHO_XAC_NHAN', NOW(), NOW());

SELECT setval(pg_get_serial_sequence('Lich_truc', 'id'), (SELECT MAX(id) FROM Lich_truc));


-- ------------------------------------------------------------
-- 7. THONG BAO
-- ------------------------------------------------------------
INSERT INTO Thong_bao (
    id, tieu_de, noi_dung,
    nguoi_gui_id, don_vi_nhan_id, muc_do_uu_tien,
    tao_luc, cap_nhat_luc, xoa_luc
) VALUES
(1,
 '[KHẨN] Họp toàn thể đoàn viên tháng 4/2025',
 'Kính gửi toàn thể cán bộ, chiến sĩ. Căn cứ kế hoạch công tác, đề nghị toàn thể đoàn viên tham dự buổi họp tổng kết tháng 4/2025 vào 14:00 ngày 30/04/2025 tại Hội trường lớn. Yêu cầu có mặt đúng giờ, mặc trang phục theo quy định.',
 'a1b2c3d4-0001-0001-0001-000000000001', NULL, 'CAO',
 '2025-04-25 08:00:00', '2025-04-25 08:00:00', NULL),

(2,
 'Lịch trực tuần 18/2025 - Chi đoàn CSHS',
 'Lịch trực tuần 18 (28/04 - 04/05/2025) của Chi đoàn Phòng CSHS đã được cập nhật trên hệ thống. Đề nghị các đồng chí kiểm tra và xác nhận ca trực trước 17:00 ngày 27/04/2025.',
 'a1b2c3d4-0002-0002-0002-000000000002', 2, 'TRUNG_BINH',
 '2025-04-24 16:00:00', '2025-04-24 16:00:00', NULL),

(3,
 'Triển khai chuyên đề an toàn giao thông tháng 5',
 'Chi đoàn CSGT phối hợp tổ chức tuyên truyền ATGT tại các trường học trên địa bàn. Chi tiết kế hoạch và phân công nhiệm vụ sẽ được thông báo sau buổi họp ngày 02/05/2025.',
 'a1b2c3d4-0003-0003-0003-000000000003', 3, 'THAP',
 '2025-04-23 10:30:00', '2025-04-23 10:30:00', NULL);

SELECT setval(pg_get_serial_sequence('Thong_bao', 'id'), (SELECT MAX(id) FROM Thong_bao));


-- ------------------------------------------------------------
-- 8. THONG BAO NGUOI DUNG (trạng thái đọc)
-- ------------------------------------------------------------
INSERT INTO Thong_bao_nguoi_dung (thong_bao_id, nguoi_dung_id, da_doc, doc_luc, tao_luc) VALUES
-- TB 1 (toàn thể): Hùng đã đọc, Lan & Sơn chưa đọc
(1, 'a1b2c3d4-0004-0004-0004-000000000004', TRUE,  '2025-04-25 09:15:00', '2025-04-25 08:00:00'),
(1, 'a1b2c3d4-0005-0005-0005-000000000005', FALSE, NULL,                  '2025-04-25 08:00:00'),
(1, 'a1b2c3d4-0006-0006-0006-000000000006', FALSE, NULL,                  '2025-04-25 08:00:00'),
-- TB 2 (CSHS): Hùng & Lan đã đọc
(2, 'a1b2c3d4-0004-0004-0004-000000000004', TRUE,  '2025-04-24 17:30:00', '2025-04-24 16:00:00'),
(2, 'a1b2c3d4-0005-0005-0005-000000000005', TRUE,  '2025-04-24 18:00:00', '2025-04-24 16:00:00'),
-- TB 3 (CSGT): Sơn chưa đọc
(3, 'a1b2c3d4-0006-0006-0006-000000000006', FALSE, NULL,                  '2025-04-23 10:30:00');


-- ------------------------------------------------------------
-- 9. MA XAC THUC OTP
-- ------------------------------------------------------------
INSERT INTO Ma_xac_thuc_OTP (
    id, nguoi_dung_id, ma_otp,
    het_han_luc, da_su_dung, loai,
    tao_luc, cap_nhat_luc
) VALUES
(1, 'a1b2c3d4-0005-0005-0005-000000000005',
 '482719', '2025-04-26 08:15:00', TRUE, 'DANG_NHAP',
 '2025-04-26 08:00:00', '2025-04-26 08:10:00'),

(2, 'a1b2c3d4-0004-0004-0004-000000000004',
 '936042', NOW() + INTERVAL '5 minutes', FALSE, 'DANG_NHAP',
 NOW(), NOW());

SELECT setval(pg_get_serial_sequence('Ma_xac_thuc_OTP', 'id'), (SELECT MAX(id) FROM Ma_xac_thuc_OTP));
