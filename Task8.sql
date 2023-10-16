/*  Задание с использованием оконных функций:
    1) Выдайте id альбома, имя исполнителя и название альбома, а также количество
       проданных треков с этого альбома. Отсортируйте исполнителей 
       в порядке убывания количества продаж, а внутри - по имени исполнителя и альбому.
AlbumId  Name           Title           Track_sold
-------  -------------  --------------  ----------
23       Chico Buarque  Minha Historia  27        
141      Lenny Kravitz  Greatest Hits   26        
73       Eric Clapton   Unplugged       25        
224      Titãs          Acústico        22        
37       Kiss           Greatest Kiss   20   
    2) Для каждого альбома найдите его ранг, рассчитанный по количеству 
    проданных треков с этого альбома (1-ый ранг соответствует максимальным продажам).
    Выдайте id альбома, имя исполнителя, название альбома, количество проданных треков
    и ранг. Отсортируйте в порядке убывания рангов.
AlbumId  Name                    Title                          Track_sold  Album_rank
-------  ----------------------  -----------------------------  ----------  ----------
50       Deep Purple             The Final Concerts (Disc 2)    1           266       
170      Ozzy Osbourne           Bark at the Moon (Remastered)  1           266       
171      Ozzy Osbourne           Blizzard of Ozz                1           266       
252      Dread Zeppelin          Un-Led-Ed                      1           266       
263      Habib Koité and Bamada  Muso Ko                        1           266   
*/


	/*----1----*/
	
	select distinct
			tmp2.albumid as albumid,
			artists_albums.name as artist_name,
			artists_albums.title as album_title,
			tmp2.sum_purc_album as sum_purc_album		
	from
		(select
			tmp1.id as id,
			tracks.albumid as albumid,
			(count(tmp1.sum_purc_track) over (partition by albumid)) as sum_purc_album		
		from
			(select
				trackid as id,
				(count(unitprice) over (partition by trackid)) as sum_purc_track
			from invoice_items) as tmp1
		inner join tracks on tmp1.id == tracks.trackid) as tmp2
	inner join artists_albums on tmp2.albumid == artists_albums.albumid
	order by sum_purc_album desc, artist_name and album_title;
	
	/*----2----*/
	
	select 
				tmp3.albumid as albumid,
				tmp3.artist_name as artist_name,
				tmp3.album_title as album_title,
				tmp3.sum_purc_album as sum_purc_album,
				rank() over(partition by tmp3.max_purc order by sum_purc_album desc) as rank_kk
	from
		(select distinct
				tmp2.albumid as albumid,
				artists_albums.name as artist_name,
				artists_albums.title as album_title,
				tmp2.sum_purc_album as sum_purc_album,
				max(tmp2.sum_purc_album) over() as max_purc
		from
			(select
				tmp1.id as id,
				tracks.albumid as albumid,
				(count(tmp1.sum_purc_track) over (partition by albumid)) as sum_purc_album		
			from
				(select
					trackid as id,
					(count(unitprice) over (partition by trackid)) as sum_purc_track
				from invoice_items) as tmp1
			inner join tracks on tmp1.id == tracks.trackid) as tmp2
		inner join artists_albums on tmp2.albumid == artists_albums.albumid
		order by sum_purc_album desc, artist_name and album_title) as tmp3
	order by rank_kk desc, artist_name and album_title;