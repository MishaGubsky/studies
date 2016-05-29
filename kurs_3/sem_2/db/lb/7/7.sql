drop table log_sites;
drop table log_invoices;
drop table log_orders;
drop table log_providers;
drop table log_catalogOfGoods;
drop table log_priceList;
drop table log_salesTable;
DROP TABLE log_items;
drop table log_users;
drop TABLE log_roles;


CREATE TABLE log_roles (
  Change_time timestamp,
  Change_action VARCHAR2(10),

  ID NUMBER,
  Description VARCHAR2(20) NOT NULL
);
/

CREATE TABLE log_users (
  Change_time timestamp,
  Change_action VARCHAR2(10),

  ID NUMBER,
  RoleID Number NOT NULL,
  Login VARCHAR2(20) NOT NULL,
  Password VARCHAR2(20) NOT NULL
);
/

CREATE TABLE log_items (
  Change_time timestamp,
  Change_action VARCHAR2(10),

  ID NUMBER,
  Name VARCHAR2(20) NOT NULL,
  Type VARCHAR2(20) NOT NULL,
  Notes VARCHAR2(50)
);
/

CREATE TABLE log_salesTable (
  Change_time timestamp,
  Change_action VARCHAR2(10),

  ID NUMBER,
  UserID Number NOT NULL,
  ItemID Number NOT NULL,
  SalesDate DATE NOT NULL,
  SalesAmount Number NOT NULL,
  ItemPrice Number NOT NULL
);
/

CREATE TABLE log_priceList (
  Change_time timestamp,
  Change_action VARCHAR2(10),

  ID NUMBER,
  PriceDate DATE NOT NULL,
  ProvidersPrice Number NOT NULL,
  SaleMarkUp Number NOT NULL,
  SalesPrice Number NOT NULL
);
/

CREATE TABLE log_catalogOfGoods (
  Change_time timestamp,
  Change_action VARCHAR2(10),

  ID NUMBER,
  PriceListID Number NOT NULL,
  SiteID Number NOT NULL,
  Amount Number NOT NULL
);
/

CREATE TABLE log_providers (
  Change_time timestamp,
  Change_action VARCHAR2(10),

  ID NUMBER,
  Name VARCHAR2(30) NOT NULL,
  Adress VARCHAR2(40),
  Phone VARCHAR2(15)
);
/

CREATE TABLE log_orders (
  Change_time timestamp,
  Change_action VARCHAR2(10),

  ID NUMBER,
  ItemID Number NOT NULL,
  ProviderID Number NOT NULL,
  Qty Number NOT NULL,
  OrderDate Date NOT NULL
);
/

CREATE TABLE log_invoices (
  Change_time timestamp,
  Change_action VARCHAR2(10),

  ID NUMBER,
  OrderID Number NOT NULL,
  InvoiceDate Date NOT NULL,
  AmountDelivery Number NOT NULL,
  CostPrice Number NOT NULL
);
/

CREATE TABLE log_sites (
  Change_time timestamp,
  Change_action VARCHAR2(10),

  ID NUMBER,
  InvoiceID Number NOT NULL,
  Amount Number NOT NULL
);
/

-- TRIGGERS

CREATE OR REPLACE TRIGGER roles_table_logger
  AFTER DELETE OR INSERT OR UPDATE ON roles
  FOR EACH ROW
  BEGIN
    CASE
      WHEN DELETING THEN
        INSERT INTO log_roles
          VALUES (current_timestamp, 'DELETE', :old.id, :old.description);
       WHEN UPDATING THEN
        INSERT INTO log_roles
          VALUES (current_timestamp, 'UPDATE', :old.id, :old.description);
      WHEN INSERTING THEN
        INSERT INTO log_roles
          VALUES (current_timestamp, 'INSERT', :new.id, :new.description);
    END CASE;
    
  END;
/

CREATE OR REPLACE TRIGGER users_table_logger
  AFTER DELETE OR INSERT OR UPDATE ON users
  FOR EACH ROW
  BEGIN
    CASE
      WHEN DELETING THEN
      INSERT INTO log_users
          VALUES (current_timestamp, 'DELETE', :old.id, :old.roleId, :old.Login, :old.Password);
       WHEN UPDATING THEN
      INSERT INTO log_users
          VALUES (current_timestamp, 'UPDATE', :old.id, :old.roleId, :old.Login, :old.Password);
      
      WHEN INSERTING THEN
      INSERT INTO log_users
          VALUES (current_timestamp, 'INSERT', :new.id, :new.roleId, :new.Login, :new.Password);
      
    END CASE;
    
  END;
/

CREATE OR REPLACE TRIGGER items_table_logger
  AFTER DELETE OR INSERT OR UPDATE ON items
  FOR EACH ROW
  BEGIN
    CASE
      WHEN DELETING THEN
      INSERT INTO log_items
          VALUES (current_timestamp, 'DELETE', :old.id, :old.Name, :old.Type, :old.Notes);
       WHEN UPDATING THEN
      INSERT INTO log_items
          VALUES (current_timestamp, 'UPDATE', :old.id, :old.Name, :old.Type, :old.Notes);
      
      WHEN INSERTING THEN
      INSERT INTO log_items
          VALUES (current_timestamp, 'INSERT', :new.id, :new.Name, :new.Type, :new.Notes);
    END CASE;
  END;
/

CREATE OR REPLACE TRIGGER sales_table_logger
  AFTER DELETE OR INSERT OR UPDATE ON salesTable
  FOR EACH ROW
  BEGIN
    CASE
      WHEN DELETING THEN
      INSERT INTO log_salesTable
          VALUES (current_timestamp, 'DELETE', :old.id, :old.userId, :old.itemId, :old.salesDate, :old.salesAmount, :old.itemPrice);
       WHEN UPDATING THEN
      INSERT INTO log_salesTable
          VALUES (current_timestamp, 'UPDATE', :old.id, :old.userId, :old.itemId, :old.salesDate, :old.salesAmount, :old.itemPrice);
      
      WHEN INSERTING THEN
      INSERT INTO log_salesTable
          VALUES (current_timestamp, 'INSERT', :new.id, :new.userId, :new.itemId, :new.salesDate, :new.salesAmount, :new.itemPrice);      
    END CASE;
    
  END;
/


CREATE OR REPLACE TRIGGER providers_table_logger
  AFTER DELETE OR INSERT OR UPDATE ON providers
  FOR EACH ROW
  BEGIN
    CASE
      WHEN DELETING THEN
      INSERT INTO log_providers
          VALUES (current_timestamp, 'DELETE', :old.id, :old.Name, :old.Adress, :old.Phone);
       WHEN UPDATING THEN
      INSERT INTO log_providers
          VALUES (current_timestamp, 'UPDATE', :old.id, :old.Name, :old.Adress, :old.Phone);
      
      WHEN INSERTING THEN
      INSERT INTO log_providers
          VALUES (current_timestamp, 'INSERT', :new.id, :new.Name, :new.Adress, :new.Phone);      
    END CASE;
    
  END;
/

CREATE OR REPLACE TRIGGER orders_table_logger
  AFTER DELETE OR INSERT OR UPDATE ON orders
  FOR EACH ROW
  BEGIN
    CASE
      WHEN DELETING THEN
      INSERT INTO log_orders
          VALUES (current_timestamp, 'DELETE', :old.id, :old.itemId, :old.providerId, :old.Qty, :old.OrderDate);
       WHEN UPDATING THEN
      INSERT INTO log_orders
          VALUES (current_timestamp, 'UPDATE', :old.id, :old.itemId, :old.providerId, :old.Qty, :old.OrderDate);
      
      WHEN INSERTING THEN
      INSERT INTO log_orders
          VALUES (current_timestamp, 'INSERT', :new.id, :new.itemId, :new.providerId, :new.Qty, :new.OrderDate);      
    END CASE;
    
  END;
/

CREATE OR REPLACE TRIGGER invoices_table_logger
  AFTER DELETE OR INSERT OR UPDATE ON invoices
  FOR EACH ROW
  BEGIN
    CASE
      WHEN DELETING THEN
      INSERT INTO log_invoices
          VALUES (current_timestamp, 'DELETE', :old.id, :old.orderId, :old.invoiceDate, :old.AmountDelivery, :old.CostPrice);
       WHEN UPDATING THEN
      INSERT INTO log_invoices
          VALUES (current_timestamp, 'UPDATE', :old.id, :old.orderId, :old.invoiceDate, :old.AmountDelivery, :old.CostPrice);
      
      WHEN INSERTING THEN
      INSERT INTO log_invoices
          VALUES (current_timestamp, 'INSERT', :new.id, :new.orderId, :new.invoiceDate, :new.AmountDelivery, :new.CostPrice);      
    END CASE;
    
  END;
/


CREATE OR REPLACE TRIGGER site_table_logger
  AFTER DELETE OR INSERT OR UPDATE ON sites
  FOR EACH ROW
  BEGIN
    CASE
      WHEN DELETING THEN
      INSERT INTO log_sites
          VALUES (current_timestamp, 'DELETE', :old.id, :old.invoiceId, :old.Amount);
       WHEN UPDATING THEN
      INSERT INTO log_sites
          VALUES (current_timestamp, 'UPDATE', :old.id, :old.invoiceId, :old.Amount);
      
      WHEN INSERTING THEN
      INSERT INTO log_sites
          VALUES (current_timestamp, 'INSERT',  :new.id, :new.invoiceId, :new.Amount);      
    END CASE;
    
  END;
/



CREATE OR REPLACE TRIGGER priceList_table_logger
  AFTER DELETE OR INSERT OR UPDATE ON priceList
  FOR EACH ROW
  BEGIN
    CASE
      WHEN DELETING THEN
      INSERT INTO log_priceList
          VALUES (current_timestamp, 'DELETE', :old.id, :old.PriceDate, :old.ProvidersPrice, :old.SaleMarkUp, :old.SalesPrice);
       WHEN UPDATING THEN
      INSERT INTO log_priceList
          VALUES (current_timestamp, 'UPDATE', :old.id, :old.PriceDate, :old.ProvidersPrice, :old.SaleMarkUp, :old.SalesPrice);
      
      WHEN INSERTING THEN
      INSERT INTO log_priceList
          VALUES (current_timestamp, 'INSERT', :new.id, :new.PriceDate, :new.ProvidersPrice, :new.SaleMarkUp, :new.SalesPrice);      
    END CASE;
    
  END;
/

CREATE OR REPLACE TRIGGER catalogOfGoods_table_logger
  AFTER DELETE OR INSERT OR UPDATE ON catalogOfGoods
  FOR EACH ROW
  BEGIN
    CASE
      WHEN DELETING THEN
      INSERT INTO log_catalogOfGoods
          VALUES (current_timestamp, 'DELETE', :old.id, :old.PriceListID, :old.SiteId, :old.Amount);
       WHEN UPDATING THEN
      INSERT INTO log_catalogOfGoods
          VALUES (current_timestamp, 'UPDATE', :old.id, :old.PriceListID, :old.SiteId, :old.Amount);
      
      WHEN INSERTING THEN
      INSERT INTO log_catalogOfGoods
          VALUES (current_timestamp, 'INSERT', :new.id, :new.PriceListID, :new.SiteId, :new.Amount);      
    END CASE;
    
  END;
/

