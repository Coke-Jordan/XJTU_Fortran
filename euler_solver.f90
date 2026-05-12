module euler_solver
    use iso_fortran_env, only : real64
    implicit none
    private
    public :: solve_euler, ode_function

    abstract interface
        function ode_function(x, y) result(value)
            import :: real64
            real(real64), intent(in) :: x, y
            real(real64) :: value
        end function ode_function
    end interface

contains

    subroutine solve_euler(f, x0, x_end, y0, n, x, y)
        procedure(ode_function) :: f
        real(real64), intent(in) :: x0, x_end, y0
        integer, intent(in) :: n
        real(real64), intent(out) :: x(0:n), y(0:n)
        real(real64) :: h
        integer :: i

        if (n <= 0) then
            print *, "步数 n 必须为正整数。"
            stop
        end if

        h = (x_end - x0) / real(n, real64)
        x(0) = x0
        y(0) = y0

        do i = 0, n - 1
            x(i + 1) = x(i) + h
            y(i + 1) = y(i) + h * f(x(i), y(i))
        end do
    end subroutine solve_euler

end module euler_solver
