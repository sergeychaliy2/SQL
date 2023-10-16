/*  Задание с использованием оконных функций:
    1) Для каждого покупателя найдите темп прироста его покупок (в долларах) по годам. 
    Темп прироста (в %) = 100*(покупки в текущем году - покупки в прошлом году)/покупки в прошлом году.
    Отсортируйте по id покупателя, а внутри - по году покупок.
Id  Year  Summa  Rate  
--  ----  -----  ------
1   2010  13.88        
1   2011  0.99   -92.87
1   2012  15.84  1500.0
1   2013  8.91   -43.75
2   2009  24.75        
2   2011  11.88  -52.0 
2   2012  0.99   -91.67
3   2010  26.75        
3   2012  5.94   -77.79
3   2013  6.93   16.67 
    2) Для каждой страны укажите список покупателей, общую сумму покупок (в рублях по курсу $1=78 руб.) 
    и фамилию покупателя, который совершил покупки на максимальную сумму.
country		customers				summa_rub	best_customer
----------	------------------------------------	-----------	----------------
Argentina	Diego Gutiérrez				2934.36		Diego Gutiérrez
Australia	Mark Taylor				2934.36		Mark Taylor
Austria		Astrid Gruber				3324.36		Astrid Gruber
Belgium		Daan Peeters				2934.36		Daan Peeters
Brazil		Alexandre Rocha, Eduardo Martins,...	14827.8		Luís Gonçalves
Canada		Robert Brown, Edward Francis,...	23708.88	François Tremblay
Chile		Luis Rojas				3636.36		Luis Rojas
Czech Republic	František Wichterlová, Helena Holý	7038.72		Helena Holý
*/

	/*----1----*/
	
	select tmp1.id,
			tmp1.year,
			tmp1.summa,
			round(100 * (tmp1.summa - tmp1.last_summa) / tmp1.last_summa, 2) as perc
		from (select tmp.id as id,
			tmp.year as year,
			tmp.summa as summa,
			lag(summa) over (partition by id) as last_summa		
			from (select invoices.customerid as id,
				substring(invoices.invoicedate,0,5) as year,
				sum(invoices.total) over (partition by substring(invoices.invoicedate,0,5), invoices.customerid) as summa
				from invoices) as tmp) as tmp1
		group by tmp1.year, tmp1.id
		order by tmp1.id;
		
	/*----2----*/
	
	select distinct tempf.country as country,
		tempf.clients as clients,
		tempf.summa_rub as summa_rub,
		tempf.best_client as best_client	
	from
		(select distinct
			inv_temp2.id as id,
			inv_temp2.country as country,
			inv_temp2.summa_rub as summa_rub,
			inv_temp2.clients as clients,
			lastname as best_client
		from
			(select distinct
				inv_temp.country as country,
				inv_temp.id as id,
				inv_temp.max_client_total as total,
				inv_temp.summa_rub as summa_rub,
				inv_temp.clients as clients
			from
				(select distinct
					tmpstart.country as country,
					customerid as id,
					(sum(total) over(partition by customerid)) as max_client_total,
					(sum(total) over(partition by billingcountry) * 78) as summa_rub,
					tmpstart.clients as clients
				from
					(select distinct country,
						GROUP_CONCAT(lastname) as clients
					from customers
					group by country) as tmpstart
					inner join invoices on invoices.billingcountry == tmpstart.country) as inv_temp
			group by country
			having max(total) == total) as inv_temp2
		inner join customers on customers.customerid == id) as tempf;