module iterative_methods
    use iso_fortran_env, only : real64
    use, intrinsic :: ieee_arithmetic, only : ieee_is_finite
    implicit none

contains

    ! Jacobi 迭代：每一步都只使用上一轮的迭代值。
    subroutine jacobi_solve(a, b, x0, tol, max_iter, x, converged, iterations, last_change)
        real(real64), intent(in) :: a(:, :), b(:), x0(:), tol
        integer, intent(in) :: max_iter
        real(real64), intent(out) :: x(:)
        logical, intent(out) :: converged
        integer, intent(out) :: iterations
        real(real64), intent(out) :: last_change
        real(real64) :: x_old(size(x0)), x_new(size(x0)), sigma
        integer :: i, iter, n

        n = size(b)
        x_old = x0
        x = x0
        converged = .false.
        iterations = 0
        last_change = huge(1.0_real64)

        do i = 1, n
            if (abs(a(i, i)) <= tiny(1.0_real64)) return
        end do

        do iter = 1, max_iter
            do i = 1, n
                sigma = sum(a(i, :) * x_old) - a(i, i) * x_old(i)
                x_new(i) = (b(i) - sigma) / a(i, i)
            end do

            if (.not. all(ieee_is_finite(x_new))) then
                x = x_old
                iterations = iter - 1
                return
            end if

            last_change = maxval(abs(x_new - x_old))
            x = x_new
            iterations = iter

            if (last_change < tol) then
                converged = .true.
                return
            end if

            if (maxval(abs(x_new)) > 1.0e12_real64) return

            x_old = x_new
        end do
    end subroutine jacobi_solve

    ! Gauss-Seidel 迭代：本轮新值会立刻用于后续分量计算。
    subroutine gauss_seidel_solve(a, b, x0, tol, max_iter, x, converged, iterations, last_change)
        real(real64), intent(in) :: a(:, :), b(:), x0(:), tol
        integer, intent(in) :: max_iter
        real(real64), intent(out) :: x(:)
        logical, intent(out) :: converged
        integer, intent(out) :: iterations
        real(real64), intent(out) :: last_change
        real(real64) :: x_old(size(x0)), sigma_left, sigma_right
        integer :: i, iter, n

        n = size(b)
        x = x0
        converged = .false.
        iterations = 0
        last_change = huge(1.0_real64)

        do i = 1, n
            if (abs(a(i, i)) <= tiny(1.0_real64)) return
        end do

        do iter = 1, max_iter
            x_old = x
            do i = 1, n
                sigma_left = 0.0_real64
                sigma_right = 0.0_real64
                if (i > 1) sigma_left = sum(a(i, 1:i - 1) * x(1:i - 1))
                if (i < n) sigma_right = sum(a(i, i + 1:n) * x_old(i + 1:n))
                x(i) = (b(i) - sigma_left - sigma_right) / a(i, i)
            end do

            if (.not. all(ieee_is_finite(x))) then
                x = x_old
                iterations = iter - 1
                return
            end if

            last_change = maxval(abs(x - x_old))
            iterations = iter

            if (last_change < tol) then
                converged = .true.
                return
            end if

            if (maxval(abs(x)) > 1.0e12_real64) then
                x = x_old
                return
            end if
        end do
    end subroutine gauss_seidel_solve

    real(real64) function residual_norm(a, x, b) result(value)
        real(real64), intent(in) :: a(:, :), x(:), b(:)

        value = maxval(abs(matmul(a, x) - b))
    end function residual_norm

end module iterative_methods

program Q2
    use iso_fortran_env, only : real64
    use iterative_methods, only : jacobi_solve, gauss_seidel_solve, residual_norm
    implicit none

    real(real64) :: a1(3, 3), b1(3)
    real(real64) :: a2(2, 2), b2(2)
    real(real64) :: a3(2, 2), b3(2)

    a1(1, :) = [5.0_real64, 1.0_real64, -3.0_real64]
    a1(2, :) = [1.0_real64, 2.0_real64, 3.0_real64]
    a1(3, :) = [7.0_real64, 8.0_real64, 11.0_real64]
    b1 = [-4.0_real64, 1.0_real64, -3.0_real64]

    a2(1, :) = [2.0_real64, 3.0_real64]
    a2(2, :) = [1.0e-5_real64, 2.0_real64]
    b2 = [2.0_real64, 1.0_real64]

    a3(1, :) = [1.0e-5_real64, 2.0_real64]
    a3(2, :) = [2.0_real64, 3.0_real64]
    b3 = [1.0_real64, 2.0_real64]

    call set_utf8_console()

    write (*, '(A)') "Q2：Jacobi 迭代法求解线性方程组，并与 Gauss-Seidel 迭代比较"
    call run_case("方程组 1", a1, b1)
    call run_case("方程组 2", a2, b2)
    call run_case("方程组 3", a3, b3)

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

    subroutine run_case(title, a, b)
        character(len=*), intent(in) :: title
        real(real64), intent(in) :: a(:, :), b(:)
        real(real64) :: x0(size(b)), x(size(b)), last_change
        logical :: converged
        integer :: iterations

        x0 = 0.0_real64

        write (*, '(/,A)') trim(title)
        call jacobi_solve(a, b, x0, 1.0e-6_real64, 5000, x, converged, iterations, last_change)
        call print_result("Jacobi 迭代", a, b, x, converged, iterations, last_change)

        call gauss_seidel_solve(a, b, x0, 1.0e-6_real64, 5000, x, converged, iterations, last_change)
        call print_result("Gauss-Seidel 迭代", a, b, x, converged, iterations, last_change)
    end subroutine run_case

    subroutine print_result(method, a, b, x, converged, iterations, last_change)
        character(len=*), intent(in) :: method
        real(real64), intent(in) :: a(:, :), b(:), x(:), last_change
        logical, intent(in) :: converged
        integer, intent(in) :: iterations
        integer :: i

        write (*, '(A)') "  " // trim(method)
        if (converged) then
            write (*, '(A,I0)') "    收敛时迭代次数 = ", iterations
            do i = 1, size(x)
                write (*, '(A,I0,A,ES24.16)') "    x(", i, ") = ", x(i)
            end do
            write (*, '(A,ES24.16)') "    残差最大范数 = ", residual_norm(a, x, b)
        else
            write (*, '(A,I0)') "    在给定迭代次数内未收敛，已执行次数 = ", iterations
            write (*, '(A,ES24.16)') "    最后一轮最大改变量 = ", last_change
            do i = 1, size(x)
                write (*, '(A,I0,A,ES24.16)') "    末次 x(", i, ") = ", x(i)
            end do
        end if
    end subroutine print_result

end program Q2
