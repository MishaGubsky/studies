drop table log_errors;
CREATE TABLE log_errors (
  tableName VARCHAR2(50),
  ErrorDescription VARCHAR2(100),
  ErrorDate TIMESTAMP
);
/
CREATE OR REPLACE procedure save_error(errorName VARCHAR2, errorMsg VARCHAR2) IS
BEGIN
  insert into log_errors values (errorName, errorMsg, current_timestamp);
 END save_error;
/

CREATE OR REPLACE procedure catch_error IS
    errorName varchar2(100);
    errorMsg varchar2(100);
BEGIN
  select regexp_replace(sys.dbms_utility.format_error_backtrace, '.*:', '') into errorName from dual;
  errorName := substr(errorName, 12, length(errorName)-12-9);
  select regexp_replace(sys.dbms_utility.format_error_stack, '.*: ', '') into errorMsg from dual;
  
  save_error(errorName, errorMsg);
  DBMS_OUTPUT.PUT_LINE ( errorName );
  DBMS_OUTPUT.PUT_LINE ( errorMsg );
 END catch_error;
/

CREATE OR REPLACE procedure insert_role(discription_ VARCHAR2) IS
BEGIN
  INSERT INTO roles VALUES(null, discription_);
  commit;
  exception
  when others then
    catch_error();  
 END insert_role;
/

CREATE OR REPLACE procedure insert_user(role VARCHAR2,
                                        login VARCHAR2,
                                        password VARCHAR2) IS
  role_id number;
BEGIN
  select id into role_id from roles where description=role;
  INSERT INTO users VALUES(null, role_id, login, password);
  commit;
  exception
    when others then
      
      catch_error();
 END insert_user;
/



CREATE OR REPLACE procedure insert_item(Name_ VARCHAR2, 
                                        Type_ VARCHAR2, 
                                        Notes_ VARCHAR2) IS
BEGIN
  INSERT INTO items VALUES(Null, Name_, Type_, Notes_);
  commit;
  exception
    when others then
      catch_error();
 END insert_item;
/

CREATE OR REPLACE procedure insert_sale(UserLogin VARCHAR2, 
                                        ItemID Number, 
                                        SalesDate Date, 
                                        SalesAmount Number, 
                                        ItemPrice Number) 
                                  IS 
                                    UserId Number;
                                    DateEx EXCEPTION;
                                    AmountEx EXCEPTION;
                                    PriceEx EXCEPTION;
BEGIN
  if SalesDate > SYSDATE then
    raise DateEx;
  end if;
  
  if SalesAmount <= 0 then
    raise AmountEx;
  end if;
  
  if ItemPrice <= 0 then
    raise PriceEx;
  end if;
  
  select id into UserId from users where login = UserLogin;
  INSERT INTO salesTable VALUES(Null, UserId, ItemID, SalesDate, SalesAmount, ItemPrice);
  commit;
 
  
  exception
    when DateEx then
      save_error('insert_sale', 'date is not valid');
      RAISE_APPLICATION_ERROR(-20001,'date is not valid');
    when AmountEx then
        save_error('insert_sale', 'Amount can not be less then 0');
        RAISE_APPLICATION_ERROR(-20002,'Amount can not be less then 0');
    when PriceEx then
        save_error('insert_sale', 'Price can not be less then 0');
        RAISE_APPLICATION_ERROR(-20003,'Price can not be less then 0');
    when others then
      catch_error();
 END insert_sale;
/

CREATE OR REPLACE procedure insert_price(PriceDate DATE,
                                        ProvidersPrice Number,
                                        SaleMarkUp Number) 
                                  IS
                                    DateEx EXCEPTION;
                                    PriceEx EXCEPTION;
BEGIN
  if PriceDate > SYSDATE then
    raise DateEx;
  end if;
  
  if providersprice <= 0 then
    raise PriceEx;
  end if;
  
  INSERT INTO priceList VALUES(Null,PriceDate,ProvidersPrice,SaleMarkUp,
                                        ProvidersPrice*(100+SaleMarkUp)/100);
  commit;
  exception
  when DateEx then
      save_error('insert_price', 'date is not valid');
      RAISE_APPLICATION_ERROR(-20001,'date is not valid');
    
   when PriceEx then
        save_error('insert_price', 'Price can not be less then 0');
        RAISE_APPLICATION_ERROR(-20003,'Price can not be less then 0');
   
    when others then
      catch_error();
 END insert_price;
/


CREATE OR REPLACE procedure insert_provider(Name VARCHAR2,
                                            Adress VARCHAR2,
                                            Phone VARCHAR2) IS
BEGIN
  INSERT INTO providers VALUES(null,Name,Adress,Phone);
  commit;
  exception
    when others then
      catch_error();
 END insert_provider;
/

CREATE OR REPLACE procedure insert_order(ItemID Number,
                                        ProviderId Number,
                                        Qty Number,
                                        OrderDate Date) 
                                    IS
                                        DateEx EXCEPTION;
                                        AmountEx EXCEPTION;
BEGIN
  if OrderDate > SYSDATE then
    raise DateEx;
  end if;
  
  if Qty <= 0 then
    raise AmountEx;
  end if;
  INSERT INTO orders VALUES(null,ItemID,ProviderID,Qty,OrderDate);
  commit;
  exception
    when DateEx then
        save_error('insert_order', 'date is not valid');
        RAISE_APPLICATION_ERROR(-20001,'date is not valid');
    when AmountEx then
        save_error('insert_order', 'Amount can not be less then 0');
        RAISE_APPLICATION_ERROR(-20002,'Amount can not be less then 0');
    
    when others then
      catch_error();
 END insert_order;
/

CREATE OR REPLACE procedure insert_invoice(OrderID Number,
                                          DateInvoice Date,
                                          AmountDelivery Number,
                                          CostPrice Number) 
                                      IS
                                        DateEx EXCEPTION;
                                        AmountEx EXCEPTION;
                                        PriceEx EXCEPTION;
BEGIN

if dateinvoice > SYSDATE then
    raise DateEx;
  end if;
  
  if amountdelivery <= 0 then
    raise AmountEx;
  end if;
  
  if costprice <= 0 then
    raise PriceEx;
  end if;
  
  INSERT INTO invoices VALUES(null,OrderID, DateInvoice, AmountDelivery,CostPrice);
  commit;
  exception
    when DateEx then
        save_error('insert_invoice', 'date is not valid');
        RAISE_APPLICATION_ERROR(-20001,'date is not valid');
    when AmountEx then
        save_error('insert_invoice', 'Amount can not be less then 0');
        RAISE_APPLICATION_ERROR(-20002,'Amount can not be less then 0');
    when PriceEx then
        save_error('insert_invoice', 'Price can not be less then 0');
        RAISE_APPLICATION_ERROR(-20003,'Price can not be less then 0');
    
    when others then
      catch_error();
 END insert_invoice;
/

CREATE OR REPLACE procedure insert_site(InvoiceID Number,
                                        Amount Number) 
                                IS
                                    AmountEx EXCEPTION;
                                        
BEGIN
  if Amount < 0 then
    raise AmountEx;
  end if;
  INSERT INTO sites VALUES(null,InvoiceID,Amount);
  commit;
  exception
    when AmountEx then
          save_error('insert_site', 'Amount can not be less then 0');
          RAISE_APPLICATION_ERROR(-20002,'Amount can not be less then 0');
    
    when others then
      catch_error();
 END insert_site;
/

create or replace procedure insert_item_in_catalog(providerPrice_ number, 
                                                    SaleMarkUp_ number, 
                                                    PriceDate_ Date,
                                                    site_id number,
                                                    amount number) IS 
  DateEx EXCEPTION;
  AmountEx EXCEPTION;
  PriceEx EXCEPTION;
  price_id number;
begin
  if PriceDate_ > SYSDATE then
    raise DateEx;
  end if;
  
  if amount < 0 then
    raise AmountEx;
  end if;
  
  if providerPrice_ <= 0 then
    raise PriceEx;
  end if;

  insert_price(PriceDate_, providerprice_, salemarkup_);
  price_id := price_seq.currval;
  insert into catalogOfgoods values(null,price_id, site_id, amount);
 
  exception
    when DateEx then
      save_error('insert_item_in_catalog', 'date is not valid');
      RAISE_APPLICATION_ERROR(-20001,'date is not valid');
    when AmountEx then
        save_error('insert_item_in_catalog', 'Amount can not be less then 0');
        RAISE_APPLICATION_ERROR(-20002,'Amount can not be less then 0');
    when PriceEx then
        save_error('insert_item_in_catalog', 'Price can not be less then 0');
        RAISE_APPLICATION_ERROR(-20003,'Price can not be less then 0');
    when others then
      catch_error();
end insert_item_in_catalog;
/