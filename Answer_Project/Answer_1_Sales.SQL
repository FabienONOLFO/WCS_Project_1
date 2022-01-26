# Query - The number of products sold by category and by month, with comparison and rate of change compared to the same month of the previous year.

WITH cte AS (
		SELECT p.productLine AS Catégories
			,(o.orderDate) AS Mois
            ,YEAR(o.orderDate) AS Annee
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
    ,Annee
	,Sales_1N
	,Sales_N
	,ROUND(100*(Sales_N - Sales_1N)/(CASE WHEN Sales_1N = 0 THEN 100 ELSE Sales_1N END),1) AS "Rate_N_%"  # Permets de créer un % avec un arondissement à la décimale .
FROM cte
