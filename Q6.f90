program Q6
    use ModuleSORT, only : bubble_sort
    implicit none
    integer :: n
    integer :: ios
    character(len=200) :: iomsg
    integer, allocatable :: a(:)

    print *, "第6题：使用冒泡算法对数列进行升序排序"
    print *, "请输入数列长度 n："
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

    print *, "排序前："
    write (*, '(*(I0,1X))') a

    call bubble_sort(a)

    print *, "排序后（从小到大）："
    write (*, '(*(I0,1X))') a
end program Q6
