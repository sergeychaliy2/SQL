/*	ЗАДАНИЯ
-- 1)
-- Написать триггер, который на ввод новой строки в таблицу bosses выдает ошибку,
-- если введен еще один босс с ролью Prime (он должен быть единственным) 
CREATE TABLE bosses (
    id     INT PRIMARY KEY,
    name   CHAR(20),
    gender CHAR(1) CHECK(gender IN('F','M')),
    role   CHAR(20) CHECK(role IN('Head','Main','Prime'))
);

-- 2) Написать триггер, который при удалении строк из представления
-- tracks_view записывает их в таблицу del_tracks.*/

	/*----1----*/
	
	create trigger check_role_before_insert_boss
	before insert on bosses
	begin
		select
			case
			when new.role is 'Prime' 
			and (select exists (select role from bosses where role == 'Prime'))	
			then
			raise (abort, 'prime roll must be one')
			end;
	end;
	
	insert into bosses (name, gender, role) values ('K', 'M', 'Prime');	
	
	
	/*----2----*/
	
	create table del_tracks as select * from tracks_view where 1 == 0;
	
	create trigger backup
	instead of delete on tracks_view
	begin
		insert into del_tracks(trackid, track, album, format, genre)
		values (old.trackid, old.track, old.album, old.format, old.genre);
		
		delete from tracks
		where trackid == old.trackid;
	end;