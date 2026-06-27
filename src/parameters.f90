module parameters
    use iso_fortran_env, only: int32, real64, real32
    implicit none
    public :: wp
    public :: nx, ny, max_iter, x_min, x_max, y_min, y_max

    integer, parameter :: wp = real64

    integer, parameter :: ratio_x = 1, ratio_y = 1
    integer, parameter :: base_size = 20000
    integer, parameter :: nx = ratio_x * base_size, ny = ratio_y * base_size
    integer, parameter :: max_iter = 150
    real(wp), parameter :: x_min = -2.0_wp, x_max = 1.0_wp
    real(wp), parameter :: y_min = - (x_max - x_min) * real(ny, wp) / real(nx, wp) / 2.0_wp, y_max = - y_min
    character(len=1), parameter :: files = 'm'  ! 's' for single file, 'm' for multiple files
end module parameters
