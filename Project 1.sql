create database portfolioProject;
use portfolioProject;
drop table Orders;
drop table Customers;
drop table Products;
create table Customers(CustomerId int primary key auto_increment, FirstName varchar(15) not null, LastName varchar(15), Email varchar(30), Phone varchar(8), City varchar(20), Country varchar(20));
/*
CustomerID	FirstName	LastName	Email	Phone	City	Country
1	John	Doe	john.doe@example.com	555-0100	New York	USA
2	Jane	Smith	jane.smith@example.com	555-0101	Los Angeles	USA
3	Michael	Brown	michael.brown@xyz.com	555-0102	Chicago	USA
4	Sarah	Wilson	sarah.wilson@abc.com	555-0103	Boston	USA
5	David	Johnson	david.johnson@xyz.com	555-0104	Miami	USA
*/

create table Products(ProductId int primary key auto_increment, ProductName varchar(30), Category varchar(30), Price decimal(10,2));
/*
ProductID	ProductName	Category	Price
1	Laptop	Electronics	800.00
2	Headphones	Electronics	50.00
3	Coffee Maker	Appliances	120.00
4	Blender	Appliances	60.00
5	Smartphone	Electronics	600.00
*/

create table Orders(OrderId int auto_increment, CustomerId int,OrderDate date,ProductId int,Quantity int,TotalAmount decimal(10,2),primary key(OrderId),foreign key(CustomerId) references Customers(CustomerId), foreign key(ProductId) references Products(ProductId));
/*
OrderID	CustomerID	OrderDate	ProductID	Quantity	TotalAmount
1	1	2024-01-10	1	1	800.00
2	2	2024-01-11	2	2	100.00
3	3	2024-01-12	3	1	120.00
4	4	2024-01-13	4	3	180.00
5	5	2024-01-14	5	2	1200.00
*/

-- inserting values into table Customers
insert into Customers values
(1, 'John', 'Doe', 'john.doe@example.com', '555-0100', 'New York', 'USA'),
(2, 'Jane', 'Smith', 'jane.smith@example.com', '555-0101', 'Los Angeles', 'USA'),
(3, 'Michael', 'Brown', 'michael.brown@xyz.com', '555-0102', 'Chicago', 'USA'),
(4, 'Sarah', 'Wilson', 'sarah.wilson@abc.com', '555-0103', 'Boston', 'USA'),
(5, 'David', 'Johnson', 'david.johnson@xyz.com', '555-0104', 'Miami', 'USA');


-- inserting values into table Products
INSERT INTO Products (ProductID, ProductName, Category, Price)
VALUES
(1, 'Laptop', 'Electronics', 800.00),
(2, 'Headphones', 'Electronics', 50.00),
(3, 'Coffee Maker', 'Appliances', 120.00),
(4, 'Blender', 'Appliances', 60),
(5, 'Smartphone', 'Electronics', 600.00);

-- inserting values into table Orders
INSERT INTO Orders (OrderID, CustomerID, OrderDate, ProductID, Quantity, TotalAmount)
VALUES
(1, 1, '2024-01-10', 1, 1, 800.00),
(2, 2, '2024-01-11', 2, 2, 100.00),
(3, 3, '2024-01-12', 3, 1, 120.00),
(4, 4, '2024-01-13', 4, 3, 180.00),
(5, 5, '2024-01-14', 5, 2, 1200.00);

delimiter $$
create procedure display_all()
begin
	select * from Customers;
    select * from Products;
	select * from Orders;
end $$
delimiter ;

call display_all();

delimiter $$
create procedure display_all2()
begin
	select *
	from  Orders o
	join Customers cu on cu.CustomerId = o.CustomerId
	group by o.CustomerId
	;
end $$
delimiter ;

call display_all();

-- JOINING ALL 3 TABLES
-- c.Customerid,c.FirstName, o.OrderDate,p.ProductName
SELECT *
from Customers c
join Orders o on o.CustomerId = c.CustomerId
join Products p on o.ProductId = p.ProductId;

-- Total Spending by Each Customer:
select cu.CustomerId, cu.FirstName, sum(TotalAmount) over(partition by CustomerId) as Total_spending
from  Orders o
join Customers cu on cu.CustomerId = o.CustomerId
group by o.CustomerId
;

-- Top 3 Most Expensive Products Ordered:
select ProductId, ProductName, Price, rank() over(order by Price desc) as Ranking_by_price
from Products
; 

select * from (
select o.OrderId, p.ProductId, p.ProductName, p.Price
from Orders o
join Products p on o.ProductId = p.ProductId
order by Price desc) as temp
limit 3
;

-- List of Products with Their Categories and Prices:
call display_all2();
select ProductName, Category, Price
from Products;

-- Average Order Value:
select avg(TotalAmount) as AvgValue
from Orders;

-- Orders Placed in a Specific Date Range:
select * 
from Orders
where OrderDate between '2024-01-01' and '2024-01-13';


