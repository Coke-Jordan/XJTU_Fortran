module gaussian_module
    use iso_fortran_env, only : real64
    implicit none

contains

    ! 使用部分选主元的高斯消元法求解线性方程组。
    subroutine gaussian_elimination(a_in, b_in, x, ok, swaps)
        real(real64), intent(in) :: a_in(:, :), b_in(:)
        real(real64), intent(out) :: x(:)
        logical, intent(out) :: ok
        integer, intent(out) :: swaps
        real(real64) :: a(size(b_in), size(b_in)), b(size(b_in))
        real(real64) :: factor, temp_row(size(b_in)), temp_value
        integer :: i, k, n, pivot_row

        n = size(b_in)
        a = a_in
        b = b_in
        x = 0.0_real64
        ok = .true.
        swaps = 0

        do k = 1, n - 1
            pivot_row = k - 1 + maxloc(abs(a(k:n, k)), dim=1)
            if (abs(a(pivot_row, k)) <= tiny(1.0_real64)) then
                ok = .false.
                return
            end if

            if (pivot_row /= k) then
                temp_row = a(k, :)
                a(k, :) = a(pivot_row, :)
                a(pivot_row, :) = temp_row

                temp_value = b(k)
                b(k) = b(pivot_row)
                b(pivot_row) = temp_value

                swaps = swaps + 1
            end if

            do i = k + 1, n
                factor = a(i, k) / a(k, k)
                a(i, k:n) = a(i, k:n) - factor * a(k, k:n)
                b(i) = b(i) - factor * b(k)
            end do
        end do

        if (abs(a(n, n)) <= tiny(1.0_real64)) then
            ok = .false.
            return
        end if

        x(n) = b(n) / a(n, n)
        do i = n - 1, 1, -1
            x(i) = (b(i) - sum(a(i, i + 1:n) * x(i + 1:n))) / a(i, i)
        end do
    end subroutine gaussian_elimination

end module gaussian_module

program Q7
    use iso_fortran_env, only : real64
    use gaussian_module, only : gaussian_elimination
    implicit none

    real(real64) :: a1(3, 3), b1(3)
    real(real64) :: a2(2, 2), b2(2)

    a1(1, :) = [5.0_real64, 1.0_real64, -3.0_real64]
    a1(2, :) = [1.0_real64, 2.0_real64, 3.0_real64]
    a1(3, :) = [7.0_real64, 8.0_real64, 11.0_real64]
    b1 = [-4.0_real64, 1.0_real64, -3.0_real64]

    a2(1, :) = [1.0e-5_real64, 2.0_real64]
    a2(2, :) = [2.0_real64, 3.0_real64]
    b2 = [1.0_real64, 2.0_real64]

    call set_utf8_console()

    write (*, '(A)') "Q7：选做题，使用部分选主元高斯消元法求解方程组"
    call solve_case("方程组 1", a1, b1)
    call solve_case("方程组 2", a2, b2)

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

    subroutine solve_case(title, a, b)
        character(len=*), intent(in) :: title
        real(real64), intent(in) :: a(:, :), b(:)
        real(real64) :: x(size(b))
        logical :: ok
        integer :: swaps, i

        call gaussian_elimination(a, b, x, ok, swaps)

        write (*, '(/,A)') trim(title)
        if (.not. ok) then
            write (*, '(A)') "  消元失败：系数矩阵为奇异矩阵或接近奇异。"
            return
        end if

        write (*, '(A,I0)') "  交换行次数 = ", swaps
        do i = 1, size(x)
            write (*, '(A,I0,A,ES24.16)') "  x(", i, ") = ", x(i)
        end do
        write (*, '(A,ES24.16)') "  残差最大范数 = ", maxval(abs(matmul(a, x) - b))
    end subroutine solve_case

end program Q7
