/** 
Creating the tables designed on our ER DIAGRAM
Table 1. customer_bio: This would contain the customers' IDs and countries. The customer's ID being the primary code.
Table 2. invoice: This wwould contain the invoice details (invoice number, stockcode, customerID, quantity and status of the invoice)
Table 3. Inventory: This would contain the inventory details (stockcode, description, and unitprice)
**/

CREATE TABLE customer_bio (
    customerID INT,
    country VARCHAR(45)
);

CREATE TABLE invoice (
    invoiceNo VARCHAR(20),
    stockCode VARCHAR(20),
    customerID INT,
    quantiy INT,
    invoiceDate DATE,
    invoice_status VARCHAR(20)
);

CREATE TABLE inventory (
    stockCode VARCHAR(20),
    stock_description VARCHAR(200),
    unitPrice FLOAT
);

/** 
We now create a temporary table to import the data from the excel sheet.
The sheet is first of all, conversted to a CSV file and then imported.
The temporary table will be called temp_table 
**/

CREATE TEMPORARY TABLE temp_table (
    invoiceNo VARCHAR,
    stockCode VARCHAR,
    stockDescription VARCHAR,
    quantity INT,
    invoiceDate DATE,
    unitPrice FLOAT,
    customerID INT,
    country VARCHAR
);

COPY temp_table FROM '/Users/Shared/Data_set_Online Retail.csv' DELIMITER ',' CSV HEADER

select * from temp_table

/** Temp table created.
We fill all the null values under customerID with "0000.
We do this to satisfy the "no null" rule for Primary Keys"
We now proceed to importing the data to the created tables
**/

UPDATE temp_table
SET customerID = 00000
WHERE customerID IS NULL

select count(*) from temp_table
where customerID = 00000

/**  135080 entries have no customerID
Now that all the null values for customerID is filled, 
we now proceed to fill in import the data to the previously created tables
**/

INSERT INTO customer_bio
    SELECT * from dist

--- Data entered into the customer_bio table
---
drop table inventory

INSERT INTO inventory 
    SELECT DISTINCT stockCode, stockDescription, unitprice
    FROM temp_table
-- The distint key word was used to import data into the table.
-- The distinct key eliminated duplicate rows and ensures only unique rows are entered.

INSERT INTO invoice
    SELECT DISTINCT invoiceNo, stockcode, customerID, quantity, invoiceDate
    FROM temp_table


select customerid, invoiceno, stockcode, unitprice
from customer_bio
join invoice using(customerid)
join inventory using(stockCode)
where customerID = 0


select invoiceNo,stockcode, stock_description from inventory
join invoice using(stockcode)
where unitprice != 0


/** Things noticed soo far,
Entries with UNIT price of 0 will be classified as Unsuccessful.
Entries with C at the beginning of the Invoice number will be classified as Cancelled
All others will be classified as successful.