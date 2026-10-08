-- -----------------------------------------------
-- Szenario: Relationale Algebra
-- Eigenstaendiges Testschema fuer MySQL 8.4.
-- Dieses gesamte Setup bis einschliesslich der INSERTs einmal ausfuehren,
-- bevor einzelne Abfragen weiter unten ausgefuehrt werden.
-- -----------------------------------------------
-- CREATE DATABASE IF NOT EXISTS db_uebungen5;
USE db_uebungen5;

-- Tabellen fuer einen reproduzierbaren, vom Grundschema getrennten Testlauf.
DROP TABLE IF EXISTS Senioren;
DROP TABLE IF EXISTS Vorlesungen;
DROP TABLE IF EXISTS Assistenten;
DROP TABLE IF EXISTS Doktoranden;
DROP TABLE IF EXISTS Angestellte;
DROP TABLE IF EXISTS Studenten;
DROP TABLE IF EXISTS Professoren;
DROP TABLE IF EXISTS Hochschulen;

CREATE TABLE Hochschulen (
    HSNr INTEGER PRIMARY KEY,
    Bezeichnung VARCHAR(50) NOT NULL
);

CREATE TABLE Studenten (
    MatNr INTEGER PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Semester INTEGER,
    besuchtHS INTEGER,
    FOREIGN KEY (besuchtHS) REFERENCES Hochschulen (HSNr)
);

CREATE TABLE Professoren (
    PersNr INTEGER PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Rang VARCHAR(50),
    Raum INTEGER
);

CREATE TABLE Vorlesungen (
    VorlNr INTEGER PRIMARY KEY,
    Titel VARCHAR(50) NOT NULL,
    SWS INTEGER,
    gelesenVon INTEGER NOT NULL,
    FOREIGN KEY (gelesenVon) REFERENCES Professoren (PersNr)
);

CREATE TABLE Assistenten (
    PersNr INTEGER PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Fachgebiet VARCHAR(50),
    istVorgesetzter INTEGER,
    FOREIGN KEY (istVorgesetzter) REFERENCES Professoren (PersNr)
);

CREATE TABLE Angestellte (
    PersNr INTEGER PRIMARY KEY,
    Name VARCHAR(50) NOT NULL
);

CREATE TABLE Doktoranden (
    PersNr INTEGER PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Thema VARCHAR(100),
    FOREIGN KEY (PersNr) REFERENCES Angestellte (PersNr)
);

INSERT INTO Hochschulen (HSNr, Bezeichnung) VALUES
    (11, 'DHBW Stuttgart'),
    (55, 'Hochschule Franken');

INSERT INTO Studenten (MatNr, Name, Semester, besuchtHS) VALUES
    (1, 'Anna', 1, 11),
    (2, 'Peter', 5, 55),
    (3, 'Peter', 5, 55);

INSERT INTO Professoren (PersNr, Name, Rang, Raum) VALUES
    (12, 'Oswald', 'Professor', 101),
    (13, 'Heinz', 'Professor', 102);

INSERT INTO Vorlesungen (VorlNr, Titel, SWS, gelesenVon) VALUES
    (123, 'Funktionalanalysis', 4, 13),
    (456, 'Maßtheorie', 6, 13),
    (789, 'Partielle DGL', 4, 12);

INSERT INTO Assistenten (PersNr, Name, Fachgebiet, istVorgesetzter) VALUES
    (98, 'Franz', 'Wahrscheinlichkeitstheorie', 13),
    (99, 'Anna', 'Analysis', 12);

INSERT INTO Angestellte (PersNr, Name) VALUES
    (60, 'Franz'),
    (61, 'Anna');

INSERT INTO Doktoranden (PersNr, Name, Thema) VALUES
    (60, 'Franz', 'Wahrscheinlichkeitstheorie'),
    (61, 'Anna', 'Analysis');

-- -----------------------------------------------
-- 1. Selection:
SELECT Semester, Name FROM Studenten WHERE Semester = 5;

-- 2. Projektion:
SELECT Semester, Name FROM Studenten;
-- DISTINCT entfernt doppelte Ergebniszeilen, falls die Projektion Duplikate enthaelt.
SELECT DISTINCT Semester, Name FROM Studenten;

-- 3. Kreuzprodukt:
SELECT * FROM Studenten CROSS JOIN Professoren;
SELECT * FROM Studenten, Professoren;

-- 4. Vereinigung (Union):
SELECT PersNr, Name FROM Assistenten
UNION
SELECT PersNr, Name FROM Doktoranden; -- (Projektion inklusive)
 
 -- 5. Differenz (Minus):
SELECT PersNr, Name FROM Doktoranden
EXCEPT
SELECT PersNr, Name FROM Assistenten;
SELECT * FROM Doktoranden WHERE Name NOT IN (SELECT Name FROM Assistenten);

-- Franz auch in die Doktorranden:
INSERT INTO Angestellte (PersNr, Name)
SELECT 70, 'Doktorand'
WHERE NOT EXISTS (SELECT 1 FROM Angestellte WHERE PersNr = 70);
INSERT INTO Doktoranden (PersNr, Name, Thema)
SELECT 70, 'Franz', 'Überabzählbar unendliche Teilmengen'
WHERE NOT EXISTS (SELECT 1 FROM Doktoranden WHERE PersNr = 70);
-- --------------------------
SELECT * FROM Assistenten WHERE Name NOT IN (SELECT Name FROM Doktoranden); -- -> Leer!

-- 6. Umbenennung im Abfrageergebnis, ohne das Grundschema zu veraendern:
SELECT Thema AS NeuName FROM Doktoranden;

-- -----------------------------------------------

-- INNER JOIN:
SELECT p.Name, v.Titel FROM Professoren p INNER JOIN Vorlesungen v ON p.PersNr = v.gelesenVon;
SELECT p.Name, p.Raum FROM Professoren p INNER JOIN Vorlesungen v ON p.PersNr = v.gelesenVon;

-- Mehrere Tabellen joinen:
SELECT p.Name as ProfName, v.Titel as VorlTitel, a.Name Assi FROM Professoren p 
INNER JOIN Vorlesungen v ON p.PersNr = v.gelesenVon
INNER JOIN Assistenten a  on a.istVorgesetzter = p.PersNr
where v.Titel = "Maßtheorie";

-- LEFT OUTER JOIN:
SELECT * FROM Professoren p LEFT OUTER JOIN Vorlesungen v ON p.PersNr = v.gelesenVon;

-- RIGHT OUTER JOIN:
SELECT * FROM Professoren p RIGHT OUTER JOIN Vorlesungen v ON p.PersNr = v.gelesenVon;

-- FULL OUTER JOIN (in MySQL mit 2 Joins)
SELECT * FROM Professoren p LEFT OUTER JOIN Vorlesungen v ON p.PersNr = v.gelesenVon
UNION
SELECT * FROM Professoren p RIGHT OUTER JOIN Vorlesungen v ON p.PersNr = v.gelesenVon;
-- NATURAL JOIN:
DROP TABLE IF EXISTS Senioren;
CREATE TABLE Senioren (
    MatNr INTEGER PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Semester INTEGER,
    HSNr INTEGER,
    CONSTRAINT Senioren_Hochschulen_FK
        FOREIGN KEY (HSNr) REFERENCES Hochschulen (HSNr)
);

INSERT INTO Senioren (MatNr, Name, Semester, HSNr)
VALUES (100, 'Se1', 1, 55),
       (102, 'Se2', 1, 55),
       (103, 'Paul', 1, 55);

-- Natural Join
SELECT * FROM Hochschulen NATURAL JOIN Senioren;

-- INTERSECTION (Schnittmenge):
SELECT Name FROM Assistenten
INTERSECT
SELECT Name FROM Doktoranden;

-- Gruppierung und Aggregatfunktion
SELECT Semester as Semester, COUNT(*) as Anzahl FROM Studenten group by Semester;

-- Sortierung 
SELECT * FROM Studenten order by Name desc;

-- --- auf Folien bezogen:

-- Folie 6: Konjunktion
SELECT * FROM Studenten WHERE Semester = 5 AND Name = 'Peter';

-- Folie 10: Richtung wie auf der Folie
SELECT PersNr, Name FROM Assistenten
EXCEPT
SELECT PersNr, Name FROM Doktoranden;

-- Folie 11: dauerhafte Umbenennung (und zurück)
ALTER TABLE Doktoranden RENAME COLUMN Thema TO NeuThema;
ALTER TABLE Doktoranden RENAME COLUMN NeuThema TO Thema;

-- Folie 13: Theta-Joins
SELECT * FROM Professoren p INNER JOIN Vorlesungen v ON p.PersNr < v.gelesenVon;
SELECT * FROM Professoren p INNER JOIN Vorlesungen v ON p.PersNr > v.gelesenVon;

-- Folie 14: LEFT JOIN mit Ungleichheit
SELECT * FROM Professoren p LEFT OUTER JOIN Vorlesungen v ON p.PersNr <> v.gelesenVon;

-- Folie 18: Schnittmenge per IN
SELECT * FROM Doktoranden WHERE Name IN (SELECT Name FROM Assistenten);

-- Folie 22: SUM als Aggregat
SELECT gelesenVon, SUM(SWS) AS SWS_gesamt, COUNT(*) AS Anzahl
FROM Vorlesungen GROUP BY gelesenVon;

-- Folien 25/29: Ausführungsplan
EXPLAIN SELECT p.Name, v.Titel FROM Professoren p
INNER JOIN Vorlesungen v ON p.PersNr = v.gelesenVon WHERE v.SWS = 4;
EXPLAIN FORMAT=TREE SELECT p.Name, v.Titel FROM Professoren p
INNER JOIN Vorlesungen v ON p.PersNr = v.gelesenVon WHERE v.SWS = 4;

-- Folie 27: Tupelkalkül
SELECT * FROM Professoren WHERE Rang = 'Professor';
