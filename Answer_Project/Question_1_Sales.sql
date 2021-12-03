WITH cte AS (
		SELECT p.productLine AS Catégories
			,MONTHNAME(o.orderDate) AS Mois
			,SUM(CASE WHEN YEAR(o.orderDate) LIKE '2019%' AND (o.status LIKE 'Shipped' or o.status LIKE 'Resolved') THEN (od.quantityOrdered) ELSE 0 END) AS Sales_2N
			,SUM(CASE WHEN YEAR(o.orderDate) LIKE '2020%' AND (o.status LIKE 'Shipped' or o.status LIKE 'Resolved') THEN (od.quantityOrdered) ELSE 0 END) AS Sales_1N
			,SUM(CASE WHEN YEAR(o.orderDate) LIKE '2021%' AND (o.status LIKE 'Shipped' or o.status LIKE 'Resolved') THEN (od.quantityOrdered) ELSE 0 END) AS Sales_N
		FROM orderdetails od
		INNER JOIN products p
			ON od.productCode = p.productCode
		INNER JOIN orders o
			ON od.orderNumber = o.orderNumber
		GROUP BY p.productLine, MONTH(o.orderDate)
		ORDER BY MONTH(o.orderDate), p.productLine
			)
SELECT Catégories
	,Mois
	,Sales_2N
	,Sales_1N
	,ROUND(100*(Sales_1N - Sales_2N)/(CASE WHEN Sales_2N = 0 THEN 100 ELSE Sales_2N END),1) AS "Rate_1N_%" 
	,Sales_N
	,ROUND(100*(Sales_N - Sales_1N)/(CASE WHEN Sales_1N = 0 THEN 100 ELSE Sales_1N END),1) AS "Rate_N_%" 
FROM cte;