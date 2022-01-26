--- Query - The turnover of the orders of the last two months by country

SELECT o.orderDate
		,datediff(now(),o.orderDate) as 'diffdate',now()
		,sum(distinct od.quantityOrdered*od.priceEach) 'total'
		,c.country
		,c.customerNumber 
FROM orders o
JOIN customers c 
	ON o.customerNumber = c.customerNumber 
JOIN orderdetails od on o.orderNumber = od.orderNumber 
WHERE datediff(now(), o.orderDate ) < 61
GROUP BY c.country 
