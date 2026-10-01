-- ---------------------------------------------------------------------
-- Datenbanken 3, Uebung 1: is-a und is-part-of
--
-- Artikel ist der Obertyp. Komplettsystem und Komponente sind disjunkte
-- Untertypen. Notebook, Desktop-PC, Prozessor und Grafikkarte sind deren
-- weitere Untertypen. SystemKomponenten bildet die n:m-Beziehung ab.
-- ---------------------------------------------------------------------

USE db_uebungen;

-- Zuerst abhaengige Tabellen, danach ihre Obertypen loeschen.
DROP TABLE IF EXISTS SystemKomponenten;
DROP TABLE IF EXISTS Notebooks;
DROP TABLE IF EXISTS DesktopPCs;
DROP TABLE IF EXISTS Prozessoren;
DROP TABLE IF EXISTS Grafikkarten;
DROP TABLE IF EXISTS Komplettsysteme;
DROP TABLE IF EXISTS Komponenten;
DROP TABLE IF EXISTS Artikel;

-- Obertyp: Bezeichnung und Preis werden nur hier gespeichert.
CREATE TABLE Artikel (
    ArtikelNr INT PRIMARY KEY,
    Bezeichnung VARCHAR(100) NOT NULL,
    Preis DECIMAL(10, 2) NOT NULL CHECK (Preis >= 0),
    ArtikelArt VARCHAR(20) NOT NULL,
    CHECK (ArtikelArt IN ('KOMPLETTSYSTEM', 'KOMPONENTE')),
    UNIQUE (ArtikelNr, ArtikelArt)
);

-- Erste Stufe der Spezialisierung.
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

-- is-part-of: Ein Komplettsystem kann mehrere Komponenten enthalten und
-- eine Komponente kann in mehreren Komplettsystemen verbaut sein.
CREATE TABLE SystemKomponenten (
    SystemNr INT NOT NULL,
    KomponentenNr INT NOT NULL,
    Anzahl INT NOT NULL CHECK (Anzahl > 0),
    PRIMARY KEY (SystemNr, KomponentenNr),
    FOREIGN KEY (SystemNr) REFERENCES Komplettsysteme(ArtikelNr),
    FOREIGN KEY (KomponentenNr) REFERENCES Komponenten(ArtikelNr)
);

-- Beispieldaten
INSERT INTO Artikel (ArtikelNr, Bezeichnung, Preis, ArtikelArt) VALUES
    (101, 'Notebook 14 Zoll', 999.00, 'KOMPLETTSYSTEM'),
    (102, 'Desktop-PC Tower', 1299.00, 'KOMPLETTSYSTEM'),
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

INSERT INTO SystemKomponenten (SystemNr, KomponentenNr, Anzahl) VALUES
    (101, 201, 1),
    (102, 201, 1),
    (102, 202, 1);

-- Kontrollabfrage: Komponenten eines Komplettsystems.
SELECT
    s.Bezeichnung AS Komplettsystem,
    k.Bezeichnung AS Komponente,
    sk.Anzahl
FROM SystemKomponenten sk
JOIN Artikel s ON s.ArtikelNr = sk.SystemNr
JOIN Artikel k ON k.ArtikelNr = sk.KomponentenNr
ORDER BY s.ArtikelNr, k.ArtikelNr;

-- Alle Artikel mit dem gemeinsamen Attributen des Obertyps.
SELECT ArtikelNr, Bezeichnung, Preis, ArtikelArt
FROM Artikel
ORDER BY ArtikelNr;

-- Komplettsysteme mit ihrem jeweiligen Untertyp.
SELECT
    a.ArtikelNr,
    a.Bezeichnung,
    a.Preis,
    CASE
        WHEN n.ArtikelNr IS NOT NULL THEN 'Notebook'
        WHEN d.ArtikelNr IS NOT NULL THEN 'Desktop-PC'
    END AS Typ,
    n.DisplaygroesseZoll,
    d.Gehaeusetyp
FROM Artikel a
JOIN Komplettsysteme ks ON ks.ArtikelNr = a.ArtikelNr
LEFT JOIN Notebooks n ON n.ArtikelNr = ks.ArtikelNr
LEFT JOIN DesktopPCs d ON d.ArtikelNr = ks.ArtikelNr
ORDER BY a.ArtikelNr;

-- Einzeln verkaufbare Komponenten mit ihrem jeweiligen Untertyp.
SELECT
    a.ArtikelNr,
    a.Bezeichnung,
    a.Preis,
    CASE
        WHEN p.ArtikelNr IS NOT NULL THEN 'Prozessor'
        WHEN g.ArtikelNr IS NOT NULL THEN 'Grafikkarte'
    END AS Typ,
    p.TaktfrequenzGHz,
    g.GrafikspeicherGB
FROM Artikel a
JOIN Komponenten k ON k.ArtikelNr = a.ArtikelNr
LEFT JOIN Prozessoren p ON p.ArtikelNr = k.ArtikelNr
LEFT JOIN Grafikkarten g ON g.ArtikelNr = k.ArtikelNr
ORDER BY a.ArtikelNr;
