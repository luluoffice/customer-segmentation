CREATE VIEW `monthly_revenue` AS 
SELECT to_char(invoicedate, 'Year') as xer, sum(amount)
FROM (
    SELECT e.invoicedate, f.unitprice * e.quantity as amount
    FROM invoice as e
    JOIN inventory as f USING(stockcode)
    WHERE invoice_status = 'Successful'
    )
GROUP BY to_char(invoicedate, 'Year');