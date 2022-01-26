--- Query using a temporary table named "top" grouping the different product codes by year
--- allowing the 5 best sales of the current year to be released

with top as (
		 select p.productCode as p_code,sum(quantityOrdered) as totalquantity, p.productName as p_Name,p.quantityInStock as instock, year(shippedDate) as année
		 ,ROW_NUMBER() over(partition by year(shippedDate) order by sum(quantityOrdered) desc) as classement 
		 from orderdetails as od 
		 inner join products as p on p.productCode=od.productCode
		 inner join orders as o on o.orderNumber=od.orderNumber 
		 group by p_code, année 
		 order by Year(shippedDate), sum(quantityOrdered) desc
		)
select p_code, totalquantity, p_Name, année, instock, (totalquantity/instock)*100 as pourcentage
from top
where classement<= 5
order by année desc, totalquantity desc
limit 5
