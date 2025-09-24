-- Create database
CREATE DATABASE testdb;
GO

USE testdb;
GO

------------------------------------------------
-- Customer master
------------------------------------------------
CREATE TABLE Customer_master (
    Customer_id INT IDENTITY(1,1) PRIMARY KEY,
    Customer_Firstname VARCHAR(150) NOT NULL,
    Customer_Lastname VARCHAR(150),
    Age INT CHECK (Age >= 0 AND Age <= 120),  -- enforce realistic age
    Email VARCHAR(250) UNIQUE NOT NULL,
    Contact VARCHAR(15) NOT NULL UNIQUE        -- changed from INT to VARCHAR
);

------------------------------------------------
-- City master
------------------------------------------------
CREATE TABLE City_Master (
    City_id INT IDENTITY(1,1) PRIMARY KEY,
    City_name VARCHAR(150) NOT NULL UNIQUE
);

------------------------------------------------
-- Address type master
------------------------------------------------
CREATE TABLE Addresstype_Master (
    Addtype_id INT IDENTITY(1,1) PRIMARY KEY,
    Address_type VARCHAR(100) NOT NULL UNIQUE
);

------------------------------------------------
-- Country master
------------------------------------------------
CREATE TABLE Country_Master (
    Country_id INT IDENTITY(1,1) PRIMARY KEY,
    Country_Name VARCHAR(150) NOT NULL UNIQUE
);

------------------------------------------------
-- Customer address info
------------------------------------------------
CREATE TABLE Customer_Address_Info (
    Add_detail_id INT IDENTITY(1,1) PRIMARY KEY,
    Address VARCHAR(500) NOT NULL,
    Addtype_id INT NOT NULL,
    City_id INT NOT NULL,
    Country_id INT NOT NULL,
    Customer_id INT NOT NULL,
    FOREIGN KEY (Addtype_id) REFERENCES Addresstype_Master(Addtype_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (City_id) REFERENCES City_Master(City_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Country_id) REFERENCES Country_Master(Country_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Customer_id) REFERENCES Customer_master(Customer_id) 
        ON DELETE CASCADE ON UPDATE CASCADE
);
