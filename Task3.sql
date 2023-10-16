/*
1) Перечислите названия альбомов группы Queen. 
2) Выведите названия треков в формате AAC audio file и названия альбомов с исполнителями (Artist), откуда эти треки.
3) Выведите наименования и исполнителей треков (Composer) из плейлиста Heavy Metal Classic.
4) Кто купил трек Angel в исполнении группы Aerosmith (Steven Tyler)? 
   Выведите имя, фамилию, страну и город покупателей.
*/

	/*----1----*/
	
	SELECT artists.name,
		GROUP_CONCAT(albums.title)
	FROM albums
	INNER JOIN artists ON albums.artistid == artists.artistid
	WHERE artists.name == 'Queen';
	
	/*----2----*/
	
	SELECT tracks.name,
		albums.title,
		artists.name,
		media_types.name
	FROM tracks
	INNER JOIN media_types ON tracks.mediatypeid = media_types.mediatypeid
		AND media_types.name == 'AAC audio file'
	INNER JOIN albums ON tracks.albumid == albums.albumid
	INNER JOIN artists ON albums.artistid == artists.artistid;
	
	/*----3----*/
	
	SELECT tracks.name,
		tracks.composer,
		playlists.name
	FROM playlist_track
	INNER JOIN playlists ON playlists.playlistid == playlist_track.playlistid
	INNER JOIN tracks ON tracks.trackid == playlist_track.trackid
	WHERE playlists.name == 'Heavy Metal Classic';
	
	/*----4----*/
	
	SELECT customers.firstname,
		customers.lastname,
		customers.country,
		customers.city,
		tracks.name
	FROM invoice_items
	INNER JOIN invoices ON invoices.invoiceid == invoice_items.invoiceid
	INNER JOIN customers ON customers.customerid == invoices.customerid
	INNER JOIN tracks ON tracks.trackid == invoice_items.trackid
	INNER JOIN albums ON albums.albumid == tracks.albumid
	INNER JOIN artists ON artists.artistid == albums.artistid
	WHERE tracks.name == 'Angel'
		AND artists.name == 'Aerosmith';
	
