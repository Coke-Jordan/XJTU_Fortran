module rk4_module
    use iso_fortran_env, only : real64
    implicit none

    ! 定义微分方程右端函数 y'=f(x,y) 的统一接口。
    abstract interface
        function ode_rhs(x, y) result(value)
            import :: real64
            real(real64), intent(in) :: x, y
            real(real64) :: value
        end function ode_rhs
    end interface

contains

    ! 用四阶龙格-库塔法计算离散节点上的数值解。
    subroutine rk4_solve(rhs, x0, y0, h, steps, x, y)
        procedure(ode_rhs) :: rhs
        real(real64), intent(in) :: x0, y0, h
        integer, intent(in) :: steps
        real(real64), allocatable, intent(out) :: x(:), y(:)
        real(real64) :: k1, k2, k3, k4
        integer :: i

        allocate (x(0:steps), y(0:steps))
        x(0) = x0
        y(0) = y0

        do i = 0, steps - 1
            k1 = h * rhs(x(i), y(i))
            k2 = h * rhs(x(i) + 0.5_real64 * h, y(i) + 0.5_real64 * k1)
            k3 = h * rhs(x(i) + 0.5_real64 * h, y(i) + 0.5_real64 * k2)
            k4 = h * rhs(x(i) + h, y(i) + k3)

            x(i + 1) = x0 + real(i + 1, real64) * h
            y(i + 1) = y(i) + (k1 + 2.0_real64 * k2 + 2.0_real64 * k3 + k4) / 6.0_real64
        end do
    end subroutine rk4_solve

end module rk4_module
