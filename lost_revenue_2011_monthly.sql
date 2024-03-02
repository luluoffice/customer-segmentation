CREATE VIEW lost_revenue_2011_monthly AS (
    SELECT to_char(invoicedate, 'Month') as "Month", ROUND(SUM(amount)) as "Revenue"
        FROM (
            SELECT e.invoicedate, f.unitprice * e.quantity as amount
            FROM invoice as e
            JOIN inventory as f USING(stockcode)
            WHERE invoice_status = 'Cancelled'
            ) as a
    WHERE to_char (a.invoicedate, 'YYYY') = '2011'
    GROUP BY to_char(invoicedate, 'Month')
);