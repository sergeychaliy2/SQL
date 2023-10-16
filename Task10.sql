/* Задание. Имеется таблица со списком товаров:
   Products (id_product, price, quantity),
   таблица заказов:
   Orders (id_order, id_product, total),
   где total - сумма заказа (в рублях),
   и таблица со счетами:
   Invoices (id_order, id_product, num_order, sum_order, return, date),
   где num_order - количество покупаемого товара,
   sum_order - на какую сумму товар покупается,
   return - остаток (total - price * num_order)
   В заказе только один товар.
   При поступлении заказа делаем запись в таблице Orders.
   В таблице Products уменьшаем поле quantity на максимальное количество
   товара, которое можно продать на сумму заказа. 
   В таблицу Invoices записываем все данные о заказе. 
*/

	/*----1----*/
	
	create table products (
	id_product integer primary key autoincrement not null,
	price numeric(10,2) not null,
	quantity integer,
	check(quantity >= 0)
	);
	
	create table orders (
	id_order integer primary key autoincrement not null,
	id_product integer not null,
	total numeric(10,2) not null
	);
	
	create table invoices (
	id_order integer not null,
	id_product integer not null,
	num_order integer not null,
	sum_order numeric(10,2) not null,
	return numeric(10,2),
	date datetime not null
	);
	
	insert into products(price, quantity)
	values(8.00, 100);
		
	begin transaction;
	
	insert into orders(id_product, total)
	values(1, 100.00);
	
	update products
	set quantity == quantity - floor((select total from orders where id_order == (select last_insert_rowid())) / (select price from products where id_product == (select id_product from orders where id_order == (select last_insert_rowid()))))
	where id_product == (select id_product from orders where id_order == (select last_insert_rowid()));
	
	insert into invoices(id_order, id_product, num_order, sum_order, return, date)
	values((select last_insert_rowid()),
	(select id_product from orders where id_order == (select last_insert_rowid())),
	floor((select total from orders where id_order == (select last_insert_rowid())) / (select price from products where id_product == (select id_product from orders where id_order == (select last_insert_rowid())))),
	(select total from orders where id_order == (select last_insert_rowid())),
	((select total from orders where id_order == (select last_insert_rowid())) - (select price from products where id_product == (select id_product from orders where id_order == (select last_insert_rowid()))) * floor((select total from orders where id_order == (select last_insert_rowid())) / (select price from products where id_product == (select id_product from orders where id_order == (select last_insert_rowid()))))),
	(select date('now')));
	
	commit;