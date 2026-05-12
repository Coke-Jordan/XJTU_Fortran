program Q4
    implicit none

    integer, target :: descending_counts(5) = [5, 4, 3, 2, 1]
    integer, target :: ascending_counts(5) = [1, 2, 3, 4, 5]
    integer, pointer :: active_counts(:)

    call set_utf8_console()

    ! 通过指针关联不同数组，复用同一套图形输出过程。
    write (*, '(A)') "Q4：使用指针功能输出两种数字图形"

    active_counts => descending_counts
    write (*, '(/,A)') "图形 1"
    call print_pattern(active_counts)

    active_counts => ascending_counts
    write (*, '(/,A)') "图形 2"
    call print_pattern(active_counts)

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

    subroutine print_pattern(counts)
        integer, target, intent(in) :: counts(:)
        integer, pointer :: row_count
        integer :: i

        do i = 1, size(counts)
            row_count => counts(i)
            write (*, '(A)') build_line(i, row_count)
        end do
    end subroutine print_pattern

    function build_line(value, count) result(line)
        integer, intent(in) :: value, count
        character(len=:), allocatable :: line
        character(len=16) :: token
        integer :: i

        line = ""
        do i = 1, count
            write (token, '(I0)') value
            if (i == 1) then
                line = trim(token)
            else
                line = trim(line) // "  " // trim(token)
            end if
        end do
    end function build_line

end program Q4
