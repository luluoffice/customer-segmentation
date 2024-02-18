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
    quantity INT,
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

COPY temp_table FROM '/Users/Shared/Data_set_Online Retail.csv' DELIMITER ',' CSV HEADER --Code for importing data from csv

select * from temp_table


--Inserting the appropriate fields in the table created.

INSERT INTO inventory -- Inentory table.
    SELECT stockCode, stockDescription, unitprice
    FROM temp_table


INSERT INTO invoice -- Invoice taable.
    SELECT invoiceNo, stockcode, customerID, quantity, invoiceDate
    FROM temp_table

INSERT INTO customer_bio -- customer_bio table.
    SELECT customerid, country
    FROM temp_table


select invoiceNo,stockcode, stock_description from inventory
join invoice using(stockcode)
where unitprice != 0


select * from invoice
join inventory using (stockcode)
where unitprice = 0
limit 10

select * from invoice
join inventory using (stockcode)
join customer_bio using (customerid)
where unitprice = 0  and customerid = 0
LIMIT 200


/** Things noticed soo far,
Entries with quantity < 0 will be classified as Cancelled orders.
Entries with C at the beginning of the Invoice number will be classified as Cancelled
All others will be classified as successful.

Invoice numbers with the prefic C can be filtered out using the LIKE function. **/

---------------------------------------------------------------------------------------------
Select invoiceno from invoice
where 
invoiceno LIKE '%C%' = TRUE

-- Classifying the rows based on the information shared above.

UPDATE inv_table
SET invoice_status = (
    CASE
        WHEN unitprice = 0 THEN 'Abandoned'
        WHEN invoiceno LIKE '%C%' = TRUE THEN 'Cancelled'
        ELSE 'Successful'
    END
)

select * from invoice
Limit 10


UPDATE invoice
SET invoice_status = 'Cancelled'
WHERE invoiceno LIKE '%C%' = TRUE



UPDATE invoice
SET invoice_status = 'Abandoned'
WHERE (select unitprice from inventory
            JOIN invoice using (stockcode)
        ) = 0


select * from invoice
LIMIT 10


select * from inventory
where unitprice = 0
LIMIT 10


ALTER table invoice
RENAME unitprie to unitprice

        


SELECT unitprice from invoice
            join inventory using (stockcode)
            where unitprice = 0
LIMIT 10

select a.stockcode, a.invoice_status, p.unitprice from inventory as a
join invoice using (stockcode) as p
limit 10

select * from inventory
where unitprice = 0
limit 10;

select * from invoice
Limit 10;



select a.stockcode, b.unitprice from inventory as a
join invoice as b using (stockcode)
limit 10


INSERT INTO invoice (unitprice) 
SELECT unitprice
FROM table1
WHERE stockcode = table1.stockcode


select * from invoice
limit 10

CREATE VIEW table1 AS
select * from inventory


select * from contact_type
limit 10

drop table invoice

-----------------
To be continued tomorrow--


create view status_update as select stockcode, unitprice from inventory
join invoice using (stockcode)
where unitprice = 0
limit 10

drop view status_update

select * from invoice
limit 10;

select * from inventory
limit 10;

UPDATE invoice
SET invoice_status = 
CASE
    WHEN invoice.unitprice = su.unitprice AND invoice.stockcode = su.stockcode THEN 'Abandoned'
    WHEN invoice.invoiceno LIKE 'C%' = TRUE THEN 'Cancelled'
    ELSE 'Successful'
    END
FROM status_update as su


select * from inventory
join invoice using (stockcode)
where invoice_status = 'Successful'

-- Setting the invoice_status of the invoice table to Cancelled for all invouceno with the C-prefix
update invoice
set invoice_status = 
    CASE 
        WHEN invoiceno LIKE 'C%' = TRUE THEN 'Cancelled'
        ELSE 'Successful'
        END

---- Update successful.

-- Setting the invouce_status on the invoice table to Cancelled for all invoiceNo with quantity < 0 
update invoice
set invoiceno = 'C' || invoiceno
where quantity < 0 AND invoice_status = 'Successful'

-- Update successful.

select * from invoice
where invoice_status = 'Cancelled'
limit 10
-- Confirmation of change.

-- Checking to see if all the invoices have been classified as either Successful or Cancelled.
select invoice_status, count(invoice_status)
from invoice
group by 
--- Confirmed!

--NEXT ANALYSIS--