--roles--
CREATE OR REPLACE procedure insert_role(priority_ number, discription_ VARCHAR2) IS
BEGIN
  INSERT INTO roles VALUES(null,priority_, discription_);
  commit;
 END insert_role;
/

CREATE OR REPLACE procedure update_role(id_ number, priority_ number, description_ VARCHAR2) IS
BEGIN
  UPDATE roles set priority=priority_, description=description_
  WHERE ID=id_;
  commit;
 END update_role;
/

CREATE OR REPLACE procedure delete_role(id_ number) IS
BEGIN
  DELETE FROM roles 
  WHERE ID=id_;
  commit;
 END delete_role;
/

-----------------------------------------------------------
--users--

CREATE OR REPLACE procedure insert_user(roleID_ number, 
                                        Login_ VARCHAR2, 
                                        Password_ VARCHAR2) IS
BEGIN
  INSERT INTO users VALUES(null,roleID_, Login_, Password_);
  commit;
 END insert_user;
/

CREATE OR REPLACE procedure update_user(id_ number, 
                                        roleID_ number, 
                                        Login_ VARCHAR2, 
                                        Password_ VARCHAR2) IS
BEGIN
  UPDATE users set ID=roleID_, Login=Login_, Password=Password_
  WHERE ID=id_;
  commit;
 END update_user;
/

CREATE OR REPLACE procedure delete_user(id_ number, 
                                        Login_ VARCHAR2, 
                                        Password_ VARCHAR2) IS
BEGIN
  if id_ is NULL then
    delete from users
    where Login=Login_ and Password=Password_;
  else
  delete from users
    where ID=id_;
  end if;
  commit;
 END delete_user;
/
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

CREATE OR REPLACE procedure update_item(id_ number, 
                                        Name_ VARCHAR2, 
                                        Type_ VARCHAR2, 
                                        Notes_ VARCHAR2) IS
BEGIN
  UPDATE items set Name=Name_, Type=Type_, Notes=Notes_
  WHERE ID=id_;
  commit;
 END update_item;
/

CREATE OR REPLACE procedure delete_item(id_ number) IS
BEGIN
  delete from items
    where ID=id_;
  commit;
 END delete_item;
/

----------------------------------------------------------
--salesTable--

CREATE OR REPLACE procedure insert_sale(UserID Number, 
                                        ItemID Number, 
                                        SalesDate Date, 
                                        SalesAmount Number, 
                                        ItemPrice Number) IS
BEGIN
  INSERT INTO salesTable VALUES(Null, UserID, ItemID, SalesDate, SalesAmount, ItemPrice);
  commit;
 END insert_sale;
/

CREATE OR REPLACE procedure update_sale(id_ Number, 
                                        UserID_ Number, 
                                        ItemID_ Number,
                                        SalesDate_ Date, 
                                        SalesAmount_ Number, 
                                        ItemPrice_ Number) IS
BEGIN
  UPDATE salesTable set UserID=UserID_, 
                        ItemID=ItemID_, 
                        SalesDate=SalesDate_, 
                        salesamount=SalesAmount_, 
                        itemprice=ItemPrice_
  WHERE ID=id_;
  commit;
 END update_sale;
/

--CREATE OR REPLACE procedure delete_sale(id_ number) IS
--BEGIN
--  delete from salesTable
--    where SaleID=id_;
--  commit;
-- END delete_sale;
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

CREATE OR REPLACE procedure update_price(GoodID_ NUMBER,
                                        DatePrice_ DATE,
                                        ProvidersPrice_ Number,
                                        SaleMarkUp_ Number) IS
BEGIN
  UPDATE priceList set DatePrice=DatePrice_,
                       ProvidersPrice=ProvidersPrice_,
                       SaleMarkUp=SaleMarkUp_,
                       SalesPrice=ProvidersPrice_*(100+SaleMarkUp_)/100
  WHERE ID=GoodID_;
  commit;
 END update_price;
/

CREATE OR REPLACE procedure delete_price(id_ number) IS
BEGIN
  delete from priceList
    where ID=id_;
  commit;
 END delete_price;
/

-----------------------------------------------------------------------

--catalogOfGoods--

CREATE OR REPLACE procedure insert_catalog(PriceListID Number,
                                            ItemID Number,
                                            Amount Number) IS
BEGIN
  INSERT INTO catalogOfGoods VALUES(null,PriceListID,ItemID,Amount);
  commit;
 END insert_catalog;
/

CREATE OR REPLACE procedure update_catalog(GoodID_ NUMBER,
                                            PriceListID_ Number,
                                            ItemID_ Number,
                                            Amount_ Number) IS
BEGIN
  UPDATE catalogOfGoods set ItemID=ItemID_,
                            PriceListID=PriceListID_,
                            Amount=Amount_ 
  WHERE ID=GoodID_;
  commit;
 END update_catalog;
/

CREATE OR REPLACE procedure delete_catalog(id_ number) IS
BEGIN
  delete from catalogOfGoods
    where ID=id_;
  commit;
 END delete_catalog;
/

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
BEGIN
  delete from providers
    where ID=id_;
  commit;
 END delete_provider;
/
-----------------------------------------------------------------------


--orders--

CREATE OR REPLACE procedure insert_order(ItemID Number,
                                        ProviderId Number,
                                        Qty Number,
                                        OrderDate Date) IS
BEGIN
  INSERT INTO orders VALUES(null,ItemID,ProviderID,Qty,OrderDate);
  commit;
 END insert_order;
/

CREATE OR REPLACE procedure update_order(OrderID_ NUMBER,
                                        ItemID_ Number,
                                        ProviderId_ Number,
                                        Qty_ Number,
                                        OrderDate_ Date) IS
BEGIN
  UPDATE orders set  ItemID=ItemID_,
                     ProviderId=ProviderId_,
                     Qty=Qty_,
                     OrderDate=OrderDate_
  WHERE ID=OrderID_;
  commit;
 END update_order;
/

--CREATE OR REPLACE procedure delete_order(id_ number) IS
--BEGIN
--  delete from orders
--    where OrderID=id_;
--  commit;
-- END delete_order;
--/

-----------------------------------------------------------------------

--invoices--

CREATE OR REPLACE procedure insert_invoice(OrderID Number,
                                          DateInvoice Date,
                                          AmountDelivery Number,
                                          CostPrice Number) IS
BEGIN
  INSERT INTO invoices VALUES(null,OrderID, DateInvoice, AmountDelivery,CostPrice);
  commit;
 END insert_invoice;
/

CREATE OR REPLACE procedure update_invoice(InvoiceID_ NUMBER,
                                          OrderID_ Number,
                                          DateInvoice_ Date,
                                          AmountDelivery_ Number,
                                          CostPrice_ Number) IS
BEGIN
  UPDATE invoices set  OrderID=OrderID_,
                      DateInvoice=DateInvoice_,
                       AmountDelivery=AmountDelivery_,
                       CostPrice=CostPrice_
  WHERE ID=InvoiceID_;
  commit;
 END update_invoice;
/

--CREATE OR REPLACE procedure delete_invoice(id_ number) IS
--BEGIN
--  delete from invoices
--    where InvoiceID=id_;
--  commit;
-- END delete_invoice;
--/

-----------------------------------------------------------------------


--sites--

CREATE OR REPLACE procedure insert_site(ItemID Number,
                                        InvoiceID Number,
                                        Amount Number) IS
BEGIN
  INSERT INTO sites VALUES(null,ItemID,InvoiceID,Amount);
  commit;
 END insert_site;
/

CREATE OR REPLACE procedure update_site(PlaceID_ NUMBER,
                                        ItemID_ Number,
                                        InvoiceID_ Number,
                                        Amount_ Number) IS
BEGIN
  UPDATE sites set  ItemID=ItemID_,
                    InvoiceID=InvoiceID_,
                    Amount=Amount_
  WHERE ID=PlaceID_;
  commit;
 END update_site;
/

CREATE OR REPLACE procedure delete_site(id_ number) IS
BEGIN
  delete from sites
    where ID=id_;
  commit;
 END delete_site;
/

-----------------------------------------------------------------------

