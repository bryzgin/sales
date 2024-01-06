-- Шаг 4
-- Запрос, который считает общее количество покупателей из таблицы customers, файл customers_count.csv
select count(distinct(customers.customer_id)) as customers_count from customers;


-- Шаг 5
-- Запрос, который формирует отчет о десятке лучших продавцов, файл top_10_total_income.csv
select
	concat(employees.first_name, ' ', employees.last_name) as name,
	count(distinct(sales.sales_id)) as operations,
	floor(sum(sales.quantity * products.price)) as income
from employees
inner join sales on
	employees.employee_id = sales.sales_person_id
inner join products on
	sales.product_id = products.product_id
group by concat(employees.first_name, ' ', employees.last_name)
order by income desc
limit 10;

-- Запрос, который формирует отчет о продавцах, чья средняя выручка за сделку меньше средней выручки за сделку по всем продавцам, файл lowest_average_income.csv
select
	concat(employees.first_name, ' ', employees.last_name) as name,
	floor(avg(sales.quantity * products.price)) as average_income
from employees
inner join sales on
	employees.employee_id = sales.sales_person_id
inner join products on
	sales.product_id = products.product_id
group by concat(employees.first_name, ' ', employees.last_name)
having floor(avg(sales.quantity * products.price)) < (select avg(sales.quantity * products.price) from sales inner join products on sales.product_id = products.product_id) 
order by average_income;

-- Запрос, который формирует отчет о выручке по дням недели, файл day_of_the_week_income.csv
select 
	concat(employees.first_name, ' ', employees.last_name) as name, 
	to_char(sales.sale_date, 'day') as weekday, 
	floor(sum(sales.quantity * products.price)) as income
from employees
inner join sales on 
	employees.employee_id = sales.sales_person_id
inner join products on 
	sales.product_id  = products.product_id
group by 
	concat(employees.first_name, ' ', employees.last_name), 
	to_char(sales.sale_date, 'id'),
	to_char(sales.sale_date, 'day')
order by to_char(sales.sale_date, 'id');


-- Шаг 6
-- Запрос, который формирует отчет о количестве покупателей в разных возрастных группах, файл age_groups.csv
select
	case 
		when customers.age between 16 and 25 then '16-25'
		when customers.age between 25 and 40 then '26-40'
		else '40+'
	end as age_category, 
	count(*) as count 
from customers
group by age_category
order by age_category;

-- Запрос, который формирует отчет по количеству уникальных покупателей и выручке, которую они принесли, файл customers_by_month.csv
select 
	to_char(sales.sale_date, 'YYYY-MM') as date, 
	count(distinct(customer_id)) as total_customers, 
	floor(sum(sales.quantity * products.price)) as income
from sales
inner join products on 
	sales.product_id = products.product_id
group by to_char(sales.sale_date, 'YYYY-MM')
order by to_char(sales.sale_date, 'YYYY-MM');

-- Запрос, который формирует отчет о покупателях, первая покупка которых была в ходе проведения акций, файл special_offer.csv
select 
	distinct on (customers.customer_id)
	concat(customers.first_name, ' ', customers.last_name) as customer,
	min(sales.sale_date) as sale_date,
	concat(employees.first_name, ' ', employees.last_name) as seller
from customers
inner join sales on 
	customers.customer_id = sales.customer_id 
inner join employees on 
	sales.sales_person_id = employees.employee_id
inner join products on 
	sales.product_id = products.product_id
group by 
	concat(customers.first_name, ' ', customers.last_name), 
	concat(employees.first_name, ' ', employees.last_name),
	customers.customer_id
having sum(products.price) = 0
order by customers.customer_id;