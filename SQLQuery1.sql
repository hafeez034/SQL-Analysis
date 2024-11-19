select * from orders1

select * from orders1
where ship_mode = ' '

update orders1 
set 
ship_mode = Null 
where ship_mode = ' '

select * from orders1
where ship_mode is null

select segment,count(segment) as counts from orders1
group by segment

--------------------------Top 10 selling products in all region
select top 10 product_id,sum(sales_price)as price
from orders1
group by product_id
order by price desc

----------------------------Top 5 HIghest selling product in each region
with cte1 as(
select  region,product_id,sum(sales_price) as sp,
row_number() over(partition by region order by sum(sales_price) ) as dr
from orders1
group by region,product_id
)
select region,product_id,sp,dr from cte1
where dr<6


----------------------------Month Wise comparison from previous year to this year 2022 vs 2023
with cte1 as(
select year(order_date) as order_year ,MONTH(order_date) as order_month ,sum(sales_price) as sales
from orders1
group by year(order_date) ,MONTH(order_date) 
--order by MONTH(order_date)
	)
select order_month,
sum(case when order_year=2022 then round(cast(sales as float),2) else 0 end) as sales_2022,
sum(case when order_year=2023 then round(cast(sales as float),2) else 0 end) as sales_2023
from cte1
group by order_month
order by order_month

----------------------Each category which month had the Highest Sales
select category,order_year_month,sales  from(
select category,FORMAT(order_date,'yyyyMM') as order_year_month,
sum(sales_price) as sales,ROW_NUMBER() over(partition by category order by sum(sales_price)) as rn
from orders1
group by category,FORMAT(order_date,'yyyyMM')) a
where rn = 1


--------------------Growth over the year in terms of sales
WITH cte1 AS (
    SELECT 
        YEAR(order_date) AS order_year, 
        MONTH(order_date) AS order_month, 
        SUM(sales_price) AS sales
    FROM orders1
    GROUP BY YEAR(order_date), MONTH(order_date)
),
cte2 AS (
    SELECT 
        order_month,
        SUM(CASE WHEN order_year = 2022 THEN ROUND(CAST(sales AS FLOAT), 2) ELSE 0 END) AS sales_2022,
        SUM(CASE WHEN order_year = 2023 THEN ROUND(CAST(sales AS FLOAT), 2) ELSE 0 END) AS sales_2023
    FROM cte1
    GROUP BY order_month
)
SELECT 
    order_month,
    (sales_2023 - sales_2022)/sales_2022 *100 AS growth
FROM cte2
order by growth desc


----------------Growth over the year in terms of sales
WITH cte1 AS (
    SELECT 
	    category,
        YEAR(order_date) AS order_year, 
        MONTH(order_date) AS order_month, 

        SUM(sales_price) AS sales
    FROM orders1
    GROUP BY YEAR(order_date), MONTH(order_date),category
),
cte2 AS (
    SELECT 
        category,
        SUM(CASE WHEN order_year = 2022 THEN ROUND(CAST(sales AS FLOAT), 2) ELSE 0 END) AS sales_2022,
        SUM(CASE WHEN order_year = 2023 THEN ROUND(CAST(sales AS FLOAT), 2) ELSE 0 END) AS sales_2023
    FROM cte1
	group by category
)
SELECT 
    category,
    (sales_2023 - sales_2022)/sales_2022 *100 AS growth
from cte2
group by category,(sales_2023 - sales_2022)/sales_2022 *100 
order by growth desc





















