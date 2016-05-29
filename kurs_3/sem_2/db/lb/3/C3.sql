drop table catalogOfGoods;
drop table priceList;
drop table sites;
drop table invoices;
drop table orders;
drop table providers;
drop table salesTable;
DROP TABLE items;
drop table users;
drop TABLE roles;
-----------------------------------------------------
--roles--

CREATE TABLE roles (
  ID NUMBER PRIMARY KEY,
  Description VARCHAR2(20) NOT NULL UNIQUE
);
/


---------------------------------------------------------
--users--

CREATE TABLE users (
  ID NUMBER PRIMARY KEY,
  RoleID Number DEFAULT 3 NOT NULL,
  Login VARCHAR2(20) NOT NULL UNIQUE,
  Password VARCHAR2(20) NOT NULL,
  CONSTRAINT fk_roles foreign key(RoleID) REFERENCES roles(ID)
);
/

---------------------------------------------
--items--

CREATE TABLE items (
  ID NUMBER PRIMARY KEY,
  Name VARCHAR2(20) NOT NULL,
  Type VARCHAR2(20) NOT NULL,
  Notes VARCHAR2(50) DEFAULT NULL
);
/



-----------------------------------------------------------
--salesTable--

CREATE TABLE salesTable (
  ID NUMBER PRIMARY KEY,
  UserID Number NOT NULL,
  ItemID Number NOT NULL,
  SalesDate DATE DEFAULT SYSDATE NOT NULL,
  SalesAmount Number NOT NULL,
  ItemPrice Number NOT NULL,
  Complited Number default 0 not null,
  CONSTRAINT fk_user foreign key(UserID) REFERENCES users(ID),
  CONSTRAINT fk_item foreign key(ItemID) REFERENCES items(ID)
);
/


------------------------------------------------------------
--providers--
CREATE TABLE providers (
  ID NUMBER PRIMARY KEY,
  Name VARCHAR2(30) NOT NULL UNIQUE,
  Adress VARCHAR2(40) DEFAULT NULL,
  Phone VARCHAR2(15) DEFAULT NULL
);
/

----------------------------------------------------------
--orders--

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
-------------------------------------------------------
--invoices--

CREATE TABLE invoices (
  ID NUMBER PRIMARY KEY,
  OrderID Number NOT NULL,
  InvoiceDate Date DEFAULT SYSDATE NOT NULL,
  AmountDelivery Number NOT NULL,
  CostPrice Number NOT NULL,
  CONSTRAINT fk_invoice_order foreign key(OrderID) REFERENCES orders(ID)
);
/

----------------------------------------------------------
--sites--
CREATE TABLE sites (
  ID NUMBER PRIMARY KEY,
  InvoiceID Number NOT NULL,
  Amount Number NOT NULL,
  CONSTRAINT fk_site_invoice foreign key(InvoiceID) REFERENCES invoices(ID)
);
/

-----------------------------------------------------------
--priceList--

CREATE TABLE priceList (
  ID NUMBER PRIMARY KEY,
  PriceDate DATE DEFAULT SYSDATE NOT NULL,
  ProvidersPrice Number NOT NULL,
  SaleMarkUp Number DEFAULT 40 NOT NULL,
  SalesPrice Number NOT NULL
);
/

---------------------------------------------------------
--catalogOfGoods--
CREATE TABLE catalogOfGoods (
  ID NUMBER PRIMARY KEY,
  PriceListID Number NOT NULL,
  SiteID Number NOT NULL,
  Amount Number NOT NULL,
  CONSTRAINT fk_catalog_price_list foreign key(PriceListID) REFERENCES priceList(ID),
  CONSTRAINT fk_catalog_site foreign key(SiteID) REFERENCES sites(ID)
);
/

commit;
----------------------------------------------------------