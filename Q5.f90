program Q5
    implicit none
    integer :: n, i, j, idx
    integer :: ios
    character(len=200) :: iomsg
    integer, allocatable :: a(:)

    print *, "第5题：输出循环右移形成的方阵"
    print *, "请输入数组元素个数 n："
    read (*, *, iostat=ios, iomsg=iomsg) n
    if (ios < 0) then
        print *, "未检测到输入。请在终端中运行程序并按提示输入数据。"
        stop
    else if (ios > 0) then
        print *, "输入格式错误：", trim(iomsg)
        stop
    end if

    if (n <= 0) then
        print *, "输入错误：n 必须为正整数。"
        stop
    end if

    allocate (a(n))
    print *, "请输入", n, "个整数："
    read (*, *, iostat=ios, iomsg=iomsg) a
    if (ios < 0) then
        print *, "输入提前结束。请一次输入足够的数组元素。"
        stop
    else if (ios > 0) then
        print *, "数组输入格式错误：", trim(iomsg)
        stop
    end if

    print *
    print *, "输出方阵如下："
    do i = 1, n
        do j = 1, n
            idx = modulo(j - i, n) + 1
            if (j < n) then
                write (*, '(I0,1X)', advance='no') a(idx)
            else
                write (*, '(I0)') a(idx)
            end if
        end do
    end do
end program Q5
