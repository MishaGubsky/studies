delete from catalogOfGoods;
delete from PriceList;
delete from sites;
delete from invoices;
delete from orders;
delete from providers;
delete from salesTable;
delete from items;
delete from users;
delete from roles;

DROP SEQUENCE role_seq;
DROP SEQUENCE user_seq;
DROP SEQUENCE items_seq;
DROP SEQUENCE sales_seq;
DROP SEQUENCE provider_seq;
DROP SEQUENCE order_seq;
DROP SEQUENCE invoice_seq;
DROP SEQUENCE site_seq;
DROP SEQUENCE price_seq;
DROP SEQUENCE catalog_seq;


CREATE SEQUENCE role_seq;
CREATE SEQUENCE user_seq;
CREATE SEQUENCE items_seq;
CREATE SEQUENCE sales_seq;
CREATE SEQUENCE provider_seq;
CREATE SEQUENCE order_seq;
CREATE SEQUENCE invoice_seq;
CREATE SEQUENCE site_seq;
CREATE SEQUENCE price_seq;
CREATE SEQUENCE catalog_seq;


begin
insert_role('admin');
insert_role('moderator');
insert_role('user');

-- UPDATE roles set  description='rebot'
--  WHERE ID=(select id from roles where description='bot');
--  
--   delete from roles
--    where ID=(select id from roles where description='ebot');
end;
/


begin
insert into users VALUES(null, 
                        (select id from roles where description='admin'), 
                        'nox',
                        'noxPASSWORD1111');
insert into users VALUES(null, 
                        (select id from roles where description='moderator'), 
                        'anna',
                        'annaPASSWORD2222');
insert into users VALUES(null, 
                        (select id from roles where description='user'), 
                        'anton',
                        'antonPASSWORD3333');
insert into users VALUES(null, 
                        (select id from roles where description='user'), 
                         'botinok',
                         'botinokPASSWORD4444');
insert into users VALUES(null, 
                        (select id from roles where description='user'), 
                         'bot1',
                         'bot1PASSWORD5555');

 UPDATE users set  login='bot2'
  WHERE ID=(select id from users where login='botinok');
  
delete from users
    where ID=(select id from users where login='bot1');
end;
/

begin
insert_item('batary','electronic','FireBall 6CT-100 R 850A(EN)');
insert_item('windscreen wiper','screen','windscreen wiper to Ford K 2004');
insert_item('spark plug','electronic',NULL);
insert_item('radiator','other',NULL);
insert_item('transmision','other',NULL);

 UPDATE items set  name='dick'
  WHERE ID=(select id from items where name='radiator');
  
delete from items
    where ID=(select id from items where name='transmision');

end;
/

begin
 insert into salesTable VALUES(NULL,
                        (select id from users where login='anton'),                   
                        (select id from items where name='batary'), 
                         SYSDATE-15,
                         1,
                         600, 0);
 insert into salesTable VALUES(NULL,
                        (select id from users where login='bot2'),                   
                        (select id from items where name='windscreen wiper'), 
                         SYSDATE-10,
                         1,
                         40, 1);
 insert into salesTable VALUES(NULL,
                        (select id from users where login='bot2'),                   
                        (select id from items where name='spark plug'), 
                         SYSDATE-9,
                         4,
                         70, 1);
 insert into salesTable VALUES(NULL,
                        (select id from users where login='bot2'),                   
                        (select id from items where name='spark plug'), 
                         SYSDATE-3,
                         1,
                         70, 0);

 UPDATE salesTable set  SalesDate=SYSDATE-4
  WHERE ID=(select id from salesTable where userId=(select id from users where login='rebot')
                                          and
                                          itemId=(select id from items where name='spark plug')
                                          and
                                          SalesDate=SYSDATE-3);
end;
/




begin
insert_provider('Moto','Minsk, Nezavisimosty 15','+375 29 3245683');
insert_provider('Avto','Minsk, Nezavisimosty 105',NULL);
insert_provider('AvtoMoto',NULL,'+375 44 3485439');
insert_provider('AvtoMotors',NULL,'+375 44 3474370');
insert_provider('AvtoSMotor',NULL,'+375 44 2354043');

UPDATE providers set name='AvtoMotor'
  WHERE ID=(select id from providers where name='AvtoSMotor');
  
delete from providers
    WHERE ID=(select id from providers where name='AvtoMotors');
end;
/

begin
INSERT INTO orders VALUES(null,(select id from items where name='windscreen wiper'),  
                                (select id from providers where name='AvtoMotor'),
                                10,
                                SYSDATE-10);
INSERT INTO orders VALUES(null,(select id from items where name='windscreen wiper'),  
                                (select id from providers where name='Avto'),
                                30,
                                SYSDATE-8);
INSERT INTO orders VALUES(null,(select id from items where name='windscreen wiper'),  
                                (select id from providers where name='AvtoMoto'),
                                30,
                                SYSDATE-5);
INSERT INTO orders VALUES(null,(select id from items where name='windscreen wiper'),  
                                (select id from providers where name='Moto'),
                                30,
                                SYSDATE-3);
                                
UPDATE orders set Qty=20
  WHERE ID=(select id from orders where itemId=(select id from items where name='windscreen wiper') and
                                        providerId=(select id from providers where name='AvtoMoto'));
  
end;
/
--
begin
INSERT INTO invoices VALUES(null,(select id from orders where itemId=(select id from items where name='windscreen wiper') and
                                        providerId=(select id from providers where name='AvtoMotor')),  
                                SYSDATE-8,
                                10,
                                500);
    
INSERT INTO invoices VALUES(null,(select id from orders where itemId=(select id from items where name='windscreen wiper') and
                                        providerId=(select id from providers where name='Avto')),  
                                SYSDATE-6,
                                30,
                                40);
INSERT INTO invoices VALUES(null,(select id from orders where itemId=(select id from items where name='windscreen wiper') and
                                        providerId=(select id from providers where name='AvtoMoto')),  
                                SYSDATE-3,
                                30,
                                60);
INSERT INTO invoices VALUES(null,(select id from orders where itemId=(select id from items where name='windscreen wiper') and
                                        providerId=(select id from providers where name='Moto')),  
                                SYSDATE-1,
                                20,
                                60);
                                
                                
UPDATE invoices set AmountDelivery=20
  WHERE ID=(select id from invoices where orderId=(select id from orders where itemId=(select id from items where name='windscreen wiper') and
                                        providerId=(select id from providers where name='AvtoMoto')));

end;
/

begin
INSERT INTO sites VALUES(null,
                              (select id from invoices where orderId=(select id from orders where itemId=(select id from items where name='windscreen wiper') and
                                        providerId=(select id from providers where name='Moto'))),  
                                10);
INSERT INTO sites VALUES(null,
                              (select id from invoices where orderId=(select id from orders where itemId=(select id from items where name='windscreen wiper') and
                                        providerId=(select id from providers where name='AvtoMoto'))),  
                                20);
INSERT INTO sites VALUES(null,
                              (select id from invoices where orderId=(select id from orders where itemId=(select id from items where name='windscreen wiper') and
                                        providerId=(select id from providers where name='Avto'))),  
                                30);
INSERT INTO sites VALUES(null,
                              (select id from invoices where orderId=(select id from orders where itemId=(select id from items where name='windscreen wiper') and
                                        providerId=(select id from providers where name='AvtoMotor'))),  
                                40);
                                
UPDATE sites set Amount=20
  WHERE ID=(select id from sites where invoiceId=(select id from invoices where 
                                                            orderId=(select id from orders where 
                                                                              itemId=(select id from items where name='windscreen wiper') and
                                                                              providerId=(select id from providers where name='Avto'))));
                                

delete sites
  WHERE ID=(select id from sites where invoiceId=(select id from invoices where 
                                                            orderId=(select id from orders where 
                                                                              itemId=(select id from items where name='windscreen wiper') and
                                                                              providerId=(select id from providers where name='AvtoMotor'))));
   
end;
/


begin
insert_price(SYSDATE,500,20);
insert_price(SYSDATE,40,20);
insert_price(SYSDATE,60,30);
insert_price(SYSDATE-1,50,30);
insert_price(SYSDATE-1,60,40);

UPDATE priceList set PriceDate=SYSDATE
  WHERE ID=(select id from priceList where PriceDate=SYSDATE-1 and
                                          ProvidersPrice=60 and
                                          SaleMarkUp=30);

delete from items
    where ID=(select id from priceList where PriceDate=SYSDATE-1 and
                                            ProvidersPrice=60 and
                                            SaleMarkUp=40);
end;
/



begin
INSERT INTO catalogOfGoods VALUES(null,
                                  (select id from priceList where ProvidersPrice=500 and
                                                                  SaleMarkUp=20),
                                  1,
                                  10);
INSERT INTO catalogOfGoods VALUES(null,
                                  (select id from priceList where ProvidersPrice=40 and
                                                                  SaleMarkUp=20),
                                  2,
                                  30);                                
INSERT INTO catalogOfGoods VALUES(null,
                                  (select id from priceList where ProvidersPrice=50 and
                                                                  SaleMarkUp=30),
                                  3,
                                  30);                                                                         
UPDATE catalogOfGoods set Amount=20
  WHERE ID=(select id from catalogOfGoods where pricelistid=(select id from priceList where ProvidersPrice=40 and
                                                                  SaleMarkUp=20) and
                                                 siteid=3 and
                                                 Amount=30);
delete from catalogOfGoods
    WHERE ID=(select id from catalogOfGoods where pricelistid=(select id from priceList where ProvidersPrice=60 and
                                                                  SaleMarkUp=30) and
                                                 siteid=3 and
                                                 Amount=30);
end;
/