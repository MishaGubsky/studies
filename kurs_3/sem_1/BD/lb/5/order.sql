######first######

#1
select * from организации;

#2
select Название, УНП, Руководитель
		from организации
		order by Название;

#3
select  * from организации 
		where `Название`='ООО "Гранит"';

#4
select * from организации 
		where instr(`Название`,'ООО');

#5
select `Спецификация`,`ЦенаОтпускная`,`Остаток` from `склад` 
		where `КодТовара`='101' and `Остаток`>100;

#6
select `Спецификация`,`ЦенаОтпускная` from `склад` 
		where `КодТовара`='500' 
		order by `ЦенаОтпускная` desc;







