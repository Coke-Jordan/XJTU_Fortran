program Q1
    use iso_fortran_env, only : real64
    implicit none
    integer, parameter :: max_roots = 8
    real(real64) :: roots(max_roots)
    integer :: count, i

    call find_real_roots(-5.0_real64, 5.0_real64, 0.25_real64, 1.0e-12_real64, roots, count)

    print *, "第1题：牛顿法求解方程 7x^4 + 6x^3 - 5x^2 + 4x + 3 = 0 的实根"
    if (count == 0) then
        print *, "未找到实根。"
    else
        print *, "找到的实根个数：", count
        do i = 1, count
            write (*, '(A,I0,A,F20.12)') "实根", i, " = ", roots(i)
        end do
    end if

contains

    real(real64) function f(x)
        real(real64), intent(in) :: x
        f = 7.0_real64 * x**4 + 6.0_real64 * x**3 - 5.0_real64 * x**2 + 4.0_real64 * x + 3.0_real64
    end function f

    real(real64) function df(x)
        real(real64), intent(in) :: x
        df = 28.0_real64 * x**3 + 18.0_real64 * x**2 - 10.0_real64 * x + 4.0_real64
    end function df

    subroutine newton_solve(x0, tol, root, ok)
        real(real64), intent(in) :: x0, tol
        real(real64), intent(out) :: root
        logical, intent(out) :: ok
        real(real64) :: x, x_new, fx, dfx
        integer :: iter
        integer, parameter :: max_iter = 100

        x = x0
        ok = .false.

        do iter = 1, max_iter
            fx = f(x)
            dfx = df(x)

            if (abs(dfx) < 1.0e-12_real64) return

            x_new = x - fx / dfx
            if (abs(x_new - x) < tol .and. abs(f(x_new)) < 1.0e-8_real64) then
                root = x_new
                ok = .true.
                return
            end if

            x = x_new
        end do

        if (abs(f(x)) < 1.0e-8_real64) then
            root = x
            ok = .true.
        end if
    end subroutine newton_solve

    subroutine find_real_roots(xmin, xmax, step, tol, roots, count)
        real(real64), intent(in) :: xmin, xmax, step, tol
        real(real64), intent(out) :: roots(:)
        integer, intent(out) :: count
        real(real64) :: x0, root
        logical :: ok

        count = 0
        x0 = xmin
        do while (x0 <= xmax + 0.5_real64 * step)
            call newton_solve(x0, tol, root, ok)
            if (ok) then
                if (.not. is_duplicate(root, roots, count)) then
                    count = count + 1
                    if (count <= size(roots)) roots(count) = root
                end if
            end if
            x0 = x0 + step
        end do

        if (count > 1) call sort_roots(roots, count)
    end subroutine find_real_roots

    logical function is_duplicate(root, roots, count)
        real(real64), intent(in) :: root
        real(real64), intent(in) :: roots(:)
        integer, intent(in) :: count
        integer :: i

        is_duplicate = .false.
        do i = 1, count
            if (abs(root - roots(i)) < 1.0e-7_real64) then
                is_duplicate = .true.
                return
            end if
        end do
    end function is_duplicate

    subroutine sort_roots(roots, count)
        real(real64), intent(inout) :: roots(:)
        integer, intent(in) :: count
        integer :: i, j
        real(real64) :: temp

        do i = 1, count - 1
            do j = i + 1, count
                if (roots(j) < roots(i)) then
                    temp = roots(i)
                    roots(i) = roots(j)
                    roots(j) = temp
                end if
            end do
        end do
    end subroutine sort_roots

end program Q1
