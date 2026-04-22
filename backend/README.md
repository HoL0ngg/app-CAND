# CAND Backend Project

Dự án phát triển Backend cho hệ thống Quản lý và Hỗ trợ Đoàn viên thanh niên (CAND). Dự án được thiết kế theo mô hình MVC sử dụng Spring Boot, đảm bảo tính bảo mật với JWT, 2FA (OTP) và phân quyền RBAC.

## 👥 Thành viên Team Backend
*(Điền tên các thành viên trong team của bạn vào đây)*
- Thành viên 1: [Họ và tên] - [Vai trò/Task]
- Thành viên 2: [Họ và tên] - [Vai trò/Task]
- Thành viên 3: [Họ và tên] - [Vai trò/Task]

## 🛠 Công nghệ sử dụng
- **Ngôn ngữ**: Java 21
- **Framework**: Spring Boot 3.3.5 (Spring Web, Spring Data JPA, Spring Security)
- **Database**: PostgreSQL 15
- **Security**: JSON Web Token (jjwt), BCrypt
- **Công cụ hỗ trợ**: Lombok, Swagger UI (Springdoc OpenAPI)
- **Triển khai**: Docker & Docker Compose

## 🏗 Kiến trúc dự án

Dự án áp dụng mô hình phân lớp tiêu chuẩn của Spring Boot:
```text
src/main/java/com/cand/backend
├── config/       # Cấu hình hệ thống (Security, Swagger,...)
├── controller/   # Lớp giao tiếp với Client (REST APIs)
├── dto/          # Các object chuyển đổi dữ liệu (Request/Response)
├── entity/       # Các Entity ánh xạ với bảng trong Database (JPA)
├── exception/    # Quản lý và xử lý ngoại lệ (Custom Exceptions)
├── repository/   # Lớp giao tiếp với Database (Kế thừa JpaRepository)
├── security/     # Logic bảo mật (JWT Provider, Filter, UserDetailsService)
└── service/      # Chứa business logic (Interface và Impl)
```

## 📝 Hướng dẫn code theo mô hình MVC (Dành cho Team)
Khi được giao task làm một tính năng mới (ví dụ: `Quản lý Bài viết`), các bạn hãy thực hiện lần lượt theo thứ tự sau để tránh lỗi phụ thuộc:

1. **Tạo Entity (`entity/Post.java`)**: 
   - Định nghĩa cấu trúc bảng trong Database bằng các annotation như `@Entity`, `@Table`, `@Id`, `@Column`.
2. **Tạo Repository (`repository/PostRepository.java`)**: 
   - Tạo interface kế thừa `JpaRepository<Post, Long>` để cung cấp sẵn các hàm CRUD. Viết thêm custom query nếu cần.
3. **Tạo DTO (`dto/request/PostRequest.java`, `dto/response/PostResponse.java`)**: 
   - Tạo các class để mapping dữ liệu Client gửi lên và dữ liệu trả về. Không dùng trực tiếp Entity làm input/output ở Controller.
4. **Tạo Service (`service/PostService.java` & `service/impl/PostServiceImpl.java`)**: 
   - Viết các interface định nghĩa nghiệp vụ. Ở class `Impl`, Inject Repository vào và xử lý logic (kiểm tra điều kiện, tính toán, save data...).
5. **Tạo Controller (`controller/PostController.java`)**: 
   - Định nghĩa các endpoint `@GetMapping`, `@PostMapping`.
   - Bắt dữ liệu từ Client (`@RequestBody`, `@PathVariable`), gọi qua Service xử lý và trả về `ResponseEntity`.
   - Có thể thêm `@PreAuthorize("hasRole('ROLE_ADMIN')")` nếu cần phân quyền.

---

## 🚀 Hướng dẫn Clone và Chạy dự án (Docker)

Hệ thống đã được đóng gói sẵn với Docker Compose bao gồm cả Database PostgreSQL và Backend App.

### Bước 1: Yêu cầu môi trường
- Đã cài đặt [Docker](https://www.docker.com/) và Docker Compose trên máy tính.
- Mở Terminal/Command Prompt.

### Bước 2: Clone project và chạy
1. Clone dự án về máy:
   ```bash
   git clone <link-repo>
   cd app-CAND/backend
   ```
2. Build ứng dụng Spring Boot ra file `.jar` (yêu cầu máy có Java hoặc dùng Maven wrapper có sẵn):
   ```bash
   ./mvnw clean package -DskipTests
   ```
   *(File `.jar` sẽ được tạo ra trong thư mục `target/`)*

3. Build và khởi động các container bằng Docker Compose:
   ```bash
   docker compose up -d --build
   ```

4. Kiểm tra:
   - Backend sẽ chạy ở cổng: `http://localhost:8080`
   - Tài liệu API (Swagger UI): `http://localhost:8080/docs`

---

## 🗄 Hướng dẫn xem dữ liệu PostgreSQL

Database PostgreSQL đang chạy ngầm trong container. Để xem dữ liệu, bạn có thể dùng một phần mềm quản lý Database như **DBeaver**, **PgAdmin**, hoặc **DataGrip**.

**Thông tin kết nối (Connection Settings):**
- **Host**: `localhost`
- **Port**: `5434`
- **Database**: `cand_db`
- **Username**: `user`
- **Password**: `cand123@`

*(Lưu ý: Đảm bảo container postgres đang chạy `Up` trước khi dùng phần mềm kết nối)*
