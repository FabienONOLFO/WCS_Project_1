--- Query to group Each month, the 2 sellers with the highest turnover by months by years.
--- via a temporary table named sale

WITH ventes AS (
		SELECT CONCAT(e.firstName,' ' , e.lastName) AS Seller
			,SUM(od.quantityOrdered * od.priceEach) AS Chiffres
			,(o.orderDate) AS Mois
			,YEAR(o.orderDate) AS Annee
			,ROW_NUMBER() OVER (PARTITION BY YEAR(o.orderDate),MONTHNAME(o.orderDate) ORDER BY SUM(od.quantityOrdered * od.priceEach) DESC) AS Classement
		FROM orders o
		INNER JOIN orderdetails od
			ON o.orderNumber = od.orderNumber
		INNER JOIN customers c
			ON o.customerNumber = c.customerNumber 
		INNER JOIN employees e
			ON c.salesRepEmployeeNumber = e.employeeNumber 
		WHERE o.status LIKE 'Shipped'  # Nous récupérons uniquement les commandes dont le statut est envoyé ou résolu
			OR o.status LIKE 'Resolved'
		GROUP BY Seller, MONTH(o.orderDate),YEAR(o.orderDate)
		ORDER BY YEAR(o.orderDate) ASC,MONTH(o.orderDate)ASC,Chiffres DESC
		)
SELECT Seller
	,Chiffres
	,Mois
	,Annee
	,Classement
FROM ventes
WHERE Classement <=2	#On rappelle la fonction ROW NUMBER en n'affichant que les deux premières lignes
