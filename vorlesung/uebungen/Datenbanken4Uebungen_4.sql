-- -----------------------------------------------
-- Uebung 4: Spezialisierung (is-a) und Komposition (is-part-of)
--
-- Szenario:
-- 1. Eine Person kann Student oder Mitarbeiter sein.
--    Student und Mitarbeiter sind Untertypen von Person (is-a).
-- 2. Ein Rechner besteht aus Komponenten.
--    Eine Komponente ist genau einem Rechner zugeordnet (is-part-of).
-- -----------------------------------------------

USE db_uebungen;

-- -----------------------------------------------
-- Teil 1: is-a
--
-- Aufgabe:
-- Erstellen Sie ein ERM mit Person als Obertyp sowie Student und
-- Mitarbeiter als Untertypen. Welche Attribute gehoeren zum Obertyp,
-- welche zu den Untertypen?
--
-- Umsetzung:
-- Jeder Untertyp verwendet den Primaerschluessel des Obertyps zugleich
-- als Primaer- und Fremdschluessel.
-- -----------------------------------------------
DROP TABLE IF EXISTS StudentenIsA;
DROP TABLE IF EXISTS Mitarbeiter;
DROP TABLE IF EXISTS Personen;

CREATE TABLE Personen (
    PersonenID INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    EMail VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE StudentenIsA (
    PersonenID INT PRIMARY KEY,
    Matrikelnummer INT NOT NULL UNIQUE,
    Studiengang VARCHAR(100) NOT NULL,
    FOREIGN KEY (PersonenID) REFERENCES Personen(PersonenID)
);

CREATE TABLE Mitarbeiter (
    PersonenID INT PRIMARY KEY,
    Personalnummer INT NOT NULL UNIQUE,
    Abteilung VARCHAR(100) NOT NULL,
    FOREIGN KEY (PersonenID) REFERENCES Personen(PersonenID)
);

-- Zuerst muss der zugehoerige Obertyp existieren.
INSERT INTO Personen (PersonenID, Name, EMail)
VALUES (1, 'Anna Berger', 'anna.berger@dhbw.de');
INSERT INTO Personen (PersonenID, Name, EMail)
VALUES (2, 'Ben Fischer', 'ben.fischer@dhbw.de');
INSERT INTO Personen (PersonenID, Name, EMail)
VALUES (3, 'Clara Roth', 'clara.roth@dhbw.de');

INSERT INTO StudentenIsA (PersonenID, Matrikelnummer, Studiengang)
VALUES (1, 10001, 'Informatik');
INSERT INTO Mitarbeiter (PersonenID, Personalnummer, Abteilung)
VALUES (2, 20001, 'IT-Service');

-- Eine Person darf hier gleichzeitig Student und Mitarbeiter sein.
INSERT INTO StudentenIsA (PersonenID, Matrikelnummer, Studiengang)
VALUES (3, 10002, 'Wirtschaftsinformatik');
INSERT INTO Mitarbeiter (PersonenID, Personalnummer, Abteilung)
VALUES (3, 20002, 'Bibliothek');

-- Anzeige aller Studenten mit ihren Daten aus dem Obertyp.
SELECT p.PersonenID, p.Name, s.Matrikelnummer, s.Studiengang
FROM Personen p
JOIN StudentenIsA s ON s.PersonenID = p.PersonenID;

-- -----------------------------------------------
-- Teil 2: is-part-of
--
-- Aufgabe:
-- Modellieren Sie die Komposition "Rechner besteht aus Komponenten".
-- Ein Rechner kann mehrere Komponenten haben. Eine Komponente kann nur
-- Teil eines Rechners sein und soll ohne diesen nicht bestehen bleiben.
--
-- Umsetzung:
-- Der NOT-NULL-Fremdschluessel stellt die obligatorische Zuordnung sicher.
-- ON DELETE CASCADE entfernt beim Loeschen eines Rechners dessen Komponenten.
-- -----------------------------------------------
DROP TABLE IF EXISTS RechnerKomponenten;
DROP TABLE IF EXISTS Rechner;

CREATE TABLE Rechner (
    RechnerID INT PRIMARY KEY,
    Inventarnummer VARCHAR(30) NOT NULL UNIQUE,
    Standort VARCHAR(100) NOT NULL
);

CREATE TABLE RechnerKomponenten (
    KomponentenID INT PRIMARY KEY,
    RechnerID INT NOT NULL,
    Bezeichnung VARCHAR(100) NOT NULL,
    Seriennummer VARCHAR(50) UNIQUE,
    FOREIGN KEY (RechnerID) REFERENCES Rechner(RechnerID)
        ON DELETE CASCADE
);

INSERT INTO Rechner (RechnerID, Inventarnummer, Standort)
VALUES (1, 'PC-1001', 'Raum 201');
INSERT INTO Rechner (RechnerID, Inventarnummer, Standort)
VALUES (2, 'PC-1002', 'Raum 202');

INSERT INTO RechnerKomponenten (KomponentenID, RechnerID, Bezeichnung, Seriennummer)
VALUES (1, 1, 'SSD 1 TB', 'SSD-4711');
INSERT INTO RechnerKomponenten (KomponentenID, RechnerID, Bezeichnung, Seriennummer)
VALUES (2, 1, 'Arbeitsspeicher 16 GB', 'RAM-0815');
INSERT INTO RechnerKomponenten (KomponentenID, RechnerID, Bezeichnung, Seriennummer)
VALUES (3, 2, 'SSD 512 GB', 'SSD-4712');

-- Anzeige der Teile eines Rechners.
SELECT r.Inventarnummer, r.Standort, k.Bezeichnung, k.Seriennummer
FROM Rechner r
JOIN RechnerKomponenten k ON k.RechnerID = r.RechnerID
ORDER BY r.RechnerID, k.KomponentenID;
