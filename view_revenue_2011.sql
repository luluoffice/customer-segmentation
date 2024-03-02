CREATE VIEW monthly_revenue_2011 AS (
    SELECT to_char(invoicedate, 'Month') as "Month", ROUND(SUM(amount)) as "Revenue"
        FROM (
            SELECT e.invoicedate, f.unitprice * e.quantity as amount
            FROM invoice as e
            JOIN inventory as f USING(stockcode)
            WHERE invoice_status = 'Successful'
            ) as a
    WHERE cast(to_char (a.invoicedate, 'YYYY')) as INT = 2011
    GROUP BY to_char(invoicedate, 'Month')