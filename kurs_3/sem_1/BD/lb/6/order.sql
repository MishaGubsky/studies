######first######

#1##
select count(`заказы`.`ЗаказID`)as 'количество заказов' from `заказы`;

#2##
select count(`заказанотоваров`.`СкладID`) as 'количество товаров',
		sum(`заказанотоваров`.`ЦенаПродажи`)as 'общая стоимость товаров'
		from `заказанотоваров`
		where `заказанотоваров`.`ЗаказID`=5;


#3##
select count(`приходсклад`.`Количество`)as 'количество товара'
			from `приходсклад`
			where `приходсклад`.`СкладID`=4 
					and `приходсклад`.`КодПоставщика`=3;

#4##
select sum(`приходсклад`.`ЦенаПоставки`) as 'общая стоимость'
		from `приходсклад`
		where year(`приходсклад`.`ДатаПоставки`)=2010
					and month(`приходсклад`.`ДатаПоставки`)=2;

#5##
select count(distinct `склад`.`Спецификация`)as 'количество типов мониторов'
			from `склад`
			join `каталогтоваров` on `каталогтоваров`.`КодТовара`=`склад`.`КодТовара` and `каталогтоваров`.`Наименование`='Монитор';

#6##
select count(`заказы`.`ЗаказID`) as 'количество заказов за 2010 г.'
			from `заказы`
			right join `сотрудники` on `сотрудники`.`СотрудникID`=`заказы`.`СотрудникID`
			where year(`заказы`.`ДатаЗаказа`)=2010;
#7##
select `клиенты`.`Менеджер`,
			count(`заказы`.`ЗаказID`) as 'количество заказов'
			from `заказы`
			right join `клиенты` on `заказы`.`МенеджерКлиентаID`=`клиенты`.`МенеджерКлиентаID`
			group by `клиенты`.`Менеджер`;
			#order by `клиенты`.`Менеджер`;
			
#8##
select distinct `каталогтоваров`.`Наименование`
			from `склад`
			right join `каталогтоваров` on `склад`.`КодТовара`=`каталогтоваров`.`КодТовара`
			where `склад`.`Остаток`<500 or `склад`.`Остаток` is NULL;
			
#9##
select `клиенты`.`Менеджер`,
			sum(`заказы`.`ОбщаяСумма`) as 'общая сумма'
		from `клиенты`
		join `заказы` on `заказы`.`МенеджерКлиентаID`=`клиенты`.`МенеджерКлиентаID`
		group by `клиенты`.`Менеджер`
		having sum(`заказы`.`ОбщаяСумма`)>9999		
			
			
