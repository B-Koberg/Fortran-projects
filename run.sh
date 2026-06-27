#!/usr/bin/env bash
# Build, run and log with timestamp

# Compiler/Wrapper vor dem Build setzen
export FPM_FC="mpifort"

# Zeitstempel für Dateinamen: YYYYMMDD_HHMMSS
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOGFILE="build_${TIMESTAMP}.log"


# Voller Pfad zur Logdatei
LOGPATH="output/.logs/${LOGFILE}"

# Löche bin Dateien, wichtig für umschalten von single_file auf multiple_files, sonst werden die alten bin Dateien nicht überschrieben
rm -f output/*.bin

# Alle folgenden Ausgaben in die Logdatei schreiben und gleichzeitig auf der Konsole anzeigen
exec > >(tee -a "$LOGPATH") 2>&1

echo "=== Build gestartet: $(date '+%Y-%m-%d %H:%M:%S') ==="

python3 -u gen_params.py

# Build mit fpm (Verbose)
fpm build -V

# Run mit mpirun
fpm run --runner "mpirun -np 4"

days=$((10#$(date +%d) - 10#${TIMESTAMP:6:2}))
hours=$((10#$(date +%H) - 10#${TIMESTAMP:9:2}))
minutes=$((10#$(date +%M) - 10#${TIMESTAMP:11:2}))
seconds=$((10#$(date +%S) - 10#${TIMESTAMP:13:2}))

echo "=== Berechnung Fertig: $(date '+%Y-%m-%d %H:%M:%S'), Dauer: ${days}:${hours}:${minutes}:${seconds} ==="

python3 -u main.py

# Bild öffnen im Hintergrund
xdg-open output/mandelbrot.png &

days=$((10#$(date +%d) - 10#${TIMESTAMP:6:2}))
hours=$((10#$(date +%H) - 10#${TIMESTAMP:9:2}))
minutes=$((10#$(date +%M) - 10#${TIMESTAMP:11:2}))
seconds=$((10#$(date +%S) - 10#${TIMESTAMP:13:2}))

echo "=== Komplett Fertig: $(date '+%Y-%m-%d %H:%M:%S'), Dauer: ${days}:${hours}:${minutes}:${seconds} ==="

# Symbolischen Link auf die neueste Logdatei aktualisieren
# damit für tail -f logs/build.log immer die aktuelle Logdatei angezeigt wird
ln -sf "$(realpath "$LOGPATH")" "output/.logs/build.log"