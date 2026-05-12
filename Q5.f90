
program Q5
    use iso_fortran_env, only : real64
    implicit none

    call set_utf8_console()

    write (*, '(A)') "Q5：格式化输入输出实验"
    write (*, '(A)') "请按屏幕提示逐项从键盘输入数据。"

    call demo_integer_formats()
    call demo_real_formats()
    call demo_complex_format()
    call demo_logical_formats()
    call demo_character_formats()

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

    subroutine demo_integer_formats()
        integer :: values(4)

        write (*, '(/,A)') "1）整数输入输出实验"
        write (*, '(A)') "请分别输入整数 1234，共 4 次。"

        write (*, '(A)') "  第 1 次：自由格式输入 1234"
        read (*, *) values(1)

        write (*, '(A)') "  第 2 次：按 I2 格式输入 1234"
        read (*, '(I2)') values(2)

        write (*, '(A)') "  第 3 次：按 I4 格式输入 1234"
        read (*, '(I4)') values(3)

        write (*, '(A)') "  第 4 次：按 I4.2 格式输入 1234"
        read (*, '(I4.2)') values(4)

        write (*, '(/,A)') "  对应输出结果："
        write (*, '(A,I0)') "  自由格式输出 -> ", values(1)
        write (*, '(A,I2)') "  I2 输出      -> ", values(2)
        write (*, '(A,I4)') "  I4 输出      -> ", values(3)
        write (*, '(A,I4.2)') "  I4.2 输出    -> ", values(4)
    end subroutine demo_integer_formats

    subroutine demo_real_formats()
        character(len=12), parameter :: labels(7) = [character(len=12) :: "自由格式", "F6.2", "E8.2", &
            "E12.2E3", "G6.2", "EN10.2", "ES10.2" ]
        real(real64) :: values(4)
        integer :: ios(4)
        integer :: i

        write (*, '(/,A)') "2）实数输入输出实验"
        write (*, '(A)') "每种输入格式都要依次输入 4 个数："
        write (*, '(A)') "  -1.234"
        write (*, '(A)') "  0.0034567"
        write (*, '(A)') "  3.14159E01"
        write (*, '(A)') "  98.76E-2"

        do i = 1, size(labels)
            write (*, '(/,A,A)') "  当前输入格式：", trim(labels(i))
            call read_real_group(labels(i), values, ios)
            call write_real_group(labels(i), values, ios)
        end do
    end subroutine demo_real_formats

    subroutine read_real_group(label, values, ios)
        character(len=*), intent(in) :: label
        real(real64), intent(out) :: values(4)
        integer, intent(out) :: ios(4)

        select case (trim(label))
        case ("自由格式")
            read (*, *, iostat=ios(1)) values(1)
            read (*, *, iostat=ios(2)) values(2)
            read (*, *, iostat=ios(3)) values(3)
            read (*, *, iostat=ios(4)) values(4)
        case ("F6.2")
            read (*, '(F6.2)', iostat=ios(1)) values(1)
            read (*, '(F6.2)', iostat=ios(2)) values(2)
            read (*, '(F6.2)', iostat=ios(3)) values(3)
            read (*, '(F6.2)', iostat=ios(4)) values(4)
        case ("E8.2")
            read (*, '(E8.2)', iostat=ios(1)) values(1)
            read (*, '(E8.2)', iostat=ios(2)) values(2)
            read (*, '(E8.2)', iostat=ios(3)) values(3)
            read (*, '(E8.2)', iostat=ios(4)) values(4)
        case ("E12.2E3")
            read (*, '(E12.2E3)', iostat=ios(1)) values(1)
            read (*, '(E12.2E3)', iostat=ios(2)) values(2)
            read (*, '(E12.2E3)', iostat=ios(3)) values(3)
            read (*, '(E12.2E3)', iostat=ios(4)) values(4)
        case ("G6.2")
            read (*, '(G6.2)', iostat=ios(1)) values(1)
            read (*, '(G6.2)', iostat=ios(2)) values(2)
            read (*, '(G6.2)', iostat=ios(3)) values(3)
            read (*, '(G6.2)', iostat=ios(4)) values(4)
        case ("EN10.2")
            read (*, '(EN10.2)', iostat=ios(1)) values(1)
            read (*, '(EN10.2)', iostat=ios(2)) values(2)
            read (*, '(EN10.2)', iostat=ios(3)) values(3)
            read (*, '(EN10.2)', iostat=ios(4)) values(4)
        case ("ES10.2")
            read (*, '(ES10.2)', iostat=ios(1)) values(1)
            read (*, '(ES10.2)', iostat=ios(2)) values(2)
            read (*, '(ES10.2)', iostat=ios(3)) values(3)
            read (*, '(ES10.2)', iostat=ios(4)) values(4)
        end select
    end subroutine read_real_group

    subroutine write_real_group(label, values, ios)
        character(len=*), intent(in) :: label
        real(real64), intent(in) :: values(4)
        integer, intent(in) :: ios(4)
        integer :: i

        write (*, '(A,A)') "  当前输出格式：", trim(label)

        select case (trim(label))
        case ("自由格式")
            do i = 1, 4
                if (ios(i) == 0) then
                    write (*, *) values(i)
                else
                    write (*, '(A,I0,A,I0)') "    第 ", i, " 个值读入失败，iostat = ", ios(i)
                end if
            end do
        case ("F6.2")
            do i = 1, 4
                if (ios(i) == 0) then
                    write (*, '(F6.2)') values(i)
                else
                    write (*, '(A,I0,A,I0)') "    第 ", i, " 个值读入失败，iostat = ", ios(i)
                end if
            end do
        case ("E8.2")
            do i = 1, 4
                if (ios(i) == 0) then
                    write (*, '(E8.2)') values(i)
                else
                    write (*, '(A,I0,A,I0)') "    第 ", i, " 个值读入失败，iostat = ", ios(i)
                end if
            end do
        case ("E12.2E3")
            do i = 1, 4
                if (ios(i) == 0) then
                    write (*, '(E12.2E3)') values(i)
                else
                    write (*, '(A,I0,A,I0)') "    第 ", i, " 个值读入失败，iostat = ", ios(i)
                end if
            end do
        case ("G6.2")
            do i = 1, 4
                if (ios(i) == 0) then
                    write (*, '(G6.2)') values(i)
                else
                    write (*, '(A,I0,A,I0)') "    第 ", i, " 个值读入失败，iostat = ", ios(i)
                end if
            end do
        case ("EN10.2")
            do i = 1, 4
                if (ios(i) == 0) then
                    write (*, '(EN10.2)') values(i)
                else
                    write (*, '(A,I0,A,I0)') "    第 ", i, " 个值读入失败，iostat = ", ios(i)
                end if
            end do
        case ("ES10.2")
            do i = 1, 4
                if (ios(i) == 0) then
                    write (*, '(ES10.2)') values(i)
                else
                    write (*, '(A,I0,A,I0)') "    第 ", i, " 个值读入失败，iostat = ", ios(i)
                end if
            end do
        end select
    end subroutine write_real_group

    subroutine demo_complex_format()
        complex(real64) :: z

        write (*, '(/,A)') "3）复数输入输出实验"
        write (*, '(A)') "请输入复数 (1.23,-8.9E-02)："
        read (*, *) z

        write (*, '(/,A)') "  输出结果："
        write (*, '(A)', advance='no') "  自由格式      -> "
        write (*, *) z
        write (*, '(A,2F6.2)') "  F6.2 格式     -> ", real(z), aimag(z)
        write (*, '(A,2E8.2)') "  E8.2 格式     -> ", real(z), aimag(z)
        write (*, '(A,F6.2,SP,F6.2,A)') "  实部+虚部i    -> ", real(z), aimag(z), "i"
    end subroutine demo_complex_format

    subroutine demo_logical_formats()
        logical :: values(4)
        integer :: ios(4), i

        write (*, '(/,A)') "4）逻辑量输入输出实验"
        write (*, '(A)') "每种输入格式都依次输入 4 个值：.TRUE.  .T.  .FALSE.  .F."
        write (*, '(A)') "注意：L 格式可能会读入失败，本程序会显示 iostat 结果。"

        write (*, '(/,A)') "  当前输入格式：自由格式"
        do i = 1, 4
            read (*, *, iostat=ios(i)) values(i)
        end do
        call write_logical_group("自由格式", values, ios)

        write (*, '(/,A)') "  当前输入格式：L"
        do i = 1, 4
            read (*, '(L)', iostat=ios(i)) values(i)
        end do
        call write_logical_group("L", values, ios)

        write (*, '(/,A)') "  当前输入格式：L4"
        do i = 1, 4
            read (*, '(L4)', iostat=ios(i)) values(i)
        end do
        call write_logical_group("L4", values, ios)
    end subroutine demo_logical_formats

    subroutine write_logical_group(label, values, ios)
        character(len=*), intent(in) :: label
        logical, intent(in) :: values(4)
        integer, intent(in) :: ios(4)
        integer :: i

        write (*, '(A,A)') "  当前输出结果（输入格式：", trim(label) // "）"
        do i = 1, 4
            if (ios(i) /= 0) then
                write (*, '(A,I0,A,I0)') "    第 ", i, " 个值读入失败，iostat = ", ios(i)
            else
                write (*, '(A,I0,A)', advance='no') "    第 ", i, " 个值 -> 自由格式："
                write (*, *) values(i)
                write (*, '(A,L)') "                 L 格式：", values(i)
                write (*, '(A,L4)') "                 L4 格式：", values(i)
            end if
        end do
    end subroutine write_logical_group

    subroutine demo_character_formats()
        character(len=20) :: values(4)

        write (*, '(/,A)') "5）字符串输入输出实验"
        write (*, '(A)') "每种输入格式都依次输入 4 个字符串：A  big  china  microsoft"

        write (*, '(/,A)') "  当前输入格式：自由格式"
        read (*, *) values(1)
        read (*, *) values(2)
        read (*, *) values(3)
        read (*, *) values(4)
        call write_character_group("自由格式", values)

        write (*, '(/,A)') "  当前输入格式：A"
        read (*, '(A)') values(1)
        read (*, '(A)') values(2)
        read (*, '(A)') values(3)
        read (*, '(A)') values(4)
        call write_character_group("A", values)

        write (*, '(/,A)') "  当前输入格式：A3"
        read (*, '(A3)') values(1)
        read (*, '(A3)') values(2)
        read (*, '(A3)') values(3)
        read (*, '(A3)') values(4)
        call write_character_group("A3", values)

        write (*, '(/,A)') "  当前输入格式：A5"
        read (*, '(A5)') values(1)
        read (*, '(A5)') values(2)
        read (*, '(A5)') values(3)
        read (*, '(A5)') values(4)
        call write_character_group("A5", values)
    end subroutine demo_character_formats

    subroutine write_character_group(label, values)
        character(len=*), intent(in) :: label
        character(len=*), intent(in) :: values(4)
        integer :: i

        write (*, '(A,A)') "  当前输出结果（输入格式：", trim(label) // "）"
        do i = 1, 4
            write (*, '(A,I0,A)', advance='no') "    第 ", i, " 个值 -> 自由格式："
            write (*, *) trim(values(i))
            write (*, '(A,A)') "                 A 格式：", trim(values(i))
            write (*, '(A,A3)') "                 A3 格式：", values(i)
            write (*, '(A,A5)') "                 A5 格式：", values(i)
        end do
    end subroutine write_character_group

end program Q5
