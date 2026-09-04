\# MySQL und Adminer



Die Datei `docker-compose.mysql-adminer.yml` startet eine MySQL-Datenbank

sowie Adminer als grafische Weboberfläche zur Datenbankverwaltung.



\## Starten



Im Hauptverzeichnis des Repositories ausführen:



```bash
docker compose -f docker-compose.mysql-adminer.yml down
docker compose -f docker/docker-compose.mysql-adminer.yml up -d

