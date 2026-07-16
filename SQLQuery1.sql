--เร่ิมจาก Master
Create Database CSMinimart
--ปรับให้เพิ่มภาษาไทยได้
Alter Database CSMinimart Collate Thai_CI_AS;
--สร้างตาราง
Create Table Employees(
	EmployeeID int identity (1,1) Primary key,
	title varchar(20) null,
	firstname varchar(50) not null,
	lastname varchar(50) null,
	position varchar(50) null,
	username varchar(50) Unique,
	passwordhash varchar(255) not null,
	IsActive bit Not null default 1
);
--ทดสอบดพิ่มข้อมูลในตาราง Employees
INSERT INTO Employees
  (Title, FirstName, LastName,Position, UserName, PasswordHash)
VALUES
  ('นางสาว', 'กาญจนา', 'พวงแก้ว','Sale Manager', 'user1', 'hashed1');
--ทดสอบเรียกข้อมูลออกมาดู
Select * From Employees
--เพิ่มชื่อใหม่
INSERT INTO Employees
  (Title, FirstName, LastName,Position, UserName, PasswordHash)
VALUES
  ('นาย', 'ไกรศักดิ์', 'นามวิเศษ','Sale Manager', 'user2', 'hashed2');
--สร้างตาราง หมวดสินค่า Categories
Create Table Categories(
	CategoryID int identity(1,1) primary key,
	CategoryName varchar(50) Unique not Null,
	Description varchar(200) null
)

INSERT INTO Categories(CategoryName, Description)
VALUES('เครื่องดื่ม','น้ำดื่ม น้ำผลไม้ ชาและกาแฟ')
INSERT INTO Categories(CategoryName, Description)
VALUES('เครื่องดื่มเย็น', 'น้ำอัดลม น้ำแข็ง เครื่องดื่มแช่เย็น')
INSERT INTO Categories(CategoryName, Description)
VALUES('อาหารสำเร็จรูป', 'บะหมี่กึ่งสำเร็จรูป อาหารกระป๋อง อาหารแช่แข็ง')
INSERT INTO Categories(CategoryName, Description)
VALUES('เครื่องสำอาง', 'ครีมบำรุงผิว เครื่องสำอาง ผลิตภัณฑ์ดูแลผิว')
INSERT INTO Categories(CategoryName, Description)
VALUES('เวชภัณฑ์', 'ยาสามัญประจำบ้าน พลาสเตอร์ อุปกรณ์ปฐมพยาบาล')

--ดูข้อมูลในตาราง Categories
Select * from Categories

--สร้างตารางสินค้า Products 
CREATE TABLE Products (
    ProductID VARCHAR(13) PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL DEFAULT 0,
    UnitsInStock INT NOT NULL DEFAULT 0,
    CategoryID INT NOT NULL,
    Discontinued BIT NOT NULL DEFAULT 0,

    CONSTRAINT CK_Products_UnitPrice
        CHECK (UnitPrice >= 0),

    CONSTRAINT CK_Products_UnitsInStock
        CHECK (UnitsInStock >= 0),

    CONSTRAINT FK_Products_Categories
        FOREIGN KEY (CategoryID)
        REFERENCES Categories(CategoryID)
);
--ทดสอบเพิ่มข้อมูลในตาราง Products
INSERT INTO Products
    (ProductID, ProductName, UnitPrice, UnitsInStock, CategoryID)
VALUES
    ('8858757001948', 'โค้ก', 15.00, 290, 1);
INSERT INTO Products
    (ProductID, ProductName, UnitPrice, UnitsInStock, CategoryID)
VALUES
    ('8851959158364', 'น้ำสไป', 19.00, 290, 1);
INSERT INTO Products
    (ProductID, ProductName, UnitPrice, UnitsInStock, CategoryID)
VALUES
    ('8859829568619', 'หนังสือ', 20.00, 290, 1);
INSERT INTO Products
    (ProductID, ProductName, UnitPrice, UnitsInStock, CategoryID)
VALUES
    ('6972129732015', 'ทิชู่', 45.00, 290, 1);
INSERT INTO Products
    (ProductID, ProductName, UnitPrice, UnitsInStock, CategoryID)
VALUES
    ('8851907300012', 'ปากกา', 10.00, 290, 1);
--เเบบผิด
INSERT INTO Products
    (ProductID, ProductName, UnitPrice,UnitsInStock, CategoryID)
VALUES
    ('8858757009999', 'สินค้าทดสอบ',-10.00, 20, 1);
--
select * from Products
--สร้างตารางใบเสร็จ
CREATE TABLE Receipts (
    ReceiptID INT IDENTITY(1,1) PRIMARY KEY,
    ReceiptDate DATETIME NOT NULL
        DEFAULT GETDATE(),
    EmployeeID INT NOT NULL,
    TotalCash DECIMAL(10,2) NOT NULL DEFAULT 0,

    CONSTRAINT CK_Receipts_TotalCash
        CHECK (TotalCash >= 0),

    CONSTRAINT FK_Receipts_Employees
        FOREIGN KEY (EmployeeID)
        REFERENCES Employees(EmployeeID)
);
--ตรวดสอบเวลา 
select GETDATE()

--ปฏิบัดเพิ่มใบเสร็จ
INSERT INTO Receipts(EmployeeID, TotalCash)
VALUES(1, 115.00);

-- แบบผิด (ไม่มี EmployeeID = 99 — ทดสอบ FK constraint)
INSERT INTO Receipts(EmployeeID, TotalCash)
VALUES(99, 100.00);

--
SELECT * FROM Receipts;

--สร้างตาราง Details
CREATE TABLE Details (
    ReceiptID INT NOT NULL,
    ProductID VARCHAR(13) NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    Quantity INT NOT NULL,

    CONSTRAINT PK_Details
        PRIMARY KEY (ReceiptID, ProductID),

    CONSTRAINT CK_Details_UnitPrice
        CHECK (UnitPrice >= 0),

    CONSTRAINT CK_Details_Quantity
        CHECK (Quantity > 0),

    CONSTRAINT FK_Details_Receipts
        FOREIGN KEY (ReceiptID)
        REFERENCES Receipts(ReceiptID),

    CONSTRAINT FK_Details_Products
        FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID)
);
--เพิ่ม ข้อมูล Details
-- แบบถูกต้อง
INSERT INTO Details(ReceiptID, ProductID, UnitPrice, Quantity)
VALUES(1, '8858757001948', 15.00, 3);

-- แบบผิด (Quantity = 0 — ทดสอบ CHECK constraint)
INSERT INTO Details(ReceiptID, ProductID, UnitPrice, Quantity)
VALUES(1, '8858757001948', 15.00, 0);

--
SELECT * FROM Details;