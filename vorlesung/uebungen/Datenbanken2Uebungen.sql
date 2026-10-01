-- =====================================================================
-- Datenbanken 2 – Architektur: SQL zu den Folien 33–38
-- Schema "Vorlesungen" ist bereits angelegt und gefuellt.
-- Komplett ausfuehrbar (MySQL Workbench: "Execute all", Strg+Umschalt+Enter).
-- Nur lesend: 16 SELECT-Abfragen, keine Schema- oder Datenaenderung.
-- Fuer vollstaendige Ergebnisse das Zeilenlimit auf "Don't Limit" stellen.
-- =====================================================================

USE Vorlesungen;

-- ---------------------------------------------------------------------
-- Folie 33 – Dreistellige Relation: BELEGUNG (PNR, KNR, DNR) in P x K x D
-- ---------------------------------------------------------------------

SELECT '33.1 Relation BELEGUNG' AS Abfrage, PNR, KNR, DNR
  FROM BELEGUNG;

SELECT '33.2 Selektion DNR = 7' AS Abfrage, PNR, KNR, DNR, DATUM
  FROM BELEGUNG
 WHERE DNR = 7;

SELECT '33.3 Schluesselspalten' AS Abfrage, COLUMN_NAME, COLUMN_KEY
  FROM information_schema.COLUMNS
 WHERE TABLE_SCHEMA = 'Vorlesungen' AND TABLE_NAME = 'BELEGUNG'
 ORDER BY ORDINAL_POSITION;

-- ---------------------------------------------------------------------
-- Folie 34 – n:m-Beziehung Dozent <-> Kurs, aufgeloest ueber BELEGUNG
-- ---------------------------------------------------------------------

SELECT '34.1 Paare Dozent/Kurs' AS Abfrage, DNR, KNR
  FROM BELEGUNG
 GROUP BY DNR, KNR
 ORDER BY DNR, KNR;

SELECT '34.2 Join Dozent/Belegung' AS Abfrage, D.DNR, D.NAME, D.VORNAME, B.KNR
  FROM DOZENT D
  JOIN BELEGUNG B ON D.DNR = B.DNR
 ORDER BY D.DNR, B.KNR;

SELECT '34.3 Kurse pro Dozent' AS Abfrage, DNR, COUNT(DISTINCT KNR) AS KURSE
  FROM BELEGUNG
 GROUP BY DNR
 ORDER BY DNR;

-- ---------------------------------------------------------------------
-- Folie 35 – Relationenschema DOZENT
-- ---------------------------------------------------------------------

SELECT '35.1 Schema DOZENT' AS Abfrage, COLUMN_NAME, DATA_TYPE, COLUMN_KEY
  FROM information_schema.COLUMNS
 WHERE TABLE_SCHEMA = 'Vorlesungen' AND TABLE_NAME = 'DOZENT'
 ORDER BY ORDINAL_POSITION;

SELECT '35.2 Tupel der Relation' AS Abfrage, DNR, STATUS, PNR, NAME, VORNAME, FIRMA
  FROM DOZENT
 ORDER BY DNR;

-- ---------------------------------------------------------------------
-- Folie 36 – Referentielle Integritaet pruefen
-- Alle drei Abfragen muessen 0 Zeilen liefern.
-- ---------------------------------------------------------------------

SELECT '36.1 BELEGUNG ohne DOZENT' AS Pruefung, B.PNR, B.KNR, B.DNR
  FROM BELEGUNG B
  LEFT JOIN DOZENT D ON B.DNR = D.DNR
 WHERE D.DNR IS NULL;

SELECT '36.2 KURS ohne THEMA' AS Pruefung, K.KNR, K.KURSBEZEICHNUNG, K.TNR
  FROM KURS K
  LEFT JOIN THEMA T ON K.TNR = T.TNR
 WHERE T.TNR IS NULL;

SELECT '36.3 PERSON ohne ROLLE' AS Pruefung, P.PNR, P.NAME, P.RNR
  FROM PERSON P
  LEFT JOIN ROLLE R ON P.RNR = R.RNR
 WHERE R.RNR IS NULL;

-- ---------------------------------------------------------------------
-- Folie 37 – Anfrageoperationen
-- ---------------------------------------------------------------------

SELECT '37.1 Selektion' AS Abfrage, KNR, KURSBEZEICHNUNG, KURSORT, TNR
  FROM KURS
 WHERE KURSORT = 'Stuttgart';

SELECT '37.2 Projektion' AS Abfrage, KNR, KURSBEZEICHNUNG
  FROM KURS
 ORDER BY KNR;

SELECT '37.3 Join' AS Abfrage, P.NAME, P.VORNAME, K.KURSBEZEICHNUNG, B.DATUM
  FROM BELEGUNG B
  JOIN PERSON P ON B.PNR = P.PNR
  JOIN KURS   K ON B.KNR = K.KNR
 ORDER BY P.NAME, K.KURSBEZEICHNUNG;

-- ---------------------------------------------------------------------
-- Folie 38 – Lesende Anfragen auf dem bestehenden Schema
-- ---------------------------------------------------------------------

SELECT '38.1 Data Dictionary' AS Abfrage, TABLE_NAME, COLUMN_NAME, DATA_TYPE, COLUMN_KEY
  FROM information_schema.COLUMNS
 WHERE TABLE_SCHEMA = 'Vorlesungen'
 ORDER BY TABLE_NAME, ORDINAL_POSITION;

SELECT '38.2 Auswertung 4 Relationen' AS Abfrage,
       P.NAME, K.KURSBEZEICHNUNG, T.THEMENGEBIET, B.DATUM
  FROM BELEGUNG B
  JOIN PERSON P ON B.PNR = P.PNR
  JOIN KURS   K ON B.KNR = K.KNR
  JOIN THEMA  T ON K.TNR = T.TNR
 ORDER BY P.NAME, K.KURSBEZEICHNUNG;