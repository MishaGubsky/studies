begin
insert_role(1,'admin');
insert_role(2,'moderator');
insert_role(3,'user');
insert_role(4,'bot');
insert_role(5,'bot');

update_role(4,4,'robot');
delete_role(5);
end;
/

begin
insert_user(1,'nox','noxPASSWORD1111');
insert_user(2,'anna','annaPASSWORD2222');
insert_user(3,'anton','antonPASSWORD3333');
insert_user(4,'botinok','botinokPASSWORD4444');
insert_user(4,'bot1','bot1PASSWORD5555');

update_user(4,4,'bot2','bot2PASSWORD5555');
delete_user(5,null,null);
end;
/

begin
insert_item('batary','electronic','FireBall 6бв-100 R 850A(EN)');
insert_item('windscreen wiper','screen','windscreen wiper to Ford K 2004');
insert_item('spark plug','electronic',NULL);
insert_item('radiator','other',NULL);
insert_item('transmision','other',NULL);

update_item(4,'disk','other',NULL);
delete_item(5);
end;
/

begin
insert_sale(2,1,SYSDATE-15,1,600);
insert_sale(3,2,SYSDATE-10,1,40);
insert_sale(3,3,SYSDATE-9,4,70);
insert_sale(4,4,SYSDATE-3,1,70);

update_sale(4,4,4,SYSDATE-4,1,70);
end;
/

begin
insert_price(SYSDATE,500,20);
insert_price(SYSDATE,40,20);
insert_price(SYSDATE,60,30);
insert_price(SYSDATE-1,60,30);
insert_price(SYSDATE-1,60,30);

update_price(4,SYSDATE,60,30);
delete_price(5);
end;
/

begin
insert_catalog(1,1,10);
insert_catalog(2,2,30);
insert_catalog(3,3,30);
insert_catalog(4,4,20);
insert_catalog(4,4,10);

update_catalog(4,4,4,30);
delete_catalog(5);
end;
/

begin
insert_provider('Moto','Minsk, Nezavisimosty 15','+375 29 3245683');
insert_provider('Avto','Minsk, Nezavisimosty 105',NULL);
insert_provider('AvtoMoto',NULL,'+375 44 3485439');
insert_provider('AvtoMotors',NULL,'+375 44 3474370');
insert_provider('AvtoSMotor',NULL,'+375 44 2354043');

update_provider(4,'AvtoMOTORse','Minsk, Nezavisimosty 1',NULL);
delete_provider(5);
end;
/

begin
insert_order(1,1,10,SYSDATE-10);
insert_order(2,2,30,SYSDATE-8);
insert_order(3,3,30,SYSDATE-5);
insert_order(4,4,30,SYSDATE-3);

update_order(4,4,4,30,SYSDATE-2);
end;
/

begin
insert_invoice(1,SYSDATE-8,10,500);
insert_invoice(2,SYSDATE-6,30,40);
insert_invoice(3,SYSDATE-3,30,60);
insert_invoice(4,SYSDATE-1,20,60);

update_invoice(4,4,SYSDATE,30,60);
end;
/

begin
insert_site(1,1,10);
insert_site(2,2,30);
insert_site(3,3,30);
insert_site(4,4,20);
insert_site(4,4,30);

update_site(4,4,4,30);
delete_site(5);
end;
/