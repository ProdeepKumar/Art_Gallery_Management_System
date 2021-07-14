-- Dropping tables
drop table Customer;
drop table Artist;
drop table Painting;


-- Creating tables
create table Painting(
    p_id number(3) not null,
    p_title varchar(10) not null,
    p_year varchar(10) not null,
    p_url varchar(20) not null,
    primary key(p_id)
);

create table Artist(
    a_id number(3) not null,
    a_name varchar(10) not null,
    a_address varchar(10) not null,
    a_phn varchar(10) not null,
    primary key(a_id),
    foreign key(a_id) references Painting(p_id) on delete cascade
);

create table Customer(
    c_id number(3) not null,
    c_name varchar(10) not null,
    c_address varchar(10) not null,
    p_id number(3) not null,
    c_phone varchar(10) not null,
    c_cost number(10) not null,
    primary key(c_id),
    foreign key(p_id) references Painting(p_id) on delete cascade
);

-- Inserting values into tables
insert into Painting values(1,'Nature','2015','www.nature.com');
insert into Painting values(2,'River','2016','www.river.com');
insert into Painting values(3,'Mountain','2020','www.mountain.com');
insert into Painting values(4,'Woman','2017','www.woman.com');
insert into Painting values(5,'Sky','2021','www.sky.com');

insert into Artist values(1,'Ramisha','Dhaka','9584652');
insert into Artist values(2,'Tabassum','Shylet','9821152');
insert into Artist values(3,'Lubna','Chattogram','9845125');
insert into Artist values(4,'Subah','Rajshahi','9823564');
insert into Artist values(5,'Marium','Barishal','9824513');

insert into Customer values(1,'Rahim','Rajshahi',3,'98542156',5000);
insert into Customer values(2,'Karim','Rajshahi',5,'98542121',6000);
insert into Customer values(3,'Babul','Dhaka',3,'98542112',10000);
insert into Customer values(4,'Habib','Khulna',4,'98542165',9000);
insert into Customer values(5,'Jahid','Barishal',3,'98542198',5000);
insert into Customer values(6,'Priyo','Khulna',2,'98542148',4000);
insert into Customer values(7,'Polash','Chattogram',1,'98542195',8000);
insert into Customer values(8,'Nokib','Dhaka',4,'98542128',4000);
insert into Customer values(9,'Munna','Pabna',5,'98542129',5000);
insert into Customer values(10,'Rahul','Dinajpur',4,'98542130',3000);


-- See all values of all tables 
select * from Artist;
select * from Painting;
select * from Customer;

-- Altering table for adding new column 
alter table Artist add age number(5);

describe Artist;

-- Altering table for moditying the datatype of a row
alter table Customer modify p_id number(5);

describe Customer;

-- Altering table for dropping a column
alter table Artist drop column age;

describe Artist;

-- Altering table to rename a column
alter table Artist rename column a_phn to a_phone;

describe Artist;

-- Updating table to change an existing value
update Painting set p_year='2018' where p_title='Woman';

select * from Painting;

-- Deleting a row
-- delete from Customer where c_name='Nokib';

select * from Customer;

-- Delete operation after assigning primary key and foreign key
-- delete from Painting where p_id=3;

select * from Artist;
select * from Painting;
select * from Customer;

-- Aliasign of relations
select cu.c_name,cu.c_phone,art.a_name,art.a_phone 
from Customer cu, Artist art where cu.c_address='Rajshahi' and
art.a_address='Dhaka';

-- Subquery
select P.p_title as Title, P.p_year as Drown_In from Painting P where P.p_id
in(
    select cu.p_id from Customer cu where cu.c_address
    in(
        select Artist.a_address from Artist where Artist.a_name='Lubna' or Artist.a_name='Subah'
    )
);

-- Set operation(Union,Intersection,Minus)
-- Union all
select a_id,a_address from Artist
union all
select p_id,c_address from Customer;

-- Union
select a_address from Artist
union
select c_address from Customer;

-- Intersection
select a_address from Artist
intersect
select c_address from Customer;

-- Minus
select a_address from Artist
minus
select c_address from Customer;

-- Join operation

select cu.c_name,cu.c_address,p.p_title from
Customer cu join Painting p
on p.p_id=cu.p_id;

-- We can use USING replacing ON if the common attribute are of same name
select cu.c_name,cu.c_address,p.p_title from
Customer cu join Painting p
using(p_id);  

-- Natural Join 
select cu.c_name,cu.c_address,p.p_title from
Customer cu natural join Painting p;

-- Inner Join 
select cu.c_name,cu.c_address,p.p_title from
Customer cu inner join Painting p
on p.p_id=cu.p_id;

-- Cross Join 
select cu.c_name,cu.c_address,p.p_title from
Customer cu cross join Painting p;

-- Left Outer Join 
select cu.c_name,cu.c_address,p.p_title from
Customer cu left outer join Painting p
on p.p_id=cu.p_id;

-- Right Outer Join 
select cu.c_name,cu.c_address,p.p_title from
Customer cu right outer join Painting p
on p.p_id=cu.p_id;

-- Full Outer Join 
select cu.c_name,cu.c_address,p.p_title from
Customer cu full outer join Painting p
on p.p_id=cu.p_id;

-- PL/SQL
-- Finding the maximum sell price of the arts
set serveroutput on
declare
    max_cost Customer.c_cost%type;
begin
    select max(c_cost) into max_cost from Customer;
    dbms_output.put_line('The maximum cost is ' || max_cost);
end;
/

-- Finding which year the perticular art is drown
set serveroutput on
declare
    art_year Painting.p_year%type;
    art_title Painting.p_title%type :='Mountain';
begin
    select p_year into art_year from Painting
    where Painting.p_title=art_title;
    dbms_output.put_line('The art ' || art_title || ' is written in ' || art_year);
end;
/

-- Logic controlling
set serveroutput on
declare
    full_cost Customer.c_cost%type;
    cust_name Customer.c_name%type;
    discunted_cost Customer.c_cost%type;
begin
    cust_name := 'Jahid';
    select c_cost into full_cost from Customer
    where c_name=cust_name;

    if full_cost < 3000 then
            discunted_cost:=full_cost;
    elsif full_cost>=3000 and full_cost<5000 then
            discunted_cost:=full_cost-(full_cost*.2);
    elsif full_cost>=5000 and full_cost<7000 then
            discunted_cost:=full_cost-(full_cost*.3);
    else discunted_cost:=full_cost-(full_cost*.5);
    end if;
dbms_output.put_line('Original cost = ' || full_cost || 
                     ' and discounted cost = ' || round(discunted_cost,2));
exception
 WHEN others THEN
 dbms_output.put_line(SQLERRM);
end;
/
show errors

-- Use of Cursor through loop
-- Show first 5 rows with their name and phone number
set serveroutput on
declare
    cursor cust_cur is
    select c_name,c_phone from Customer;
    cust_record cust_cur%rowtype;
begin
open cust_cur;
    loop
        fetch cust_cur into cust_record;
        exit when cust_cur%rowcount>5;
    dbms_output.put_line('Name : ' || cust_record.c_name || ' Contact : ' || cust_record.c_phone);
    end loop;
    close cust_cur;
end;
/

-- Use of Procedure to find a customer information
set serveroutput on
create or replace procedure getcust is
    cust_name Customer.c_name%type;
    cust_address Customer.c_address%type;
begin
    cust_name:='Polash';
    select c_address into cust_address from Customer
    where c_name=cust_name;
    dbms_output.put_line('Address of '||cust_name||' is '||cust_address);
end;
/
show errors

begin
    getcust;
end;
/

-- Procedure to insert a new record in Customer table
-- The procedure newcust takes all the attributes of Customer table
create or replace procedure newcust (
    new_id Customer.c_id%type,
    new_name Customer.c_name%type,
    new_address Customer.c_address%type,
    new_pid Customer.p_id%type,
    new_phone Customer.c_phone%type,
    new_cost Customer.c_cost%type
) is
begin
    insert into Customer (c_id,c_name,c_address,p_id,c_phone,c_cost)
    values(new_id,new_name,new_address,new_pid,new_phone,new_cost);
    commit;
end newcust;
/
show errors

begin
    newcust(11,'Shanto','Cumilla',1,'98521458',3500);
end;
/
select * from Customer;

