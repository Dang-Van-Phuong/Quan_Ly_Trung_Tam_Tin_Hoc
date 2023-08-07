CREATE DATABASE DOAN_QLTRUNGTAMTINHOC ON PRIMARY
(
	name =DOAN_QLTRUNGTAMTINHOC, Filename= 'D:\DoAn_CacHeCoSoDuLieu\DOAN_QLTRUNGTAMTINHOC.mdf', Size=20MB, Maxsize=50MB, Filegrowth=15%
)
--test
LOG ON
(
	NAME = DOAN_QLTRUNGTAMTINHOCLog, Filename= 'D:\DoAn_CacHeCoSoDuLieu\DOAN_QLTRUNGTAMTINHOCLog.ldf', Size=10MB, Maxsize=20MB, Filegrowth=20%
);
GO
USE DOAN_QLTRUNGTAMTINHOC
GO

-- TẠO CÁC THỰC THỂ
	-- Bảng TAIKHOAN
CREATE TABLE TAIKHOAN
(
	MADANGNHAP CHAR(4) PRIMARY KEY,
	MATKHAU NVARCHAR(10) NOT NULL
);
	-- tạo ràng buộc 
		-- madangnhap là duy nhất
	ALTER TABLE TAIKHOAN
	ADD CONSTRAINT UQ_TAIKHOAN_MADANGNHAP UNIQUE (MADANGNHAP);
GO

	--Bảng HOCVIEN
CREATE TABLE HOCVIEN
(
	MAHV CHAR(4) PRIMARY KEY,
	MALOP CHAR(4),
	HOTEN NVARCHAR(50),
	NGAYSINH DATE,
	DIACHI NVARCHAR(50),
	NGHENGHIEP NVARCHAR(50),
	TINHTRANG NVARCHAR(50),
	SOBIENLAI CHAR(4),
	HOCPHI NVARCHAR(10), 
	GIOITINH NVARCHAR(10) CHECK (GIOITINH IN (N'Nam', N'Nữ'))
);
	-- tạo ràng buộc
		-- ngày sinh không được bằng với ngày của hệ thống
	alter  table HOCVIEN
	add constraint CHK_TABLE_HOCVIEN_NGAYSINH CHECK (NGAYSINH <= GETDATE())
GO

	-- Bảng GIAOVIEN
CREATE TABLE GIAOVIEN	
(
	MAGV CHAR(4) PRIMARY KEY,
	HOTEN NVARCHAR(50),
	NGAYSINH DATE,
	DIACHI NVARCHAR(50),
	DIENTHOAI NVARCHAR(10),
	TRINHDO NVARCHAR(50),
	GIOITINH NVARCHAR(10) CHECK (GIOITINH IN (N'Nam', N'Nữ'))
);
	-- tạo ràng buộc 
		-- ngày sinh không được bằng với ngày của hệ thống
	alter table GIAOVIEN
    add constraint CHK_TABLE_GIAOVIEN_NGAYSINH CHECK (NGAYSINH <= GETDATE()) 
GO

	-- Bảng PHONGHOC
CREATE TABLE PHONGHOC
(
	MAPHONG CHAR(4) PRIMARY KEY,
	TENPHONG NVARCHAR(50),
	TINHTRANG NVARCHAR(50)
)
	-- tạo ràng buộc
	
GO

	--Bảng LOPHOC
	CREATE TABLE LOPHOC
(
	MALOP CHAR(4) PRIMARY KEY,
	SISO INT,
	MAPHONG CHAR(4),
	MAGV CHAR(4),
	MAKH CHAR(4),
	CAHOC NVARCHAR(20),
	NGAYBATDAU DATE,
	NGAYKETTHUC DATE
)
	-- tạo các ràng buộc và khóa ngoại
	ALTER TABLE LOPHOC
	ADD CONSTRAINT CHK_LOPHOC_NGAY CHECK (NGAYBATDAU <= NGAYKETTHUC);
GO

	--BẢNG KHÓA HỌC 
CREATE TABLE KHOAHOC
(
	MAKH CHAR(4) PRIMARY KEY,
	TENKH NVARCHAR(50),
	GHICHU NVARCHAR(100)
)
	-- tạo các ràng buộc
	alter table KHOAHOC
	add CONSTRAINT UQ_KHOAHOC_TENKH UNIQUE (TENKH)
GO

	-- TẠO BẢNG ĐIỂM
CREATE TABLE DIEM
(
	MAHV CHAR(4) PRIMARY KEY,
	MAKH CHAR(4),
	MALOP CHAR(4),
	DIEMQT FLOAT,
	DIEMGK FLOAT,
	DIEMCK FLOAT,
	TONGDIEM FLOAT,
	XEPLOAI NVARCHAR(20),
	GHICHU NVARCHAR(20),
	TINHTRANG BIT,
)
	-- tạo ràng buộc
	ALTER TABLE DIEM
	add CONSTRAINT ck_DIEMQT CHECK (DIEMQT >= 0 AND DIEMQT <= 10)
	ALTER TABLE DIEM
	add CONSTRAINT ck_DIEMGK CHECK (DIEMGK >= 0 AND DIEMGK <= 10)
	ALTER TABLE DIEM
	add CONSTRAINT ck_DIEMCK CHECK (DIEMCK >= 0 AND DIEMCK <= 10)

	-- tạo khóa ngoại
	-- Tạo khóa ngoại từ bảng HOCVIEN đến bảng LOPHOC
ALTER TABLE HOCVIEN
ADD CONSTRAINT FK_HOCVIEN_LOPHOC FOREIGN KEY (MALOP) REFERENCES LOPHOC (MALOP);
-- Tạo khóa ngoại từ bảng LOPHOC đến bảng PHONGHOC
ALTER TABLE LOPHOC
ADD CONSTRAINT FK_LOPHOC_PHONGHOC FOREIGN KEY (MAPHONG) REFERENCES PHONGHOC (MAPHONG);
-- Tạo khóa ngoại từ bảng LOPHOC đến bảng GIAOVIEN
ALTER TABLE LOPHOC
ADD CONSTRAINT FK_LOPHOC_GIAOVIEN FOREIGN KEY (MAGV) REFERENCES GIAOVIEN (MAGV);
-- Tạo khóa ngoại từ bảng LOPHOC đến bảng KHOAHOC
ALTER TABLE LOPHOC
ADD CONSTRAINT FK_LOPHOC_KHOAHOC FOREIGN KEY (MAKH) REFERENCES KHOAHOC (MAKH);
-- Tạo khóa ngoại từ bảng DIEM đến bảng HOCVIEN
ALTER TABLE DIEM
ADD CONSTRAINT FK_DIEM_HOCVIEN FOREIGN KEY (MAHV) REFERENCES HOCVIEN (MAHV);
-- Tạo khóa ngoại từ bảng DIEM đến bảng LOPHOC
ALTER TABLE DIEM
ADD CONSTRAINT FK_DIEM_LOPHOC FOREIGN KEY (MALOP) REFERENCES LOPHOC (MALOP);
ALTER TABLE DIEM
DROP CONSTRAINT FK_DIEM_LOPHOC;

--THÊM DỮ LIỆU
	-- bảng khóa học
	INSERT INTO KHOAHOC (MAKH, TENKH, GHICHU)
VALUES
    ('KH01', N'Lập trình C++ căn bản', N'Khóa học về lập trình C++ dành cho người mới bắt đầu'),
    ('KH02', N'Thiết kế đồ họa', N'Khóa học về thiết kế đồ họa và đồ họa máy tính'),
    ('KH03', N'Tin học văn phòng', N'Khóa học về tin học cơ bản và ứng dụng văn phòng'),
    ('KH04', N'Lập trình Python', N'Khóa học về lập trình Python từ cơ bản đến nâng cao'),
    ('KH05', N'Thiết kế web', N'Khóa học về thiết kế và phát triển trang web'),
    ('KH06', N'Lập trình Java', N'Khóa học về lập trình Java và ứng dụng')
	select *from KHOAHOC
go
	-- bảng phòng học
		select *from PHONGHOC
	INSERT INTO PHONGHOC (MAPHONG, TENPHONG, TINHTRANG)
VALUES
    ('PH01', N'Phòng học 01', N'Trống'),
    ('PH02', N'Phòng học 02', N'Đang sử dụng'),
    ('PH03', N'Phòng học 03', N'Trống'),
    ('PH04', N'Phòng học 04', N'Đang sử dụng'),
    ('PH05', N'Phòng học 05', N'Trống'),
    ('PH06', N'Phòng học 06', N'Đang sử dụng'),
    ('PH07', N'Phòng học 07', N'Trống'),
    ('PH08', N'Phòng học 08', N'Đang sử dụng'),
    ('PH09', N'Phòng học 09', N'Trống'),
    ('PH10', N'Phòng học 10', N'Đang sử dụng'),
    ('PH11', N'Phòng học 11', N'Trống'),
    ('PH12', N'Phòng học 12', N'Đang sử dụng'),
    ('PH13', N'Phòng học 13', N'Trống'),
    ('PH14', N'Phòng học 14', N'Đang sử dụng'),
    ('PH15', N'Phòng học 15', N'Trống');
	
	-- bảng giáo viên
		select *from GIAOVIEN
	INSERT INTO GIAOVIEN (MAGV, HOTEN, NGAYSINH, DIACHI, DIENTHOAI, TRINHDO, GIOITINH)
VALUES
    ('GV01', N'Nguyễn Văn Thọ', '1990-01-15', N'Hà Nội', '0123456789', N'Thạc Sĩ', N'Nam'),
    ('GV02', N'Phạm Thị Bùi Trang', '1985-03-25', N'Hồ Chí Minh', '0987654321', N'Cử Nhân', N'Nữ'),
    ('GV03', N'Lê Đức Minh', '1992-07-10', N'Đà Nẵng', '0369874521', N'Tiến Sĩ', N'Nam'),
    ('GV04', N'Trần Thanh Dương Thùy', '1988-11-08', N'Hải Phòng', '0543216789', N'Cử Nhân', N'Nữ'),
    ('GV05', N'Nguyễn Hoàng Quốc Bảo', '1993-05-20', N'Bình Dương', '0789562314', N'Thạc sĩ', N'Nam'),
    ('GV06', N'Phan Thị Bảo Thy', '1982-09-12', N'Long An', '0765432189', N'Cử Nhân', N'Nữ'),
    ('GV07', N'Bùi Văn Giáp', '1991-04-02', N'Cần Thơ', '0321876543', N'Thạc sĩ', N'Nam'),
    ('GV08', N'Vũ Thị Hoa', '1987-08-30', N'An Giang', '0956314782', N'Cử Nhân', N'Nữ'),
    ('GV09', N'Huỳnh Minh Tiến', '1994-12-05', N'Vũng Tàu', '0236541897', N'Cử Nhân', N'Nam'),
    ('GV10', N'Lương Văn Linh', '1989-06-18', N'Tây Ninh', '0619875432', N'Thạc sĩ', N'Nam'),
    ('GV11', N'Đặng Thị Linh Chi', '1984-02-21', N'Quảng Ngãi', '0897432165', N'Cử Nhân', N'Nữ'),
    ('GV12', N'Trần Quốc Thái', '1995-10-03', N'Kiên Giang', '0123654789', N'Cử Nhân', N'Nam'),
    ('GV13', N'Lê Văn Nho', '1983-11-17', N'Bình Phước', '0987456321', N'Tiến Sĩ', N'Nam'),
    ('GV14', N'Nguyễn Thị Oanh', '1990-07-07', N'Lâm Đồng', '0369214785', N'Cử Nhân', N'Nữ'),
    ('GV15', N'Phạm Minh Phương', '1986-09-28', N'Đắk Lắk', '0785643129', N'Cử Nhân', N'Nam');

	-- bảng lớp học
	select *from LOPHOC
	INSERT INTO LOPHOC (MALOP, SISO, MAPHONG, MAGV, MAKH, CAHOC, NGAYBATDAU, NGAYKETTHUC)
VALUES
    ('ML01', 20, 'PH01', 'GV01', 'KH01', N'Sáng thứ 2', '2023-08-07', '2023-11-07'),
    ('ML02', 25, 'PH02', 'GV02', 'KH02', N'Chiều thứ 3', '2023-08-10', '2023-11-10'),
    ('ML03', 15, 'PH03', 'GV03', 'KH03', N'Sáng thứ 4', '2023-08-15', '2023-11-15'),
    ('ML04', 30, 'PH04', 'GV04', 'KH04', N'Chiều thứ 5', '2023-08-20', '2023-11-20'),
    ('ML05', 22, 'PH05', 'GV05', 'KH05', N'Sáng thứ 6', '2023-08-25', '2023-11-25'),
    ('ML06', 18, 'PH06', 'GV06', 'KH06', N'Chiều thứ 7', '2023-09-01', '2023-12-01'),
    ('ML07', 26, 'PH07', 'GV07', 'KH01', N'Sáng Chủ nhật', '2023-09-07', '2023-12-07'),
    ('ML08', 20, 'PH08', 'GV08', 'KH02', N'Chiều thứ 2', '2023-09-15', '2023-12-15'),
    ('ML09', 15, 'PH09', 'GV09', 'KH03', N'Sáng thứ 3', '2023-09-20', '2023-12-20'),
    ('ML10', 28, 'PH10', 'GV10', 'KH04', N'Chiều thứ 4', '2023-09-25', '2023-12-25'),
    ('ML11', 17, 'PH11', 'GV11', 'KH01', N'Sáng thứ 5', '2023-10-01', '2023-12-01'),
    ('ML12', 23, 'PH12', 'GV12', 'KH02', N'Chiều thứ 6', '2023-10-10', '2024-01-10'),
    ('ML13', 14, 'PH13', 'GV13', 'KH03', N'Sáng thứ 7', '2023-10-15', '2023-12-15'),
    ('ML14', 30, 'PH14', 'GV14', 'KH04', N'Chiều Chủ nhật', '2023-10-20', '2024-01-20'),
    ('ML15', 21, 'PH15', 'GV15', 'KH05', N'Sáng thứ 2', '2023-10-25', '2023-12-25');

	-- bảng hoc vien
	select *from HOCVIEN
	INSERT INTO HOCVIEN (MAHV, MALOP, HOTEN, NGAYSINH, DIACHI, NGHENGHIEP, TINHTRANG, SOBIENLAI, HOCPHI, GIOITINH)
VALUES
    ('HV01', 'ML01', N'Nguyễn Thị Nhân', '2000-03-10', N'Hà Nội', N'Học sinh', N'Còn học', 'BL01', 1800000, N'Nữ'),
    ('HV02', 'ML02', N'Trần Văn Nam', '1999-06-25', N'Hồ Chí Minh', N'Sinh viên', N'Còn học', 'BL02', 2500000, N'Nam'),
    ('HV03', 'ML03', N'Lê Thị Lan', '2001-01-15', N'Đà Nẵng', N'Văn phòng', N'Đã học xong', 'BL03', 3500000, N'Nữ'),
    ('HV04', 'ML04', N'Phạm Văn An', '2002-04-30', N'Nghệ An', N'Học sinh', N'Còn học', 'BL04', 2000000, N'Nam'),
    ('HV05', 'ML05', N'Nguyễn Thị Mai', '2000-07-08', N'Bình Dương', N'Sinh viên', N'Còn học', 'BL05', 2800000, N'Nữ'),
    ('HV06', 'ML06', N'Bùi Minh Hoàng', '1998-11-20', N'Long An', N'Văn phòng', N'Đã học xong', 'BL06', 4000000, N'Nam'),
    ('HV07', 'ML07', N'Lê Thị Hà', '2003-02-05', N'Cần Thơ', N'Học sinh', N'Còn học', 'BL07', 1700000, N'Nữ'),
    ('HV08', 'ML08', N'Nguyễn Đức Thắng', '1999-05-18', N'An Giang', N'Sinh viên', N'Còn học', 'BL08', 2600000, N'Nam'),
    ('HV09', 'ML09', N'Hồ Thị Ngọc', '2001-09-07', N'Vũng Tàu', N'Văn phòng', N'Đã học xong', 'BL09', 3800000, N'Nữ'),
    ('HV10', 'ML10', N'Đặng Văn Bình', '2002-11-30', N'Đồng Nai', N'Học sinh', N'Còn học', 'BL10', 1900000, N'Nam'),
    ('HV11', 'ML11', N'Trần Thị Thu', '2000-08-12', N'Quảng Ngãi', N'Sinh viên', N'Còn học', 'BL11', 2700000, N'Nữ'),
    ('HV12', 'ML12', N'Vũ Đức Tuấn', '1999-04-02', N'Phú Yên', N'Văn phòng', N'Đã học xong', 'BL12', 4200000, N'Nam'),
    ('HV13', 'ML13', N'Phan Thị Ngân', '2001-12-25', N'Bình Phước', N'Học sinh', N'Còn học', 'BL13', 1600000, N'Nữ'),
    ('HV14', 'ML14', N'Nguyễn Văn Hùng', '1998-09-18', N'Đắk Lắk', N'Sinh viên', N'Còn học', 'BL14', 2900000, N'Nam'),
    ('HV15', 'ML15', N'Lê Thị Trang', '2000-06-07', N'Gia Lai', N'Văn phòng', N'Đã học xong', 'BL15', 4300000, N'Nữ'),
    ('HV16', 'ML01', N'Hoàng Thị Tuyết', '2002-02-28', N'Thái Nguyên', N'Học sinh', N'Còn học', 'BL16', 2100000, N'Nữ'),
    ('HV17', 'ML02', N'Nguyễn Văn Hải', '1999-07-15', N'Nam Định', N'Sinh viên', N'Còn học', 'BL17', 2400000, N'Nam'),
    ('HV18', 'ML03', N'Trần Thị Hoa', '2001-04-05', N'Hải Phòng', N'Văn phòng', N'Đã học xong', 'BL18', 3700000, N'Nữ'),
    ('HV19', 'ML04', N'Võ Văn Đạt', '2003-10-20', N'Hưng Yên', N'Học sinh', N'Còn học', 'BL19', 2200000, N'Nam'),
    ('HV20', 'ML05', N'Nguyễn Thị Tâm', '2000-09-28', N'Bắc Ninh', N'Sinh viên', N'Còn học', 'BL20', 3100000, N'Nữ'),
    ('HV21', 'ML06', N'Phạm Đức Anh', '1998-12-07', N'Hà Nam', N'Văn phòng', N'Đã học xong', 'BL21', 4800000, N'Nam'),
    ('HV22', 'ML07', N'Huỳnh Minh Hải', '2003-01-10', N'Thái Bình', N'Học sinh', N'Còn học', 'BL22', 2300000, N'Nam'),
    ('HV23', 'ML08', N'Nguyễn Thị Ngọc', '1999-03-28', N'Hà Tĩnh', N'Sinh viên', N'Còn học', 'BL23', 3300000, N'Nữ'),
    ('HV24', 'ML09', N'Lê Văn Quang', '2001-08-15', N'Quảng Bình', N'Văn phòng', N'Đã học xong', 'BL24', 4600000, N'Nam'),
    ('HV25', 'ML10', N'Trương Thị Hoàng', '2002-10-10', N'Ninh Bình', N'Học sinh', N'Còn học', 'BL25', 2000000, N'Nữ'),
    ('HV26', 'ML11', N'Đỗ Văn Hùng', '2000-05-07', N'Yên Bái', N'Sinh viên', N'Còn học', 'BL26', 3000000, N'Nam'),
    ('HV27', 'ML12', N'Phan Thị Tú', '1998-11-30', N'Lào Cai', N'Văn phòng', N'Đã học xong', 'BL27', 4200000, N'Nữ'),
    ('HV28', 'ML13', N'Nguyễn Văn Thanh', '2001-07-18', N'Sơn La', N'Học sinh', N'Còn học', 'BL28', 2400000, N'Nam'),
    ('HV29', 'ML14', N'Hoàng Thị Hồng', '2000-02-05', N'Tuyên Quang', N'Sinh viên', N'Còn học', 'BL29', 3200000, N'Nữ'),
    ('HV30', 'ML15', N'Nguyễn Thế Anh', '1999-09-22', N'Điện Biên', N'Văn phòng', N'Đã học xong', 'BL30', 4500000, N'Nam');

	-- bảng điểm
	select *from DIEM
	INSERT INTO DIEM (MAHV, MAKH, MALOP, DIEMQT, DIEMGK, DIEMCK, TONGDIEM, XEPLOAI, GHICHU, TINHTRANG)
VALUES
    --('HV01', 'KH01', 'ML01', 8.5, 7.5, 9.0, (8.5 + 7.5 + 9.0) / 3, N'Khá', N'Đạt chuẩn', 1),
    ('HV02', 'KH01', 'ML02', 7.0, 6.5, 8.0, (7.0 + 6.5 + 8.0) / 3, N'Trung bình', N'Cần cải thiện', 0),
    ('HV03', 'KH02', 'ML03', 9.5, 8.5, 9.0, (9.5 + 8.5 + 9.0) / 3, N'Giỏi', N'Xuất sắc', 1),
    ('HV04', 'KH02', 'ML01', 6.0, 7.0, 6.5, (6.0 + 7.0 + 6.5) / 3, N'Trung bình', N'Cần cải thiện', 0),
    ('HV05', 'KH03', 'ML02', 8.0, 8.5, 9.5, (8.0 + 8.5 + 9.5) / 3, N'Khá', N'Đạt chuẩn', 1),
    ('HV06', 'KH03', 'ML03', 7.5, 6.0, 7.0, (7.5 + 6.0 + 7.0) / 3, N'Trung bình', N'Cần cải thiện', 0),
    ('HV07', 'KH04', 'ML01', 6.5, 7.5, 8.5, (6.5 + 7.5 + 8.5) / 3, N'Trung bình', N'Cần cải thiện', 0),
    ('HV08', 'KH04', 'ML02', 9.0, 9.5, 9.0, (9.0 + 9.5 + 9.0) / 3, N'Giỏi', N'Xuất sắc', 1),
    ('HV09', 'KH05', 'ML03', 6.5, 8.0, 7.5, (6.5 + 8.0 + 7.5) / 3, N'Trung bình', N'Cần cải thiện', 0),
    ('HV10', 'KH05', 'ML01', 8.5, 7.5, 8.0, (8.5 + 7.5 + 8.0) / 3, N'Khá', N'Đạt chuẩn', 1),
    ('HV11', 'KH06', 'ML02', 7.0, 6.0, 6.5, (7.0 + 6.0 + 6.5) / 3, N'Trung bình', N'Cần cải thiện', 0),
    ('HV12', 'KH06', 'ML03', 9.0, 8.0, 7.5, (9.0 + 8.0 + 7.5) / 3, N'Khá', N'Đạt chuẩn', 1),
    ('HV13', 'KH07', 'ML01', 5.5, 6.5, 6.0, (5.5 + 6.5 + 6.0) / 3, N'Yếu', N'Cần cải thiện', 0),
    ('HV14', 'KH07', 'ML02', 8.5, 9.0, 8.5, (8.5 + 9.0 + 8.5) / 3, N'Khá', N'Đạt chuẩn', 1),
    ('HV15', 'KH08', 'ML03', 7.5, 7.5, 8.0, (7.5 + 7.5 + 8.0) / 3, N'Khá', N'Đạt chuẩn', 1),
    ('HV16', 'KH08', 'ML01', 8.0, 8.5, 8.5, (8.0 + 8.5 + 8.5) / 3, N'Khá', N'Đạt chuẩn', 1),
    ('HV17', 'KH09', 'ML02', 6.5, 6.0, 6.5, (6.5 + 6.0 + 6.5) / 3, N'Trung bình', N'Cần cải thiện', 0),
    ('HV18', 'KH09', 'ML03', 9.0, 9.5, 9.0, (9.0 + 9.5 + 9.0) / 3, N'Giỏi', N'Xuất sắc', 1),
    ('HV19', 'KH10', 'ML01', 6.5, 8.0, 7.5, (6.5 + 8.0 + 7.5) / 3, N'Trung bình', N'Cần cải thiện', 0),
    ('HV20', 'KH10', 'ML02', 8.5, 7.5, 8.0, (8.5 + 7.5 + 8.0) / 3, N'Khá', N'Đạt chuẩn', 1),
    ('HV21', 'KH01', 'ML03', 7.0, 6.0, 6.5, (7.0 + 6.0 + 6.5) / 3, N'Trung bình', N'Cần cải thiện', 0),
    ('HV22', 'KH01', 'ML01', 9.0, 8.0, 7.5, (9.0 + 8.0 + 7.5) / 3, N'Khá', N'Đạt chuẩn', 1),
    ('HV23', 'KH02', 'ML02', 5.5, 6.5, 6.0, (5.5 + 6.5 + 6.0) / 3, N'Yếu', N'Cần cải thiện', 0),
    ('HV24', 'KH02', 'ML03', 8.5, 9.0, 8.5, (8.5 + 9.0 + 8.5) / 3, N'Khá', N'Đạt chuẩn', 1),
    ('HV25', 'KH03', 'ML01', 7.5, 7.5, 8.0, (7.5 + 7.5 + 8.0) / 3, N'Khá', N'Đạt chuẩn', 1),
    ('HV26', 'KH03', 'ML02', 8.5, 7.5, 9.0, (8.5 + 7.5 + 9.0) / 3, N'Khá', N'Đạt chuẩn', 1),
    ('HV27', 'KH04', 'ML03', 7.0, 6.0, 6.5, (7.0 + 6.0 + 6.5) / 3, N'Trung bình', N'Cần cải thiện', 0),
    ('HV28', 'KH04', 'ML01', 9.5, 8.5, 9.0, (9.5 + 8.5 + 9.0) / 3, N'Giỏi', N'Xuất sắc', 1),
    ('HV29', 'KH05', 'ML02', 6.0, 7.0, 6.5, (6.0 + 7.0 + 6.5) / 3, N'Trung bình', N'Cần cải thiện', 0),
    ('HV30', 'KH05', 'ML03', 8.0, 8.5, 9.5, (8.0 + 8.5 + 9.5) / 3, N'Khá', N'Đạt chuẩn', 1);
