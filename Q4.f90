program Q4
    use iso_fortran_env, only : real64
    use euler_solver, only : solve_euler
    implicit none
    real(real64) :: x0, x_end, y0
    integer :: n, i
    integer :: ios
    character(len=200) :: iomsg
    real(real64), allocatable :: x(:), y(:)

    print *, "第4题：Euler法求解微分方程 y' = x + 2y"
    print *, "题目默认参数可输入：0 1 1.0 10"
    print *, "请依次输入 x0、xn、y0 和步数 n："
    read (*, *, iostat=ios, iomsg=iomsg) x0, x_end, y0, n
    if (ios < 0) then
        print *, "未检测到输入。请在终端中运行程序并按提示输入数据。"
        stop
    else if (ios > 0) then
        print *, "输入格式错误：", trim(iomsg)
        stop
    end if

    if (x_end <= x0) then
        print *, "输入错误：需要满足 xn > x0。"
        stop
    end if

    if (n <= 0) then
        print *, "输入错误：步数 n 必须为正整数。"
        stop
    end if

    allocate (x(0:n), y(0:n))
    call solve_euler(rhs, x0, x_end, y0, n, x, y)

    print *
    print *, "计算结果如下："
    write (*, '(A)') "      x                y"
    do i = 0, n
        write (*, '(F8.4,2X,F18.10)') x(i), y(i)
    end do

contains

    real(real64) function rhs(x, y)
        real(real64), intent(in) :: x, y
        rhs = x + 2.0_real64 * y
    end function rhs

end program Q4
