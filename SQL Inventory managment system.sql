create database Inventory_Structure;
Use inventory_structure;

--creating supplier table
create table supplier (SID varchar(5) primary key, sname varchar (30) not null, sadd varchar (50) not null, 
scity varchar (20) check(scity='delhi'), sphone varchar (10) unique, email varchar (50) not null);

--creating product table
create table product (PID varchar (5) primary key, pdesc varchar (20) not null, price money check(price>0), 
category varchar (5) check (category in ('it','ha','hc')), SID varchar (5) references supplier(SID));

--creating stock table
create table stock (PID varchar (5) references product(PID), SQTY int check (sqty>=0), ROL int check (ROL>0), MOQ int check (MOQ>=5));

--creating Customer table
create table customer (CID varchar (5) primary key, cname varchar (30) not null, address varchar (50) not null, 
city varchar (20) not null, phone varchar (10) not null, email varchar (50) not null, DOB date check (DOB<'2000-01-01'));

--creating orders table
create table orders (OID varchar (5) primary key, Odate date not null, PID varchar (5) references product(PID), 
CID varchar (5) references customer(CID), Oqty int check (Oqty>=1));

--creating a view for Bill: bill_view
create view bill_view as
select OID, Odate, cname, address, customer.phone, Pdesc, Price, Oqty, price*oqty as Amount 
from orders join customer on customer.CID=orders.CID join product on orders.PID=product.PID;

select * from orders

--creating procedure to insert values in supplier table. autofill the SID
alter sequence seqsup
restart with 1
increment by 1;

alter procedure addsupplier 
@sname as varchar (30),
@sadd as varchar (50),
@scity as varchar (20),
@sphone as varchar (10),
@email as varchar (50)
as
begin
declare @num as int, @SID as varchar (10)
set @num=(next value for seqsup)
if @num<10
set @sid=concat('S000',@num)
else if @num<100
set @sid=concat('S00',@num)
else if @num<1000
set @sid=concat('S0',@num)
else
set @sid=concat('S',@num)
insert into supplier values (@sid,@sname,@sadd,@scity,@sphone,@email)
select * from supplier
end;

--creating procedure to insert values in product table. autofill the PID
alter sequence seqpro
restart with 1
increment by 1;

alter procedure addproduct
@pdesc as varchar (20),
@price as money,
@category as varchar (5),
@SID as varchar (5)
as
begin
declare @num as int, @PID as varchar (10)
set @num=(next value for seqpro)
if @num<10
set @pid=concat('P000',@num)
else if @num<100
set @PID=concat('P00',@num)
else if @num<1000
set @pid=concat('P0',@num)
else
set @pid=concat('P',@num)
insert into product values (@PID,@pdesc,@price,@category,@SID)
select * from product
end;

--creating procedure to insert values in customer table
create procedure addstock
@PID as varchar (5),
@Sqty as int,
@ROL as int,
@MOQ as int
as
begin
insert into stock values (@PID,@Sqty,@Rol,@Moq)
select * from stock
end;


--creating procedure to insert values in customer table
alter sequence seqcus
restart with 1
increment by 1;


alter procedure addcustomer
@cname as varchar (30),
@address as varchar (30),
@city as varchar (30),
@phone as varchar (10),
@email as varchar (50),
@dob as date
as
begin
declare @num as int, @CID as varchar (10)
set @num=(next value for seqcus)
if @num<10
set @CID=concat('C000',@num)
else if @num<100
set @CID=concat('C00',@num)
else if @num<1000
set @CID=concat('C0',@num)
else
set @CID=concat('C',@num)
insert into customer values (@cid,@cname,@address,@city,@phone,@email,@dob)
select * from customer
end;

--creating procedure to insert values in orders table
alter sequence seqord
restart with 1
increment by 1

alter procedure addorders
@PID as varchar (5),
@CID as varchar (5),
@Oqty as int
as
begin
declare @num as int, @OID as varchar (10)
set @num=(next value for seqord)
if @num<10
set @OID=concat('O000',@num)
else if @num<100
set @Oid=concat('O00',@num)
else if @num<1000
set @OID=concat('O0',@num)
else
set @OID=concat('O',@num)
insert into orders values (@OID,getdate(),@PID,@CID,@Oqty)
select * from orders
end;

--creating trigger on orders table to deduct stock each time an order is placed.
select * from stock
select * from orders

alter trigger trg_stock
on orders
for insert
as
begin
declare @pid as varchar (5), @Oqty as int
select @PID=Pid, @Oqty=Oqty from inserted
update stock set SQTY=SQTY-@Oqty where Pid=@pid
end;

select * from supplier
select * from product
select * from stock
select * from customer
select * from orders

--inserting values into supplier table
addsupplier 'Vivek Singh','Moti Nagar','Delhi','9868783345','vivek.singh@gmail.com'
addsupplier 'Madhuram Sinha','Palam','Delhi','9871560988','msinha23@yahoo.com'
addsupplier 'Digambar Prasad','Karampura','Delhi','8876994512','digambarprasad1984@yahoo.com'
addsupplier 'Neeraj Shridhar','Patel Nagar','Delhi','7438863017','shridharneeraj@gmail.com'
addsupplier 'Vishal Pandey','Hari Nagar','Delhi','9990355667','vshlpndy@gmail.com';

--inserting values into product table
Addproduct 'Smartphone', 15000, 'IT', 'S0001'
Addproduct 'Washing Machine', 22000, 'HA', 'S0002'
Addproduct 'Blood Pressure Monitor', 2500, 'HC', 'S0003'
Addproduct 'Home Theater System', 25000, 'IT', 'S0004'
Addproduct 'Laptop', 55000, 'IT', 'S0001'
Addproduct 'Mixer Grinder', 4000, 'HA', 'S0005'
Addproduct 'Air Conditioner', 35000, 'HA', 'S0002'
Addproduct 'Smart TV', 45000, 'IT', 'S0001'
Addproduct 'Digital Thermometer', 500, 'HC', 'S0003'
Addproduct 'Microwave Oven', 10000, 'HA', 'S0002'
Addproduct 'Electric Toothbrush', 3500, 'HC', 'S0003'
Addproduct 'Bluetooth Speaker', 5000, 'IT', 'S0001'
Addproduct 'Refrigerator', 30000, 'HA', 'S0002'
Addproduct 'Pulse Oximeter', 1500, 'HC', 'S0003'
Addproduct 'Headphones', 2000, 'IT', 'S0004'
Addproduct 'Water Purifier', 12000, 'HA', 'S0005'
Addproduct 'Vacuum Cleaner', 8000, 'HA', 'S0002'
Addproduct 'Glucose Meter', 3000, 'HC', 'S0003'
Addproduct 'Gaming Console', 45000, 'IT', 'S0001'
Addproduct 'First Aid Kit', 1200, 'HC', 'S0003'


--inserting values into stock table
Addstock 'P0001', 120, 50, 20
Addstock 'P0002', 30, 15, 10
Addstock 'P0003', 200, 75, 25
Addstock 'P0004', 50, 20, 10
Addstock 'P0005', 40, 15, 10
Addstock 'P0006', 60, 25, 15
Addstock 'P0007', 25, 10, 5
Addstock 'P0008', 70, 30, 15
Addstock 'P0009', 300, 100, 30
Addstock 'P0010', 80, 35, 15
Addstock 'P0011', 150, 60, 20
Addstock 'P0012', 100, 40, 15
Addstock 'P0013', 35, 15, 10
Addstock 'P0014', 250, 90, 30
Addstock 'P0015', 90, 40, 15
Addstock 'P0016', 50, 20, 10
Addstock 'P0017', 45, 20, 10
Addstock 'P0018', 180, 70, 25
Addstock 'P0019', 25, 10, 5
Addstock 'P0020', 300, 100, 30

--inserting values into customer table
Addcustomer 'Rajesh Kumar', 'Azadpur', 'Delhi', '9812345670', 'rajesh.kumar@gmail.com', '1995-06-15'
Addcustomer 'Priya Sharma', 'Chandpole', 'Jaipur', '9876543210', 'priya.sharma@yahoo.com', '1998-09-10'
Addcustomer 'Amit Singh', 'MP Nagar', 'Bhopal', '9753124680', 'amit.singh@gmail.com', '1996-11-22'
Addcustomer 'Suman Reddy', 'Madhapur', 'Hyderabad', '9988776655', 'suman.reddy@yahoo.com', '1997-03-04'
Addcustomer 'Vikas Verma', 'Indrapuri', 'Indore', '9812345678', 'vikas.verma@gmail.com', '1993-02-12'
Addcustomer 'Sunita Patel', 'Sayajigunj', 'Vadodara', '9955321432', 'sunita.patel@yahoo.com', '1994-07-30'
Addcustomer 'Deepak Gupta', 'Sadar Bazar', 'Meerut', '9998877665', 'deepak.gupta@gmail.com', '1991-08-05'
Addcustomer 'Neha Agarwal', 'Tajganj', 'Agra', '9723146598', 'neha.agarwal@yahoo.com', '1999-12-18'
Addcustomer 'Ravi Kumar', 'Mithapur', 'Patna', '9654321789', 'ravi.kumar@gmail.com', '1995-05-25'
Addcustomer 'Seema Joshi', 'Hazratganj', 'Lucknow', '9832156789', 'seema.joshi@yahoo.com', '1992-01-28'
Addcustomer 'Rajani Nair', 'Palarivattom', 'Kochi', '9675891234', 'rajani.nair@gmail.com', '1990-10-14'
Addcustomer 'Manoj Mehta', 'Kothrud', 'Pune', '9743125609', 'manoj.mehta@yahoo.com', '1994-02-22'
Addcustomer 'Anjali Yadav', 'Govind Nagar', 'Kanpur', '9684153720', 'anjali.yadav@gmail.com', '1997-04-03'
Addcustomer 'Arun Patel', 'Althan', 'Surat', '9456721908', 'arun.patel@yahoo.com', '1996-08-17'
Addcustomer 'Sneha Saini', 'New Friends Colony', 'Delhi', '9967450231', 'sneha.saini@gmail.com', '1993-05-10'
Addcustomer 'Karan Thakur', 'Sector 15', 'Faridabad', '9865324710', 'karan.thakur@yahoo.com', '1998-06-23'
Addcustomer 'Madhuri Das', 'Salt Lake City', 'Kolkata', '9741627389', 'madhuri.das@gmail.com', '1994-09-19'
Addcustomer 'Harish Joshi', 'Sector 37', 'Chandigarh', '9546273810', 'harish.joshi@yahoo.com', '1991-11-05'
Addcustomer 'Rina Bhattacharya', 'Bhadauri', 'Patiala', '9806123456', 'rina.bhattacharya@gmail.com', '1996-01-12'
Addcustomer 'Sandeep Rathi', 'Ramdaspeth', 'Nagpur', '9823764590', 'sandeep.rathi@yahoo.com', '1997-07-25'

--inserting values into stock table
Addorders 'P0001', 'C0005', 10
Addorders 'P0004', 'C0006', 20
Addorders 'P0009', 'C0009', 12
Addorders 'P0001', 'C0010', 22
Addorders 'P0003', 'C0007', 5
Addorders 'P0006', 'C0002', 3
Addorders 'P0004', 'C0003', 10
Addorders 'P0003', 'C0005', 6
Addorders 'P0005', 'C0009', 15
Addorders 'P0008', 'C0008', 25
Addorders 'P0005', 'C0008', 5
Addorders 'P0008', 'C0001', 17
Addorders 'P0007', 'C0010', 8
Addorders 'P0010', 'C0004', 10
Addorders 'P0004', 'C0003', 11
Addorders 'P0010', 'C0001', 12
Addorders 'P0010', 'C0002', 20
Addorders 'P0002', 'C0009', 14
