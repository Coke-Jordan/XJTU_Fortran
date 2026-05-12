module trapezoid_module
    use iso_fortran_env, only : real64
    implicit none

    ! 定义可传入的单变量实函数接口，便于更换被积函数。
    abstract interface
        function scalar_function(x) result(value)
            import :: real64
            real(real64), intent(in) :: x
            real(real64) :: value
        end function scalar_function
    end interface

contains

    ! 使用梯形法计算定积分，并返回节点与函数值数组。
    subroutine trapezoid_integral(func, x0, xn, n, x, fx, integral)
        procedure(scalar_function) :: func
        real(real64), intent(in) :: x0, xn
        integer, intent(in) :: n
        real(real64), allocatable, intent(out) :: x(:), fx(:)
        real(real64), intent(out) :: integral
        real(real64) :: h
        integer :: i

        if (n < 2) error stop "节点个数 n 至少应为 2"

        allocate (x(n), fx(n))
        h = (xn - x0) / real(n - 1, real64)

        do i = 1, n
            x(i) = x0 + real(i - 1, real64) * h
            fx(i) = func(x(i))
        end do

        integral = h * (0.5_real64 * fx(1) + sum(fx(2:n - 1)) + 0.5_real64 * fx(n))
    end subroutine trapezoid_integral

end module trapezoid_module

program Q1
    use iso_fortran_env, only : real64
    use trapezoid_module, only : trapezoid_integral, scalar_function
    implicit none

    integer, parameter :: sample_sizes(3) = [5, 11, 101]
    real(real64), parameter :: x0 = -1.0_real64
    real(real64), parameter :: xn = 1.0_real64
    real(real64), parameter :: exact_value = 2.0_real64 / 3.0_real64
    real(real64), allocatable :: x(:), fx(:)
    real(real64) :: integral_value, error_value
    integer :: case_id, i

    procedure(scalar_function) :: sample_integrand

    call set_utf8_console()

    write (*, '(A)') "Q1：用梯形法计算 f(x)=x^2 在 [-1,1] 上的定积分"
    write (*, '(A,ES24.16)') "精确积分值 = ", exact_value

    do case_id = 1, size(sample_sizes)
        call trapezoid_integral(sample_integrand, x0, xn, sample_sizes(case_id), x, fx, integral_value)
        error_value = abs(integral_value - exact_value)

        write (*, '(/,A,I0,A,I0)') "节点个数 n = ", sample_sizes(case_id), "，小区间个数 = ", &
            sample_sizes(case_id) - 1
        write (*, '(A,ES24.16)') "积分近似值 = ", integral_value
        write (*, '(A,ES24.16)') "绝对误差   = ", error_value
        write (*, '(A)') " 序号               x(i)                 f(x(i))"
        do i = 1, size(x)
            write (*, '(I3,2ES22.10)') i, x(i), fx(i)
        end do

        deallocate (x, fx)
    end do

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
end program Q1

real(real64) function sample_integrand(x)
    use iso_fortran_env, only : real64
    implicit none

    real(real64), intent(in) :: x

    sample_integrand = x * x
end function sample_integrand
