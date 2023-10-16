/*  Задания.
    1) Найдите дубликаты по полю email в таблице employees 
    (добавьте для теста парочку существующих адресов).
    2) Вытащить текст между двумя разделителями 'unstructured;text;format'
    (длина текста может быть любой).
*/
/* 2) результат:
INSERT INTO temp1 VALUES ('unstructured;text;format');
INSERT INTO temp1 VALUES ('unstructured123;again text;123format123');
----------------------------------------
First_word       Second_word  Third_word
---------------  -----------  ----------
unstructured     text         format
unstructured123  again text   123format123
*/

	/*----1----*/
	
	insert into employees(firstname, lastname, email)
	values('Jack', 'the Handsome', 'andrew.adams@chinookcorp.com');
	
	insert into employees(firstname, lastname, email)
	values('Jack', 'the Handsome', 'andrew.adams@chinookcorp.com');
	
	insert into employees(firstname, lastname, email)
	values('Jack', 'the Handsome', 'nancy.vasileva@chinookcorp.com');
	
	select email, count(*) as dupes,
		group_concat(employeeid)
	from employees
	where email in (
		select email
		from employees
		group by email
		having (count(*) > 1)
	)
	group by email;
	
	/*----2----*/
	
	create table temp (
	words_id integer primary key autoincrement not null,
	words text
	);
	
	create table temp1 (
	words_id integer primary key autoincrement not null,
	first_word text,
	second_word text,
	third_word text
	);
	
	insert into temp (words)
	values('unstructured123;again text;123format123');
	
	insert into temp1 (first_word)
	values(
	(select
		substr(words, 1, instr(words, ';') - 1)
	from temp
	where words_id == last_insert_rowid())
	);
	
	update temp1
	set second_word =
	(select
		substr(words, length((select first_word from temp1 where words_id == last_insert_rowid())) + 2,
		instr(substr(words, length((select first_word from temp1 where words_id == last_insert_rowid())) + 2), ';') - 1)
	from temp
	where words_id == last_insert_rowid())
	where words_id == last_insert_rowid();
	
		
	update temp1
	set third_word =
	(select
		substr(words, length((select first_word from temp1 where words_id == last_insert_rowid())) + length((select second_word from temp1 where words_id == last_insert_rowid())) + 3,
		length(words) - (length((select first_word from temp1 where words_id == last_insert_rowid())) + length((select second_word from temp1 where words_id == last_insert_rowid())) + 2))
		from temp
		where words_id == last_insert_rowid())
	where words_id == last_insert_rowid();	
	
	insert into temp (words)
	values('unstructured;text;format');