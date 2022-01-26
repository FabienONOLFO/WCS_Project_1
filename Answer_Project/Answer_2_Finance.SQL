# Query - The turnover of the orders of the last two months by country

select o.orderDate, datediff(now(), o.orderDate ) as 'diffdate',now(),  sum(distinct od.quantityOrdered*od.priceEach) 'total', c.country, c.customerNumber from orders o
inner join customers c 
	on o.customerNumber = c.customerNumber 
inner join orderdetails od on o.orderNumber = od.orderNumber 
where datediff(now(), o.orderDate ) < 61
group by  c.country 
