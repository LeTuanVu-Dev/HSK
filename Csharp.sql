--Tạo cơ sở dữ liệu
CREATE DATABASE BTL_QUANLYBANHANG_CSharps
ON (
	 NAME = 'BTL_SQLSever_QUANLYBANHANG',
	 FILENAME = 'D:\SQL_HSK\btl\BTL_QUANLYBANHANG.mdf',
	 MAXSIZE = UNLIMITED
)
GO

USE BTL_QUANLYBANHANG_CSharps
GO
--Tạo bảng Nhà Cung Cấp
CREATE TABLE tblNhaCungCap (
    sMaNCC VARCHAR(10) NOT NULL,
    sTenNCC NVARCHAR(50) NOT NULL,
    sDiaChi NVARCHAR(255) NOT NULL,
	sSDT VARCHAR(11) NOT NULL,
	sEmail VARCHAR(50) NOT NULL,
    CONSTRAINT PK_tblNhaCungCap PRIMARY KEY(sMaNCC)
)

--Tạo bảng Sản Phẩm
CREATE TABLE tblSanPham (
    sMaSP VARCHAR(10) NOT NULL,
    sTenSP NVARCHAR(50) NOT NULL,
	sMaNCC VARCHAR(10) NOT NULL,
	iTongSL INT NOT NULL,
	fGiaSP FLOAT NOT NULL,
	sMauSac NVARCHAR(30) NOT NULL,
	fKichThuoc FLOAT NOT NULL,
	iRAM INT NOT NULL,
	iBoNhoTrong INT NOT NULL,
	iTGBaoHanh INT NOT NULL,
    CONSTRAINT PK_tblSanPham PRIMARY KEY(sMaSP),
	CONSTRAINT FK_SanPham_NhaCungCap FOREIGN KEY(sMaNCC)
	REFERENCES dbo.tblNhaCungCap(sMaNCC)
)

--Tạo bảng Nhân Viên
CREATE TABLE tblNhanVien (
    sMaNV VARCHAR(10) NOT NULL,
    sTenNV NVARCHAR(50) NOT NULL,
	bGioiTinh BIT NOT NULL,
    sDiaChi NVARCHAR(255),
	sSDT VARCHAR(11) NOT NULL,
	sEmail VARCHAR(50),
	sCMND VARCHAR(12) NOT NULL,
	dNgaySinh DATE NOT NULL,
	dNgayVaoLam DATE NOT NULL,
	fHeSoLuong FLOAT NOT NULL,
	fPhuCap FLOAT NOT NULL,
    CONSTRAINT PK_tblNhanVien PRIMARY KEY(sMaNV),
	CONSTRAINT CHK_dNgaySinh_NhanVien CHECK (dNgaySinh <= GETDATE()),
	CONSTRAINT CHK_dNgayVaoLam CHECK (dNgayVaoLam <= GETDATE()),
	CONSTRAINT CHK_fHeSoLuong CHECK (fHeSoLuong > 0 AND fHeSoLuong < 10),
	CONSTRAINT CHK_fPhuCap CHECK (fPhuCap > 0)
)
SELECT * FROM dbo.tblNhanVien

-- Thêm userName, Pass cho nhân viên
alter table tblNhanVien add username varchar(30) ,pass varchar(255) , rolle varchar(10)


CREATE TABLE tblKhachHang (
    sMaKH VARCHAR(10) NOT NULL,
    sTenKH NVARCHAR(50) NOT NULL,
    sDiaChi NVARCHAR(255) NOT NULL,
	dNgaySinh DATE,
	sSDT VARCHAR(11) NOT NULL,
	sEmail VARCHAR(50),
	sCMND VARCHAR(12),
    CONSTRAINT PK_tblKhachHang PRIMARY KEY(sMaKH),
	CONSTRAINT CHK_dNgaySinh_KhachHang CHECK (dNgaySinh < GETDATE())
)

--Tạo bảng Hóa Đơn Bán
CREATE TABLE tblHoaDonBan (
    iMaHDB INT IDENTITY(1,1),
    sMaNV VARCHAR(10) NOT NULL,
    sMaKH VARCHAR(10) NOT NULL,
	dNgayBan DATE NOT NULL,
    CONSTRAINT PK_tblHoaDonBan PRIMARY KEY(iMaHDB),
	CONSTRAINT FK_HoaDonBan_NhanVien FOREIGN KEY(sMaNV)
	REFERENCES dbo.tblNhanVien(sMaNV),
	CONSTRAINT FK_HoaDonBan_KhachHang FOREIGN KEY(sMaKH)
	REFERENCES dbo.tblKhachHang(sMaKH),
	CONSTRAINT CHK_dNgayDatHang CHECK (dNgayBan <= GETDATE())
)

--Tạo bảng Chi Tiết Hóa Đơn Bán
CREATE TABLE tblCT_HoaDonBan (
    iMaHDB INT NOT NULL,
    sMaSP VARCHAR(10) NOT NULL,
    iSLBan INT NOT NULL,
	fGiaBan FLOAT NOT NULL,
	fMucGiamGia FLOAT,
	dTGBaoHanh DATE,
    CONSTRAINT PK_tblCT_HoaDonBan PRIMARY KEY(iMaHDB, sMaSP),
	CONSTRAINT FK_CT_HoaDonBan_HoaDonBan FOREIGN KEY(iMaHDB)
	REFERENCES dbo.tblHoaDonBan(iMaHDB),
	CONSTRAINT FK_CT_HoaDonBan_SanPham FOREIGN KEY(sMaSP)
	REFERENCES dbo.tblSanPham(sMaSP),
	CONSTRAINT CHK_iSLBan CHECK (iSLBan > 0),
	CONSTRAINT CHK_fGiaBan CHECK (fGiaBan > 0),
	CONSTRAINT CHK_fMucGiamGia CHECK (fMucGiamGia BETWEEN 0 AND 1)
)

--Tạo bảng Hóa Đơn Nhập
CREATE TABLE tblHoaDonNhap (
    iMaHDN INT IDENTITY(1,1),
    sMaNV VARCHAR(10) NOT NULL,
    sMaNCC VARCHAR(10) NOT NULL,
	dNgayNhapHang DATE NOT NULL,
    CONSTRAINT PK_tblHoaDonNhap PRIMARY KEY(iMaHDN),
	CONSTRAINT FK_HoaDonNhap_NhanVien FOREIGN KEY(sMaNV)
	REFERENCES dbo.tblNhanVien(sMaNV),
	CONSTRAINT FK_HoaDonNhap_NhaCungCap FOREIGN KEY(sMaNCC)
	REFERENCES dbo.tblNhaCungCap(sMaNCC),
	CONSTRAINT CHK_dNgayNhapHang CHECK (dNgayNhapHang <= GETDATE())
)

--Tạo bảng Chi Tiết Hóa Đơn Nhập
CREATE TABLE tblCT_HoaDonNhap (
    iMaHDN INT NOT NULL,
    sMaSP VARCHAR(10) NOT NULL,
    iSLNhap INT NOT NULL,
	fGiaNhap FLOAT NOT NULL,
    CONSTRAINT PK_tblCT_HoaDonNhap PRIMARY KEY(iMaHDN, sMaSP),
	CONSTRAINT FK_CT_HoaDonNhap_HoaDonNhap FOREIGN KEY(iMaHDN)
	REFERENCES dbo.tblHoaDonNhap(iMaHDN),
	CONSTRAINT FK_CT_HoaDonNhap_SanPham FOREIGN KEY(sMaSP)
	REFERENCES dbo.tblSanPham(sMaSP),
	CONSTRAINT CHK_iSLNhap CHECK (iSLNhap > 0),
	CONSTRAINT CHK_fGiaNhap CHECK (fGiaNhap > 0)
)

--Chèn dữ liệu vào bảng tblNhaCungCap
INSERT INTO dbo.tblNhaCungCap(sMaNCC, sTenNCC, sDiaChi, sSDT, sEmail)
VALUES
	('NCC001', N'Apple', N'Thanh Hóa', '0952058829', 'Apple.388@gmail.com'),
	('NCC002', N'Samsung', N'Hồ Chí Minh', '0955024523', 'Samsung.850@gmail.com'),
	('NCC003', N'Xiaomi', N'Hà Nội', '0912579450', 'Xiaomi.431@gmail.com'),
	('NCC004', N'Oppo', N'Hà Nội', '0939732965', 'Oppo.15@gmail.com'),
	('NCC005', N'Nokia', N'Hà Nội', '0329669463', 'Nokia.530@gmail.com'),
	('NCC006', N'Realme', N'Hải Phòng', '0913456506', 'Realme.865@gmail.com'),
	('NCC007', N'Vsmart', N'Hồ Chí Minh', '0365167764', 'Vsmart.209@gmail.com'),
	('NCC008', N'Vivo', N'Hà Nội', '0917361477', 'Vivo.635@gmail.com'),
	('NCC009', N'Redmi', N'Đồng Nai', '0994417810', 'Redmi.821@gmail.com'),
	('NCC010', N'LG', N'Hà Nội', '0318583909', 'LG.367@gmail.com'),
	('NCC011', N'Motorola', N'Đồng Nai', '0943952683', 'Motorola.744@gmail.com'),
	('NCC012', N'OnePlus', N'Hà Nội', '0371756798', 'OnePlus.5@gmail.com'),
	('NCC013', N'Huawei', N'Hồ Chí Minh', '0938047406', 'Huawei.482@gmail.com'),
	('NCC014', N'HTC', N'Hà Nội', '0918460967', 'HTC.613@gmail.com'),
	('NCC015', N'Lenovo ', N'Hồ Chí Minh', '0324213584', 'Lenovo.236@gmail.com'),
	('NCC016', N'Blackberry', N'Hồ Chí Minh', '0335201765', 'Blackberry.681@gmail.com'),
	('NCC017', N'Alcatel-Lucent', N'Đà Nẵng', '0360150461', 'Alcatel-Lucent.281@gmail.com'),
	('NCC018', N'Sony', N'Hồ Chí Minh', '0312910276', 'Sony.456@gmail.com'),
	('NCC019', N'ZTE', N'Hà Nội', '0986576815', 'ZTE.693@gmail.com'),
	('NCC020', N'Asus', N'Đà Nẵng', '0390661477', 'Asus.333@gmail.com')

SELECT * FROM dbo.tblNhaCungCap

--Chèn dữ liệu vào bảng tblSanPham
INSERT INTO dbo.tblSanPham(sMaSP, sTenSP, sMaNCC, iTongSL, fGiaSP, sMauSac, fKichThuoc, iRAM, iBoNhoTrong, iTGBaoHanh)
VALUES
	('SP001', N'iPhone 13 512GB', 'NCC001', '110', 42000000, N'Xám', 6.7, 6, 512, 12),
	('SP002', N'iPhone 13 512GB', 'NCC001', '110', 42000000, N'Bạc', 6.7, 6, 512, 12),
	('SP003', N'iPhone 13 512GB', 'NCC001', '110', 42000000, N'Xanh', 6.7, 6, 512, 12),
	('SP004', N'iPhone 13 512GB', 'NCC001', '110', 42000000, N'Vàng', 6.7, 6, 512, 12),
	('SP005', N'iPhone 12 Pro Max 128GB', 'NCC001', '129', 26000000, N'Xám', 6.7, 6, 128, 12),
	('SP006', N'iPhone 12 Pro Max 128GB', 'NCC001', '129', 26000000, N'Bạc', 6.7, 6, 128, 12),
	('SP007', N'iPhone 12 Pro Max 128GB', 'NCC001', '129', 26000000, N'Xanh', 6.7, 6, 128, 12),
	('SP008', N'iPhone 12 Pro Max 128GB', 'NCC001', '129', 26000000, N'Vàng', 6.7, 6, 128, 12),
	('SP009', N'iPhone 11 64GB', 'NCC001', '183', 14500000, N'Đen', 6.1, 4, 64, 12),
	('SP010', N'iPhone 11 64GB', 'NCC001', '183', 14500000, N'Xanh lục', 6.1, 4, 64, 12),
	('SP011', N'iPhone 11 64GB', 'NCC001', '183', 14500000, N'Trắng', 6.1, 4, 64, 12),
	('SP012', N'iPhone 11 64GB', 'NCC001', '183', 14500000, N'Đỏ', 6.1, 4, 64, 12),
	('SP013', N'iPhone SE(2020) 128GB', 'NCC001', '175', 8000000, N'Đen', 4.7, 3, 64, 12),
	('SP014', N'iPhone SE(2020) 128GB', 'NCC001', '175', 8000000, N'Trắng', 4.7, 3, 64, 12),
	('SP015', N'Samsung Galaxy Z Fold3', 'NCC002', '128', 50000000, N'Bạc', 7.6, 12, 256, 12),
	('SP016', N'Samsung Galaxy Z Fold3', 'NCC002', '128', 50000000, N'Đen', 7.6, 12, 256, 12),
	('SP017', N'Samsung Galaxy Z Fold3', 'NCC002', '128', 50000000, N'Trắng', 7.6, 12, 256, 12),
	('SP018', N'Samsung Galaxy A50s', 'NCC002', '20', 5600000, N'Tím', 6.5, 8, 128, 12),
	('SP019', N'Samsung Galaxy A50s', 'NCC002', '20', 5600000, N'Đen', 6.5, 8, 128, 12),
	('SP020', N'Samsung Galaxy A10s', 'NCC002', '136', 2000000, N'Đỏ', 6.2, 2, 32, 12),
	('SP021', N'Samsung Galaxy A10s', 'NCC002', '136', 2000000, N'Trắng', 6.2, 2, 32, 12),
	('SP022', N'Samsung Galaxy A71', 'NCC002', '105', 5200000, N'Xanh lục', 6.7, 8, 128, 12),
	('SP023', N'Samsung Galaxy A71', 'NCC002', '105', 5200000, N'Hồng', 6.7, 8, 128, 12),
	('SP024', N'Redmi Note 8 Pro', 'NCC009', '124', 3300000, N'Xanh lục', 6.53, 6, 64, 18),
	('SP025', N'Redmi Note 8 Pro', 'NCC009', '124', 3300000, N'Xanh dương', 6.53, 6, 64, 18),
	('SP026', N'Redmi Note 8 Pro', 'NCC009', '124', 3300000, N'Xám', 6.53, 6, 64, 18),
	('SP027', N'Redmi Note 10', 'NCC009', '106', 6700000, N'Vàng Đồng', 6.67, 8, 128, 18),
	('SP028', N'Redmi Note 10', 'NCC009', '106', 6700000, N'Trắng', 6.67, 8, 128, 18),
	('SP029', N'Redmi Note 10', 'NCC009', '106', 6700000, N'Xám', 6.67, 8, 128, 18),
	('SP030', N'Redmi Note 9 Pro 5G', 'NCC009', '107', 4200000, N'Trắng', 6.67, 8, 256, 12),
	('SP031', N'Redmi Note 9 Pro 5G', 'NCC009', '107', 4200000, N'Đen', 6.67, 8, 256, 12),
	('SP032', N'Redmi Note 9 Pro 5G', 'NCC009', '107', 4200000, N'Bạc', 6.67, 8, 256, 12)

SELECT * FROM dbo.tblSanPham
SELECT * FROM dbo.tblCT_HoaDonNhap
SELECT * FROM dbo.tblCT_HoaDonBan
UPDATE dbo.tblCT_HoaDonNhap SET fGiaNhap = 26000000 WHERE sMaSP= 'SP007'


select * from tblNhanVien
--Chèn dữ liệu vào bảng tblNhanVien
INSERT INTO dbo.tblNhanVien(sMaNV, sTenNV, bGioiTinh, sDiaChi, sSDT, sEmail, sCMND, dNgaySinh, dNgayVaoLam, fHeSoLuong, fPhuCap)
VALUES
	('NV001', N'Hải Triều Nghệ An', 1, N'Hà Nam', '0960701267', 'haitrieunghean.568@gmail.com', '11530235612', '1992/07/31', '2019/12/26', 2.89, 0.1),
	('NV002', N'Tào Mạnh Cường', 1, N'Hà Nam', '0311967673', 'taomanhcuong.993@gmail.com', '11234046938', '2000/01/12', '2020/07/07', 3.3, 0.4),
	('NV003', N'Nguyễn Văn Tùng Béo', 1, N'Hải Phòng', '0377034441', 'nguyenvantungbeo.607@gmail.com', '11846667283', '1992/04/22', '2020/11/25', 2.49, 0.1),
	('NV004', N'Nguyễn Thị Lan Nhi', 0, N'Hà Nội', '0383838061', 'nguyenthilannhi.3@gmail.com', '11682626165', '1994/07/19', '2018/11/20', 4.02, 0.4),
	('NV005', N'Phạm Gia Bảo', 1, N'Hà Nội', '0368047154', 'phamgiabao.575@gmail.com', '11278497787', '2000/10/23', '2019/11/26', 2.83, 0.3),
	('NV006', N'Nguyễn Văn Ánh Sáng', 1, N'Vĩnh Phúc', '0960099347', 'nguyenvananhsang.520@gmail.com', '11674576966', '1997/10/07', '2020/12/22', 4.57, 0.6),
	('NV007', N'Phạm Bóng Tối', 1, N'Hải Phòng', '0314680565', 'phambongtoi.666@gmail.com', '11983726570', '1999/01/10', '2019/11/18', 4.31, 0.1),
	('NV008', N'Nguyễn Hải Đăng', 1, N'Hà Nội', '0999837330', 'nguyenhaidang.845@gmail.com', '11654628510', '1990/07/31', '2020/10/26', 3.55, 0.6),
	('NV009', N'Nguyễn Thị Thùy Linh', 0, N'Hà Nội', '0949513696', 'nguyenthithuylinh.762@gmail.com', '11401467638', '1995/10/08', '2018/12/05', 4.32, 0.1),
	('NV010', N'Trần Thị Hà Trang', 0, N'Hà Nội', '0360992350', 'tranthihatrang.171@gmail.com', '11877680898', '1990/09/08', '2018/08/28', 2.56, 0.4),
	('NV011', N'Nguyễn Thị Huyền Trang', 0, N'Hà Nội', '0940482090', 'nguyenthihuyentrang.157@gmail.com', '11301480849', '1999/05/24', '2019/12/07', 3.49, 0.6),
	('NV012', N'Phạm Duy Đạt', 1, N'Hải Phòng', '0966120112', 'phamduydat.609@gmail.com', '11667174459', '1991/02/22', '2019/04/25', 4.81, 0.5),
	('NV013', N'Phạm Minh Đức', 1, N'Hà Nội', '0375982612', 'phamminhduc.344@gmail.com', '11345765355', '1991/09/05', '2018/10/26', 2.77, 0.5),
	('NV014', N'Trần Thị Thu Hà', 0, N'Hải Phòng', '0966215380', 'tranthithuha.858@gmail.com', '11152200969', '1997/05/14', '2020/04/15', 2.76, 0.4),
	('NV015', N'Trịnh Ngọc Hào', 0, N'Hà Nội', '0330732763', 'trinhngochao.848@gmail.com', '11834490490', '1993/08/03', '2020/02/28', 3.3, 0.6),
	('NV016', N'Trịnh Ngọc Tân', 1, N'Hà Nội', '0976910859', 'trinhngoctan.178@gmail.com', '11349552178', '2000/06/04', '2020/07/09', 4.24, 0.1),
	('NV017', N'Nguyễn Thị Kiều Ly', 0, N'Hà Nam', '0999124425', 'nguyenthikieuly.493@gmail.com', '11847970305', '1992/05/27', '2019/07/21', 4.54, 0.6),
	('NV018', N'Nguyễn An Nhiên', 0, N'Hà Nội', '0977122874', 'nguyenannhien.476@gmail.com', '11269167500', '1994/08/21', '2020/01/26', 3.71, 0.1),
	('NV019', N'Đặng Xuân Mai', 0, N'Vĩnh Phúc', '0975474174', 'dangxuanmai.58@gmail.com', '11177090960', '1998/01/20', '2018/10/12', 4.02, 0.6),
	('NV020', N'Hòa Dỹ Nhiên', 0, N'Hà Nội', '0385320691', 'hoadynhien.462@gmail.com', '11275363177', '2000/04/26', '2020/02/18', 2.68, 0.1)

SELECT * FROM dbo.tblNhanVien

--Chèn dữ liệu vào bảng tblKhachHang
INSERT INTO dbo.tblKhachHang(sMaKH, sTenKH, sDiaChi, dNgaySinh, sSDT, sEmail, sCMND)
VALUES
	('KH001', N'Ngô Văn Ten', N'Hà Nội', '2000/05/05', '972127995', 'ngovanten.974@gmail.com', '118591281127'),
	('KH002', N'Bùi Xuân Huấn', N'Hà Nội', '2009/12/25', '312258341', 'buixuanhuan.946@gmail.com', '114952214831'),
	('KH003', N'Dương Hồng Hạnh', N'Bắc Ninh', '1995/02/22', '983485237', 'duonghonghanh.693@gmail.com', '116951224138'),
	('KH004', N'Nguyễn Lưu Luyến', N'Hà Nội', '2000/11/02', '350552411', 'nguyenluuluyen.133@gmail.com', '114316661609'),
	('KH005', N'Mai Luyến Lưu', N'Hải Phòng', '2006/01/30', '341745245', 'mailuyenluu.265@gmail.com', '117276762538'),
	('KH006', N'Tống Kim Phúc', N'Bắc Ninh', '1996/06/08', '962591648', 'tongkimphuc.254@gmail.com', '118590731570'),
	('KH007', N'Tốn Phúc Thinh', N'Hà Nội', '2005/07/17', '984717398', 'tonphucthinh.151@gmail.com', '116839749704'),
	('KH008', N'Tào Minh Quang', N'Thái Bình', '2008/12/17', '338264540', 'taominhquang.524@gmail.com', '115012730306'),
	('KH009', N'Nguyễn Minh Chính', N'Hà Nội', '2008/04/02', '333589075', 'nguyenminhchinh.413@gmail.com', '114905881466'),
	('KH010', N'Phạm Chính Nghĩa', N'Thái Bình', '1994/04/13', '998963807', 'phamchinhnghia.619@gmail.com', '112556443370'),
	('KH011', N'Lưu Luyễn Mãi', N'Hà Nội', '1996/08/16', '329181837', 'luuluyenmai.670@gmail.com', '111845853369'),
	('KH012', N'Nguyễn Sao Mai', N'Hải Phòng', '1999/03/16', '386504860', 'nguyensaomai.48@gmail.com', '118704179252'),
	('KH013', N'Nguyễn Văn Tùng', N'Bắc Ninh', '2002/09/03', '395280061', 'nguyenvantung.893@gmail.com', '114694286788'),
	('KH014', N'Nguyễn Văn Lợi', N'Hà Nam', '2005/04/30', '927423428', 'nguyenvanloi.659@gmail.com', '119919700150'),
	('KH015', N'Phạm Danh Đạt', N'Hà Nội', '1991/08/08', '320510353', 'phamdanhdat.432@gmail.com', '116780532804'),
	('KH016', N'Nguyễn Ngọc Duy', N'Bắc Ninh', '1990/03/30', '988180089', 'nguyenngocduy.108@gmail.com', '112948998928'),
	('KH017', N'Ngô Xuân Mai', N'Hà Nội', '2006/06/05', '336719480', 'ngoxuanmai.561@gmail.com', '117179862012'),
	('KH018', N'Nguyễn Trần Hà Anh', N'Bắc Ninh', '1997/05/13', '935254825', 'nguyentranhaanh.99@gmail.com', '119408307680'),
	('KH019', N'Hà Thị Xuyễn', N'Hải Phòng', '2001/05/09', '329138352', 'hathixuyen.143@gmail.com', '116240176517'),
	('KH020', N'Đào Minh Hà', N'Hà Nam', '1999/02/11', '912030230', 'daominhha.972@gmail.com', '113140366994')

SELECT * FROM dbo.tblKhachHang

--Chèn dữ liệu vào bảng tblHoaDonBan
INSERT INTO dbo.tblHoaDonBan(sMaNV, sMaKH, dNgayBan)
VALUES
	('NV001', 'KH001', '2021/02/26'),
	('NV001', 'KH008', '2021/09/09'),
	('NV001', 'KH002', '2021/06/03'),
	('NV001', 'KH019', '2021/05/12'),
	('NV002', 'KH014', '2021/08/25'),
	('NV002', 'KH007', '2021/01/10'),
	('NV002', 'KH001', '2021/02/17'),
	('NV003', 'KH006', '2021/05/21'),
	('NV003', 'KH002', '2021/06/13'),
	('NV002', 'KH015', '2021/04/24'),
	('NV003', 'KH009', '2021/02/12'),
	('NV004', 'KH013', '2021/06/28'),
	('NV004', 'KH008', '2021/06/30'),
	('NV001', 'KH005', '2021/01/02'),
	('NV001', 'KH008', '2021/08/22'),
	('NV008', 'KH007', '2021/06/07'),
	('NV004', 'KH012', '2021/07/27'),
	('NV005', 'KH008', '2021/01/03'),
	('NV006', 'KH018', '2021/03/25'),
	('NV010', 'KH004', '2021/03/18')

SELECT * FROM dbo.tblHoaDonBan

--Chèn dữ liệu vào bảng tblCT_HoaDonBan
INSERT INTO dbo.tblCT_HoaDonBan(iMaHDB, sMaSP, iSLBan, fGiaBan, fMucGiamGia)
VALUES
	(1, 'SP001', 2, 43000000, 0),
	(1, 'SP005', 2, 51000000, 0),
	(1, 'SP009', 5, 3800000, 0),
	(1, 'SP015', 2, 7000000, 0),
	(2, 'SP001', 2, 42500000, 0),
	(2, 'SP002', 2, 26500000, 0),
	(2, 'SP003', 10, 15000000, 0),
	(3, 'SP013', 2, 1000000, 0),
	(3, 'SP016', 1, 9000000, 0),
	(4, 'SP003', 1, 16000000, 0.1),
	(5, 'SP005', 2, 52000000, 0),
	(7, 'SP009', 1, 4000000, 0),
	(7, 'SP020', 1, 5000000, 0),
	(8, 'SP002', 2, 35000000, 0.2),
	(8, 'SP009', 2, 3500000, 0),
	(8, 'SP011', 3, 4500000, 0),
	(9, 'SP001', 2, 47000000, 0.1),
	(10, 'SP006', 2, 6000000, 0),
	(11, 'SP001', 1, 42000000, 0),
	(11, 'SP006', 1, 5500000, 0)

SELECT * FROM dbo.tblCT_HoaDonBan

--Chèn dữ liệu vào bảng tblHoaDonNhap
INSERT INTO dbo.tblHoaDonNhap(sMaNV, sMaNCC, dNgayNhapHang)
VALUES
	('NV010', 'NCC001', '2021/07/24'),
	('NV011', 'NCC002', '2021/06/11'),
	('NV012', 'NCC001', '2021/02/25'),
	('NV013', 'NCC004', '2021/05/22'),
	('NV014', 'NCC002', '2021/07/29'),
	('NV015', 'NCC007', '2021/08/18'),
	('NV010', 'NCC009', '2021/03/10'),
	('NV010', 'NCC001', '2021/05/10'),
	('NV013', 'NCC001', '2021/04/13'),
	('NV014', 'NCC018', '2021/09/04'),
	('NV013', 'NCC018', '2021/05/11'),
	('NV016', 'NCC002', '2021/09/04'),
	('NV011', 'NCC001', '2021/02/08'),
	('NV016', 'NCC001', '2021/02/05'),
	('NV014', 'NCC007', '2021/07/03'),
	('NV016', 'NCC018', '2021/07/31'),
	('NV016', 'NCC004', '2021/07/02'),
	('NV020', 'NCC001', '2021/02/01'),
	('NV012', 'NCC007', '2021/02/13'),
	('NV014', 'NCC001', '2021/07/04')

SELECT * FROM dbo.tblHoaDonNhap

--Chèn dữ liệu vào bảng CT_HoaDonNhap
INSERT INTO dbo.tblCT_HoaDonNhap(iMaHDN, sMaSP, iSLNhap, fGiaNhap)
VALUES
	(1, 'SP001', 35, 42000000),
	(1, 'SP002', 10, 26000000),
	(1, 'SP003', 20, 14500000),
	(2, 'SP005', 20, 50000000),
	(2, 'SP006', 30, 5600000),
	(2, 'SP007', 35, 2100000),
	(2, 'SP008', 30, 5200000),
	(3, 'SP002', 15, 25500000),
	(3, 'SP003', 20, 14000000),
	(4, 'SP012', 40, 8000000),
	(4, 'SP014', 15, 27000000),
	(5, 'SP007', 10, 2000000),
	(6, 'SP015', 40, 6700000),
	(7, 'SP009', 20, 3300000),
	(7, 'SP010', 40, 6700000),
	(7, 'SP011', 15, 4200000),
	(8, 'SP001', 30, 40000000),
	(8, 'SP003', 15, 16000000),
	(9, 'SP004', 25, 8000000),
	(10, 'SP018', 35, 2200000)

SELECT * FROM dbo.tblCT_HoaDonNhap


SELECT * FROM dbo.tblSanPham
SELECT * FROM dbo.tblCT_HoaDonNhap
SELECT * FROM dbo.tblCT_HoaDonBan
UPDATE dbo.tblCT_HoaDonBan SET fGiaBan = 28000000 WHERE sMaSP ='SP006'
--------------------------------------------------------------------

CREATE PROCEDURE themNhaCC
@sMaNCC VARCHAR(10),
@sTenNCC NVARCHAR(50),
@sDiaChi NVARCHAR(50),
@sSDT VARCHAR(11),
@sEmail NVARCHAR(50)
AS
BEGIN
    INSERT INTO dbo.tblNhaCungCap(sMaNCC,sTenNCC,sDiaChi,sSDT,sEmail)
	VALUES( @sMaNCC,@sTenNCC,@sDiaChi,@sSDT,@sEmail )
END
EXECUTE dbo.themNhaCC @sMaNCC = 'NCC023',   -- varchar(10)
                      @sTenNCC = N'1', -- nvarchar(50)
                      @sDiaChi = N'1', -- nvarchar(50)
                      @sSDT = '',     -- varchar(11)
                      @sEmail = N'1'   -- nvarchar(50)

SELECT * FROM dbo.tblNhaCungCap
GO


-- xóa nhà cung cấp
CREATE PROCEDURE xoaNhaCC
@sMaNCC VARCHAR(10)
AS
BEGIN
    IF EXISTS(SELECT * FROM dbo.tblNhaCungCap WHERE @sMaNCC = sMaNCC)
		BEGIN
		    DELETE dbo.tblNhaCungCap WHERE sMaNCC = @sMaNCC
		END
	ELSE
		PRINT N'CODE NHA CC NOT EXIST'
END
EXECUTE dbo.xoaNhaCC @sMaNCC = 'NCC023' -- varchar(10)

SELECT * FROM dbo.tblNhaCungCap
GO

-- Thêm khách hàng
CREATE PROC themKhachHang
@sMaKH VARCHAR(10) ,
@sTenKH NVARCHAR(50) ,
@sDiaChi NVARCHAR(255),
@dNgaySinh DATE,
@sSDT VARCHAR(11) ,
@sEmail VARCHAR(50),
@sCMND VARCHAR(12)
AS
BEGIN
    INSERT INTO dbo.tblKhachHang(sMaKH,sTenKH,sDiaChi,dNgaySinh,sSDT,sEmail,sCMND)
	VALUES(@sMaKH,@sTenKH,@sDiaChi,@dNgaySinh,@sSDT,@sEmail,@sCMND)
END
EXECUTE dbo.themKhachHang @sMaKH = 'KH021',               -- varchar(10)
                          @sTenKH = N'1',             -- nvarchar(50)
                          @sDiaChi = N'1',            -- nvarchar(255)
                          @dNgaySinh = '2022-02-16', -- date
                          @sSDT = '1',                -- varchar(11)
                          @sEmail = '1',              -- varchar(50)
                          @sCMND = '1'                -- varchar(12)

SELECT * FROM dbo.tblKhachHang

--------------------
GO

CREATE PROCEDURE xoaKhachHang
@sMaKH VARCHAR(10)
AS
BEGIN
    IF EXISTS(SELECT * FROM dbo.tblKhachHang WHERE @sMaKH = sMaKH)
		BEGIN
		    DELETE dbo.tblKhachHang WHERE sMaKH = @sMaKH
		END
	ELSE
		PRINT N'CODE KHACH HANG NOT EXIST'
END
go
---------------------
-- Thêm sản phẩm nha anh triều
CREATE PROCEDURE themSanPham
@sMaSP VARCHAR(10) ,
@sTenSP NVARCHAR(50),
@sMaNCC VARCHAR(10) ,
@iTongSL INT ,
@fGiaSP FLOAT ,
@sMauSac NVARCHAR(30),
@fKichThuoc FLOAT ,
@iRAM INT,
@iBoNhoTrong INT ,
@iTGBaoHanh INT
AS
BEGIN
    INSERT INTO dbo.tblSanPham(sMaSP,sTenSP,sMaNCC,iTongSL,fGiaSP,sMauSac,fKichThuoc,iRAM,iBoNhoTrong,iTGBaoHanh)
	VALUES( @sMaSP,@sTenSP,@sMaNCC,@iTongSL,@fGiaSP,@sMauSac,@fKichThuoc,@iRAM,@iBoNhoTrong,@iTGBaoHanh)
END
go
-- Xóa sản phẩm
create PROCEDURE xoaSanPham
@sMaSP VARCHAR(10)
AS
BEGIN
    IF EXISTS(SELECT * FROM dbo.tblSanPham WHERE @sMaSP = sMaSP)
		BEGIN
		    DELETE dbo.tblSanPham WHERE sMaSP = @sMaSP
		END
	ELSE
		PRINT N'CODE SAN PHAM NOT EXIST'
END

--- thêm nhân viên
CREATE PROCEDURE themNhanVien
@sMaNV VARCHAR(10),
@sTenNV NVARCHAR(50) ,
@bGioiTinh BIT ,
@sDiaChi NVARCHAR(255),
@sSDT VARCHAR(11) ,
@sEmail VARCHAR(50),
@sCMND VARCHAR(12) ,
@dNgaySinh DATE ,
@dNgayVaoLam DATE ,
@fHeSoLuong FLOAT ,
@fPhuCap FLOAT 
AS 
BEGIN
    INSERT INTO dbo.tblNhanVien(sMaNV,sTenNV,bGioiTinh,sDiaChi,sSDT,sEmail,sCMND,dNgaySinh,dNgayVaoLam,fHeSoLuong,fPhuCap)
	VALUES( @sMaNV,@sTenNV,@bGioiTinh,@sDiaChi,@sSDT,@sEmail,@sCMND,@dNgaySinh,@dNgayVaoLam,@fHeSoLuong,@fPhuCap)
END

-- Xóa nhân viên
CREATE PROCEDURE xoaNhanVien
@sMaNV VARCHAR(10)
AS
BEGIN
    IF EXISTS(SELECT * FROM dbo.tblNhanVien WHERE @sMaNV = sMaNV)
		BEGIN
		    DELETE dbo.tblNhanVien WHERE sMaNV = @sMaNV
		END
	ELSE
		PRINT N'CODE NHAN VIEN NOT EXIST'
END






-- Proceduce crystal report
-- thống kê doanh thu
CREATE PROCEDURE prTKDoanhThu(@Ngaybatdau DATE, @Ngayketthuc DATE)
AS
BEGIN
	SELECT sTenNCC, sTenSP, 
	ISNULL(t1.[Số lượng bán], 0) [Số lượng bán],
	ISNULL(t1.[Doanh thu], 0) [Doanh thu],
	ISNULL(t1.[Giảm giá], 0) [Giảm giá],
	ISNULL(t1.[Doanh thu thực], 0) [Doanh thu thực]
	FROM dbo.tblSanPham
	LEFT JOIN (
		SELECT sMaSP, 
			SUM(iSLBan) [Số lượng bán], 
			SUM(iSLBan*fGiaBan) [Doanh thu],
			SUM(iSLBan*fGiaBan*fMucGiamGia) [Giảm giá],
			SUM(iSLBan*fGiaBan*(1-fMucGiamGia)) [Doanh thu thực]
		FROM dbo.tblHoaDonBan
		INNER JOIN dbo.tblCT_HoaDonBan ON tblCT_HoaDonBan.iMaHDB = tblHoaDonBan.iMaHDB
		WHERE dNgayBan BETWEEN @Ngaybatdau AND @Ngayketthuc
		GROUP BY sMaSP
	) t1 ON t1.sMaSP = tblSanPham.sMaSP
	INNER JOIN dbo.tblNhaCungCap ON tblNhaCungCap.sMaNCC = tblSanPham.sMaNCC
	ORDER BY [t1].[Doanh thu thực] DESC
END

EXEC dbo.prTKDoanhThu @Ngaybatdau='2021/05/01', -- date
    @Ngayketthuc='2021/12/31' -- date

-- doanh thu nhân viên
SELECT sTenNV, 
	ISNULL(t1.[Số Đơn Bán], 0) [Số Đơn Bán], 
	ISNULL(t1.[Số Sản Phẩm Bán], 0) [Số Sản Phẩm Bán], 
	ISNULL(t1.[Tổng bán], 0) [Tổng bán],
	ISNULL(t1.[Giảm Giá], 0) [Giảm Giá],
	ISNULL(t1.[Doanh Thu], 0) [Doanh Thu]
FROM dbo.tblNhanVien
LEFT JOIN (
	SELECT sMaNV, COUNT(dbo.tblHoaDonBan.iMaHDB) [Số Đơn Bán], SUM(iSLBan) [Số Sản Phẩm Bán], SUM(iSLBan*fGiaBan*(1-fMucGiamGia)) [Doanh Thu]
	,SUM(iSLBan*fGiaBan) [Tổng bán], SUM(iSLBan*fGiaBan*(fMucGiamGia)) [Giảm Giá]
	FROM dbo.tblHoaDonBan
	INNER JOIN dbo.tblCT_HoaDonBan ON tblCT_HoaDonBan.iMaHDB = tblHoaDonBan.iMaHDB
	
	GROUP BY sMaNV
	
) t1 ON t1.sMaNV = tblNhanVien.sMaNV
GO

CREATE OR ALTER PROCEDURE prTKDoanhThuNhanVien(@Ngaybatdau DATE, @Ngayketthuc DATE)
AS
BEGIN
    SELECT sTenNV, 
	ISNULL(t1.[Số Đơn Bán], 0) [Số Đơn Bán], 
	ISNULL(t1.[Số Sản Phẩm Bán], 0) [Số Sản Phẩm Bán], 
	ISNULL(t1.[Tổng bán], 0) [Tổng bán],
	ISNULL(t1.[Giảm Giá], 0) [Giảm Giá],
	ISNULL(t1.[Doanh Thu], 0) [Doanh Thu]
	FROM dbo.tblNhanVien
	LEFT JOIN (
	SELECT sMaNV, COUNT(dbo.tblHoaDonBan.iMaHDB) [Số Đơn Bán], SUM(iSLBan) [Số Sản Phẩm Bán], SUM(iSLBan*fGiaBan*(1-fMucGiamGia)) [Doanh Thu]
	,SUM(iSLBan*fGiaBan) [Tổng bán], SUM(iSLBan*fGiaBan*(fMucGiamGia)) [Giảm Giá]
	FROM dbo.tblHoaDonBan
	INNER JOIN dbo.tblCT_HoaDonBan ON tblCT_HoaDonBan.iMaHDB = tblHoaDonBan.iMaHDB
	WHERE dNgayBan BETWEEN @Ngaybatdau AND @Ngayketthuc
	GROUP BY sMaNV

	) t1 ON t1.sMaNV = tblNhanVien.sMaNV
END
EXEC dbo.prTKDoanhThuNhanVien @Ngaybatdau = '2021-01-30', -- date
                              @Ngayketthuc = '2022-03-30' -- date


-- test
SELECT tblHoaDonBan.sMaNV,COUNT(tblCT_HoaDonBan.iMaHDB),SUM(iSLBan) [Số Sản Phẩm Bán], SUM(iSLBan*fGiaBan*(1-fMucGiamGia)) [Tổng Tiền] FROM dbo.tblNhanVien 
JOIN dbo.tblHoaDonBan ON tblHoaDonBan.sMaNV = tblNhanVien.sMaNV
LEFT JOIN dbo.tblCT_HoaDonBan ON tblCT_HoaDonBan.iMaHDB = tblHoaDonBan.iMaHDB
GROUP BY tblHoaDonBan.sMaNV




SELECT * FROM dbo.tblHoaDonBan

SELECT * FROM dbo.tblCT_HoaDonBan
GO


-- thống kê quản lý kinh doanh
-- thống kê hàng tồn: tên sp , sl nhập , giá nhập , lượng đã bán , giá bán , lượng tồn , tiền tồn, tiền lãi
CREATE OR ALTER PROCEDURE prTKTienSanPham(@NgayBatDau DATE, @NgayKetThuc DATE)
AS
BEGIN
	SELECT sTenSP, 
		ISNULL(t2.[Lượng Nhập], 0) [Lượng Nhập], 
		ISNULL(t2.[Tiền Nhập], 0) [Tiền Nhập], 
		ISNULL(t1.[Lượng Bán], 0) [Lượng Bán], 
		ISNULL(t1.[Tiền Bán], 0) [Tiền Bán], 
		iTongSL, iTongSL*fGiaSP [Tiền Tồn],
		CASE 
			WHEN t1.[Tiền Bán]/t1.[Lượng Bán] IS NULL THEN 0
			ELSE (t1.[Tiền Bán]/t1.[Lượng Bán] - fGiaSP)*t1.[Lượng Bán]
		END [Tiền Lãi]
	FROM dbo.tblSanPham
	LEFT JOIN (
		SELECT sMaSP, SUM(iSLBan) [Lượng Bán], SUM(iSLBan*fGiaBan*(1-fMucGiamGia)) [Tiền Bán]
		FROM dbo.tblHoaDonBan
		INNER JOIN dbo.tblCT_HoaDonBan ON tblCT_HoaDonBan.iMaHDB = tblHoaDonBan.iMaHDB
		WHERE dNgayBan BETWEEN @Ngaybatdau AND @Ngayketthuc
		GROUP BY sMaSP
	) t1 ON t1.sMaSP = tblSanPham.sMaSP
	LEFT JOIN (
		SELECT sMaSP, SUM(iSLNhap) [Lượng Nhập], SUM(iSLNhap*fGiaNhap) [Tiền Nhập]
		FROM dbo.tblHoaDonNhap
		INNER JOIN dbo.tblCT_HoaDonNhap ON tblCT_HoaDonNhap.iMaHDN = tblHoaDonNhap.iMaHDN
		WHERE dNgayNhapHang BETWEEN @Ngaybatdau AND @Ngayketthuc
		GROUP BY sMaSP
	) t2 ON t2.sMaSP = tblSanPham.sMaSP
END


SELECT * FROM dbo.tblCT_HoaDonNhap
SELECT * FROM dbo.tblSanPham
SELECT sTenSP, 
		ISNULL(t2.[Lượng Nhập], 0) [Lượng Nhập], 
		ISNULL(t2.[Tiền Nhập], 0) [Tiền Nhập], 
		ISNULL(t1.[Lượng Bán], 0) [Lượng Bán], 
		ISNULL(t1.[Tiền Bán], 0) [Tiền Bán], 
		iTongSL, iTongSL*fGiaSP [Tiền Tồn],
		CASE 
			WHEN t1.[Tiền Bán]/t1.[Lượng Bán] IS NULL THEN 0
			ELSE (t1.[Tiền Bán]/t1.[Lượng Bán] - fGiaSP)*t1.[Lượng Bán]
		END [Tiền Lãi]
	FROM dbo.tblSanPham
	LEFT JOIN (
		SELECT sMaSP, SUM(iSLBan) [Lượng Bán], SUM(iSLBan*fGiaBan*(1-fMucGiamGia)) [Tiền Bán]
		FROM dbo.tblHoaDonBan
		INNER JOIN dbo.tblCT_HoaDonBan ON tblCT_HoaDonBan.iMaHDB = tblHoaDonBan.iMaHDB
		
		GROUP BY sMaSP
	) t1 ON t1.sMaSP = tblSanPham.sMaSP
	LEFT JOIN (
		SELECT sMaSP, SUM(iSLNhap) [Lượng Nhập], SUM(iSLNhap*fGiaNhap) [Tiền Nhập]
		FROM dbo.tblHoaDonNhap
		INNER JOIN dbo.tblCT_HoaDonNhap ON tblCT_HoaDonNhap.iMaHDN = tblHoaDonNhap.iMaHDN
		
		GROUP BY sMaSP
	) t2 ON t2.sMaSP = tblSanPham.sMaSP


	SELECT * FROM dbo.tblSanPham
GO

-- Nhân viên, khách hàng ,
SELECT tblHoaDonBan.iMaHDB 
FROM dbo.tblHoaDonBan 
INNER JOIN dbo.tblCT_HoaDonBan ON tblCT_HoaDonBan.iMaHDB = tblHoaDonBan.iMaHDB
INNER JOIN dbo.tblKhachHang ON tblKhachHang.sMaKH = tblHoaDonBan.sMaKH
INNER JOIN dbo.tblNhanVien ON tblNhanVien.sMaNV = tblHoaDonBan.sMaNV
GROUP BY tblHoaDonBan.iMaHDB 


SELECT tblHoaDonBan.iMaHDB, tblHoaDonBan.sMaNV, sTenNV, tblHoaDonBan.sMaKH, sTenKH, dNgayBan, 
	ISNULL(t1.[Số Lượng Bán], 0) [Số Lượng Bán], 
	ISNULL(t1.[Tổng Tiền], 0) [Tổng Tiền]
FROM dbo.tblHoaDonBan
LEFT JOIN dbo.tblKhachHang ON tblKhachHang.sMaKH = tblHoaDonBan.sMaKH
LEFT JOIN dbo.tblNhanVien ON tblNhanVien.sMaNV = tblHoaDonBan.sMaNV
LEFT JOIN (
	SELECT iMaHDB, SUM(iSLBan) [Số Lượng Bán], SUM(iSLBan*fGiaBan*(1-fMucGiamGia)) [Tổng Tiền] 
	FROM dbo.tblCT_HoaDonBan
	GROUP BY iMaHDB
) t1 ON t1.iMaHDB = tblHoaDonBan.iMaHDB

GO

-- triiger nha babe
/* Tạo Trigger */
--Trigger 1: kiểm tra nhân viên vào làm phải đủ 18 tuổi khi thêm hoặc cập nhật bảng tblNhanVien
CREATE TRIGGER tgNVVaoLamDu18
ON tblNhanVien
AFTER INSERT, UPDATE
AS
BEGIN
	DECLARE @ngaySinh DATE, @ngayVaoLam DATE
	SELECT @ngaySinh = dNgaySinh, @ngayVaoLam = dNgayVaoLam FROM INSERTED
	IF (@ngayVaoLam < DATEADD(YEAR, 18, @ngaySinh))
	BEGIN
		PRINT N'Nhân viên chưa đủ 18 tuổi'
		ROLLBACK TRAN
	END
END

DROP TRIGGER dbo.tgNVVaoLamDu18
select * from tblNhanVien
--Test thỏa mãn
INSERT INTO dbo.tblNhanVien(sMaNV, sTenNV, bGioiTinh, sDiaChi, sSDT, sEmail, sCMND, dNgaySinh, dNgayVaoLam, fHeSoLuong, fPhuCap)
VALUES('NV022', N'Bùi Thế Hải', 1, 'Hà Giang', '033524687', NULL, '076541235', '2000/10/10', '2018/10/15', 3.4, 0.4)
--Test lỗi
INSERT INTO dbo.tblNhanVien(sMaNV, sTenNV, bGioiTinh, sDiaChi, sSDT, sEmail, sCMND, dNgaySinh, dNgayVaoLam, fHeSoLuong, fPhuCap)
VALUES('NV022', N'Bùi Văn Công', 1, 'Hà Giang', '0335675875', NULL, '076425186', '2000/10/10', '2018/10/09', 3.4, 0.4)

SELECT * FROM dbo.tblNhanVien

DELETE FROM dbo.tblNhanVien
WHERE sMaNV = 'NV022'

--Trigger 2: kiểm tra số lượng bán không được lớn hơn tổng số lượng sản phẩm khi thêm hoặc cập nhật bảng tblCT_HoaDonBan
CREATE TRIGGER tgSLBan_KhongLonHon_TongSL
ON tblCT_HoaDonBan
AFTER INSERT, UPDATE
AS
BEGIN
	DECLARE @maSP VARCHAR(10), @slBan INT, @tongSL INT
	SELECT @maSP = sMaSP, @slBan = iSLBan FROM INSERTED
	SELECT @tongSL = iTongSL FROM dbo.tblSanPham WHERE sMaSP = @maSP
	IF (@slBan > @tongSL)
	BEGIN
	    PRINT N'Số lượng bán sản phẩm ' + @maSP + N' không được vượt quá tổng số lượng sản phẩm hiện có'
		ROLLBACK TRAN
	END
END

DROP TRIGGER dbo.tgSLBan_KhongLonHon_TongSL

--Test lỗi
INSERT INTO dbo.tblCT_HoaDonBan(iMaHDB, sMaSP, iSLBan, fGiaBan, fMucGiamGia)
VALUES(12, 'SP002', 200, 27000000, NULL)

UPDATE dbo.tblCT_HoaDonBan
SET iSLBan = 200
WHERE iMaHDB = 11 AND sMaSP = 'SP006'

--Test thỏa mãn
INSERT INTO dbo.tblCT_HoaDonBan(iMaHDB, sMaSP, iSLBan, fGiaBan, fMucGiamGia)
VALUES(12, 'SP002', 2, 27000000, 0)

UPDATE dbo.tblCT_HoaDonBan
SET iSLBan = 5
WHERE iMaHDB = 11 AND sMaSP = 'SP006'

--Reset
DELETE FROM dbo.tblCT_HoaDonBan
WHERE iMaHDB = 12

UPDATE dbo.tblCT_HoaDonBan
SET iSLBan = 1
WHERE iMaHDB = 11 AND sMaSP = 'SP006'

SELECT * FROM dbo.tblSanPham WHERE sMaSP IN ('SP002', 'SP006')
SELECT * FROM dbo.tblCT_HoaDonBan

--Trigger 3: Cập nhật tổng số lượng sản phẩm trong bảng tblSanPham khi thêm, sửa, xóa trong bảng tblCT_HoaDonBan
CREATE TRIGGER tgCapNhat_TongSLSanPham_CTHoaDonBan
ON tblCT_HoaDonBan
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	UPDATE dbo.tblSanPham
	SET iTongSL += iSLBan
	FROM DELETED
	WHERE DELETED.sMaSP = tblSanPham.sMaSP

	UPDATE dbo.tblSanPham
	SET iTongSL -= iSLBan
	FROM INSERTED
	WHERE INSERTED.sMaSP = tblSanPham.sMaSP
END

DROP TRIGGER dbo.tgCapNhat_TongSLSanPham_CTHoaDonBan

--Kiểm tra kết quả Trigger
INSERT INTO dbo.tblCT_HoaDonBan(iMaHDB, sMaSP, iSLBan, fGiaBan, fMucGiamGia)
VALUES(15, 'SP002', 15, 27000000, 0.1)

UPDATE dbo.tblCT_HoaDonBan
SET	sMaSP = 'SP001', iSLBan = 6
WHERE iMaHDB = 15 AND sMaSP = 'SP002'

DELETE FROM dbo.tblCT_HoaDonBan
WHERE iMaHDB = 15 AND sMaSP = 'SP001'

--Select
SELECT * FROM dbo.tblSanPham
SELECT * FROM dbo.tblCT_HoaDonBan 


--Trigger 4: Cập nhật tổng số lượng sản phẩm trong bảng tblSanPham khi thêm, sửa, xóa trong bảng tblCT_HoaDonNhap
CREATE OR ALTER TRIGGER tgCapNhat_TongSLSanPham_CTHoaDonNhap
ON tblCT_HoaDonNhap
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	UPDATE dbo.tblSanPham
	SET iTongSL -= iSLNhap
	FROM DELETED
	WHERE DELETED.sMaSP = tblSanPham.sMaSP
	
	UPDATE dbo.tblSanPham
	SET iTongSL += iSLNhap
	FROM INSERTED
	WHERE INSERTED.sMaSP = tblSanPham.sMaSP
END

DROP TRIGGER dbo.tgCapNhat_TongSLSanPham_CTHoaDonNhap

--Kiểm tra kết quả Trigger
INSERT INTO dbo.tblCT_HoaDonNhap(iMaHDN, sMaSP, iSLNhap, fGiaNhap)
VALUES (15, 'SP002', 10, 26000000)

UPDATE dbo.tblCT_HoaDonNhap
SET	sMaSP = 'SP001', iSLNhap = 9
WHERE iMaHDN = 15 AND sMaSP = 'SP002'

DELETE FROM dbo.tblCT_HoaDonNhap
WHERE iMaHDN = 15 AND sMaSP = 'SP001'

--Select
SELECT * FROM dbo.tblSanPham
SELECT * FROM dbo.tblCT_HoaDonNhap


--Trigger 5: Cập nhật giá sản phẩm theo giá nhập gần đây nhất
CREATE TRIGGER tgCapNhatGiaSP
ON tblCT_HoaDonNhap
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	DECLARE @maSPxoa VARCHAR(10), @giaNhapMoiNhatxoa FLOAT, @giaSPxoa FLOAT,
			@maSPthem VARCHAR(10), @giaNhapMoiNhatthem FLOAT
	SELECT @maSPxoa = sMaSP, @giaSPxoa = fGiaNhap FROM DELETED
	SELECT @maSPthem = sMaSP FROM INSERTED

	SET @giaNhapMoiNhatthem = 
		(SELECT TOP 1 fGiaNhap
		FROM dbo.tblCT_HoaDonNhap
		INNER JOIN dbo.tblHoaDonNhap ON tblHoaDonNhap.iMaHDN = tblCT_HoaDonNhap.iMaHDN
		WHERE sMaSP = @maSPthem
		ORDER BY dNgayNhapHang DESC)

	SET @giaNhapMoiNhatxoa = 
		(SELECT TOP 1 fGiaNhap
		FROM dbo.tblCT_HoaDonNhap
		INNER JOIN dbo.tblHoaDonNhap ON tblHoaDonNhap.iMaHDN = tblCT_HoaDonNhap.iMaHDN
		WHERE sMaSP = @maSPxoa
		ORDER BY dNgayNhapHang DESC)  

	UPDATE dbo.tblSanPham
	SET	fGiaSP = @giaNhapMoiNhatthem
	WHERE sMaSP = @maSPthem

	UPDATE dbo.tblSanPham
	SET	fGiaSP = ISNULL(@giaNhapMoiNhatxoa, @giaSPxoa)
	WHERE sMaSP = @maSPxoa
	--SELECT @maSPxoa [Mã xóa], @giaNhapMoiNhatxoa [Giá xóa], @maSPthem [Mã thêm], @giaNhapMoiNhatthem [Giá thêm]
END

DROP TRIGGER dbo.tgCapNhatGiaSP


--Trigger 6: Tự động điền thời gian bảo hành cho từng sản phẩm trong chi tiết hóa đơn
CREATE OR ALTER TRIGGER tgTGBaoHanh_SanPham
ON tblSanPham
AFTER INSERT, UPDATE
AS
BEGIN
	IF UPDATE(iTGBaoHanh)
	BEGIN
		UPDATE dbo.tblCT_HoaDonBan
		SET dTGBaoHanh = DATEADD(MONTH, iTGBaoHanh, dNgayBan)
		FROM INSERTED, dbo.tblHoaDonBan
		WHERE tblHoaDonBan.iMaHDB = tblCT_HoaDonBan.iMaHDB AND
			  INSERTED.sMaSP = tblCT_HoaDonBan.sMaSP
	END
END

CREATE OR ALTER TRIGGER tgTGBaoHanh__HDB
ON tblHoaDonBan
AFTER INSERT, UPDATE
AS
BEGIN
	IF UPDATE(dNgayBan)
	BEGIN
		UPDATE dbo.tblCT_HoaDonBan
		SET dTGBaoHanh = DATEADD(MONTH, iTGBaoHanh, dNgayBan)
		FROM INSERTED, dbo.tblSanPham
		WHERE INSERTED.iMaHDB = tblCT_HoaDonBan.iMaHDB AND
			  tblSanPham.sMaSP = tblCT_HoaDonBan.sMaSP
	END
END

UPDATE dbo.tblCT_HoaDonBan
SET dTGBaoHanh = DATEADD(MONTH, iTGBaoHanh, dNgayBan)
FROM dbo.tblSanPham, dbo.tblHoaDonBan
WHERE tblHoaDonBan.iMaHDB = tblCT_HoaDonBan.iMaHDB AND
	  tblSanPham.sMaSP = tblCT_HoaDonBan.sMaSP


	  SELECT * FROM dbo.tblSanPham
	  SELECT * FROM dbo.tblCT_HoaDonBan