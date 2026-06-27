#!/usr/bin/env python3
import json
from pathlib import Path
from datetime import datetime

p = json.load(open("params.json"))

wp = p["wp"]
ratio_x = int(p["ratio_x"])
ratio_y = int(p["ratio_y"])
base_size = int(p["base_size"])
max_iter = int(p["max_iter"])
x_min = float(p["x_min"])
x_max = float(p["x_max"])
files = p["files"]

nx_expr = f"ratio_x * base_size"
ny_expr = f"ratio_y * base_size"

out = Path("src/parameters.f90")
with out.open("w") as f:
    f.write("module parameters\n")
    f.write("    use iso_fortran_env, only: int32, real64, real32\n")
    f.write("    implicit none\n")
    f.write("    public :: wp\n")
    f.write("    public :: nx, ny, max_iter, x_min, x_max, y_min, y_max\n\n")
    f.write(f"    integer, parameter :: wp = {wp}\n\n")
    f.write(f"    integer, parameter :: ratio_x = {ratio_x}, ratio_y = {ratio_y}\n")
    f.write(f"    integer, parameter :: base_size = {base_size}\n")
    f.write(f"    integer, parameter :: nx = {nx_expr}, ny = {ny_expr}\n")
    f.write(f"    integer, parameter :: max_iter = {max_iter}\n")
    f.write(f"    real(wp), parameter :: x_min = {x_min}_wp, x_max = {x_max}_wp\n")
    f.write("    real(wp), parameter :: y_min = - (x_max - x_min) * real(ny, wp) / real(nx, wp) / 2.0_wp, y_max = - y_min\n")
    f.write(f"    character(len=1), parameter :: files = '{files}'  ! 's' for single file, 'm' for multiple files\n")
    f.write("end module parameters\n")
print(f"({datetime.now().strftime('%H:%M:%S')}) Written {out}")
