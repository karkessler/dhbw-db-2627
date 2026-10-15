-- SQL-Version der Aufgaben aus relationale-uebungen.txt
-- Die Abfragen sind fuer MySQL 8.4 formuliert.

-- 1. Studenten ab dem 3. Semester
SELECT * FROM Studenten WHERE Semester >= 3;

-- 2. Namen aller Studenten; DISTINCT entspricht der Projektion in der Mengenalgebra.
SELECT DISTINCT Name FROM Studenten;

-- 3. Studenten im 3. bis 5. Semester
SELECT * FROM Studenten WHERE Semester >= 3 AND Semester <= 5;

-- 4. Studenten im 1. oder ab dem 5. Semester
SELECT * FROM Studenten WHERE Semester = 1 OR Semester >= 5;

-- 5. Studenten, die nicht im 1. Semester sind
SELECT * FROM Studenten WHERE NOT (Semester = 1);

-- 5a. Studenten mit mehr als 3 Semestern
SELECT * FROM Studenten WHERE Semester > 3;

-- 5b. Studenten mit weniger als 3 Semestern
SELECT * FROM Studenten WHERE Semester < 3;

-- 5c. Studenten, die nicht im 1. Semester sind
SELECT * FROM Studenten WHERE Semester <> 1;

-- 6. Relation mit Alias S
SELECT * FROM Studenten AS S;

-- 7. Attribut gelesenVon als PersNr ausgeben
SELECT VorlNr, Titel, SWS, gelesenVon AS PersNr FROM Vorlesungen;

-- 8. Kreuzprodukt
SELECT * FROM Studenten CROSS JOIN Professoren;

-- 9. Vereinigungsmenge
SELECT Name FROM Professoren
UNION
SELECT Name FROM Assistenten;

-- 10. Schnittmenge
SELECT Name FROM Professoren
INTERSECT
SELECT Name FROM Assistenten;

-- 11. Differenzmenge
SELECT Name FROM Professoren
EXCEPT
SELECT Name FROM Assistenten;

-- 12. Theta-Join
SELECT DISTINCT p.Name, v.Titel
FROM Professoren AS p
INNER JOIN Vorlesungen AS v ON p.PersNr = v.gelesenVon;

-- 13. Natural Join nach Umbenennung von gelesenVon in PersNr
SELECT DISTINCT p.Name, v.Titel
FROM Professoren AS p
NATURAL JOIN (
    SELECT VorlNr, Titel, SWS, gelesenVon AS PersNr
    FROM Vorlesungen
) AS v;

-- 14. Left Outer Join
SELECT p.*, v.*
FROM Professoren AS p
LEFT OUTER JOIN Vorlesungen AS v ON p.PersNr = v.gelesenVon;

-- 15. Right Outer Join
SELECT p.*, v.*
FROM Professoren AS p
RIGHT OUTER JOIN Vorlesungen AS v ON p.PersNr = v.gelesenVon;

-- 16. Full Outer Join in MySQL
SELECT p.*, v.*
FROM Professoren AS p
LEFT OUTER JOIN Vorlesungen AS v ON p.PersNr = v.gelesenVon
UNION
SELECT p.*, v.*
FROM Professoren AS p
RIGHT OUTER JOIN Vorlesungen AS v ON p.PersNr = v.gelesenVon;

-- 17. Left Semi Join
SELECT p.*
FROM Professoren AS p
WHERE EXISTS (
    SELECT 1
    FROM Vorlesungen AS v
    WHERE v.gelesenVon = p.PersNr
);

-- 18. Right Semi Join
SELECT v.*
FROM Vorlesungen AS v
WHERE EXISTS (
    SELECT 1
    FROM Professoren AS p
    WHERE p.PersNr = v.gelesenVon
);

-- 19. Anti Join
SELECT p.*
FROM Professoren AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM Vorlesungen AS v
    WHERE v.gelesenVon = p.PersNr
);

-- 20. Division: Professoren, die jede Vorlesung lesen
SELECT DISTINCT v1.gelesenVon
FROM Vorlesungen AS v1
WHERE NOT EXISTS (
    SELECT 1
    FROM Vorlesungen AS v2
    WHERE NOT EXISTS (
        SELECT 1
        FROM Vorlesungen AS v3
        WHERE v3.gelesenVon = v1.gelesenVon
          AND v3.VorlNr = v2.VorlNr
    )
);

-- 21. Sortierung
SELECT * FROM Studenten ORDER BY Name DESC;

-- 22. Gruppierung und Aggregation
SELECT gelesenVon, COUNT(*) AS Anzahl
FROM Vorlesungen
GROUP BY gelesenVon;

-- 23. Benannte Zwischenrelation als Common Table Expression
WITH professoren AS (
    SELECT DISTINCT Name FROM Professoren
)
SELECT * FROM professoren;
