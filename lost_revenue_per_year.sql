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