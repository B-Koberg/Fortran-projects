#!/bin/bash
# mein_skript.sh - einfaches Beispiel

export FPM_FC="mpifort"

fpm run --runner "mpirun -np 4"

python3 plot.py

xdg-open mandelbrot_150.png