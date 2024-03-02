CREATE VIEW to_spending_customers_2010 AS
select customerid, ROUND(sum(sub_total)) as "revenue"
FROM (
    select a.customerid, a.stockcode, a.quantity, a.quantity * b.unitprice as "sub_total"
    from invoice as a
    join inventory as b using (stockcode)
    WHERE invoice_status = 'Successful' AND to_char(invoicedate, 'YYYY') = '2010')
GROUP BY customerid
ORDER BY revenue DESC;