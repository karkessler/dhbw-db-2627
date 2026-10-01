-- -----------------------------------------------
-- Übung 3: ERM für ein Flugbuchungssystem
--
-- Aufgabe:
-- Erstellen Sie ein ERM für ein Buchungssystem einer Fluggesellschaft.
-- Beachten Sie dabei:
-- * Ein Flug hat eine eindeutige Flugnummer und eine Abflugzeit.
-- * Ein Flugsteig hat eine eindeutige Nummer und eine Ortsbezeichnung.
-- * Passagiere besitzen Tickets mit eindeutiger Ticketnummer.
-- * Ein Sitzplatz ist nur zusammen mit seiner Flugnummer eindeutig.
-- * Jeder Sitzplatz ist einem Flug zugeordnet und ist Raucher- oder
--   Nichtraucherplatz.
-- * Jeder Flug wird an genau einem Flugsteig abgefertigt; ein Flugsteig
--   kann viele Flüge abfertigen.
-- * Jedes Ticket gehört zu genau einem Flug und genau einem Sitzplatz.
-- * Ein Sitzplatz kann leer sein oder von genau einem Passagier belegt sein.
--
-- Musterloesung:
-- Sitzplatz ist eine schwache Entitaet. Sein Schluessel besteht aus
-- (FlugNr, Sitznummer). Ticket ist eine eigene Entitaet, damit ein
-- Passagier mehrere Tickets besitzen kann.
-- -----------------------------------------------

USE db_uebungen;

DROP TABLE IF EXISTS Tickets;
DROP TABLE IF EXISTS Sitzplaetze;
DROP TABLE IF EXISTS Fluege;
DROP TABLE IF EXISTS Passagiere;
DROP TABLE IF EXISTS Flugsteige;

-- Starke Entitaet: Flugsteig
CREATE TABLE Flugsteige (
    FlugsteigNr INT PRIMARY KEY,
    Ort VARCHAR(100) NOT NULL
);

-- Starke Entitaet: Flug
-- Jeder Flug wird an genau einem Flugsteig abgefertigt.
CREATE TABLE Fluege (
    FlugNr INT PRIMARY KEY,
    Abflugdatum DATE NOT NULL,
    Abflugzeit TIME NOT NULL,
    FlugsteigNr INT NOT NULL,
    FOREIGN KEY (FlugsteigNr) REFERENCES Flugsteige(FlugsteigNr)
);

-- Starke Entitaet: Passagier
CREATE TABLE Passagiere (
    PassagierID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL
);

-- Schwache Entitaet: Sitzplatz
-- Sitznummer ist nur innerhalb eines Flugs eindeutig.
CREATE TABLE Sitzplaetze (
    FlugNr INT NOT NULL,
    Sitznummer VARCHAR(5) NOT NULL,
    Raucherplatz BOOLEAN NOT NULL,
    PRIMARY KEY (FlugNr, Sitznummer),
    FOREIGN KEY (FlugNr) REFERENCES Fluege(FlugNr)
        ON DELETE CASCADE,
    CHECK (Raucherplatz IN (0, 1))
);

-- Ein Ticket ordnet genau einen Passagier einem Sitzplatz eines Flugs zu.
-- Der zusammengesetzte Fremdschluessel stellt sicher, dass Sitzplatz und
-- Flug im Ticket zusammenpassen. UNIQUE verhindert eine Doppelbelegung.
CREATE TABLE Tickets (
    TicketNr INT PRIMARY KEY,
    PassagierID INT NOT NULL,
    FlugNr INT NOT NULL,
    Sitznummer VARCHAR(5) NOT NULL,
    FOREIGN KEY (PassagierID) REFERENCES Passagiere(PassagierID),
    FOREIGN KEY (FlugNr, Sitznummer)
        REFERENCES Sitzplaetze(FlugNr, Sitznummer)
        ON DELETE CASCADE,
    UNIQUE (FlugNr, Sitznummer)
);

-- -----------------------------------------------
-- Beispieldaten
-- -----------------------------------------------
INSERT INTO Flugsteige (FlugsteigNr, Ort) VALUES
    (1, 'Terminal 1, Bereich A'),
    (2, 'Terminal 1, Bereich B');

INSERT INTO Fluege (FlugNr, Abflugdatum, Abflugzeit, FlugsteigNr) VALUES
    (1001, '2026-10-01', '08:30:00', 1),
    (1002, '2026-10-01', '11:15:00', 2);

INSERT INTO Passagiere (PassagierID, Name) VALUES
    (1, 'Anna Berger'),
    (2, 'Ben Fischer');

INSERT INTO Sitzplaetze (FlugNr, Sitznummer, Raucherplatz) VALUES
    (1001, '1A', 0),
    (1001, '1B', 0),
    (1001, '2A', 1),
    (1002, '1A', 0);

INSERT INTO Tickets (TicketNr, PassagierID, FlugNr, Sitznummer) VALUES
    (50001, 1, 1001, '1A'),
    (50002, 2, 1001, '1B'),
    (50003, 1, 1002, '1A');

-- -----------------------------------------------
-- Kontrollabfragen
-- -----------------------------------------------

-- Alle belegten Sitzplaetze mit Passagier, Flug und Flugsteig
SELECT
    t.TicketNr,
    p.Name AS Passagier,
    f.FlugNr,
    f.Abflugdatum,
    f.Abflugzeit,
    fs.Ort AS Flugsteig,
    t.Sitznummer,
    s.Raucherplatz
FROM Tickets t
JOIN Passagiere p ON p.PassagierID = t.PassagierID
JOIN Fluege f ON f.FlugNr = t.FlugNr
JOIN Flugsteige fs ON fs.FlugsteigNr = f.FlugsteigNr
JOIN Sitzplaetze s
    ON s.FlugNr = t.FlugNr
   AND s.Sitznummer = t.Sitznummer
ORDER BY f.FlugNr, t.Sitznummer;

-- Auch freie Sitzplaetze eines Flugs anzeigen
SELECT
    s.FlugNr,
    s.Sitznummer,
    s.Raucherplatz,
    p.Name AS Passagier
FROM Sitzplaetze s
LEFT JOIN Tickets t
    ON t.FlugNr = s.FlugNr
   AND t.Sitznummer = s.Sitznummer
LEFT JOIN Passagiere p ON p.PassagierID = t.PassagierID
WHERE s.FlugNr = 1001
ORDER BY s.Sitznummer;

-- -----------------------------------------------
-- Aufgaben zur Kontrolle der Constraints
-- -----------------------------------------------

-- Scheitert: Der Sitzplatz 1A des Flugs 1001 ist bereits belegt.
-- INSERT INTO Tickets (TicketNr, PassagierID, FlugNr, Sitznummer)
-- VALUES (50004, 2, 1001, '1A');

-- Scheitert: Der Sitzplatz 9Z existiert nicht fuer Flug 1001.
-- INSERT INTO Tickets (TicketNr, PassagierID, FlugNr, Sitznummer)
-- VALUES (50004, 2, 1001, '9Z');

-- Fuehren Sie aus und pruefen Sie anschliessend, dass die Sitzplaetze und
-- Tickets des Flugs 1002 durch ON DELETE CASCADE entfernt wurden:
-- DELETE FROM Fluege WHERE FlugNr = 1002;

-- -----------------------------------------------
-- Uebung 3, Zusatzaufgabe: ERM fuer einen Hardware-Onlineshop
--
-- Aufgabe:
-- Modellieren Sie Artikel, Komplettsysteme und Komponenten fuer einen
-- Hardware-Onlineshop. Jeder Artikel ist entweder Komplettsystem oder
-- Komponente, nie beides. Komplettsysteme sind Notebooks oder Desktop-PCs;
-- Komponenten sind Prozessoren oder Grafikkarten. Ein Komplettsystem besteht
-- aus mehreren Komponenten, und ein Komponentenmodell kann in mehreren
-- Komplettsystemen verbaut sein und wird auch einzeln verkauft.
--
-- Musterloesung:
-- * Notebook, Desktop-PC, Prozessor und Grafikkarte sind is-a-Untertypen.
-- * Die Tabelle SystemKomponenten bildet is-part-of als n:m-Aggregation ab.
--   Es handelt sich nicht um eine Komposition, da Komponenten eigenstaendig
--   verkauft werden und ohne Komplettsystem weiter existieren.
-- -----------------------------------------------

DROP TABLE IF EXISTS SystemKomponenten;
DROP TABLE IF EXISTS Notebooks;
DROP TABLE IF EXISTS DesktopPCs;
DROP TABLE IF EXISTS Prozessoren;
DROP TABLE IF EXISTS Grafikkarten;
DROP TABLE IF EXISTS Komplettsysteme;
DROP TABLE IF EXISTS Komponenten;
DROP TABLE IF EXISTS Artikel;

-- Obertyp aller verkauften Artikel.
-- ArtikelArt bildet die disjunkte Spezialisierung auf der ersten Ebene ab.
CREATE TABLE Artikel (
    ArtikelNr INT PRIMARY KEY,
    Bezeichnung VARCHAR(100) NOT NULL,
    Preis DECIMAL(10, 2) NOT NULL CHECK (Preis >= 0),
    ArtikelArt VARCHAR(20) NOT NULL,
    CHECK (ArtikelArt IN ('KOMPLETTSYSTEM', 'KOMPONENTE')),
    UNIQUE (ArtikelNr, ArtikelArt)
);

-- Untertypen von Artikel.
-- ArtikelArt als Teil des Fremdschluessels verhindert eine Zuordnung zum
-- falschen Zweig der Spezialisierung.
CREATE TABLE Komplettsysteme (
    ArtikelNr INT PRIMARY KEY,
    ArtikelArt VARCHAR(20) NOT NULL DEFAULT 'KOMPLETTSYSTEM',
    CHECK (ArtikelArt = 'KOMPLETTSYSTEM'),
    UNIQUE (ArtikelNr, ArtikelArt),
    FOREIGN KEY (ArtikelNr, ArtikelArt)
        REFERENCES Artikel(ArtikelNr, ArtikelArt)
);

CREATE TABLE Komponenten (
    ArtikelNr INT PRIMARY KEY,
    ArtikelArt VARCHAR(20) NOT NULL DEFAULT 'KOMPONENTE',
    CHECK (ArtikelArt = 'KOMPONENTE'),
    UNIQUE (ArtikelNr, ArtikelArt),
    FOREIGN KEY (ArtikelNr, ArtikelArt)
        REFERENCES Artikel(ArtikelNr, ArtikelArt)
);

-- Untertypen von Komplettsystem.
CREATE TABLE Notebooks (
    ArtikelNr INT PRIMARY KEY,
    ArtikelArt VARCHAR(20) NOT NULL DEFAULT 'KOMPLETTSYSTEM',
    DisplaygroesseZoll DECIMAL(4, 1) NOT NULL CHECK (DisplaygroesseZoll > 0),
    FOREIGN KEY (ArtikelNr, ArtikelArt)
        REFERENCES Komplettsysteme(ArtikelNr, ArtikelArt)
);

CREATE TABLE DesktopPCs (
    ArtikelNr INT PRIMARY KEY,
    ArtikelArt VARCHAR(20) NOT NULL DEFAULT 'KOMPLETTSYSTEM',
    Gehaeusetyp VARCHAR(50) NOT NULL,
    FOREIGN KEY (ArtikelNr, ArtikelArt)
        REFERENCES Komplettsysteme(ArtikelNr, ArtikelArt)
);

-- Untertypen von Komponente.
CREATE TABLE Prozessoren (
    ArtikelNr INT PRIMARY KEY,
    ArtikelArt VARCHAR(20) NOT NULL DEFAULT 'KOMPONENTE',
    TaktfrequenzGHz DECIMAL(4, 2) NOT NULL CHECK (TaktfrequenzGHz > 0),
    FOREIGN KEY (ArtikelNr, ArtikelArt)
        REFERENCES Komponenten(ArtikelNr, ArtikelArt)
);

CREATE TABLE Grafikkarten (
    ArtikelNr INT PRIMARY KEY,
    ArtikelArt VARCHAR(20) NOT NULL DEFAULT 'KOMPONENTE',
    GrafikspeicherGB INT NOT NULL CHECK (GrafikspeicherGB > 0),
    FOREIGN KEY (ArtikelNr, ArtikelArt)
        REFERENCES Komponenten(ArtikelNr, ArtikelArt)
);

-- is-part-of: Ein Komplettsystem kann mehrere Komponenten enthalten und ein
-- Komponentenmodell kann in mehreren Komplettsystemen verwendet werden.
CREATE TABLE SystemKomponenten (
    KomplettsystemNr INT NOT NULL,
    KomponentenNr INT NOT NULL,
    Anzahl INT NOT NULL CHECK (Anzahl > 0),
    PRIMARY KEY (KomplettsystemNr, KomponentenNr),
    FOREIGN KEY (KomplettsystemNr) REFERENCES Komplettsysteme(ArtikelNr),
    FOREIGN KEY (KomponentenNr) REFERENCES Komponenten(ArtikelNr)
);

-- -----------------------------------------------
-- Beispieldaten
-- -----------------------------------------------
INSERT INTO Artikel (ArtikelNr, Bezeichnung, Preis, ArtikelArt) VALUES
    (101, 'DHBW Notebook 14', 999.00, 'KOMPLETTSYSTEM'),
    (102, 'DHBW Desktop Tower', 1299.00, 'KOMPLETTSYSTEM'),
    (201, 'Prozessor X8', 249.00, 'KOMPONENTE'),
    (202, 'Grafikkarte G12', 499.00, 'KOMPONENTE');

INSERT INTO Komplettsysteme (ArtikelNr) VALUES
    (101),
    (102);

INSERT INTO Komponenten (ArtikelNr) VALUES
    (201),
    (202);

INSERT INTO Notebooks (ArtikelNr, DisplaygroesseZoll) VALUES
    (101, 14.0);

INSERT INTO DesktopPCs (ArtikelNr, Gehaeusetyp) VALUES
    (102, 'Midi-Tower');

INSERT INTO Prozessoren (ArtikelNr, TaktfrequenzGHz) VALUES
    (201, 3.80);

INSERT INTO Grafikkarten (ArtikelNr, GrafikspeicherGB) VALUES
    (202, 12);

INSERT INTO SystemKomponenten (KomplettsystemNr, KomponentenNr, Anzahl) VALUES
    (101, 201, 1),
    (102, 201, 1),
    (102, 202, 1);

-- -----------------------------------------------
-- Kontrollabfragen
-- -----------------------------------------------

-- Komponenten eines Komplettsystems
SELECT
    ks.Bezeichnung AS Komplettsystem,
    k.Bezeichnung AS Komponente,
    sk.Anzahl
FROM SystemKomponenten sk
JOIN Artikel ks ON ks.ArtikelNr = sk.KomplettsystemNr
JOIN Artikel k ON k.ArtikelNr = sk.KomponentenNr
ORDER BY ks.ArtikelNr, k.ArtikelNr;

-- Alle einzeln verkaufbaren Komponenten mit ihrem spezifischen Merkmal
SELECT
    a.ArtikelNr,
    a.Bezeichnung,
    a.Preis,
    p.TaktfrequenzGHz,
    g.GrafikspeicherGB
FROM Artikel a
JOIN Komponenten k ON k.ArtikelNr = a.ArtikelNr
LEFT JOIN Prozessoren p ON p.ArtikelNr = k.ArtikelNr
LEFT JOIN Grafikkarten g ON g.ArtikelNr = k.ArtikelNr
ORDER BY a.ArtikelNr;

-- Scheitert: Artikel 101 ist ein Komplettsystem und keine Komponente.
-- INSERT INTO Komponenten (ArtikelNr) VALUES (101);

-- Hinweis zur totalen Spezialisierung:
-- Die Tabellenstruktur erzwingt die disjunkten Zweige ueber ArtikelArt.
-- Dass jeder Artikel auch wirklich einen Eintrag in seinem Untertyp und
-- jeder Komplettsystem-/Komponenten-Eintrag genau einen Blattuntertyp besitzt,
-- wird bei tabellenweiser Vererbung in Standard-SQL typischerweise durch
-- Transaktionen mit Triggern oder durch die Anwendung sichergestellt.
