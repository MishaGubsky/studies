SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT=0;
START TRANSACTION;
SET time_zone = "+00:00";
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

CREATE TABLE IF NOT EXISTS `заказанотоваров` (
  `ЗаказID` int(11) NOT NULL AUTO_INCREMENT,
  `СкладID` int(11) NOT NULL,
  `Количество` double NOT NULL,
  `ЦенаПродажи` double NOT NULL,
  PRIMARY KEY (`ЗаказID`,`СкладID`),
  KEY `СкладID` (`СкладID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=14 ;

INSERT INTO `заказанотоваров` (`ЗаказID`, `СкладID`, `Количество`, `ЦенаПродажи`) VALUES
(1, 1, 4, 250),
(1, 2, 10, 300),
(2, 6, 20, 200),
(2, 12, 1, 150),
(2, 14, 10, 100),
(2, 16, 2, 160),
(3, 2, 10, 300),
(3, 17, 10, 300),
(4, 12, 10, 150),
(4, 13, 5, 160),
(5, 14, 20, 100),
(5, 15, 10, 130),
(5, 16, 10, 160),
(6, 5, 20, 215),
(6, 7, 10, 260),
(7, 14, 20, 100),
(8, 3, 10, 180),
(8, 4, 10, 160),
(9, 17, 20, 100),
(10, 12, 20, 150),
(10, 13, 10, 160),
(10, 16, 10, 160),
(11, 4, 20, 160),
(11, 5, 10, 250),
(12, 10, 10, 210),
(13, 1, 10, 250),
(13, 3, 10, 180);

CREATE TABLE IF NOT EXISTS `заказы` (
  `ЗаказID` int(11) NOT NULL AUTO_INCREMENT,
  `МенеджерКлиентаID` int(11) NOT NULL,
  `СотрудникID` int(11) NOT NULL,
  `НомерНакладной` varchar(10) CHARACTER SET cp1251 COLLATE cp1251_general_cs DEFAULT NULL,
  `ДатаЗаказа` date NOT NULL,
  `ОбщаяСумма` float NOT NULL,
  `СостояниеID` int(11) NOT NULL,
  `ДатаОтгрузки` date DEFAULT NULL,
  `Примечание` text CHARACTER SET cp1251 COLLATE cp1251_general_cs,
  PRIMARY KEY (`ЗаказID`),
  KEY `МенеджерКлиентаID` (`МенеджерКлиентаID`,`СотрудникID`,`СостояниеID`),
  KEY `СотрудникID` (`СотрудникID`),
  KEY `СостояниеID` (`СостояниеID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=14 ;

INSERT INTO `заказы` (`ЗаказID`, `МенеджерКлиентаID`, `СотрудникID`, `НомерНакладной`, `ДатаЗаказа`, `ОбщаяСумма`, `СостояниеID`, `ДатаОтгрузки`, `Примечание`) VALUES
(1, 1, 1, 'X000100', '2010-01-14', 4000, 3, '2010-01-20', NULL),
(2, 2, 1, 'X000103', '2010-01-14', 3470, 3, '2010-01-19', 'Оплата налич.'),
(3, 1, 3, 'X000320', '2010-03-24', 6000, 3, '2010-03-29', NULL),
(4, 4, 3, 'X000109', '2010-01-24', 2300, 3, '2004-02-11', NULL),
(5, 5, 1, 'X000309', '2010-03-14', 2300, 3, '2010-02-02', NULL),
(6, 3, 3, 'X000209', '2010-02-04', 6900, 3, '2010-03-24', NULL),
(7, 4, 1, 'X000212', '2010-02-06', 2000, 3, '2010-02-14', NULL),
(8, 6, 3, 'X000220', '2010-02-12', 3400, 3, '2010-02-18', NULL),
(9, 7, 1, 'X000224', '2010-02-14', 2000, 3, '2010-02-19', NULL),
(10, 4, 1, 'X000224', '2010-02-24', 6200, 3, '2010-03-03', NULL),
(11, 6, 1, NULL, '2010-03-20', 5350, 2, NULL, NULL),
(12, 3, 5, NULL, '2010-04-05', 3300, 1, NULL, NULL),
(13, 2, 3, NULL, '2010-04-02', 2100, 1, NULL, NULL);

CREATE TABLE IF NOT EXISTS `каталогтоваров` (
  `КодТовара` int(11) NOT NULL,
  `Наименование` varchar(40) CHARACTER SET cp1251 COLLATE cp1251_general_cs NOT NULL,
  PRIMARY KEY (`КодТовара`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


INSERT INTO `каталогтоваров` (`КодТовара`, `Наименование`) VALUES
(100, 'Телевизор'),
(101, 'Монитор'),
(200, 'Модуль памяти'),
(230, 'Флеш-память'),
(300, 'Материнская плата'),
(400, 'Видеокарта'),
(500, 'HD'),
(510, 'CD-ROM'),
(600, 'Корпус'),
(700, 'Принтер'),
(850, 'Источник БП'),
(940, 'Модем');

CREATE TABLE IF NOT EXISTS `клиенты` (
  `МенеджерКлиентаID` int(11) NOT NULL AUTO_INCREMENT,
  `КлиентID` int(11) NOT NULL,
  `Менеджер` varchar(30) CHARACTER SET cp1251 COLLATE cp1251_general_cs NOT NULL,
  `Телефон` varchar(15) CHARACTER SET cp1251 COLLATE cp1251_general_cs NOT NULL,
  `Факс` varchar(15) CHARACTER SET cp1251 COLLATE cp1251_general_cs DEFAULT NULL,
  PRIMARY KEY (`МенеджерКлиентаID`),
  KEY `КлиентID` (`КлиентID`),
  KEY `КлиентID_2` (`КлиентID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

INSERT INTO `клиенты` (`МенеджерКлиентаID`, `КлиентID`, `Менеджер`, `Телефон`, `Факс`) VALUES
(1, 1, 'Скорый И.С.', '222-30-17', '222-30-17'),
(2, 6, 'Сафронов Н.С.', '234-30-12', '232-50-17'),
(3, 1, 'Боровой А.С.', '251-46-87', '251-46-87'),
(4, 3, 'Алексеев О.В.', '211-26-17', '211-26-17'),
(5, 3, 'Макаров Д.С.', '221-06-07', '221-32-17'),
(6, 1, 'Коновалов Р.Л.', '222-30-17', '222-30-17'),
(7, 4, 'Хвостов А.Ж.', '255-30-97', NULL),
(8, 6, 'Круг Л.Л.', '213-16-87', '213-16-87');


CREATE TABLE IF NOT EXISTS `организации` (
  `ОрганизацииID` int(11) NOT NULL,
  `УНП` varchar(9) CHARACTER SET cp1251 COLLATE cp1251_general_cs NOT NULL,
  `Название` varchar(50) CHARACTER SET cp1251 COLLATE cp1251_general_cs NOT NULL,
  `Руководитель` varchar(30) CHARACTER SET cp1251 COLLATE cp1251_general_cs NOT NULL,
  `Телефон` varchar(15) CHARACTER SET cp1251 COLLATE cp1251_general_cs DEFAULT NULL,
  `ЮрАдрес` varchar(100) CHARACTER SET cp1251 COLLATE cp1251_general_cs NOT NULL,
  PRIMARY KEY (`ОрганизацииID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



INSERT INTO `организации` (`ОрганизацииID`, `УНП`, `Название`, `Руководитель`, `Телефон`, `ЮрАдрес`) VALUES
(1, '100128881', 'ООО "Винт"', 'Иванов И.И.', '222-30-17', 'г.Минск, ул. Бровки, 21'),
(2, '102023442', 'ЗАО "Белинвестторг"', 'Хорошев Х.И.', '221-06-07', 'г.Могилев, ул. Котовского, 12'),
(3, '100023390', 'ООО "Ветразь"', 'Бронштейн Я.И.', '234-30-10', 'г.Минск, пр.Скорины, 108, офис 12а'),
(4, '101100111', 'РУП "Трансгаз"', 'Петров П.И.', '605-32-17', 'г.Минск, ул. Беды, 11'),
(5, '100303122', 'ТУП "Белоптторг"', 'Сачек А.П.', '205-30-97', 'г.Брест, ул. Индустриальная, 20а'),
(6, '101002008', 'ООО "Гранит"', 'Серов И.Г.', '605-40-34', 'г.Гродно, ул. Солнечная, 1'),
(7, '101033300', 'УП "Белкантон"', 'Котелков И.И.', '330-60-43', 'г.Гродно, ул. Победы, 1');



CREATE TABLE IF NOT EXISTS `поставщики` (
  `МенеджерПоставщикаID` int(11) NOT NULL,
  `ПоставщикID` int(11) NOT NULL,
  `Менеджер` varchar(30) CHARACTER SET cp1251 COLLATE cp1251_general_cs NOT NULL,
  `Телефон` varchar(15) CHARACTER SET cp1251 COLLATE cp1251_general_cs NOT NULL,
  `Факс` varchar(15) CHARACTER SET cp1251 COLLATE cp1251_general_cs DEFAULT NULL,
  PRIMARY KEY (`МенеджерПоставщикаID`),
  KEY `ПоставщикID` (`ПоставщикID`),
  KEY `ПоставщикID_2` (`ПоставщикID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


INSERT INTO `поставщики` (`МенеджерПоставщикаID`, `ПоставщикID`, `Менеджер`, `Телефон`, `Факс`) VALUES
(1, 2, 'Лушкин В.И.', '221-06-07', NULL),
(2, 5, 'Громов О.Ф.', '234-30-12', '232-50-17'),
(3, 7, 'Бронштейн А.С.', '251-46-87', '251-46-87'),
(4, 2, 'Коновалов Р.Л.', '330-60-43', NULL),
(5, 5, 'Петров П.Л.', '205-30-97', NULL);


CREATE TABLE IF NOT EXISTS `приходсклад` (
  `СкладID` int(11) NOT NULL,
  `ДатаПоставки` date NOT NULL,
  `КодПоставщика` int(11) NOT NULL,
  `НомерНакладной` varchar(10) CHARACTER SET cp1251 COLLATE cp1251_general_cs NOT NULL,
  `Количество` int(11) NOT NULL,
  `ЦенаПоставки` double NOT NULL,
  `Приемщик` int(11) DEFAULT NULL,
  PRIMARY KEY (`СкладID`,`ДатаПоставки`),
  KEY `КодПоставщика` (`КодПоставщика`,`Приемщик`),
  KEY `Приемщик` (`Приемщик`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


INSERT INTO `приходсклад` (`СкладID`, `ДатаПоставки`, `КодПоставщика`, `НомерНакладной`, `Количество`, `ЦенаПоставки`, `Приемщик`) VALUES
(1, '2010-01-03', 1, 'Z000100', 94, 200, 2),
(1, '2010-02-12', 1, 'Z001201', 30, 200, 2),
(2, '2010-01-03', 1, 'Z000100', 114, 350, 2),
(3, '2010-01-05', 2, 'Q002350', 60, 140, 2),
(3, '2010-02-15', 2, 'Q002521', 50, 140, 2),
(4, '2010-01-03', 3, 'W043333', 240, 110, 4),
(4, '2010-03-08', 3, 'W043656', 100, 110, 4),
(5, '2010-01-03', 3, 'W043333', 168, 175, 4),
(6, '2010-01-03', 3, 'W043333', 20, 140, 4),
(7, '2010-01-03', 3, 'W043333', 100, 210, 4),
(7, '2010-03-05', 3, 'Q011999', 30, 210, 4),
(8, '2010-01-12', 4, 'S110099', 20, 120, 2),
(9, '2010-01-12', 4, 'S110099', 200, 135, 2),
(10, '2010-01-12', 4, 'S110099', 130, 175, 2),
(11, '2010-01-12', 4, 'S110099', 120, 110, 2),
(12, '2010-01-12', 2, 'Q012222', 101, 110, 4),
(12, '2010-02-22', 2, 'Q014221', 50, 110, 4),
(13, '2010-01-12', 2, 'Q012222', 65, 115, 4),
(13, '2010-02-22', 2, 'Q014221', 50, 115, 4),
(14, '2010-01-12', 1, 'Z001055', 100, 75, 2),
(15, '2010-01-12', 1, 'Z001055', 210, 95, 2),
(16, '2010-01-12', 1, 'Z001055', 122, 110, 2),
(17, '2010-01-15', 3, 'W043678', 30, 250, 4),
(17, '2010-03-05', 3, 'W044735', 100, 250, 4);


CREATE TABLE IF NOT EXISTS `склад` (
  `Склад` int(11) NOT NULL AUTO_INCREMENT,
  `КодТовара` int(11) NOT NULL,
  `Спецификация` varchar(50) CHARACTER SET cp1251 COLLATE cp1251_general_cs NOT NULL,
  `ЦенаОтпускная` float NOT NULL,
  `Остаток` int(11) NOT NULL,
  `Место` int(11) DEFAULT NULL,
  PRIMARY KEY (`Склад`),
  KEY `КодТовара` (`КодТовара`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=18 ;

INSERT INTO `склад` (`Склад`, `КодТовара`, `Спецификация`, `ЦенаОтпускная`, `Остаток`, `Место`) VALUES
(1, 100, 'Горизонт 700', 250, 110, 1),
(2, 100, 'Горизонт 800', 300, 94, 1),
(3, 101, 'Viewsonic 16', 180, 90, 2),
(4, 101, 'LG 16', 160, 210, 2),
(5, 101, 'Samsung 16', 215, 138, 2),
(6, 101, 'Viewsonic 17', 200, 0, 2),
(7, 101, 'LG 19', 260, 120, 3),
(8, 500, 'HP 3,5gb', 160, 20, 13),
(9, 500, 'HP 6gb', 180, 200, 13),
(10, 500, 'HP 10gb', 210, 120, 13),
(11, 500, 'LG 5gb', 150, 120, 14),
(12, 700, 'Canon L111E', 150, 120, 33),
(13, 700, 'Canon L112E', 160, 100, 33),
(14, 700, 'HP 800M', 100, 50, 34),
(15, 700, 'HP 1000L', 130, 200, 34),
(16, 700, 'HP 1100L', 160, 100, 34),
(17, 100, 'Sony 80', 300, 100, 1);

CREATE TABLE IF NOT EXISTS `состояниезаказа` (
  `СостояниеID` int(11) NOT NULL AUTO_INCREMENT,
  `Состояние` varchar(16) CHARACTER SET cp1251 COLLATE cp1251_general_cs NOT NULL,
  PRIMARY KEY (`СостояниеID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;


INSERT INTO `состояниезаказа` (`СостояниеID`, `Состояние`) VALUES
(1, 'Оформлен'),
(2, 'Оплачен'),
(3, 'Отгружен');

CREATE TABLE IF NOT EXISTS `сотрудники` (
  `СотрудникID` int(11) NOT NULL,
  `ФИО` varchar(30) CHARACTER SET cp1251 COLLATE cp1251_general_cs NOT NULL,
  `Должность` varchar(20) CHARACTER SET cp1251 COLLATE cp1251_general_cs NOT NULL,
  `Телефон` varchar(15) CHARACTER SET cp1251 COLLATE cp1251_general_cs DEFAULT NULL,
  PRIMARY KEY (`СотрудникID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


INSERT INTO `сотрудники` (`СотрудникID`, `ФИО`, `Должность`, `Телефон`) VALUES
(1, 'Вышинский Л.С.', 'Менеджер', '211-11-77'),
(2, 'Соболевская Ж.Д.', 'Кладовщик', '211-12-19'),
(3, 'Ружанская О.Л.', 'Менеджер', '211-11-79'),
(4, 'Котова Д.О.', 'Кладовщик', '211-12-20'),
(5, 'Трубова И.Л.', 'Менеджер', '211-11-76');


ALTER TABLE `заказанотоваров`
  ADD CONSTRAINT `@n0@g0@q0@g0@n0@g0@t0@u0@y0@u0@i0@g0@w0@u0@i0_ibfk_3` FOREIGN KEY (`СкладID`) REFERENCES `склад` (`Склад`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `@n0@g0@q0@g0@n0@g0@t0@u0@y0@u0@i0@g0@w0@u0@i0_ibfk_2` FOREIGN KEY (`ЗаказID`) REFERENCES `заказы` (`ЗаказID`) ON DELETE CASCADE ON UPDATE CASCADE;


 ALTER TABLE `заказы`
  ADD CONSTRAINT `@n0@g0@q0@g0@n0@n1_ibfk_3` FOREIGN KEY (`СостояниеID`) REFERENCES `состояниезаказа` (`СостояниеID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `@n0@g0@q0@g0@n0@n1_ibfk_1` FOREIGN KEY (`МенеджерКлиентаID`) REFERENCES `клиенты` (`МенеджерКлиентаID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `@n0@g0@q0@g0@n0@n1_ibfk_2` FOREIGN KEY (`СотрудникID`) REFERENCES `сотрудники` (`СотрудникID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `клиенты`
  ADD CONSTRAINT `@q0@r0@o0@l0@t0@y0@n1_ibfk_1` FOREIGN KEY (`КлиентID`) REFERENCES `организации` (`ОрганизацииID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `поставщики`
  ADD CONSTRAINT `@v0@u0@x0@y0@g0@i0@l1@o0@q0@o0_ibfk_1` FOREIGN KEY (`ПоставщикID`) REFERENCES `организации` (`ОрганизацииID`) ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE `приходсклад`
  ADD CONSTRAINT `@v0@w0@o0@h1@u0@k0@x0@q0@r0@g0@k0_ibfk_3` FOREIGN KEY (`Приемщик`) REFERENCES `сотрудники` (`СотрудникID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `@v0@w0@o0@h1@u0@k0@x0@q0@r0@g0@k0_ibfk_1` FOREIGN KEY (`СкладID`) REFERENCES `склад` (`Склад`),
  ADD CONSTRAINT `@v0@w0@o0@h1@u0@k0@x0@q0@r0@g0@k0_ibfk_2` FOREIGN KEY (`КодПоставщика`) REFERENCES `поставщики` (`МенеджерПоставщикаID`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `склад`
  ADD CONSTRAINT `@x0@q0@r0@g0@k0_ibfk_1` FOREIGN KEY (`КодТовара`) REFERENCES `каталогтоваров` (`КодТовара`) ON DELETE CASCADE ON UPDATE CASCADE;
SET FOREIGN_KEY_CHECKS=1;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;








