program Q6_analyze
    use iso_fortran_env, only : real64
    implicit none

    ! 从 data1.txt 中读回数据，统计函数最大值和最小值。
    integer :: unit_id, ios, count, i, max_index, min_index
    real(real64), allocatable :: x(:), y(:)
    real(real64) :: tx, ty

    call set_utf8_console()

    open (newunit=unit_id, file="data1.txt", status="old", action="read", iostat=ios)
    if (ios /= 0) then
        write (*, '(A)') "Q6 第 2 部分：无法打开 data1.txt"
        stop 1
    end if

    count = 0
    do
        read (unit_id, *, iostat=ios) tx, ty
        if (ios /= 0) exit
        count = count + 1
    end do

    rewind (unit_id)
    allocate (x(count), y(count))
    do i = 1, count
        read (unit_id, *) x(i), y(i)
    end do
    close (unit_id)

    max_index = maxloc(y, dim=1)
    min_index = minloc(y, dim=1)

    write (*, '(A)') "Q6 第 2 部分：data1.txt 中数据的统计结果"
    write (*, '(A,I0)') "  数据点个数 = ", count
    write (*, '(A,F10.4,A,ES24.16)') "  最大值点：x = ", x(max_index), "，y = ", y(max_index)
    write (*, '(A,F10.4,A,ES24.16)') "  最小值点：x = ", x(min_index), "，y = ", y(min_index)

contains

    subroutine set_utf8_console()
        use, intrinsic :: iso_c_binding, only : c_int
        implicit none

        interface
            function SetConsoleOutputCP(code_page) bind(C, name="SetConsoleOutputCP") result(status)
                import :: c_int
                integer(c_int), value :: code_page
                integer(c_int) :: status
            end function SetConsoleOutputCP

            function SetConsoleCP(code_page) bind(C, name="SetConsoleCP") result(status)
                import :: c_int
                integer(c_int), value :: code_page
                integer(c_int) :: status
            end function SetConsoleCP
        end interface

        if (SetConsoleOutputCP(65001_c_int) == 0_c_int) return
        if (SetConsoleCP(65001_c_int) == 0_c_int) return
    end subroutine set_utf8_console
end program Q6_analyze
