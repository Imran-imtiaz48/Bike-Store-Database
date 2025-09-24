-- Create database
CREATE DATABASE BikeStore;
GO

USE BikeStore;
GO

-- Create logical schemas for better organization
CREATE SCHEMA production;
CREATE SCHEMA sales;
GO

------------------------------------------------
-- Production schema tables
------------------------------------------------
CREATE TABLE production.categories (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE production.brands (
    brand_id INT IDENTITY(1,1) PRIMARY KEY,
    brand_name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE production.products (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    brand_id INT NOT NULL,
    category_id INT NOT NULL,
    model_year SMALLINT NOT NULL CHECK (model_year >= 1900),
    list_price DECIMAL(10,2) NOT NULL CHECK (list_price >= 0),
    FOREIGN KEY (category_id) REFERENCES production.categories (category_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (brand_id) REFERENCES production.brands (brand_id) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

------------------------------------------------
-- Sales schema tables
------------------------------------------------
CREATE TABLE sales.customers (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(25),
    email VARCHAR(255) NOT NULL UNIQUE,
    street VARCHAR(255),
    city VARCHAR(50),
    state VARCHAR(25),
    zip_code VARCHAR(10)
);

CREATE TABLE sales.stores (
    store_id INT IDENTITY(1,1) PRIMARY KEY,
    store_name VARCHAR(255) NOT NULL,
    phone VARCHAR(25),
    email VARCHAR(255) UNIQUE,
    street VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(25),
    zip_code VARCHAR(10)
);

CREATE TABLE sales.staffs (
    staff_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(25),
    active TINYINT NOT NULL CHECK (active IN (0,1)),
    store_id INT NOT NULL,
    manager_id INT NULL,
    FOREIGN KEY (store_id) REFERENCES sales.stores (store_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (manager_id) REFERENCES sales.staffs (staff_id)
);

CREATE TABLE sales.orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    order_status TINYINT NOT NULL CHECK (order_status BETWEEN 1 AND 4),
    -- 1 = Pending, 2 = Processing, 3 = Rejected, 4 = Completed
    order_date DATE NOT NULL,
    required_date DATE NOT NULL,
    shipped_date DATE NULL,
    store_id INT NOT NULL,
    staff_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES sales.customers (customer_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (store_id) REFERENCES sales.stores (store_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES sales.staffs (staff_id)
);

CREATE TABLE sales.order_items (
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    list_price DECIMAL(10,2) NOT NULL CHECK (list_price >= 0),
    discount DECIMAL(4,2) NOT NULL DEFAULT 0 CHECK (discount BETWEEN 0 AND 1),
    PRIMARY KEY (order_id, item_id),
    FOREIGN KEY (order_id) REFERENCES sales.orders (order_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (product_id) REFERENCES production.products (product_id) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE sales.stocks (
    store_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 0 CHECK (quantity >= 0),
    PRIMARY KEY (store_id, product_id),
    FOREIGN KEY (store_id) REFERENCES sales.stores (store_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (product_id) REFERENCES production.products (product_id) 
        ON DELETE CASCADE ON UPDATE CASCADE
);
