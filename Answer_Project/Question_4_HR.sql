
WITH ventes AS (
		SELECT CONCAT(e.firstName,' ' , e.lastName) AS Seller
			,SUM(od.quantityOrdered * od.priceEach) AS Chiffres
			,MONTHNAME(o.orderDate) AS Mois
			,YEAR(o.orderDate) AS Année
			,ROW_NUMBER() OVER (PARTITION BY YEAR(o.orderDate),MONTHNAME(o.orderDate) ORDER BY SUM(od.quantityOrdered * od.priceEach) DESC) AS Classement
		FROM orders o
		INNER JOIN orderdetails od
			ON o.orderNumber = od.orderNumber
		INNER JOIN customers c
			ON o.customerNumber = c.customerNumber 
		INNER JOIN employees e
			ON c.salesRepEmployeeNumber = e.employeeNumber 
		WHERE o.status LIKE 'Shipped'
			OR o.status LIKE 'Resolved'
		GROUP BY Seller, MONTH(o.orderDate),YEAR(o.orderDate)
		ORDER BY YEAR(o.orderDate) ASC,MONTH(o.orderDate)ASC,Chiffres DESC
		)
SELECT Seller
	,Chiffres
	,Mois
	,Année
	,Classement
FROM ventes
WHERE Classement <=2;
