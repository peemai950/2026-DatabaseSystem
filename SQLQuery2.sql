--สำรวด รายชื่อตาราง
select * from information_schema.tables 
where TABLE_TYPE = 'BASE TABLE';
--สำรวดโครงสร้างตาราง
EXEC sp_help 'products'
EXEC sp_help 'employees'
--คำสั่ง Select เบื่องต้น
--ต้องการชื่อสินค้า
Select * from Products
--ต้องการ รหัสสินค้า ชื่อสินค้า ราคา
Select ProductID, ProductName, Unitprice from Products
--ต้องการ ชื่อสินค้า ราคา
---- Alias Name = เรียนง่ายๆว่าชื่อเล่น
Select ProductID as รหัส, ProductName as ชื่อสินค้า, Unitprice as ราคา
from Products

Select ProductID  รหัส, ProductName  ชื่อสินค้า, Unitprice  ราคา
from Products
--ใช้ Distinct สำหรับกำจัดข้อมูลที่ซ้ำกัน
Select Distinct Position from Employees
--ใช้ Top(n) สำหรับเเสดงข้อมูล n รายการ (โดยปกติจะใช้ร่วมกับการเรียงลำดับ)
Select top(3) ProductID, ProductName, Unitprice
from dbo.Products;
--ปรับปรุงราคาสอนค้า "ดินสอ" เป็นราคาใหม่ 17 บาท
Update dbo.Products
set UnitPrice = 17, UnitsInStock = 100
where ProductName = 'ดินสอ'
--หลังจากรันโค้ดเเล้วดูข้อมูลว่าเปลี่ยนหรือไม่
Select * from Products
--เเบบไม่มี where
Update dbo.Products
set UnitPrice = UnitPrice * 1.05;
--ปรับปรุงจำนวนคงเหลือของน้ำส้ม เพิ่มจากเดิมอีก 100 ชิ้น
Update dbo.Products
set UnitsInStock =  UnitsInStock + 100
where ProductName = 'น้ำส้ม'
--ปรับปรุงราคาเเเชมพู ลดราคา 5 บาท
Update dbo.Products
set UnitPrice = UnitPrice -5
where ProductName = 'แชมพู'
--ลบข้อมูล 
Delete From dbo.Products
where ProductName = 'ดินสอ'

--การใช้ where ใน คำสั่ง Select 
Select * From Products
where UnitPrice <20 

--ชื่อ นามสกุน พนักงาน ที่มีตำแหน่ง 'Sale Manager'
Select firstname, lastname
from Employees
where Position = 'Sale manager'
--รหัส ชื่อสินค้า ที่เลิกจำหน่ายเเล้ว (discontinue =1)
select productID, productName
from Products
where Discontinued =1
--
select *
from dbo.Products
where UnitPrice >= 10
	AND UnitsInStock < 100;
--
select *
from dbo.Products
where CategoryID >= 2
	OR CategoryID < 4;
--
select *
from dbo.Products
where NOT Discontinued = 1;

--ต้องงการข้อมูลสินค้าที่มีจำนวนคงเหลือ 3000-500 ชิ้น
Select * from Products
where UnitsInStock between 300 and 500
--การใช้เงื่อนไขร่สมกับ wildCard %
--ต้องการข้อมูลพนักงานที่มีชื่อขึ้นต้นด้วย ก
select * from Employees
where FirstName like 'ก%'

--ต้องการข้อมูลพนักงานที่มีนามสกุนลงท้ายด้วย "คำ"
select * from Employees
where LastName like '%คำ'
-- เตรียมข้อมูลใช้กับคำสัง is null
insert into Employees(FirstName, UserName, Password)
values ('ปีใหม่','peemai','255527'),('บอส','boss','255527')
--ข้อมูลพนักงานที่ไม่ทราบนามสกุน
select * from dbo.Employees
where LastName is Null or lastname = ''

--ปรับปรุงข้อมูลทดสอบช่องว่าง
update Employees set LastName = ''
where FirstName = 'ปีใหม่'

--ปัญหาเบี้องต้นจากค่า null คือ ไปรวมกับใครเป็น null ไปหมด
select firstname+' '+Lastname as ชื่อพนักงาน
from Employees

--ต้องการข้อมูลใบเสร็จืั้ขายสินค้าก่อนวันที่ 10 ก.พ. 2013
select * from Receipts
where ReceiptDate < '2013-02-10'
--บางกรณีใช้ Function Year() หรือ Month() ร่วมกับเงื่อนไขได้
--ต้องการข้อมูลใยเสร็จที่ขายสินค้าในเดือนกุมภาพันธ์ 2013
select * from Receipts
where Year(ReceiptDate) = 2013
and Month(ReceiptDate)= 02
--
select ProductID,ProductName,UnittPrice
from dbo.Products
order BY UnitPrice DESC;
--ต่องการข้อมูลใบเสร็จ อันใหม่ที่สุดขึ้นก่อน
select * from Receipts
order by ReceipDate DESC;