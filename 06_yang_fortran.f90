program yanghui
    implicit none

    integer :: n

    ! 第6题 Fortran 语言版：按 n 打印杨辉三角。
    print *, '请输入 n（1-20）：'
    read *, n

    if (n < 1 .or. n > 20) then
        print *, 'n 输入无效。'
        stop 1
    end if

    call YANG(n)

contains

    subroutine YANG(n)
        integer, intent(in) :: n
        integer(kind=8) :: a(20, 20)
        integer :: i
        integer :: j
        integer :: k

        a = 0

        ! 先把每一行首尾两个数置为 1。
        do i = 1, n
            a(i, 1) = 1
            a(i, i) = 1
        end do

        ! 中间位置等于上一行相邻两个数之和。
        do i = 3, n
            do j = 2, i - 1
                a(i, j) = a(i - 1, j - 1) + a(i - 1, j)
            end do
        end do

        do i = 1, n
            do k = 1, n - i
                write (*, '(a)', advance='no') '  '
            end do
            do j = 1, i
                write (*, '(i4)', advance='no') a(i, j)
            end do
            write (*, *)
        end do
    end subroutine YANG

end program yanghui
