select * 
from orderstatus
select *
from dsadataset

------1. Which product category had the highest sales?

select productcategory,sum(sales) as Total_sales
from dsadataset
group by productcategory
order by total_sales desc
limit 1;

------2a. What are the Top 3 regions in terms of sales? 
select region, sum (sales) as total_sales
from dsadataset
group by region
order by total_sales desc
limit 3;

------------2b.what are the Bottom 3 regions in terms of sales? 
select region, sum (sales) as total_sales
from dsadataset
group by region
order by total_sales asc
limit 3;


--------3 What were the total sales of appliances in Ontario
select *
from dsadataset

select productsubcategory,region, sum(sales) as total_sales
from dsadataset
where productsubcategory ='Appliances' and region ='Ontario'
group by productsubcategory,region
order by total_sales;

------4. Advise the management of KMS on what to do to increase the revenue from the bottom 
---10 customers

select customername,sum (sales) as total_sales
from dsadataset
group by customername
order by total_sales asc
limit 10;

------an insight such as their region,customersegment,productname was done to be able to give this recommendation.
-----1)Distance and shipping costs may be significant factors impacting the purchasing behavior of these customers. 
------It is advisable for the company to analyze the geographic distribution of its customer base and consider
----establishing a branch or distribution center strategically located within key regions to reduce shipping expenses.

------2)The company can encourage these customers to purchase in bulk and utilize sea freight for shipping, 
-------which would significantly reduce their overall costs.
------3)For individual consumers, offering targeted discounts can incentivize increased purchasing and boost overall sales volume.
-----introduce customer incentive and product bundling.

--------5. KMS incurred the most shipping cost using which shipping method? 

select shipmode, sum (shippingcost) as "total shipping cost"
from dsadataset
group by shipmode
order by "total shipping cost" desc
limit 1

-----6. Who are the most valuable customers, and what products or services do they typically 
----purchase? 
--------- valuable customers
select customername,sum (sales) as "total sales"
from dsadataset
group by customername
order by "total sales" desc
limit 10
------------ valuable customers with the product they typically purchase
WITH top_customers AS (
SELECT customername, SUM(sales) AS total_sales
FROM  dsadataset
GROUP BY customername
ORDER BY total_sales DESC
 LIMIT 10
)
SELECT d.customername,  d.productname, 
SUM(d.sales) AS product_sales
FROM dsadataset d
JOIN  top_customers t
ON  d.customername = t.customername
GROUP BY  d.customername, d.productname
ORDER BY  d.customername, product_sales DESC;


        

------7. Which small business customer had the highest sales? 

select *
from kmsproject

select customersegment,customername,sum(sales) as total_sales
from dsadataset
where customersegment='Small Business'
group by customername,customersegment
order by total_sales desc
limit 1;

-----8. Which Corporate Customer placed the most number of orders in 2009 – 2012?
SELECT customersegment, customername,count(*)as order_items
FROM dsadataset
WHERE  customersegment = 'Corporate' AND orderdate BETWEEN '2009-01-01' AND '2012-12-31'
group by customername,customersegment
ORDER BY  order_items DESC
LIMIT 1;

----9. Which consumer customer was the most profitable one? 

select *
from dsadataset

SELECT  customername,customersegment, SUM(profit) AS total_profit
FROM  dsadataset
WHERE  customersegment = 'Consumer'
GROUP BY  customername,customersegment
ORDER BY  total_profit DESC
LIMIT 1;

------ 10 Which customer returned items, and what segment do they belong to? 

SELECT 
    D.customername,
    D.customersegment
FROM dsadataset D
JOIN orderstatus S ON D.orderid = S.orderid
WHERE S.status = 'Returned';

SELECT 

-------11. If the delivery truck is the most economical but the slowest shipping method and 
-----Express Air is the fastest but the most expensive one, do you think the company 
-----appropriately spent shipping costs based on the Order Priority? Explain your answer

select *
from dsadataset

SELECT OrderPriority, ShipMode,
COUNT(OrderID) AS Total_Delivery,
ROUND(SUM(Sales - Profit)::numeric, 2) AS EstimatedShippingCost,
AVG(ShipDate - OrderDate) AS AvgShipDays
FROM dsadataset
GROUP BY OrderPriority, ShipMode;


-----The company did not allocate shipping costs appropriately in relation to order priority. Based on the query results, 
-----several low-priority orders were delivered using Express Air, which is the most expensive shipping method.
-----While Express Air is indeed the fastest, its use should be reserved for high-priority or time-sensitive shipments.
-----Additionally, some orders with unspecified priority levels were also shipped via Express Air, 
------further indicating a lack of alignment between shipping method and order urgency.
----To improve cost efficiency and operational effectiveness, 
-----the company should implement stricter shipping policies that reserve premium delivery options—such as
----Express Air—exclusively for high-priority orders. 
-----Lower-priority shipments should be routed through more economical options like ground or standard shipping methods.

