-- -----------------------------------------------
-- - Szenario 2: c-c:
-- - 1. Männer sind mit Frauen verheiratet oder nicht.
-- - 2. Männer und Frauen können nur einmal gleichzeitig verheiratet sein
-- -----------------------------------------------

USE db_uebungen;

-- Bereinigung für eine erneute Ausführung des Skripts.
DROP TABLE IF EXISTS Ehepaar;
DROP TABLE IF EXISTS Frauen;
DROP TABLE IF EXISTS Männer;

-- -----------------------------------------------
create table Männer 
(MaNr integer not null primary key,
Name varchar(50) not null,
Vorname varchar(50) not null);
-- ------------------------
create table Frauen 
(FrNr integer not null primary key,
Name varchar(50) not null,
Vorname varchar(50) not null);
-- ------------------------
create table Ehepaar 
(MaNr integer not null,
FrNr integer not null,
foreign key Ehepaar_Männer_FK (MaNr) references Männer (MaNr),
foreign key Ehepaar_Frauen_FK (FrNr) references Frauen (FrNr),
primary key (MaNr, FrNr));
-- ------------------------
insert into Männer (MaNr, Name, Vorname) 
values (1,'Jan', 'Müller');
insert into Männer (MaNr, Name, Vorname) 
values (2,'Peter', 'Meier');
insert into Männer (MaNr, Name, Vorname) 
values (3,'Jürgen', 'Sturm');
insert into Männer (MaNr, Name, Vorname) 
values (4,'Jens', 'Stark');
insert into Männer (MaNr, Name, Vorname) 
values (5,'Kurt', 'Schmitt');
insert into Männer (MaNr, Name, Vorname) 
values (6,'Oswald', 'Peterson');
insert into Männer (MaNr, Name, Vorname) 
values (7,'Thomas', 'Schneider');
insert into Männer (MaNr, Name, Vorname) 
values (8,'Axel', 'Mertens');
insert into Männer (MaNr, Name, Vorname) 
values (9,'Michael', 'Hofmeister');
insert into Männer (MaNr, Name, Vorname) 
values (10,'Jonas', 'Meerbad');
-- ------------------------
insert into Frauen (FrNr, Name, Vorname) 
values (11,'Julia', 'Bürkle');
insert into Frauen (FrNr, Name, Vorname) 
values (22,'Iris', 'Mittermeier');
insert into Frauen (FrNr, Name, Vorname) 
values (33,'Petra', 'Schnelle');
insert into Frauen (FrNr, Name, Vorname) 
values (44,'Ruth', 'Stör');
insert into Frauen (FrNr, Name, Vorname) 
values (55,'Michaela', 'Herb');
-- ------------------------
insert into Ehepaar (MaNr, FrNr) values (1, 1); -- was bedeutet das?
insert into Ehepaar (MaNr, FrNr) values (1, 2); -- was bedeutet das?
insert into Ehepaar (MaNr, FrNr) values (1, 55); -- was bedeutet das?
insert into Ehepaar (MaNr, FrNr) values (1, 55); -- was bedeutet das?
delete from Ehepaar where MaNr = 1 and FrNr = 55;
insert into Ehepaar (MaNr, FrNr) values (2, 55);
insert into Ehepaar (MaNr, FrNr) values (2, 55);
-- -------------------------
create table Ehepaar 
(MaNr integer not null,
FrNr integer not null,
foreign key Ehepaar_Männer_FK (MaNr) references Männer (MaNr),
foreign key Ehepaar_Frauen_FK (FrNr) references Frauen (FrNr),
primary key (MaNr, FrNr));
-- --------------------------
create table Ehepaar 
(MaNr integer not null,
FrNr integer not null,
foreign key Ehepaar_Frauen_FK (FrNr) references Frauen (FrNr),
primary key (MaNr));
-- -- foreign key Ehepaar_Frauen_FK (FrNr) references Frauen (FrNr) on delete cascade, ---> löscht hier Reference, wenn Frau in Frauen gelöscht
-- --------------------------
-- create table Ehepaar 
-- (MaNr integer not null,
-- FrNr integer not null,
-- foreign key Ehepaar_Männer_FK (MaNr) references Männer (MaNr),
-- foreign key Ehepaar_Frauen_FK (FrNr) references Frauen (FrNr),
-- primary key (MaNr, FrNr));
-- alter table Ehepaar modify column FrNr integer unique;
-- alter table Ehepaar modify column MaNr integer unique;
-- --------------------------
insert into Ehepaar (MaNr, FrNr) values (2, 55); -- was bedeutet das?
insert into Ehepaar (MaNr, FrNr) values (2, 44); -- was bedeutet das?
insert into Ehepaar (MaNr, FrNr) values (2, 11); -- was bedeutet das?
insert into Ehepaar (MaNr, FrNr) values (3, 11);