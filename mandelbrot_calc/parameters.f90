module parameters
    implicit none
    public :: nx, ny, max_iter, x_min, x_max, y_min, y_max

    integer, parameter :: nx = 600, ny = 600
    integer, parameter :: max_iter = 5000
    real(8), parameter :: x_min = -2.0d0, x_max = 1.0d0
    real(8), parameter :: y_min = -1.5d0, y_max = 1.5d0

end module parameters