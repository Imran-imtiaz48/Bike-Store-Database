USE [Bike Store];
GO

-- Explore reference tables (good for context, but SELECT * is not ideal for production)
-- Instead, select only required columns
SELECT brand_id, brand_name FROM production.brands;
SELECT category_id, category_name FROM production.categories;
SELECT product_id, product_name, brand_id, category_id, list_price FROM production.products;
SELECT store_id, product_id, quantity FROM production.stocks;
SELECT customer_id, first_name, last_name, city, state FROM sales.customers;
SELECT order_id, customer_id, order_date, store_id, staff_id FROM sales.orders;
SELECT order_id, item_id, product_id, quantity, list_price FROM sales.order_items;
SELECT staff_id, first_name, last_name, store_id FROM sales.staffs;
SELECT store_id, store_name, city, state FROM sales.stores;

---------------------------------------------------------------
-- Enhanced query with aggregate functions, joins, and keys
---------------------------------------------------------------
SELECT 
    ord.order_id,
    CONCAT(cus.first_name, ' ', cus.last_name) AS CustomerName,
    cus.city,
    cus.state,
    ord.order_date,
    SUM(ite.quantity) AS TotalUnits,
    SUM(ite.quantity * ite.list_price) AS TotalRevenue,
    pro.product_name,
    cat.category_name,
    sto.store_name,
    CONCAT(sta.first_name, ' ', sta.last_name) AS SalesRep
FROM sales.orders AS ord
INNER JOIN sales.customers AS cus
    ON ord.customer_id = cus.customer_id
INNER JOIN sales.order_items AS ite
    ON ord.order_id = ite.order_id
INNER JOIN production.products AS pro
    ON ite.product_id = pro.product_id
INNER JOIN production.categories AS cat
    ON pro.category_id = cat.category_id
INNER JOIN sales.stores AS sto
    ON ord.store_id = sto.store_id
INNER JOIN sales.staffs AS sta
    ON ord.staff_id = sta.staff_id
GROUP BY 
    ord.order_id,
    CONCAT(cus.first_name, ' ', cus.last_name),
    cus.city,
    cus.state,
    ord.order_date,
    pro.product_name,
    cat.category_name,
    sto.store_name,
    CONCAT(sta.first_name, ' ', sta.last_name)
ORDER BY ord.order_date DESC;
