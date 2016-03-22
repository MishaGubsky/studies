drop table sites;
drop table invoices;
drop table orders;
drop table providers;
drop table catalogOfGoods;
drop table priceList;
drop table salesTable;
DROP TABLE items;
drop table users;
drop TABLE roles;
-----------------------------------------------------
--roles--
drop SEQUENCE role_seq;
create SEQUENCE role_seq;

CREATE TABLE roles (
  ID NUMBER PRIMARY KEY,
  Login VARCHAR2(20) NOT NULL UNIQUE,
  PASSWORD VARCHAR2(20) NOT NULL,
  Description VARCHAR2(20) NOT NULL
);
/

CREATE OR REPLACE TRIGGER role_trigger
BEFORE INSERT ON roles FOR EACH ROW
BEGIN
:NEW.ID := role_seq.NEXTVAL;
END;
/

---------------------------------------------------------
--users--
drop SEQUENCE user_seq;
create SEQUENCE user_seq;

CREATE TABLE users (
  ID NUMBER PRIMARY KEY,
  RoleID Number DEFAULT 3 NOT NULL,
  Login VARCHAR2(20) NOT NULL UNIQUE,
  Password VARCHAR2(20) NOT NULL,
  CONSTRAINT fk_roles foreign key(RoleID) REFERENCES roles(ID)
);
/

CREATE OR REPLACE TRIGGER user_trigger
BEFORE INSERT ON users FOR EACH ROW
BEGIN
:NEW.ID := user_seq.NEXTVAL;
END;
/
---------------------------------------------
--items--
drop SEQUENCE items_seq;
create SEQUENCE items_seq;

CREATE TABLE items (
  ID NUMBER PRIMARY KEY,
  Name VARCHAR2(20) NOT NULL,
  Type VARCHAR2(20) NOT NULL,
  Notes VARCHAR2(50) DEFAULT NULL
);
/


CREATE OR REPLACE TRIGGER items_trigger
BEFORE INSERT ON items FOR EACH ROW
BEGIN
:NEW.ID := items_seq.NEXTVAL;
END;
/

-----------------------------------------------------------
--salesTable--
drop SEQUENCE sales_seq;
create SEQUENCE sales_seq;

CREATE TABLE salesTable (
  ID NUMBER PRIMARY KEY,
  UserID Number NOT NULL,
  ItemID Number NOT NULL,
  SalesDate DATE DEFAULT SYSDATE NOT NULL,
  SalesAmount Number NOT NULL,
  ItemPrice Number NOT NULL,
  CONSTRAINT fk_user foreign key(UserID) REFERENCES users(ID),
  CONSTRAINT fk_item foreign key(ItemID) REFERENCES items(ID)
);
/

CREATE OR REPLACE TRIGGER sales_trigger
BEFORE INSERT ON salesTable FOR EACH ROW
BEGIN
:NEW.ID := sales_seq.NEXTVAL;
END;
/

----------------------------------------------------------
--priceList--
drop SEQUENCE price_seq;
create SEQUENCE price_seq;

CREATE TABLE priceList (
  ID NUMBER PRIMARY KEY,
  DatePrice DATE DEFAULT SYSDATE NOT NULL,
  ProvidersPrice Number NOT NULL,
  SaleMarkUp Number DEFAULT 40 NOT NULL,
  SalesPrice Number NOT NULL
);
/

CREATE OR REPLACE TRIGGER price_trigger
BEFORE INSERT ON priceList FOR EACH ROW
BEGIN
:NEW.ID := price_seq.NEXTVAL;
END;
/

---------------------------------------------------------
--catalogOfGoods--
drop SEQUENCE catalog_seq;
create SEQUENCE catalog_seq;

CREATE TABLE catalogOfGoods (
  ID NUMBER PRIMARY KEY,
  PriceListID Number NOT NULL,
  ItemID Number NOT NULL,
  Amount Number NOT NULL,
  CONSTRAINT fk_catalog_price_list foreign key(PriceListID) REFERENCES priceList(ID),
  CONSTRAINT fk_catalog_item foreign key(ItemID) REFERENCES items(ID)
);
/

CREATE OR REPLACE TRIGGER catalog_trigger
BEFORE INSERT ON catalogOfGoods FOR EACH ROW
BEGIN
:NEW.ID := catalog_seq.NEXTVAL;
END;
/
------------------------------------------------------------
--providers--
drop SEQUENCE provider_seq;
create SEQUENCE provider_seq;

CREATE TABLE providers (
  ID NUMBER PRIMARY KEY,
  Name VARCHAR2(30) NOT NULL UNIQUE,
  Adress VARCHAR2(40) DEFAULT NULL,
  Phone VARCHAR2(15) DEFAULT NULL
);
/

CREATE OR REPLACE TRIGGER provider_trigger
BEFORE INSERT ON providers FOR EACH ROW
BEGIN
:NEW.ID := provider_seq.NEXTVAL;
END;
/
----------------------------------------------------------
--orders--
drop SEQUENCE order_seq;
create SEQUENCE order_seq;


CREATE TABLE orders (
  ID NUMBER PRIMARY KEY,
  ItemID Number NOT NULL,
  ProviderID Number NOT NULL,
  Qty Number NOT NULL,
  OrderDate Date DEFAULT SYSDATE NOT NULL,
  CONSTRAINT fk_order_provider foreign key(ProviderID) REFERENCES providers(ID),
  CONSTRAINT fk_order_item foreign key(ItemID) REFERENCES items(ID)
);
/

CREATE OR REPLACE TRIGGER order_trigger
BEFORE INSERT ON orders FOR EACH ROW
BEGIN
:NEW.ID := order_seq.NEXTVAL;
END;
/
--------------------------------------------------------
--invoices--
drop SEQUENCE invoice_seq;
create SEQUENCE invoice_seq;


CREATE TABLE invoices (
  ID NUMBER PRIMARY KEY,
  OrderID Number NOT NULL,
  DateInvoice Date DEFAULT SYSDATE NOT NULL,
  AmountDelivery Number NOT NULL,
  CostPrice Number NOT NULL,
  CONSTRAINT fk_invoice_order foreign key(OrderID) REFERENCES orders(ID) ON DELETE CASCADE
);
/

CREATE OR REPLACE TRIGGER invoice_trigger
BEFORE INSERT ON invoices FOR EACH ROW
BEGIN
:NEW.ID := invoice_seq.NEXTVAL;
END;
/
----------------------------------------------------------
--sites--
drop SEQUENCE site_seq;
create SEQUENCE site_seq;


CREATE TABLE sites (
  ID NUMBER PRIMARY KEY,
  ItemID Number NOT NULL,
  InvoiceID Number NOT NULL,
  Amount Number NOT NULL,
  CONSTRAINT fk_site_invoice foreign key(InvoiceID) REFERENCES invoices(ID),
  CONSTRAINT fk_site_item foreign key(ItemID) REFERENCES items(ID)
);
/

CREATE OR REPLACE TRIGGER site_trigger
BEFORE INSERT ON sites FOR EACH ROW
BEGIN
:NEW.ID := site_seq.NEXTVAL;
END;
/
-----------------------------------------------------------