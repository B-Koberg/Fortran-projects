module mpi_utils
    use mpi_f08
    use parameters
    implicit none
    private
    public :: split_arrays, gather_2d
contains
    subroutine split_arrays(rank, size, x_pix, x_pix_local, local_nx)
        integer, intent(in) :: rank, size
        integer, intent(in) :: x_pix(nx)
        integer, intent(out), allocatable :: x_pix_local(:)
        integer, intent(out) :: local_nx

        integer :: startx, endx
        integer :: block

        block = nx / size
        startx = rank*block + 1
        endx   = (rank+1)*block
        if (rank == size-1) endx = nx

        if (startx > endx) then
            stop "Error: More processes than work items"
        else
            local_nx = endx - startx + 1
        end if

        allocate(x_pix_local(local_nx))
        x_pix_local = x_pix(startx:endx)
    end subroutine split_arrays


    subroutine gather_2d(local_nx, rank, size, iter_array_local, iter_array, recvcounts, displs)
        integer, intent(in) :: local_nx, rank, size
        integer, intent(in) :: iter_array_local(local_nx, ny)
        integer, intent(out) :: iter_array(nx, ny)
        integer :: recvcounts(:), displs(:)

        integer :: p, tmp_start, tmp_end, block

        block = nx / size

        do p = 0, size-1
            tmp_start = p*block + 1
            tmp_end   = (p+1)*block
            if (p == size-1) tmp_end = nx

            recvcounts(p+1) = (tmp_end - tmp_start + 1) * ny
        end do

        displs(1) = 0
        do p = 2, size
            displs(p) = displs(p-1) + recvcounts(p-1)
        end do


        call MPI_Gatherv( &
            iter_array_local, local_nx*ny, MPI_INTEGER, &
            iter_array, recvcounts, displs, MPI_INTEGER, &
            0, MPI_COMM_WORLD)

        !MPI_Gatherv(
        !Was sende ich?,
        !Wie viele Elemente sende ich?,
        !Welcher Datentyp?,
        !Wohin wird gesammelt?,
        !Wie viel kommt von jedem Rank?,
        !Wo wird jedes Paket abgelegt?,
        !Welcher Datentyp wird empfangen?,
        !Wer sammelt?,
        !In welchem Communicator?
        !)
    end subroutine

end module mpi_utils