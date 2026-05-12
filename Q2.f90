program Q2
    use prime_utils, only : is_prime
    implicit none
    integer :: n
    integer :: ios
    character(len=200) :: iomsg

    print *, "第2题：判断一个大于2的正整数是否为素数"
    print *, "请输入一个大于2的正整数："
    read (*, *, iostat=ios, iomsg=iomsg) n
    if (ios < 0) then
        print *, "未检测到输入。请在终端中运行程序并按提示输入数据。"
        stop
    else if (ios > 0) then
        print *, "输入格式错误：", trim(iomsg)
        stop
    end if

    if (n <= 2) then
        print *, "输入不符合要求。"
    else if (is_prime(n)) then
        print *, n, "是素数。"
    else
        print *, n, "不是素数。"
    end if
end program Q2
