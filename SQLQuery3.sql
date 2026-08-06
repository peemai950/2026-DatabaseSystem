--Lab ในชั้นเรียนวันที่  6 สิงหาคม 2569
--ใช้ ฐานข้อมูล Northwind เพื่อ Query ข้อมูลต่อไปนี้

--1.ต้องการ คำนำหน้า ชื่อ นามสกุล พนักงาน ที่อยู่ในเมือง London
SELECT TitleOfCourtesy, FirstName, LastName
FROM Employees
WHERE City = 'London'

--2.ข้อมูล รหัสสินค้า ชื่อสินค้า ราคา จำนวน ของสินค้าที่มีจำนวนน้อยกว่า 30
SELECT ProductID, ProductName, UnitPrice, UnitsInStock
FROM Products
WHERE UnitsInStock < 30;

--3.รหัสลูกค้า ชื่อบริษัท เบอร์โทรศัพท์ ของลูกค้าที่อยู่ในประเทศต่อไปนี้
--    Sweden, Germany, France, Spain, UK
SELECT CustomerID, CompanyName, Phone
FROM Customers
WHERE Country IN ('Sweden', 'Germany', 'France', 'Spain', 'UK')

--4.ข้อมูลลูกค้าที่ไม่มีหมายเลขโทรสาร (Fax)
SELECT *
FROM Customers
WHERE Fax IS NULL

--5.ข้อมูลสินค้าที่มีจำนวนสินค้าต่ำกว่าจุดสั่งซื้อ และ มีจำนวนที่สั่งซื้อแล้ว
SELECT *
FROM Products
WHERE UnitsInStock < ReorderLevel
  AND UnitsOnOrder > 0

--6.ชื่อ นามสกุล พนักงานที่เข้าทำงานในปี 1992
SELECT FirstName, LastName
FROM Employees
WHERE YEAR(HireDate) = 1992

--7.ต้องการข้อมูลสินค้าที่มีราคาตั้งแต่ 20-70
SELECT *
FROM Products
WHERE UnitPrice BETWEEN 20 AND 70

--8.ข้อมูลลูกค้าที่มีชื่อบริษัทขึ้นต้นด้วย S และอยู่ประเทศ Mexico
SELECT *
FROM Customers
WHERE CompanyName LIKE 'S%'
  AND Country = 'Mexico'

--9.ข้อมูลลูกค้าที่มีตำแหน่งของผู้ที่ประสานงานเป็น Manager
SELECT CustomerID, CompanyName, ContactName, ContactTitle
FROM Customers
WHERE ContactTitle = 'Manager';

--Aggeregate Function (หรือเรียกว่า Group Function)
-- เป็น Function ที่คำนวณมาจากข้อมูลหลายเเถว
select top(5) * from Products

select COUNT(*) as จำนวนชนิด, max(UnitPrice) as ราคาสูงสุด, 
	min(UnitPrice) ราคาต่ำสุด,avg(UnitPrice) ราคาเฉลี่ย,sum(UnitsInStock) จำนวนรวมทั้งหมด
from Products

-- ต้องการทราบว่าสินค้าเเต่ละหมวดหมู่(Category) มีสินค้ากี่ชนิด เเต่ละชนิดมีราคาเฉลี่ย มีราคาสุงสุด เเละต่ำสุด
select CategoryID, COUNT(*) จำนวนชนิด,
 avg(UnitPrice) ราคาเฉลี่ย,max(UnitPrice) as ราคาสูงสุด,min(UnitPrice) ราคาต่ำสุด
from Products
Group by CategoryID

--ต้องการทราบข้อมูลว่าเเต่ละประเทศ (country) มีลูกค้าอยู่กี่ราย (city)
select country,city, COUNT(*) จำนวนลูกค้า
from Customers
group by Country, city
order by Country asc, count(*) desc
--order by COUNT(*) desc
--order by 3 desc --เพิ่มเติม

--ต้องการทราบข้อมูลว่าเเต่ละประเทศ (country) เเสดงเฉพาะที่มีจำนวนลูกค้า 10 รายขึ้นไป
select country, COUNT(*) จำนวนลูกค้า
from Customers
group by Country
having COUNT(*) >=10

--ต้องการทราบว่าสินค่าที่มีมูลละค่าสูง (ราคาตั้งเเต่ 75 ขึ้นไป) เเต่ละหมวดหมู่มีจำนวนกี่ชนิด มีราคาเฉลี่ยเท่าใด
--ให้เเสดงเฉพาะสินค้าที่มีราคาสูงกว่าเฉลี่ย
select categoryID, COUNT(*) จำนวนชนิด, avg(UnitPrice) ราคาเฉลี่ย
from Products
where UnitPrice >=75
group by CategoryID
having avg(UnitPrice) > 200

--จากคาราง [Order Details] ให้รวมว่าในเเต่ละการสั่งซื้อ มียอดเงินรวมเท่าใด
select orderID, UnitPrice,Quantity,Discount,
		UnitPrice * Quantity as ราคาเต็ม,
		UnitPrice * Quantity * Discount as ส่วนลด,
		 (UnitPrice * Quantity)-(UnitPrice * Quantity * Discount) as ราคาหักส่วนลดเเล้ว
from [Order Details]

--ต้องการเฉพาะใบสั่งซื้อที่มียอดเงินรวมมากกว่า 1000
select orderID,
	sum((UnitPrice * Quantity * (1- Discount))) as ยอดเงินรวม
from [Order Details]
group by OrderID
	sum((UnitPrice * Quantity * (1- Discount))) > 2000
--order by 3 desc