CREATE VIEW top_spending_customers_all_time AS
select customerid, ROUND(sum(sub_total)) as "revenue"
FROM (
    select a.customerid, a.stockcode, a.quantity, a.quantity * b.unitprice as "sub_total"
    from invoice as a
    join inventory as b using (stockcode)
    WHERE invoice_status = 'Successful')
GROUP BY customerid
ORDER BY revenue DESC;