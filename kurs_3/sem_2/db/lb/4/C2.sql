--1

CREATE TABLE mytable (
  ID NUMBER, 
  val NUMBER
);
/

--2

BEGIN
  FOR j IN 1..10000 loop
    INSERT INTO mytable VALUES(j, round(dbms_random.VALUE*1000));
  END loop;
  --  INSERT INTO mytable VALUES(4, round(dbms_random.VALUE*1000));
  --  INSERT INTO mytable VALUES(4, round(dbms_random.VALUE*1000));

END;
/

--3

CREATE OR REPLACE FUNCTION isevenmore RETURN CHAR IS
  even NUMBER:=0;
BEGIN
  SELECT count(ID) INTO even FROM mytable
  WHERE mod(val,2)=0;
  dbms_output.put_line('count of even number='||even);
  IF even=(10000-even) THEN
    RETURN 'Equal';
  elsif even< 10000-even THEN
    RETURN 'FALSE';
  ELSE
    RETURN 'TRUE';
  END IF;
 END isevenmore;
/

--4

CREATE OR REPLACE FUNCTION insert_string(id_ number) RETURN CHAR IS
 val_ number;
BEGIN
  val_:=round(dbms_random.VALUE*1000);
  INSERT INTO mytable VALUES(id_, val_);
  commit;
  dbms_output.put_line('insert into mytable values('||to_char(id_)||', '||val_||');');
  return val_;
 END insert_string;
/

--5

CREATE OR REPLACE procedure insert_mytable(id_ number, val_ number) IS
BEGIN
  if val_<0 then 
    INSERT INTO mytable VALUES(id_, round(dbms_random.VALUE*1000));
  else
    INSERT INTO mytable VALUES(id_, val_);
  end if;
  commit;
 END insert_mytable;
/

CREATE OR REPLACE procedure delete_mytable(id_ number, val_ number) IS
BEGIN
  if id_<1 then
    delete from mytable
    where val=val_;
  else
    delete from mytable
    where id=id_ and val=val_;
  end if;
  commit;
 END delete_mytable;
/

CREATE OR REPLACE procedure update_mytable(id_ number, old_val number, new_val number) IS
BEGIN
  if id_<1 then
    update mytable set val=new_val
    where val=old_val;
  else
    update mytable set val=new_val
    where id=id_ and val=old_val;
  end if;
  commit;
 END update_mytable;
/



--tests

declare
 x varchar(10);
 answer number;
BEGIN  
  --3
  dbms_output.put_line(isevenmore());
  
  --4
  SELECT '&¬ведите_строку' INTO x FROM dual;
  answer:=insert_string(TO_NUMBER(x));
  
  --5
  insert_mytable(15, 23);
  
  update_mytable(15, 23, 7);
  
  delete_mytable(x, answer);
END;
/
