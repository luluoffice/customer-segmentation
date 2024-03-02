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
where quantity < 0

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
-- CREATING VIEW FOR MONTHLY REVENUE --
CREATE VIEW monthly_revenue AS (
    SELECT to_char(invoicedate, 'Month') as "Month", ROUND(SUM(amount)) as "Revenue"
        FROM (
            SELECT e.invoicedate, f.unitprice * e.quantity as amount
            FROM invoice as e
            JOIN inventory as f USING(stockcode)
            WHERE invoice_status = 'Successful'
            )
    GROUP BY to_char(invoicedate, 'Month')
);

select * from monthly_revenue
---- VIEW FOR MONTHLY REVENUE_ACROSS ALL TIME CREATED ---

CREATE VIEW monthly_revenue_all AS (
    SELECT to_char(invoicedate, 'Month') as "Month", ROUND(SUM(amount)) as "Revenue"
        FROM (
            SELECT e.invoicedate, f.unitprice * e.quantity as amount
            FROM invoice as e
            JOIN inventory as f USING(stockcode)
            WHERE invoice_status = 'Successful'
            )
    GROUP BY to_char(invoicedate, 'Month')
);

select * from monthly_revenue_all

-- VIEW CREATED 

---- VIEW FOR MONTHLY REVENUE_PER YEAR---
--- 2011 ----
CREATE VIEW monthly_revenue_2011 AS (
    SELECT to_char(invoicedate, 'Month') as "Month", ROUND(SUM(amount)) as "Revenue"
        FROM (
            SELECT e.invoicedate, f.unitprice * e.quantity as amount
            FROM invoice as e
            JOIN inventory as f USING(stockcode)
            WHERE invoice_status = 'Successful'
            ) as a
    WHERE EXTRACT (YEAR FROM a.invoicedate) = 2011
    GROUP BY to_char(invoicedate, 'Month')
);

select * from monthly_revenue_2011

-- VIEW CREATED 

---- VIEW FOR MONTHLY REVENUE_PER YEAR---
--- 2010 ----
CREATE VIEW monthly_revenue_2010 AS (
    SELECT to_char(invoicedate, 'Month') as "Month", ROUND(SUM(amount)) as "Revenue"
        FROM (
            SELECT e.invoicedate, f.unitprice * e.quantity as amount
            FROM invoice as e
            JOIN inventory as f USING(stockcode)
            WHERE invoice_status = 'Successful'
            ) as a
    WHERE EXTRACT (YEAR FROM a.invoicedate) = 2010
    GROUP BY to_char(invoicedate, 'Month')
);

select * from monthly_revenue_2010

----- REVENUE PER MONTH --------


CREATE VIEW lost_revenue_per_year AS (
    SELECT to_char(invoicedate, 'YYYY') as "Year", ROUND(SUM(amount)) as "Revenue"
        FROM (
            SELECT e.invoicedate, f.unitprice * e.quantity as amount
            FROM invoice as e
            JOIN inventory as f USING(stockcode)
            WHERE invoice_status = 'Cancelled'
            ) as a
    GROUP BY to_char(invoicedate, 'YYYY')
);

select * from lost_revenue_per_year

CREATE VIEW lost_revenue_2011_monthly AS (
    SELECT to_char(invoicedate, 'Month') as "Month", ROUND(SUM(amount)) as "Revenue"
        FROM (
            SELECT e.invoicedate, f.unitprice * e.quantity as amount
            FROM invoice as e
            JOIN inventory as f USING(stockcode)
            WHERE invoice_status = 'Cancelled'
            ) as a
    WHERE EXTRACT (YEAR FROM a.invoicedate) = 2011
    GROUP BY to_char(invoicedate, 'Month')
);

--Top 15 most purchased items (using the stock code and filtering by the invoice_status)
2010

select stockcode, sum(sum_sum) as "total_total",b.stock_description
FROM(
    select stockcode, quantity as "sum_sum"
    from invoice
    WHERE to_char(invoicedate,'YYYY') = '2010' AND invoice_status = 'Successful')
JOIN inventory as b USING (stockcode)
GROUP BY stockcode, b.stock_description
ORDER BY total_total DESC
LIMIT 15

--Top 15 most purchased items (using the stock code and filtering by the invoice_status)
2011

select stockcode, sum(sum_sum) as "total_total",b.stock_description
FROM(
    select stockcode, quantity as "sum_sum"
    from invoice
    WHERE to_char(invoicedate,'YYYY') = '2011' AND invoice_status = 'Successful')
JOIN inventory as b USING (stockcode)
GROUP BY stockcode, b.stock_description
ORDER BY total_total DESC
LIMIT 15

--Top 15 most purchased items (using the stock code and filtering by the invoice_status)
-- All time

select stockcode, sum(sum_sum) as "total_total",b.stock_description
FROM(
    select stockcode, quantity as "sum_sum"
    from invoice
    WHERE invoice_status = 'Successful')
JOIN inventory as b USING (stockcode)
GROUP BY stockcode, b.stock_description
ORDER BY total_total DESC
LIMIT 15

--- Finding the top spending customers for all time.

select customerid, ROUND(sum(sub_total)) as "revenue"
FROM (
    select a.customerid, a.stockcode, a.quantity, a.quantity * b.unitprice as "sub_total"
    from invoice as a
    join inventory as b using (stockcode)
    WHERE invoice_status = 'Successful')
GROUP BY customerid
ORDER BY revenue DESC


--- Finding the top spending customers for 2010

select customerid, ROUND(sum(sub_total)) as "revenue"
FROM (
    select a.customerid, a.stockcode, a.quantity, a.quantity * b.unitprice as "sub_total"
    from invoice as a
    join inventory as b using (stockcode)
    WHERE invoice_status = 'Successful' AND to_char(invoicedate, 'YYYY'):: INT = 2010)
GROUP BY customerid
ORDER BY revenue DESC

--- Finding the top spending customers for 2011

select customerid, ROUND(sum(sub_total)) as "revenue"
FROM (
    select a.customerid, a.stockcode, a.quantity, a.quantity * b.unitprice as "sub_total"
    from invoice as a
    join inventory as b using (stockcode)
    WHERE invoice_status = 'Successful' AND to_char(invoicedate, 'YYYY'):: INT = 2011)
GROUP BY customerid
ORDER BY revenue DESC

-- Total number of successful and cancelled invoices.

select invoice_status, count(*)
from invoice
GROUP BY invoice_status