/*
 * Your team also needs you to query some information from the database that you have designed.
 * You are tasked to write a sql statement for each of the following task:
 */

-- 1. I want to know the list of our customers and their spending.

select
	cust.customer_name,
	SUM(ct.price) as total_spending
from
	customer cust
	inner join sales st on cust.customer_id = st.customer_id
	inner join car ct on st.car_id = ct.car_id
group by cust.customer_name


-- 2. I want to find out the top 3 car manufacturers that customers bought by sales (quantity) 
--    and the sales number for it in the current month.

select
	tbl.*
from (
	select 
		mt.manufacturer_name,
		SUM(ct.price) as total_sales,
		count(1) as total_quantity,
		row_number() over (order by SUM(ct.price) desc) as rk_sales,
		row_number() over (order by count(1) desc) as rk_quantity
	from
		sales st
		inner join car ct on st.car_id = ct.car_id
		inner join manufacturer mt on ct.manufacturer_id = mt.manufacturer_id
	where
		extract(year from st.sales_datetime) = extract (year FROM CURRENT_DATE)
		and extract(month from st.sales_datetime) =  extract (month FROM CURRENT_DATE)
	group by mt.manufacturer_name
) as tbl 
where
	tbl.rk_sales <= 3 or tbl.rk_quantity <=3