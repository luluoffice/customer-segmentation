CREATE VIEW top_15_stocks_all_time AS 
select stockcode, sum(sum_sum) as "total_total", b.stock_description
FROM(
    select stockcode, quantity as "sum_sum"
    from invoice
    WHERE invoice_status = 'Successful')
JOIN inventory as b USING (stockcode)
GROUP BY stockcode, b.stock_description
ORDER BY total_total DESC
LIMIT 15;