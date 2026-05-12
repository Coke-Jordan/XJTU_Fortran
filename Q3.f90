program Q3
    use prime_utils, only : build_prime_table
    implicit none
    integer, parameter :: limit = 1000
    character(len=*), parameter :: report_name = "Q3_report.txt"
    integer :: even_n, p, count, max_count, max_even
    integer :: counts(2:limit / 2)
    integer :: report_unit, ios
    character(len=200) :: iomsg
    character(len=260) :: report_path
    logical :: prime_flags(0:limit)

    print *, "第3题：验证1000以内偶数的哥德巴赫猜想"
    print *, "程序将生成完整分解报告，并在终端显示摘要。"

    call build_prime_table(prime_flags)

    report_path = report_name

    open (newunit=report_unit, file=trim(report_path), status='replace', action='write', &
          iostat=ios, iomsg=iomsg)
    if (ios /= 0) then
        print *, "无法创建报告文件：", trim(iomsg)
        stop
    end if

    write (report_unit, '(A)') "第3题：验证1000以内偶数的哥德巴赫猜想"
    write (report_unit, '(A)') "以下给出每个偶数分解成两个素数之和的所有等式及个数统计。"

    max_count = -1
    max_even = 4
    counts = 0

    do even_n = 4, limit, 2
        count = 0
        write (report_unit, '(/,A,I0,A)') "偶数 ", even_n, " 的分解："

        do p = 2, even_n / 2
            if (prime_flags(p) .and. prime_flags(even_n - p)) then
                write (report_unit, '(I0,A,I0,A,I0)') even_n, " = ", p, " + ", even_n - p
                count = count + 1
            end if
        end do

        counts(even_n / 2) = count
        write (report_unit, '(A,I0)') "分解个数：", count

        if (count > max_count) then
            max_count = count
            max_even = even_n
        end if
    end do

    write (report_unit, '(/,A)') "偶数与分解个数统计表："
    do even_n = 4, limit, 2
        write (report_unit, '(I4,A,I0)') even_n, " -> ", counts(even_n / 2)
    end do

    write (report_unit, '(/,A,I0,A,I0)') "在 4 到 ", limit, " 之间，分解个数最多的偶数是：", max_even
    write (report_unit, '(A,I0)') "对应的分解个数为：", max_count
    write (report_unit, '(A)') "从统计表可以直接观察每个偶数分解个数的变化情况。"
    close (report_unit)

    print *
    print *, "已验证 4 到", limit, "之间的全部偶数。"
    write (*, '(A,I0,A,I0)') "分解个数最多的偶数是：", max_even, "，个数为：", max_count
    print *, "完整分解和统计已写入：", trim(report_path)
end program Q3
