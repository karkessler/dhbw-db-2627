# MySQL und Adminer



Die Datei `docker-compose.mysql-adminer.yml` startet eine MySQL-Datenbank

sowie Adminer als grafische Weboberfläche zur Datenbankverwaltung.



## Starten



Im Hauptverzeichnis des Repositories ausführen:



```bash
docker compose -f docker/docker-compose.mysql-adminer.yml down
docker compose -f docker/docker-compose.mysql-adminer.yml up -d
```

## Datenbank-Dump importieren

`docker/dump.sql` enthält das Schema **Vorlesungen**. Starte die Container
und führe im Hauptverzeichnis des Repositories diese PowerShell-Befehle aus:

```powershell
docker compose -f docker\docker-compose.mysql-adminer.yml exec -T mysql `
  mysql -uroot -padmin123 -e "CREATE DATABASE IF NOT EXISTS Vorlesungen"
cmd /c "docker compose -f docker\docker-compose.mysql-adminer.yml exec -T mysql mysql -uroot -padmin123 Vorlesungen < docker\dump.sql"
```

`MYSQL_DATABASE` ist in der Compose-Datei ebenfalls auf `Vorlesungen`
gesetzt. Die Variable wird nur bei der ersten Initialisierung des
Docker-Volumes angewendet; der erste Befehl stellt daher sicher, dass die
Datenbank auch bei einem bereits vorhandenen Volume existiert.
