-- Sales and Customer Insights

-- 1. Retrieve the full names of customers alphabetically with the total amount of money they have spent 
select * from sales_customer;
select * from person_person;
select * from sales_salesorderheader

select concat_ws(' ', pp.firstname, pp.middlename, pp.lastname) as full_name, sum(SOH.TotalDue) as total_spent
from person_person as PP
left join sales_customer as SC
on PP.businessEntityID = SC.PersonID
left join sales_salesorderheader as SOH
on SC.CustomerID = SOH.CustomerID
where pp.PersonType in ('IN', 'SC')
group by concat_ws(' ', pp.firstname, pp.middlename, pp.lastname)
order by full_name asc;

-- 2. Identify each sales person and the total amount they generated in revenue through orders
select * from sales_salesperson;
select * from person_person;
select * from sales_salesorderheader;

select concat_ws(' ', pp.FirstName, pp.MiddleName, pp.LastName) as full_name, ifnull(sum(soh.SubTotal),0) as total_revenue
from person_person as pp
left join sales_salesperson as sp
on pp.BusinessEntityID = sp.BusinessEntityID
left join sales_salesorderheader as soh
on sp.TerritoryID = soh.TerritoryID
where pp.PersonType = 'SP'
group by concat_ws(' ', pp.FirstName, pp.MiddleName, pp.LastName)
order by total_revenue desc;

-- 3. Sales territory with the highest sales 
select * from sales_salesterritory;
select * from sales_salesorderheader;

select ST.Name, sum(soh.SubTotal) as total_sales
from sales_salesterritory as ST
inner join sales_salesorderheader as SOH
on ST.TerritoryID = SOH.TerritoryID
group by st.name
order by total_sales desc
Limit 1;

-- 4. Provide a list of all individual customers, including their full names, email addresses and phone numbers for marketing campaign
select * from person_person;
select * from person_emailaddress;
select * from person_personphone;

select concat_ws(' ', PP.FirstName, PP.MiddleName, PP.LastName) as full_name, PE.EmailAddress, PPP.PhoneNumber
from person_person as PP
left join person_emailaddress as PE
on PP.BusinessEntityID = PE.BusinessEntityID
left join person_personphone as PPP
on PE.BusinessEntityID = PPP.BusinessEntityID
where PP.PersonType in ('IN', 'SC')

-- 5. List all reseller store names, and the sales person assigned to manage the store
select * from sales_store;
select * from sales_salesperson;
select * from person_person;

select SS.Name, concat_ws(' ', PP.FirstName, PP.MiddleName, PP.LastName) as sales_person
from sales_store as SS
left join sales_salesperson as SSP
on SSP.BusinessEntityID = SS.SalesPersonID
left join person_person as PP
on SSP.BusinessEntityID = PP.BusinessEntityID
where PP.PersonType = 'SP';

-- 6. What are the top 10 customers by total revenue, and their full names
select * from person_person;
select * from sales_customer;
select * from sales_salesorderheader;

select concat_ws(' ', PP.firstname, PP.middlename, PP.lastname) as full_name, sum(soh.SubTotal) as total_revenue
from person_person as PP
inner join sales_customer as SC
on PP.BusinessEntityID = SC.PersonID
inner join sales_salesorderheader as SOH
on SC.CustomerID = SOH.CustomerID
where PP.PersonType in ('IN', 'SC')
group by  concat_ws(' ', PP.firstname, PP.middlename, PP.lastname)
order by total_revenue desc
limit 10;

-- 7. List all territories by name, the region, and the total revenue they have generated over the years. 
select * from sales_salesterritory;
select * from sales_salesorderheader;
select * from person_countryregion;

select SST.Name as territory_name, PCR.Name as region_name, sum(SOH.SubTotal) as total_revenue
from sales_salesterritory as SST
left join sales_salesorderheader as SOH
on SST.TerritoryID = SOH.TerritoryID
left join person_countryregion as PCR
on SST.CountryRegionCode = PCR.CountryRegionCode
group by SST.Name, PCR.Name
order by total_revenue desc;

-- PRODUCTION AND INVENTORY MANAGEMENT

-- 8. What are the top 5 best selling products by the total quantity ordered
select * from production_product;
select * from sales_salesorderdetail;

select P_P.name, sum(SOD.OrderQty) as total_quantity_ordered
from production_product as P_P
inner join sales_salesorderdetail as SOD
on P_P.ProductID = SOD.ProductID
group by P_P.Name
order by total_quantity_ordered desc
limit 5;

-- 9. Retrieve the product names, their subcategories and main categories with the current stock level
select * from production_product;
select * from production_productsubcategory;
select * from production_productcategory;
select * from production_productinventory;

select P_P.Name as Product_Name, PPS.Name as Subcategory_Name, PPC.Name as Category_Name, sum(PPI.Quantity) as current_stock_level
from production_product as P_P
inner join production_productsubcategory as PPS
on P_P.ProductSubcategoryID = PPS.ProductSubcategoryID
inner join production_productcategory as PPC
on PPS.ProductCategoryID = PPC.ProductCategoryID
inner join production_productinventory as PPI
on P_P.ProductID = PPI.ProductID
group by P_P.Name, PPS.Name, PPC.Name;

-- 10. List all products by name, showing their average customer ratings. For products without review, display a rating of 0
select * from production_product;
select * from production_productreview;

select P_P.Name, ifnull(avg(PPR.Rating), 0) as average_rating
from production_product as P_P
left join production_productreview as PPR
on P_P.ProductID = PPR.ProductID
group by P_P.Name
order by average_rating desc;

-- 11. Which 10 products have generated the highest revenue in AdventureWorks
select * from production_product;
select * from sales_salesorderdetail;

select P_P.Name, round(sum(SOD.LineTotal),0) as total_revenue
from production_product as P_P
inner join sales_salesorderdetail as SOD
on P_P.ProductID = SOD.ProductID
group by P_P.Name
order by total_revenue desc
limit 10;

-- HUMAN RESOURCES AND EMPLOYEE TRACKING

-- 12. Generate a list of all current employees, their job titles, and the department they are currently working
select * from humanresources_employee;
select * from person_person;
select * from humanresources_employeedepartmenthistory;
select * from humanresources_department;

select concat_ws(' ', PP.FirstName, PP.MiddleName, PP.LastName) as full_name, HRE.JobTitle, HRD.Name as department_name
from person_person as PP
left join humanresources_employee as HRE
on PP.BusinessEntityID = HRE.BusinessEntityID
left join humanresources_employeedepartmenthistory as HREH
on HRE.BusinessEntityID = HREH.BusinessEntityID
left join humanresources_department as HRD
on HREH.DepartmentID = HRD.DepartmentID
where HRE.CurrentFlag = 1 and HREH.EndDate is null;

-- 13. Who are our top 10 longest serving current employees? List their names and the date they were hired
select * from person_person;
select * from humanresources_employee;

select concat_ws(' ', PP.FirstName, PP.MiddleName, PP.LastName) as full_name, HRE.HireDate as date_hired
from person_person as PP
inner join humanresources_employee as HRE
on PP.BusinessEntityID = HRE.BusinessEntityID
where HRE.CurrentFlag = 1
order by date_hired asc
limit 10;

-- 14. Which employees have worked in more than one department during their career at AdventureWork
select * from person_person;
select * from humanresources_employeedepartmenthistory;

select concat_ws(' ', PP.FirstName, PP.MiddleName, PP.LastName) as full_name, count(HRE.DepartmentID) as department_count
from humanresources_employeedepartmenthistory as HRE
inner join person_person as PP
on HRE.BusinessEntityID = PP.BusinessEntityID
group by concat_ws(' ', PP.FirstName, PP.MiddleName, PP.LastName)
having count(HRE.DepartmentID) > 1;

-- RESELLER SALES, PRODUCTION, AND CUSTOMER BEHAVIOR

-- 15. Which 5 physical stores generated the highest total revenue.
select * from sales_store;
select * from sales_customer;
select * from sales_salesorderheader;

select SS.Name, sum(SOH.TotalDue) as total_revenue
from sales_salesorderheader as SOH
inner join sales_customer as SC
on SOH.CustomerID = SC.CustomerID
inner join sales_store as SS
on SC.StoreID = SS.BusinessEntityID
group by SS.Name
order by total_revenue desc
limit 5;

-- 16. What is the total revenue generated by each product subcategory
select * from production_product;
select * from production_productsubcategory;
select * from sales_salesorderdetail;

select PPC.Name, round(sum(SOD.LineTotal),0) as total_revenue
from production_productsubcategory as PPC
inner join production_product as P_P
on PPC.ProductSubcategoryID = P_P.ProductSubcategoryID
inner join sales_salesorderdetail as SOD
on P_P.ProductID = SOD.ProductID
group by PPC.Name
order by total_revenue desc;

-- 17. Which customers have only ever placed exactly one order, with their full names.
select * from person_person;
select * from sales_customer;
select * from sales_salesorderheader;

select concat_ws(' ', PP.FirstName, PP.MiddleName, PP.LastName) as full_name, count(SOH.SalesOrderID) as total_order
from person_person as PP
inner join sales_customer as SC
on PP.BusinessEntityID = SC.PersonID
inner join sales_salesorderheader as SOH
on SC.CustomerID = SOH.CustomerID
group by concat_ws(' ', PP.FirstName, PP.MiddleName, PP.LastName)
having count(SOH.SalesOrderID) = 1;

-- 18. What is the average order value across all customers combined
select * from person_person;
select * from sales_customer;
select * from sales_salesorderheader;

select round(avg(soh.SubTotal),2) as avg_order_value
from person_person as p_p
left join sales_customer as sc
on sc.PersonID = p_p.BusinessEntityID
left join sales_salesorderheader as soh
on sc.CustomerID = soh.CustomerID
where p_p.PersonType in ('IN', 'SC');






