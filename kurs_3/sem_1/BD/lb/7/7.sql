#1
select `Название`, `УНП`, `ЮрАдрес` from `организации`
	where `ОрганизацииID` in 
	(select `ПоставщикID` from `поставщики`);
	
	
#2
select `Наименование` from `каталогтоваров`
	where `КодТовара` not in 
	(select `КодТовара` from `склад`);
	
#3
select `Наименование` from `каталогтоваров`
	where `КодТовара` in 
	(select `КодТовара` from `склад` 
		where `Остаток` < 101);
									
#4
select `ЗаказID`,`НомерНакладной`,`ДатаЗаказа` from `заказы`
	where `ЗаказID` in (select `ЗаказID` from `заказанотоваров`
									group by `ЗаказID`
									having count(`ЗаказID`)>2);		
#5
select `Название` from `организации`
	where `ОрганизацииID` in 
	(select `ОрганизацииID` from `организации`
		join `клиенты` on `КлиентID`=`ОрганизацииID`
		join `заказы` on `заказы`.`МенеджерКлиентаID`=`клиенты`.`МенеджерКлиентаID`
		group by `организацииId`
		having count(`организацииId`) > 2);
	
#6
select `Название` from `организации`
	join `клиенты` on `КлиентID`=`ОрганизацииID`
	where `клиенты`.`МенеджерКлиентаID` 
	in (select `клиенты`.`МенеджерКлиентаID` from `клиенты`
			join `заказы` on `заказы`.`МенеджерКлиентаID`=`клиенты`.`МенеджерКлиентаID`
			join `заказанотоваров` on `заказанотоваров`.`ЗаказID`=`заказы`.`ЗаказID`
			where `СкладID` = 12);
															
#7
select `Спецификация` from `склад`
	where (`КодТовара`,`ЦенаОтпускная`) in 
	(select `КодТовара`, min(`ЦенаОтпускная`) from `склад`
      where `КодТовара` in 
		(select `КодТовара` from `каталогтоваров`
			where `Наименование` = 'Монитор'))
