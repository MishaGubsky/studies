drop SEQUENCE site_seq;
create SEQUENCE site_seq;

drop table sites;
CREATE TABLE sites (
  PlaceID NUMBER PRIMARY KEY,
  ItemID Number,
  InvoiceID Number,
  Amount Number,
  DateDelivery Date,
  CONSTRAINT fk_site_invoice foreign key(InvoiceID) REFERENCES invoices,
  CONSTRAINT fk_site_item foreign key(ItemID) REFERENCES items
);
/

CREATE OR REPLACE TRIGGER site_trigger
BEFORE INSERT ON users FOR EACH ROW
BEGIN
:NEW.PlaceID := site_seq.NEXTVAL;
END;
/

  

--CREATE OR REPLACE TRIGGER sales_PRICE_trigger
--AFTER INSERT ON user FOR EACH ROW
--BEGIN
--:NEW.SalesPrice := :OLD.ProvidersPrice*:OLD.SaleMarkUp;
--END;
--/