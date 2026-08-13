--Lab ในฉันเรียนวันที่ 13 สิงหาคม 2569
--ในฐานข้อมูล Northwind
-- 1. ต้องการข้อมูล รหัสใบสั่งซื้อ ยอดเงินรวมที่หักส่วนลดแล้ว จากแต่ละใบสั่งซื้อ ทั้งหมด เรียงลำดับตามยอดเงิน จากมากไปน้อย  
SELECT 
    OrderID,
    format(SUM(UnitPrice * Quantity * (1 - Discount)),'N2') AS TotalAmount
FROM [Order Details]
GROUP BY OrderID
ORDER BY TotalAmount DESC;
-- 2. ต้องการ ชื่อประเทศ ของผู้แทนจำหน่าย (suppliers) และจำนวนผู้แทนจำหน่ายในแต่ละประเทศ
--	  แสดงมาเฉพาะรายการที่ผู้แทนจำหน่ายมีมากกว่า 1 ราย 
SELECT Country,
    COUNT(SupplierID) AS SupplierCount
FROM Suppliers
GROUP BY Country
HAVING COUNT(SupplierID) > 1
-- 3. รหัสสินค้า จำนวนรวมทั้งหมดที่ขายได้ ราคาสูงสุดที่ขายได้ ราคาต่ำสุดที่ขายได้ 
--	  แสดงเฉพาะสินค้าที่ขายได้รวมมากกว่า 1500 ชิ้น 
SELECT 
    ProductID,
    SUM(Quantity) AS TotalQuantitySold,
    MAX(UnitPrice) AS MaxPrice,
    MIN(UnitPrice) AS MinPrice
FROM [Order Details]
GROUP BY ProductID
HAVING SUM(Quantity) > 1500
ORDER BY TotalQuantitySold DESC;
--เพิ่มข้อ 3 ต้องการเฉพาะ จำนวนรายการที่ไม่มีสวนลด
SELECT ProductID,SUM(Quantity) AS TotalQuantity
FROM [Order Details]
where Discount > 0
GROUP BY ProductID
HAVING SUM(Quantity) > 500
ORDER BY TotalQuantity DESC;
--ORDER BY TotalQuantitySold ASC;
-- การ Query ข้อมูล จากหลายตาราง (Join Table) 

-- 
select * from Products
select * from Categories
-- Inner foin
select *
from Products inner join Categories
              on products.CategoryID = Categories.categoryID
--ต้องการชื่อหมวดหมู่สสินค้า ชื่อหมวดหมู่สินค้า รหัสสสินนค้า ชื่อสินค้า ราคา โดยเรียงลำดับตามหมวดหมู่สินค้า เเละราคาสูงไปต่ำ
select products.categoryID, CategoryName, productID, productName, UnitPrice
from Products Inner join Categories
        on Products.CategoryID = Categories.CategoryID
Order by CategoryID asc ,UnitPrice desc

select p.categoryID, CategoryName, productID, productName, UnitPrice
from Products as p Inner join Categories as c
        on p.CategoryID = c.CategoryID
Order by CategoryID asc ,UnitPrice desc

--ต้องการชื่อผู้รับผิดชอบการสังซื้อเเต่ละรายการ
select * from Orders
select * from Employees
--ต้องการ รหัสใบสั่งซื่อ วันที่สังซื้อ วันที่รับสินค้า ประเทศปลายทาง ชื่อ-นามสกุนพนักงานผู้รับผิดชาบ
select o.OrderID,  FORMAT((o.OrderDate), 'dd/MM/yyyy') AS 'DD/MM/YYYY',
                   FORMAT((o.ShippedDate), 'dd/MM/yyyy') AS 'DD/MM/YYYY', o.ShipCountry,
       e.FirstName + SPACE(2) + e.LastName SaleMan
from orders as o inner join Employees e on o.EmployeeID = e.EmployeeID 

--ต้องการชื่อหมวดหมู่สสินค้า ชื่อหมวดหมู่สินค้า รหัสสสินนค้า ชื่อสินค้า ราคา 
--โดยเรียงลำดับตามหมวดหมู่สินค้า เเละราคาสูงไปต่ำ เเละสินค้ามาจากประเทศ USA,Mexico,Canada
select * from Products
select * from Categories
select * from Suppliers

select c.CategoryID, c.CategoryName,
       p.ProductID, p.ProductName, p.UnitPrice,
       s.Country
from Products as p inner join Categories as c on p.CategoryID = c.CategoryID
                   inner join Suppliers as s on p.SupplierID = s.SupplierID
where s.Country in ('USA', 'Mexico', 'Canada')
order by country

-- แบบฝึกหัดการ Join ตาราง 
-- 1. ต้องการ รหัสบริษัทขนส่ง, ชื่อบริษัทขนส่ง, จำนวนใบสั่งซื้อที่เกี่ยวข้อง, ยอดรวมค่าขนส่ง
select s.ShipperID,
       s.CompanyName,
    COUNT(o.OrderID) as TotalOrders,
    SUM(o.Freight) as TotalFreight
from Shippers as s inner join Orders o on s.ShipperID = o.ShipVia
group by s.ShipperID, s.CompanyName
-- 2. รหัสใบสั่งซื้อ วันที่สั่งซื้อ ชื่อบริษัทลูกค้า ให้แสดงเฉพาะ ลูกค้าที่อยู่ในประเทศ USA 
select o.OrderID,
       FORMAT((o.OrderDate), 'dd/MM/yyyy'),
       c.CompanyName
from Orders as o inner join Customers c on o.CustomerID = c.CustomerID
where c.Country = 'USA'
-- 3. รหัสพนักงาน ชื่อนามสกุล จำนวนใบสั่งซื้อที่เกี่ยวข้อง
select e.EmployeeID,e.FirstName + space(2) + e.LastName as FullName,
    COUNT(o.OrderID) as TotalOrders
from Employees e inner join Orders o on e.EmployeeID = o.EmployeeID
group by e.EmployeeID, e.FirstName, e.LastName
-- 4. รหัสใบสั่งซื้อ วันที่สั่งซื้อ ชื่อพนักงาน ชื่อบริษัทลูกค้า ชื่อบริษัทขนส่ง 
--    ยอดรวมในใบสั่งซื้อ เฉพาะรายการที่ขายในปี 1997 เรียงตามลำดับ ยอดเงินจากมากไปน้อย
select o.OrderID,
       FORMAT((o.OrderDate), 'dd/MM/yyyy'),
       e.FirstName + space(2) + e.LastName as EmployeeName,
       c.CompanyName as CustomerName,
       s.CompanyName as ShipperName,
    format(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)),'N2') as TotalAmount
from Orders o inner join Employees e on o.EmployeeID = e.EmployeeID
              inner join Customers c on o.CustomerID = c.CustomerID
              inner join Shippers s on o.ShipVia = s.ShipperID
              inner join [Order Details] od on o.OrderID = od.OrderID
where YEAR(OrderDate) = 1997
group by o.OrderID, o.OrderDate, e.FirstName, e.LastName, c.CompanyName, s.CompanyName
order by TotalAmount DESC;

--ต้องการ รหัสสินค้า ชื่อสินค้า จำนวนที่ขายได้ เฉพาะสินค้าที่ขายดีที่สุด 5 อันดับเเรก ในปี 1997
select TOP 5
    p.ProductID,
    p.ProductName,
    SUM(Quantity) as TotalQuantitySold
from Products p
             inner join [Order Details] od on p.ProductID = od.ProductID
             inner join Orders o on od.OrderID = o.OrderID
where YEAR(OrderDate) = 1997
group by p.ProductID, p.ProductName
order by 3 DESC;
-----------------------------------------------------------------------------------
-- ข้อมูล ชื่อบริษัทลูกค้า และประเทศลูกค้า ทีซื้อสินค้าที่มาจากบริษัทซื่อ Exotic Liquids
select c.CompanyName as CustomerCompanyName,
    c.Country as CustomerCountry
from Customers c
            join Orders o on c.CustomerID = o.CustomerID
            join [Order Details] od on o.OrderID = od.OrderID
            join Products p on od.ProductID = p.ProductID
            join Suppliers s on p.SupplierID = s.SupplierID
where s.CompanyName = 'Exotic Liquids'

--ชื่อบริษัทลูกค้าที่มีสินค้า Seafood
----------------------------------------------------------------------------------
-- sub Query (Query ซ้อนกัน)
-- ชื่อพนักงานที่มีตำเเหน่งเดียวกับ (Nancy ตำเเหน่งอะไร)
select Firstname
from Employees
where Title = (select title from Employees where FirstName = 'Nancy')

-- ชื่อพนักงานืี่มีอายุน้อยกว่า (Robert เกิดเมื่อใด)
select Firstname
from Employees
where BirthDate > (select BirthDate from Employees where FirstName = 'Robert')
-- รหัสสินค้า ชื่อสินค้า ที่มีราคาสูงกว่าค่าเฉลี่ยทั้งหมดของราคาสินค้า (ค่าเฉลี่ยของราคาสินค้าคืออะไร)
select productID, productName, unitprice
from Products
where UnitPrice > (select AVG(UnitPrice) from Products) 
-- ชื่อ นามสกุล พนักงานที่มีอายุมากที่สุด
select FirstName, LastName, BirthDate
from Employees
where BirthDate = (select MIN(BirthDate) from Employees)
--  ชื่อ นามสกุล พนักงานที่ เข้าทำงานมากที่สุด
select FirstName, LastName, HireDate
from Employees
where HireDate = (select MIN(HireDate) from Employees)









  

