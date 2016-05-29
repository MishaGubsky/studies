--roles--
CREATE OR REPLACE procedure insert_role(discription_ VARCHAR2) IS
BEGIN
  INSERT INTO roles VALUES(null, discription_);
  commit;
 END insert_role;
/

-----------------------------------------------------------
--users--
--
--CREATE OR REPLACE procedure insert_user(roleID_ number, 
--                                        Login_ VARCHAR2, 
--                                        Password_ VARCHAR2) IS
--BEGIN
--  INSERT INTO users VALUES(null,roleID_, Login_, Password_);
--  commit;
-- END insert_user;
--/
--------------------------------------------------------
--items--

CREATE OR REPLACE procedure insert_item(Name_ VARCHAR2, 
                                        Type_ VARCHAR2, 
                                        Notes_ VARCHAR2) IS
BEGIN
  INSERT INTO items VALUES(Null, Name_, Type_, Notes_);
  commit;
 END insert_item;
/

----------------------------------------------------------
--salesTable--

--CREATE OR REPLACE procedure insert_sale(UserID Number, 
--                                        ItemID Number, 
--                                        SalesDate Date, 
--                                        SalesAmount Number, 
--                                        ItemPrice Number) IS
--BEGIN
--  INSERT INTO salesTable VALUES(Null, UserID, ItemID, SalesDate, SalesAmount, ItemPrice);
--  commit;
-- END insert_sale;
--/

--------------------------------------------------------------------
--PriceList--

CREATE OR REPLACE procedure insert_price(DatePrice DATE,
                                        ProvidersPrice Number,
                                        SaleMarkUp Number) IS
BEGIN
  INSERT INTO priceList VALUES(Null,DatePrice,ProvidersPrice,SaleMarkUp,
                                        ProvidersPrice*(100+SaleMarkUp)/100);
  commit;
 END insert_price;
/
-----------------------------------------------------------------------

--catalogOfGoods--

--CREATE OR REPLACE procedure insert_catalog(PriceListID Number,
--                                            ItemID Number,
--                                            Amount Number) IS
--BEGIN
--  INSERT INTO catalogOfGoods VALUES(null,PriceListID,ItemID,Amount);
--  commit;
-- END insert_catalog;
--/

-----------------------------------------------------------------------


--providers--

CREATE OR REPLACE procedure insert_provider(Name VARCHAR2,
                                            Adress VARCHAR2,
                                            Phone VARCHAR2) IS
BEGIN
  INSERT INTO providers VALUES(null,Name,Adress,Phone);
  commit;
 END insert_provider;
/
-----------------------------------------------------------------------


--orders--

--CREATE OR REPLACE procedure insert_order(ItemID Number,
--                                        ProviderId Number,
--                                        Qty Number,
--                                        OrderDate Date) IS
--BEGIN
--  INSERT INTO orders VALUES(null,ItemID,ProviderID,Qty,OrderDate);
--  commit;
-- END insert_order;
--/


-----------------------------------------------------------------------

--invoices--
--
--CREATE OR REPLACE procedure insert_invoice(OrderID Number,
--                                          DateInvoice Date,
--                                          AmountDelivery Number,
--                                          CostPrice Number) IS
--BEGIN
--  INSERT INTO invoices VALUES(null,OrderID, DateInvoice, AmountDelivery,CostPrice);
--  commit;
-- END insert_invoice;
--/

-----------------------------------------------------------------------

--
----sites--
--
--CREATE OR REPLACE procedure insert_site(ItemID Number,
--                                        InvoiceID Number,
--                                        Amount Number) IS
--BEGIN
--  INSERT INTO sites VALUES(null,ItemID,InvoiceID,Amount);
--  commit;
-- END insert_site;
--/
-------------------------------------------------------------------------

