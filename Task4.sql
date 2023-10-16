/*  Задание. Из таблицы tracks вывести список исполнителей. 
    Для каждого указать количество треков и долю в общем количестве треков (в процентах). 
    Отсортировать по доле по убыванию. Не учитывать NULL исполнителей.
    Результат (852 строки):
--------------------------------------
Исполнитель	Количество	Доля
--------------------------------------
Steve Harris	80		3.1683
U2		44		1.7426
Jagger/Richards	35		1.3861
Billy Corgan	31		1.2277
Kurt Cobain	26		1.0297
Bill Berry-P...	25		0.9901
The Tea Party	24		0.9505
Miles Davis	23		0.9109
Gilberto Gil	23		0.9109
Chris Cornell	23		0.9109
Chico Science	23		0.9109
*/

	/*----1----*/
	
	SELECT DISTINCT composer,
		COUNT(trackid) AS tracks_sum,
		ROUND (COUNT(trackid) * 100.0 /
			(SELECT COUNT(*)
				FROM tracks)
			, 3) AS percent_share
	FROM tracks
	WHERE tracks.composer IS NOT NULL
	GROUP BY composer
	ORDER BY percent_share DESC;