/*
1) Сколько покупателей из каждой страны? Отсортируйте страны в порядке убывания покупателей.
2) Для тех стран, у которых покупатели больше чем из одного города, перечислите эти города через зяпятую.  
3) Покупатели из скольких штатов представлены в таблице? Выведите одну цифру.
4) Укажите для стран, которые делятся на штаты (это Австралия, Бразилия и США), количество представленных покупателями штатов.
   Отсортируйте страны в порядке увеличения количества штатов.
5) Сколько покупателей всего и сколько из них не указало компанию. Выведите две цифры.
*/

	/*----1----*/

	SELECT Country,
		COUNT(CustomerId) AS cust_count
	FROM Customers
	GROUP BY Country
	ORDER BY cust_count DESC;
	
	/*----2----*/
	
	SELECT country,
		GROUP_CONCAT(DISTINCT city)
	FROM customers
	GROUP BY country
	HAVING count(DISTINCT city) > 1;
	
	/*----3----*/
	
	SELECT count(DISTINCT state)
	FROM customers;
	
	/*----4----*/
	
	SELECT Country,
		count(DISTINCT State) AS state_count
	FROM customers
	Where Country in
		('Australia',
		'Brazil',
		'USA') 
	GROUP BY Country
	ORDER BY state_count DESC;
	
	/*----5----*/	
	
	SELECT count(customerId),
		(SELECT count(customerId)
		FROM customers
		WHERE Company IS NULL)
	FROM customers;