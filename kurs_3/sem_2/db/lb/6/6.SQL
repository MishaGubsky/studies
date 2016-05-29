--triggers

CREATE OR REPLACE TRIGGER role_trigger
BEFORE INSERT  ON roles FOR EACH ROW
BEGIN
:NEW.ID := role_seq.NEXTVAL;
END;
/


CREATE OR REPLACE TRIGGER user_trigger
BEFORE INSERT  ON users FOR EACH ROW
BEGIN
:NEW.ID := user_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER items_trigger
BEFORE INSERT  ON items FOR EACH ROW
BEGIN
:NEW.ID := items_seq.NEXTVAL;
END;
/



CREATE OR REPLACE TRIGGER sales_trigger
BEFORE INSERT  ON salesTable FOR EACH ROW
BEGIN
  :NEW.ID := sales_seq.NEXTVAL;  
END;
/

CREATE OR REPLACE TRIGGER price_trigger
BEFORE INSERT OR UPDATE  ON priceList FOR EACH ROW
BEGIN
if INSERTING THEN
:NEW.ID := price_seq.NEXTVAL;
end if;
if UPDATING THEN
:NEW.salesPrice := :new.ProvidersPrice*(100+:new.SaleMarkUp)/100;
end if;
END;
/

CREATE OR REPLACE TRIGGER catalog_trigger
BEFORE INSERT  ON catalogOfGoods FOR EACH ROW
BEGIN
:NEW.ID := catalog_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER provider_trigger
BEFORE INSERT  ON providers FOR EACH ROW
BEGIN


:NEW.ID := provider_seq.NEXTVAL;

END;
/

CREATE OR REPLACE TRIGGER order_trigger
BEFORE INSERT  ON orders FOR EACH ROW
BEGIN


:NEW.ID := order_seq.NEXTVAL;

END;
/

CREATE OR REPLACE TRIGGER invoice_trigger
BEFORE INSERT  ON invoices FOR EACH ROW
BEGIN


:NEW.ID := invoice_seq.NEXTVAL;

END;
/

CREATE OR REPLACE TRIGGER site_trigger
BEFORE INSERT  ON sites FOR EACH ROW
BEGIN


:NEW.ID := site_seq.NEXTVAL;

END;
/





















--PROCEDURES

CREATE OR REPLACE procedure insert_role(discription_ VARCHAR2) IS
BEGIN
  INSERT INTO roles VALUES(null, discription_);
  commit;
 END insert_role;
/

CREATE OR REPLACE procedure insert_user(login VARCHAR2,
                                        password VARCHAR2, 
                                        role VARCHAR2 default 'user') IS
  role_id number;
  v_failures NUMBER(12) := 0;  
BEGIN
  
  select id into role_id from roles where description=role;
  INSERT INTO users VALUES(null, role_id, login, password);
  commit;  
  DBMS_MVIEW.REFRESH_ALL_MVIEWS(v_failures);
 END insert_user;
/

CREATE OR REPLACE procedure update_user(id_ number, 
                                        roleID_ number, 
                                        Login_ VARCHAR2, 
                                        Password_ VARCHAR2) IS
BEGIN
  UPDATE users set roleID=roleID_, Login=Login_, Password=Password_
  WHERE ID=id_;
  commit;
  
 END update_user;
/

CREATE OR REPLACE procedure delete_user(id_ number) IS
v_failures NUMBER(12) := 0;  
BEGIN
  
  delete from users
    where ID=id_;
  commit;
  DBMS_MVIEW.REFRESH_ALL_MVIEWS(v_failures);
 END delete_user;
/
------------------------------------------------------------------------------------

CREATE OR REPLACE procedure insert_item(Name_ VARCHAR2, 
                                        Type_ VARCHAR2, 
                                        Notes_ VARCHAR2) IS
                                        v_failures NUMBER(12) := 0;  
BEGIN
  INSERT INTO items VALUES(Null, Name_, Type_, Notes_);
  commit;
  
  DBMS_MVIEW.REFRESH_ALL_MVIEWS(v_failures);
 END insert_item;
/

CREATE OR REPLACE procedure update_item(id_ Number,
                                        Name_ VARCHAR2, 
                                        Type_ VARCHAR2, 
                                        Notes_ VARCHAR2) IS
                                        v_failures NUMBER(12) := 0; 
BEGIN
  update items set NAME=name_,
                   TYpe = TYPE_,
                   notes = notes_
            where id = id_;
commit;

  DBMS_MVIEW.REFRESH_ALL_MVIEWS(v_failures);
 END update_item;
/


------------------------------------------------------------------------------


CREATE OR REPLACE procedure update_sale(id_ Number, 
                                        compl Number) IS UserId Number;
BEGIN
  UPDATE salesTable set complited = compl
  WHERE ID=id_;
  commit;
 END update_sale;
/

CREATE OR REPLACE procedure insert_price(PriceDate DATE,
                                        ProvidersPrice Number,
                                        SaleMarkUp Number) IS
                                        v_failures NUMBER(12) := 0;  
BEGIN
  
  INSERT INTO priceList VALUES(Null,PriceDate,ProvidersPrice,SaleMarkUp,
                                        ProvidersPrice*(100+SaleMarkUp)/100);
  commit;
  
  DBMS_MVIEW.REFRESH_ALL_MVIEWS(v_failures);
 END insert_price;
/
------------------------------------------------------------------------------

CREATE OR REPLACE procedure insert_provider(Name VARCHAR2,
                                            Adress VARCHAR2,
                                            Phone VARCHAR2) IS
                                            v_failures NUMBER(12) := 0;  
BEGIN
  INSERT INTO providers VALUES(null,Name,Adress,Phone);
  commit;
  
  DBMS_MVIEW.REFRESH_ALL_MVIEWS(v_failures);
 END insert_provider;
/

CREATE OR REPLACE procedure update_provider(ProviderID_ NUMBER,
                                            Name_ VARCHAR2,
                                            Adress_ VARCHAR2,
                                            Phone_ VARCHAR2) IS
                                            
BEGIN
  UPDATE providers set Name=Name_,
                       Adress=Adress_,
                       Phone=Phone_
  WHERE ID=ProviderID_;
  commit;
 END update_provider;
/

CREATE OR REPLACE procedure delete_provider(id_ number) IS
v_failures NUMBER(12) := 0;  
BEGIN
  delete from providers
    where ID=id_;
    
  DBMS_MVIEW.REFRESH_ALL_MVIEWS(v_failures);
  commit;
  
 END delete_provider;
/

------------------------------------------------------------------------------------

CREATE OR REPLACE procedure insert_order(ItemID Number,
                                        ProviderId Number,
                                        Qty Number) IS
                                        v_failures NUMBER(12) := 0;  
BEGIN
  INSERT INTO orders VALUES(null,ItemID,ProviderID,Qty,SYSDATE);
  commit;
  
  DBMS_MVIEW.REFRESH_ALL_MVIEWS(v_failures);
 END insert_order;
/

------------------------------------------------------------------------------------

CREATE OR REPLACE procedure insert_invoice(OrderID Number,
                                          AmountDelivery Number,
                                          CostPrice Number) IS
                                          v_failures NUMBER(12) := 0;  
BEGIN
  INSERT INTO invoices VALUES(null,OrderID, SYSDATE, AmountDelivery,CostPrice);
  insert_site(invoice_seq.currval, AmountDelivery);
  commit;
  
--  DBMS_MVIEW.REFRESH_ALL_MVIEWS(v_failures);
 END insert_invoice;
/

------------------------------------------------------------------------------------


CREATE OR REPLACE procedure insert_site(InvoiceID Number,
                                        Amount Number) IS
                                        v_failures NUMBER(12) := 0;  
BEGIN
  INSERT INTO sites VALUES(null,InvoiceID,Amount);
  commit;
  
  DBMS_MVIEW.REFRESH_ALL_MVIEWS(v_failures);
 END insert_site;
/

-----------------------------------------------------------------------------------

create or replace procedure insert_item_in_catalog(providerPrice_ number, 
                                                    SaleMarkUp_ number, 
                                                    PriceDate_ Date,
                                                    site_id number,
                                                    amount number) is 
                                                    v_failures NUMBER(12) := 0;  
  price_id number;
  item_id number;
begin
insert_price(PriceDate_, providerprice_, salemarkup_);
price_id := price_seq.currval;
insert into catalogOfgoods values(null,price_id, site_id, amount);

  DBMS_MVIEW.REFRESH_ALL_MVIEWS(v_failures);
end insert_item_in_catalog;
/

create or replace function auth_user(user_login varchar2, user_pass varchar2)
                                          return number is
                                          u users%ROWTYPE;
begin
  DBMS_OUTPUT.PUT_LINE (user_login);
  select * into u from users where login = user_login;
  if (u.password = user_pass) then
    return u.id;
  else 
    return 0;
  end if;
  exception
    when others then
      return -1;
  
end auth_user;
/

CREATE OR REPLACE procedure insert_sale(UserLogin VARCHAR2, 
                                        ItemID Number,  
                                        SalesAmount Number, 
                                        ItemPrice Number) IS UserId Number;
                                        v_failures NUMBER(12) := 0;  
BEGIN
  select id into UserId from users where login = UserLogin;
  INSERT INTO salesTable VALUES(Null, UserId, ItemID, SYSDATE, SalesAmount, ItemPrice, 0);
  commit;
  
  DBMS_MVIEW.REFRESH_ALL_MVIEWS(v_failures);
 END insert_sale;
/


CREATE OR REPLACE procedure update_site(id_ Number,
                                        amount_ Number) IS
                                        amount NUMBER;
BEGIN
  select sites.amount into amount from sites where id = id_;
  if (amount - amount_ = 0) then
    delete from sites where id = id_;
  else
    update sites set sites.amount = sites.amount - amount_
        WHERE ID=id_;
  end if;
  commit;
 END update_site;
/


CREATE OR REPLACE procedure user_order(UserLogin VARCHAR2, 
                                        ItemID Number,  
                                        SalesAmount Number, 
                                        ItemPrice Number,
                                        CatalogId Number) IS 
                                        SiteId_ Number;
                                        v_failures NUMBER(12) := 0;          
BEGIN
  select siteid into SiteId_ from catalogOfgoods where id = CatalogId;
--  INSERT INTO salesTable VALUES(Null, UserId, ItemID, SYSDATE, SalesAmount, ItemPrice, 0);
  insert_sale(UserLogin, ItemID, SalesAmount, ItemPrice);
  update_site(SiteId_, SalesAmount);
  commit;
  DBMS_MVIEW.REFRESH_ALL_MVIEWS(v_failures);
 END user_order;
/



drop materialized view user_view;
drop materialized view catalog_view;
drop materialized view site_item_view;
drop materialized view sales_view;
drop materialized view invoices_view;

--views
create materialized view user_view REFRESH COMPLETE as
      select  users.id,
              users.roleid,
              users.login,
              users.PASSWORD, 
              ROLES.description as role 
                  from users
                  join roles on users.roleid=roles.Id
        order by users.id asc;
/

create materialized view sales_view REFRESH COMPLETE as
      select  salesTable.userId as user_id,
              items.id as item_id,
              users.login as user_name,
              items.name as item_Name,
              SalesDate, 
              SalesAmount, 
              ItemPrice,
              complited
              from salesTable
                  join items on items.id = salesTable.itemId
                  join users on users.id = salesTable.userId
        order by complited desc, SalesDate asc;
/


create materialized view catalog_view REFRESH COMPLETE as
 select items.id as item_id,
        items.name as item_Name,
        items.type,
        items.notes,
        priceList.salesPrice as price,
        sites.amount,
        catalogofgoods.id as catalog_id
        from items
        left join orders on orders.itemid=items.Id
        left join invoices on invoices.orderid=orders.ID
        left join sites on sites.invoiceid=invoices.ID
        left join catalogOfGoods on catalogofgoods.siteid = sites.id 
        left join pricelist on catalogofgoods.pricelistid=pricelist.ID
        order by catalogofgoods.id asc, items.name asc;
/

create materialized view site_item_view REFRESH COMPLETE as
select  providers.id as provider_id,
        items.id as item_id,
        items.name as item_Name,
        providers.name as provider,
        orders.OrderDate,
        invoices.INVOICEDATE,
        orders.qty,
        invoices.AMOUNTDELIVERY,
        sites.amount as Amount_remaining
        from sites
        join invoices on sites.invoiceid=invoices.ID
        join orders on invoices.orderid=orders.ID
        join providers on orders.providerid=providers.ID
        join items on orders.itemid=items.ID
        order by sites.id asc;
/

create materialized view invoices_view REFRESH COMPLETE as
select  items.id as item_id,
        items.name as item_Name,
        providers.name as provider,
        orders.OrderDate,
        invoices.INVOICEDATE,
        orders.qty,
        invoices.AMOUNTDELIVERY,
        invoices.costprice,
        providers.id as provider_id,
        orders.id as order_id
        from orders 
        left join invoices on invoices.orderid=orders.ID
        left join providers on orders.providerid=providers.ID
        left join items on orders.itemid=items.ID
        order by orders.OrderDate desc, invoices.Invoicedate desc;
/

commit;