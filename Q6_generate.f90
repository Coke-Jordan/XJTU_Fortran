program Q6_generate
    use iso_fortran_env, only : real64
    use rk4_module, only : rk4_solve, ode_rhs
    implicit none

    ! 用四阶龙格-库塔法求解微分方程，并写入 data1.txt。
    integer, parameter :: steps = 1000
    real(real64), parameter :: x0 = 0.0_real64
    real(real64), parameter :: y0 = 1.0_real64
    real(real64), parameter :: h = 0.1_real64
    real(real64), allocatable :: x(:), y(:)
    integer :: unit_id, i

    procedure(ode_rhs) :: sample_rhs

    call set_utf8_console()

    call rk4_solve(sample_rhs, x0, y0, h, steps, x, y)

    open (newunit=unit_id, file="data1.txt", status="replace", action="write")
    do i = 1, steps
        write (unit_id, '(F10.4,1X,ES24.16)') x(i), y(i)
    end do
    close (unit_id)

    write (*, '(A)') "Q6 第 1 部分：已生成 data1.txt。"
    write (*, '(A)') "部分节点结果如下："
    call print_value(1)
    call print_value(2)
    call print_value(3)
    call print_value(10)
    call print_value(100)
    call print_value(1000)

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

    subroutine print_value(index)
        integer, intent(in) :: index

        write (*, '(A,F8.4,A,ES24.16)') "  x = ", x(index), "，y = ", y(index)
    end subroutine print_value

end program Q6_generate

real(real64) function sample_rhs(x, y)
    use iso_fortran_env, only : real64
    implicit none

    real(real64), intent(in) :: x, y

    sample_rhs = x + sin(x)
end function sample_rhs
