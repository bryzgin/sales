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
order by operations desc;

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