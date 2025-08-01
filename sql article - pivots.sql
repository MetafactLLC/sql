


use northwind

/*
select * from HumanResources.Employee


select * from HumanResources.Department

select * from person.ContactType

select * from person.person

select distinct persontype  from person.person
*/

/*
Lets take a look at how to make some simple pivot tables in SQL Server.

This example uses the Northwind database for the example.  More specifically, we are using the Invoices view.

A Pivot table is done when you want to get a 3 dimensional view of the data.  One can easily be created in MS Excel (using much less resources) but the same operation can be used in SQL.  

Suppose we are looking at the Invoices view and we want to know the total freight for each shipper that each customer paid.

One way of doing this is through sub selects
*/
-- sub select 
select distinct i.customername ,
	(select sum(freight) from Invoices i2 where i2.customername = i.customername and i2.shippername ='United Package') as [United Package] ,
	(select sum(freight) from Invoices i2 where i2.customername = i.customername and i2.shippername ='Federal Shipping') as [Federal Shipping] ,
	(select sum(freight) from Invoices i2 where i2.customername = i.customername and i2.shippername ='Speedy Express') as [Speedy Express] 
from Invoices i

/*
Another way is through pivots.  
To set this up, you need to know 
	1. what categories will be pivoting on (turning into columns)
	2. what value you will aggregate
*/
/*
First, figure out the values you want to use. 
*/
	select shippername, customername, freight 
	from Invoices 
/*
Then, use that recorset to select from.  SQL needs use that recordset to pivot on 
*/
select * from (
	select shippername, customername, freight 
	from Invoices 
) as source
/*
Finally - the pivot!  Use the aggregate function on your value. For the column you will be pivoting on, write a statement similar what you would write in a where clause using in().  In this situation though, do not use strings to represent the values because these will be your column names. 
*/
pivot ( sum(freight) for shippername in([United Package], [Federal Shipping], [Speedy Express])) as pvt

/*
The total statement should look like this: 
*/
-- pivot with aggregate
select * from (
	select shippername, customername, freight 
	from Invoices 
) as source
pivot ( sum(freight) for shippername in([United Package], [Federal Shipping], [Speedy Express])) as pvt


/*
The pivot is more elegant and readable than the sub selects above, but that comes at a cost.  I took a look at the execution plan and the SQL processor spends mucho time matching the shipper name with the column names in the table while performing the aggregate function.

This could cause performance issues if you are crunching LOTS of numbers or will have LOTS of columns.  Somehow, this is made more efficient when you explicitly tell the SQL processor to match via the subselects.

Questions, comments?  Hit me up at: meekscapital@gmail.com
*/


select * from Invoices
select distinct shippername from Invoices
select distinct customername from Invoices
select distinct freight from Invoices

-- sub select 
select distinct i.customername ,
	(select sum(freight) from Invoices i2 where i2.customername = i.customername and i2.shippername ='United Package') as [United Package] ,
	(select sum(freight) from Invoices i2 where i2.customername = i.customername and i2.shippername ='Federal Shipping') as [Federal Shipping] ,
	(select sum(freight) from Invoices i2 where i2.customername = i.customername and i2.shippername ='Speedy Express') as [Speedy Express] 
from Invoices i


-- pivot with aggregate
select * from (
	select shippername, customername, freight 
	from Invoices 
) as source
pivot ( sum(freight) for shippername in([United Package], [Federal Shipping], [Speedy Express])) as pvt

-- pivot without aggregate


	select shippername, customername, freight 
	from Invoices 
pivot ( sum(freight) for shippername in([United Package], [Federal Shipping], [Speedy Express])) as pvt











