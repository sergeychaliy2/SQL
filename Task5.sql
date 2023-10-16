/*  Задания.
    1) Вывести треки (id, наименование и исполнителя), на которые не было заказов.
    Отсортируйте по id трека. Выполните запрос двумя или более способами.
Результат (1519 строк):
------------------------------------------------------------
TrackId	Name				Composer
------------------------------------------------------------
7	Let's Get It Up		Angus Young, Malcolm Young, Brian Johnson
11	C.O.D.				Angus Young, Malcolm Young, Brian Johnson
17	Let There Be Rock		AC/DC
18	Bad Boy Boogie		AC/DC
22	Whole Lotta Rosie		AC/DC
23	Walk On Water		Steven Tyler, Joe Perry, Jack Blades, Tommy Shaw
27	Dude (Looks Like A Lady)	Steven Tyler, Joe Perry, Desmond Child
29	Cryin'				Steven Tyler, Joe Perry, Taylor Rhodes
-------------------------------------------------------------   
    2) Найдите наиболее покупаемые треки в Канаде. 
    Выведите наименование, исполнителей и количество покупок только тех треков, которые хоть раз покупались.
    Отсортируйте по количеству покупок по убыванию, внутри - по исполнителю (null в конце группы),
    внутри исполнителя - по наименованию трека.
Результат (302 строки):
-------------------------------------------------------------------------
name			composer				purchases
-------------------------------------------------------------------------
Plaster Caster	Gene Simmons					2
Turbo Lover		NULL						2
Overdose		AC/DC						1
Shock Me		Ace Frehley					1
Crumbs From Your Table	Adam Clayton, Bono, Larry Mullen & The Edge	1
Love And Peace Or Else	Adam Clayton, Bono, Larry Mullen & The Edge	1
Moonchild		Adrian Smith; Bruce Dickinson			1
Can I Play With Madness	Adrian Smith; Bruce Dickinson; Steve Harris	1
--------------------------------------------------------------------------    
    3) Отнесите каждый трек к одной из трех категорий 
    в зависимости от его продолжительности: 
	менее 3 минут, 
	от 3 до 7 минут (включительно два раза) 
	и более 7 минут.
    Посчитайте количество треков 
    и среднюю продолжительность трека в каждой категории в минутах.
Результат:
---------------------------------------
category	quantity	avg_dur
---------------------------------------
0-3 min	480		1.75
3-7 min	2670		4.03
> 7 min	353		27.24
---------------------------------------
*/

	/*----1----*/
	
	SELECT trackid,
		name,
		composer
	FROM tracks
	LEFT JOIN invoice_items USING (trackid)
	WHERE invoiceid IS NULL  
	ORDER BY trackid;

	SELECT trackid,
			name,
			composer
	FROM tracks
	EXCEPT 
		SELECT DISTINCT trackid,
			name,
			composer
		FROM invoice_items
		INNER JOIN tracks USING (trackid)
	ORDER BY trackid;
	
	/*----2----*/
	
	SELECT name,
		composer,
		count(trackid) as purchases
	FROM tracks
	INNER JOIN invoice_items USING (trackid)
	INNER JOIN invoices USING (invoiceid)
	GROUP BY billingcountry, trackid
	HAVING billingcountry = 'Canada'
	ORDER BY purchases DESC, composer NULLS LAST, Name;
	
	/*----3----*/
	
	SELECT
		IIF(milliseconds < 180000, '0-3 min',
			IIF(milliseconds >= 180000 AND milliseconds <= 420000, '3-7 min', '> 7 min'))
			category,
		COUNT (trackid),
        ROUND((AVG(milliseconds) / 60000),2) AS avg_dur
	FROM tracks
	GROUP BY category;