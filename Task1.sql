/*
1) Из каких стран покупатели? Выведите список стран без повторений в алфавитном порядке.  
2) Выведите покупателей из Бразилии. Указать имя и фамилию. Отсортировать по фамилии.
3) У какого города почтовый индекс 11230? 
4) Выведите всех покупателей с почтой gmail. Указать имя, фамилию и почту.
5) Выведите имя, фамилию и компанию корпоративных покупателей, отсортированных по наименованию компании.
6) Выведите имя, фамилию, город и страну всех европейских покупателей. Отсортируйте по стране, внутри - по городу, внутри города - по фамилии.
*/

	/*----1----*/
	
	SELECT DISTINCT country
	FROM customers
	ORDER BY country ASC;
	
	/*----2----*/

	SELECT FirstName,
		LastName
	FROM customers
	WHERE country = 'Brazil'
	ORDER BY LastName;
	
	/*----3----*/

	SELECT City
	FROM customers
	WHERE PostalCode = '11230';
	
	/*----4----*/

	SELECT FirstName,
		LastName,
		Email
	FROM customers
	WHERE Email LIKE '%gmail%';
	
	/*----5----*/

	SELECT FirstName,
		LastName,
		Company
	FROM customers
	WHERE Company IS NOT NULL
	ORDER BY Company;
	
	/*----6----*/

	SELECT FirstName,
		LastName,
		City,
		Country
	FROM customers
	WHERE Country IN
		('Austria',
		'Albania',
		'Andorra',
		'Belarus',
		'Belgium',
		'Bulgaria',
		'Bosnia and Herzegovina',
		'Vatican',
		'Hungary',
		'Germany',
		'Greece',
		'Denmark',
		'Ireland',
		'Iceland',
		'Spain',
		'Italy',
		'Kosovo',
		'Latvia',
		'Lithuania',
		'Liechtenstein',
		'Luxembourg',
		'Macedonia',
		'Malta',
		'Moldova',
		'Monaco',
		'Netherlands',
		'Norway',
		'Poland',
		'Portugal',
		'Romania',
		'San-Marino',
		'Serbia',
		'Slovakia',
		'Slovenia',
		'Finland',
		'France',
		'Croatia',
		'Montenegro',
		'Czech Republic',
		'Switzerland',
		'Sweden',
		'Estonia')
	ORDER BY Country,
		City,
		LastName;