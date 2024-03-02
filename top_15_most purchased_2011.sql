CREATE VIEW top_15_purchased_item_2011 AS
select stockcode, sum(sum_sum) as "total_total",b.stock_description
FROM(
    select stockcode, quantity as "sum_sum"
    from invoice
    WHERE to_char(invoicedate,'YYYY') = '2011' AND invoice_status = 'Successful')
JOIN inventory as b USING (stockcode)
GROUP BY stockcode, b.stock_description
ORDER BY total_total DESC
LIMIT 15