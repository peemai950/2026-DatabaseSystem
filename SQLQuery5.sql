--MiniMart---------------------------------

--สำรวจข้อมูล Receips, Derails, Employee, Product
select * from Receipts
select * from Details
select * from Employees
select * from Products
--เป้าหมาย ต้องการสร้างรายการจำหน่ายสินค่า ผู้ชายคือ วุฒิศักดิ์
--สินค้าที่ขาย ได้แก่ ดินสอ 5 แท่ง และ ยางลบ 4 ก้อน
--เริ่มต้น Transaction
Begin Transaction
--1. เพิ่มใบเสร็จใหม่ Receipts ยังไม่มียอด TotalCash
insert into Receipts(ReceiptDate,EmployeeID,TotalCash)
	Values(GETDATE(), 4, 0)
--2. เพิ่มรายการสินค้า Details 2 รายการ (6)
insert into Details(ReceiptID,ReceiptID,UnitPrice,Quantity)
	Values(6,1, 17, 5) --ดิสสอ
insert into Details(ReceiptID,ReceiptID,UnitPrice,Quantity)
	Values(6,2, 17, 4) --ยางลบ
--3. ปรับปรุงยอดขาย TotalCash
update Receipts set TotalCash =
	(select sum(unitprice*quantity)from Details
	where ReceiptID =6)
   where ReceiptID =6
--4. ปรับปรุงจำนวนสินค้า ดินสอ -5 ยางลบ -4
update Products set UnitsInStock = UnitsInStock - 5 where productID = 1 --ดินสอ
update Products set UnitsInStock = UnitsInStock - 4 where productID = 2 --ดินสอ
--จบการทำงาน
commit 
----------ทดสอบ Roll back-------------------------------------------
--เริ่มต้น Transaction
Begin Transaction
--1. เพิ่มใบเสร็จใหม่ Receipts ยังไม่มียอด TotalCash
insert into Receipts(ReceiptDate,EmployeeID,TotalCash)
	Values(GETDATE(), 4, 0)
--2. เพิ่มรายการสินค้า Details 2 รายการ (6)
insert into Details(ReceiptID,ReceiptID,UnitPrice,Quantity)
	Values(12,1, 17, 5)
insert into Details(ReceiptID,ReceiptID,UnitPrice,Quantity)
	Values(12,2, 17, 4)
	-- ตรวดสอบดูข้อมูลที่เกิดขึ้น
	Select * from Receipts where ReceiptID = 8
	Select * from Details where ReceiptID = 8
--หากระบบผิดพลาด เราจะ Rollback
Rollback
		--ตรวดสอบดูข้อมูลว่ายังอยู่ไหม
		Select * from Receipts where ReceiptID = 8
		Select * from Details where ReceiptID = 8

--Northwind-------------------------------------------------------------
--Part 1 ------------------------------------------------------
--step 0
Select CustomerID, CompanyName
From Customers
Where CustomerID = 'AlFKI'
--step 1 มองภาพรวม

--step 2
USE Northwind;

Begin Transaction;

insert into Orders
 (CustomerID, EmployeeID
 OrderDate, RequiredDate, Freight)
Values
 ('ALFKI', 1, Getdate(),
   Dateadd(DAY,7,Getdate()), 50.00)
--step 3
select SCOPE_IDENTITY()
		AS NewOrderID;
--step 4
insert into [Order Details]
(OrderID, ProductID,
 UnitPrice, Quantity, Discount)
select
	<NewOrderID>, ProductID,
	UnitPrice, 2, 0
from Products
where ProductID = 1;
--step 5
--ตรวด Orders
select * from Orders
where OrderID = <NewOrderID>;
--ตรวด Orders Details
select * from [Order Details]
where OrderID = <NewOrderID>;
--step 6 commit และตรวดสอบผล

--Part 2 ------------------------------------------------------
--step 1 
USE Northwind;

Begin Transaction;

insert into Orders
 (CustomerID, EmployeeID
 OrderDate, RequiredDate, Freight)
Values
 ('ALFKI', 1, Getdate(),
   Dateadd(DAY,7,Getdate()), 75.00)

--step 2
select SCOPE_IDENTITY()
		AS NewOrderID;

--step 3 
insert into [Order Details]
(OrderID, ProductID,
 UnitPrice, Quantity, Discount)
select
	<RollbackOrderID>, ProductID,
	UnitPrice, 1, 0
from Products
where ProductID = 1;
--step 4
insert into [Order Details]
(OrderID, ProductID,
 UnitPrice, Quantity, Discount)
select
	<RollbackOrderID>, ProductID,
	UnitPrice, 2, 0
from Products
where ProductID = 2;
--step 5
--ตรวด Orders
select * from Orders
where OrderID = <RollbackOrderID>;
--ตรวด Orders Details
select * from [Order Details]
where OrderID = <RollbackOrderID>;
