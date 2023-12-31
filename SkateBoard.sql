﻿0-- Tạo cơ sở dữ liệu
CREATE DATABASE BTLQUYS;
USE BTLQUYS;

-- Tạo bảng Khách hàng
CREATE TABLE KhachHang (
  CustomerID INT PRIMARY KEY,
  FirstName nVARCHAR(50),
  LastName nVARCHAR(50),
  Email nVARCHAR(100),
  Phone nVARCHAR(20),
  Address nVARCHAR(200)
);

-- Tạo bảng Sản phẩm
CREATE TABLE SanPham (
  ProductID INT PRIMARY KEY,
  ProductName nVARCHAR(100),
  Price DECIMAL(10,2),
  Description TEXT
);

-- Tạo bảng Đơn hàng
CREATE TABLE DonHang (
  OrderID INT PRIMARY KEY,
  OrderDate DATE,
  CustomerID INT,
  FOREIGN KEY (CustomerID) REFERENCES KhachHang(CustomerID)
);

-- Tạo bảng Chi tiết đơn hàng
CREATE TABLE ChiTietDonHang (
  OrderDetailID INT PRIMARY KEY ,
  OrderID INT,
  ProductID INT,
  Quantity INT,
  FOREIGN KEY (OrderID) REFERENCES DonHang(OrderID),
  FOREIGN KEY (ProductID) REFERENCES SanPham(ProductID)
);

-- Tạo bảng Nhà cung cấp
CREATE TABLE NhaCungCap (
  SupplierID INT PRIMARY KEY,
  SupplierName nVARCHAR(100),
  Address nVARCHAR(200),
  Phone nVARCHAR(20),
  Email nVARCHAR(100)
);

-- Tạo bảng Hóa đơn nhập
CREATE TABLE HoaDonNhap (
  InvoiceID INT PRIMARY KEY,
  InvoiceDate DATE,
  SupplierID INT,
  FOREIGN KEY (SupplierID) REFERENCES NhaCungCap(SupplierID)
);

-- Tạo bảng Chi tiết hóa đơn nhập
CREATE TABLE ChiTietHoaDonNhap (
  InvoiceDetailID INT PRIMARY KEY,
  InvoiceID INT,
  ProductID INT,
  Quantity INT,
  UnitPrice DECIMAL(10,2),
  FOREIGN KEY (InvoiceID) REFERENCES HoaDonNhap(InvoiceID),
  FOREIGN KEY (ProductID) REFERENCES SanPham(ProductID)
);

-- Tạo bảng Loại tài khoản
CREATE TABLE LoaiTaiKhoan (
  AccountTypeID INT PRIMARY KEY,
  TypeName VARCHAR(50)
);

-- Tạo bảng Tài khoản
CREATE TABLE TaiKhoan (
  AccountID INT PRIMARY KEY ,
  AccountNumber VARCHAR(20),
  AccountTypeID INT,
  CustomerID INT,
  Balance DECIMAL(10,2),
  FOREIGN KEY (AccountTypeID) REFERENCES LoaiTaiKhoan(AccountTypeID),
  FOREIGN KEY (CustomerID) REFERENCES Khachhang(CustomerID)
);

INSERT INTO KhachHang (CustomerID, FirstName, LastName, Email, Phone, Address)
VALUES
  (1, N'Nguyễn', N'Văn A', N'nguyen.vana@email.com', N'0123456789', '123 Đường ABC'),
  (2, N'Trần', N'Thị B', N'tran.thib@email.com', N'0987654321', '456 Đường XYZ');


INSERT INTO SanPham (ProductID, ProductName, Price, Description)
VALUES
  (1, N'Sản phẩm A', 100.00, N'Mô tả sản phẩm A'),
  (2, N'Sản phẩm B', 50.50, N'Mô tả sản phẩm B');


INSERT INTO DonHang (OrderID, OrderDate, CustomerID)
VALUES
  (1, '2023-09-24', 1),
  (2, '2023-09-25', 2);


INSERT INTO ChiTietDonHang (OrderDetailID, OrderID, ProductID, Quantity)
VALUES
  (1, 1, 1, 3),
  (2, 1, 2, 2),
  (3, 2, 1, 1);


INSERT INTO NhaCungCap (SupplierID, SupplierName, Address, Phone, Email)
VALUES
  (1, N'Nhà cung cấp X', N'789 Đường MNO', '0988888888', N'nccx@email.com'),
  (2, N'Nhà cung cấp Y', N'101 Đường PQR', '0123456789', N'nccy@email.com');


INSERT INTO HoaDonNhap (InvoiceID, InvoiceDate, SupplierID)
VALUES
  (1, N'2023-09-24', 1),
  (2, N'2023-09-25', 2);

INSERT INTO ChiTietHoaDonNhap (InvoiceDetailID, InvoiceID, ProductID, Quantity, UnitPrice)
VALUES
  (1, 1, 1, 5, 90.00),
  (2, 1, 2, 3, 45.00),
  (3, 2, 1, 2, 95.50);


INSERT INTO LoaiTaiKhoan (AccountTypeID, TypeName)
VALUES
  (1, N'Tiết kiệm'),
  (2, N'Thanh toán');


INSERT INTO TaiKhoan (AccountID, AccountNumber, AccountTypeID, CustomerID, Balance)
VALUES
  (1, N'TK123456', 1, 1, 1000.00),
  (2, N'TK789012', 2, 2, 500.50);


 create proc sp_get_all_khachhang
 as
 begin
	select * from KhachHang
 end

create proc sp_create_khachhang(@Customerid int,@FirstName nvarchar(50),@LastName nvarchar(50),@Email nvarchar(100),@phone nvarchar(20),@Address nvarchar (200))
as
begin
	insert into KhachHang(CustomerID,FirstName,LastName,Email,phone,Address)
	values(@Customerid,@FirstName, @LastName, @Email, @phone, @Address)
end


create proc sp_update_khachhang(@CustomerID int, @FirstName nvarchar(50),@LastName nvarchar(50),@Email nvarchar(100),@Phone nvarchar(20),@Address nvarchar (200))
as
begin
	update KhachHang
	set FirstName=@FirstName,LastName=@LastName,Email=@Email,Phone=@Phone,Address=@Address
	where CustomerID=@CustomerID
end

create proc sp_delele_khachhang(@CustomerID int)
as
begin
	delete from KhachHang
	where CustomerID=@CustomerID
end




create proc sp_get_all_hoadon
as
begin
	select * from HoaDonNhap
end


create PROCEDURE sp_create_hoadonnhap
(@InvoiceID int, 
 @InvoiceDate date, 
 @SupplierID int,  
 @list_json_chitiethoadon NVARCHAR(MAX)
)
AS
    BEGIN
		DECLARE @MaHoaDon INT;
        INSERT INTO HoaDonNhap
                (InvoiceID, 
                 InvoiceDate,
                 SupplierID              
                )
                VALUES
                (@InvoiceID, 
                 @InvoiceDate, 
                 @SupplierID
                );

				SET @MaHoaDon = (SELECT SCOPE_IDENTITY());
                IF(@list_json_chitiethoadon IS NOT NULL)
                    BEGIN
                        INSERT INTO ChiTietHoaDonNhap
						 (InvoiceDetailID, 
						  InvoiceID,
                          ProductID, 
                          Quantity,
						  UnitPrice
                        )
                    SELECT JSON_VALUE(p.value, '$.InvoiceDetailID'), 
                            @MaHoaDon, 
                            JSON_VALUE(p.value, '$.ProductID'),
							JSON_VALUE(p.value, '$.Quantity'),
							JSON_VALUE(p.value, '$.UnitPrice')
							
                    FROM OPENJSON(@list_json_chitiethoadon) AS p;
                END;
        SELECT '';
    END;


create proc sp_update_hoadonnhap(@InvoiceID int, @InvoiceDate date,@SupplierID int)
as
begin
	update HoaDonNhap
	set InvoiceID=@InvoiceID,InvoiceDate=@InvoiceDate,SupplierID=@SupplierID
	where InvoiceID=@InvoiceID
end


create proc sp_delele_HoaDonNhap(@InvoiceID int)
as
begin
	delete from HoaDonNhap
	where InvoiceID=@InvoiceID
end


alter proc sp_get_all_nhacungcap
as
begin
	select * from NhaCungCap
end


create proc sp_create_nhacungcap(@SupplierID int,@SupplierName nvarchar(100),@Address nvarchar(200), @Phone nvarchar(20), @Email nvarchar(100))
as
begin
	insert into NhaCungCap(SupplierID,SupplierName,Address,Phone,Email)
	values(@SupplierID, @SupplierName, @Address,@Phone,@Email)
end


create proc sp_update_nhacungcap(@SupplierID int, @SupplierName nvarchar(100),@Address nvarchar(200),@Phone nvarchar(20),@Email nvarchar(100))
as
begin
	update NhaCungCap
	set SupplierID=@SupplierID,SupplierName=@SupplierName,Address=@Address,Phone=@Phone,Email=@Email
	where SupplierID=@SupplierID
end


create proc sp_delele_NhaCungCap(@SupplierID int)
as
begin
	delete from NhaCungCap
	where SupplierID=@SupplierID
end


create proc sp_get_all_sanpham
as
begin
	select * from SanPham
end



Alter proc sp_create_sanpham(@ProductID int,@ProductName nvarchar(100),@Price decimal(10, 2), @Description text,@AnhDaiDien nvarchar(max),@Size nvarchar(20))
as
begin
	insert into SanPham(ProductID,ProductName,Price,Description,AnhDaiDien,Size)
	values(@ProductID, @ProductName, @Price,@Description,@AnhDaiDien,@Size)
end


Alter proc sp_update_sanpham(@ProductID int,@ProductName nvarchar(100),@Price decimal(10, 2), @Description text, @AnhDaiDien nvarchar(max),@Size nvarchar(20))
as
begin
	Update SanPham
	set ProductID=@ProductID,ProductName=@ProductName,Price=@Price,Description=@Description, AnhDaiDien=@AnhDaiDien, Size=@Size
	where ProductID=@ProductID
end


create proc sp_delete_sanpham(@ProductID int)
as
begin
	delete from SanPham
	where ProductID=@ProductID
end


create proc sp_get_all_donhang
as
begin
	select * from DonHang
end


create proc sp_create_donhang(@OrderID int, @OrderDate date, @CustomerID int)
as
begin
	insert into DonHang(OrderID,OrderDate,CustomerID)
	values(@OrderID, @OrderDate,@CustomerID)
end

create proc sp_update_donhang(@OrderID int, @OrderDate date, @CustomerID int)
as
begin
	Update DonHang
	set OrderID=@OrderID,OrderDate=@OrderDate,CustomerID=@CustomerID
	where OrderID=@OrderID
end



create proc sp_delete_donhang(@OrderID int)
as
begin
	delete from DonHang
	where OrderID=@OrderID
end


create proc sp_get_all_chitietdonhang
as
begin
	select * from ChiTietDonHang
end


CREATE PROCEDURE sp_create_chitietdonhang
    @OrderDetailID INT,
    @OrderID INT,
    @ProductID INT,
    @Quantity INT
AS
BEGIN
    INSERT INTO ChiTietDonHang (OrderDetailID, OrderID, ProductID, Quantity)
    VALUES (@OrderDetailID, @OrderID, @ProductID, @Quantity)
END


create proc sp_update_chitietdonhang(@OrderDetailID int, @OrderID int, @ProductID int, @Quantity int)
as
begin
	Update ChiTietDonHang
	set OrderDetailID=@OrderDetailID,OrderID=@OrderID,ProductID=@ProductID, Quantity=@Quantity
	where OrderDetailID=@OrderDetailID
end


create proc sp_delele_chitietdonhang(@OrderDetailID int)
as
begin
	delete from ChiTietDonHang
	where OrderDetailID=@OrderDetailID
end


create proc sp_get_all_chitietHDN
as
begin
	select * from ChiTietHoaDonNhap
end
exec sp_get_all_chitietHDN

create proc sp_create_chitietHDN(@InvoiceDetailID int, @InvoiceID int, @ProductID int, @Quantity int, @UnitPrice decimal(10, 2))
as
begin
	insert into ChiTietHoaDonNhap(InvoiceDetailID,InvoiceID,ProductID, Quantity, UnitPrice)
	values(@InvoiceDetailID, @InvoiceID,@ProductID, @Quantity, @UnitPrice)
end



create proc sp_update_chitietHDN(@InvoiceDetailID int, @InvoiceID int, @ProductID int, @Quantity int, @UnitPrice decimal(10, 2))
as
begin
	Update ChiTietHoaDonNhap
	set InvoiceDetailID=@InvoiceDetailID,InvoiceID=@InvoiceID,ProductID=@ProductID, Quantity=@Quantity, UnitPrice=@UnitPrice
	where InvoiceDetailID=@InvoiceDetailID
end


create proc sp_delete_chitietHDN(@InvoiceDetailID int)
as
begin
	delete from ChiTietHoaDonNhap
	where InvoiceDetailID=@InvoiceDetailID
end


create proc sp_get_all_loaitaikhoan
as
begin
	select * from LoaiTaiKhoan
end


create proc sp_create_loaitaikhoan(@AccountTypeID int, @TypeName varchar(50))
as
begin
	insert into LoaiTaiKhoan(AccountTypeID, TypeName)
	values(@AccountTypeID, @TypeName)
end


create proc sp_update_loaitaikhoan(@AccountTypeID int, @TypeName varchar(50))
as
begin
	Update LoaiTaiKhoan
	set AccountTypeID=@AccountTypeID, TypeName=@TypeName
	where AccountTypeID=@AccountTypeID
end


create proc sp_delete_loaitaikhoan(@AccountTypeID int)
as
begin
	delete from LoaiTaiKhoan
	where AccountTypeID=@AccountTypeID
end

alter table SanPham
add Size nvarchar(10)

select*from SanPham
