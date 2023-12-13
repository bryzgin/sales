-- Данный запрос считает общее количество покупателей из таблицы customers
select count(customer_id)  as customers_count
from customers;

-- Отчет с продавцами у которых наибольшая выручка
select concat(employees.first_name, ' ', employees.last_name) as name, 
sum(sales.quantity) as operations, 
round(sum(sales.quantity * products.price)) as income
from employees
inner join sales on employees.employee_id = sales.sales_person_id
inner join products on sales.product_id  = products.product_id
group by concat(employees.first_name, ' ', employees.last_name)
order by operations desc
limit 10;

-- Вспомогательный расчет средней выручки за сделку по всем продавцам
select round(avg(sales.quantity * products.price)) as average_income
from sales
inner join products on sales.product_id = products.product_id;

-- Отчет с продавцами, чья выручка ниже средней выручки всех продавцов
select concat(employees.first_name, ' ', employees.last_name) as name,
round(avg(sales.quantity * products.price)) as average_income 
from employees
inner join sales on employees.employee_id = sales.sales_person_id
inner join products on sales.product_id = products.product_id
group by concat(employees.first_name, ' ', employees.last_name)
having round(avg(sales.quantity * products.price)) < 267166
order by round(avg(sales.quantity * products.price));

-- Отчет с данными по выручке по каждому продавцу и дню недели
select concat(employees.first_name, ' ', employees.last_name) as name, to_char(sales.sale_date, 'Day') as weekday, round(sum(sales.quantity * products.price)) as income
from employees
inner join sales on employees.employee_id = sales.sales_person_id
inner join products on sales.product_id  = products.product_id
group by concat(employees.first_name, ' ', employees.last_name), to_char(sales.sale_date, 'Day')
order by to_char(sales.sale_date, 'Day');

-- Данный запрос формирует отчет по возрастным группам
-- Я использовал условную конструкцию CASE для группировки
select
case 
	when customers.age between 16 and 25 then '16-25'
	when customers.age between 25 and 40 then '26-40'
	else '40+'
end as age_category, count(*) as count 
from customers
group by age_category
order by age_category;

-- Данный запрос формирует отчет о количестве уникальных покупателей и выручке
-- Для вывода даты в требуемом формате я использовал функцию TO_CHAR и шаблон формата 'YYYY-MM'
select to_char(sales.sale_date, 'YYYY-MM') as date, count(customer_id) as total_customers, round(sum(sales.quantity * products.price)) as income
from sales
inner join products on sales.product_id = products.product_id
group by to_char(sales.sale_date, 'YYYY-MM')
order by to_char(sales.sale_date, 'YYYY-MM');

-- Данный запрос формирует отчет о покупателях, первая покупка которых была в ходе проведения акций
select concat(customers.first_name, ' ', customers.last_name) as customer, 
min(sales.sale_date) as sale_date, 
concat(employees.first_name, ' ', employees.last_name) as seller
from customers
inner join sales on customers.customer_id = sales.customer_id 
inner join employees on sales.sales_person_id = employees.employee_id
inner join products on sales.product_id = products.product_id
group by concat(customers.first_name, ' ', customers.last_name), concat(employees.first_name, ' ', employees.last_name)
having sum(products.price) = 0;
