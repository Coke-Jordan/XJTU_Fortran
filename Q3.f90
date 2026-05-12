module int_set_module
    implicit none
    private

    public :: int_set, make_set, operator(+), operator(-), operator(*)

    ! 用派生类型保存一个不重复的整数集合。
    type :: int_set
        integer, allocatable :: values(:)
    contains
        procedure :: print => print_set
    end type int_set

    interface make_set
        module procedure make_set_from_array
    end interface make_set

    interface operator(+)
        module procedure union_set
    end interface operator(+)

    interface operator(-)
        module procedure difference_set
    end interface operator(-)

    interface operator(*)
        module procedure intersection_set
    end interface operator(*)

contains

    ! 从整数数组构造集合，并自动完成去重与排序。
    function make_set_from_array(items) result(set_value)
        integer, intent(in) :: items(:)
        type(int_set) :: set_value

        allocate (set_value%values(size(items)))
        if (size(items) > 0) set_value%values = items
        call normalize(set_value)
    end function make_set_from_array

    function union_set(lhs, rhs) result(out)
        type(int_set), intent(in) :: lhs, rhs
        type(int_set) :: out
        integer, allocatable :: buffer(:)
        integer :: n1, n2

        n1 = size(lhs%values)
        n2 = size(rhs%values)
        allocate (buffer(n1 + n2))
        if (n1 > 0) buffer(1:n1) = lhs%values
        if (n2 > 0) buffer(n1 + 1:n1 + n2) = rhs%values
        out = make_set(buffer)
    end function union_set

    function difference_set(lhs, rhs) result(out)
        type(int_set), intent(in) :: lhs, rhs
        type(int_set) :: out
        integer, allocatable :: buffer(:), trimmed(:)
        integer :: i, count

        allocate (buffer(size(lhs%values)))
        count = 0
        do i = 1, size(lhs%values)
            if (.not. any(rhs%values == lhs%values(i))) then
                count = count + 1
                buffer(count) = lhs%values(i)
            end if
        end do

        allocate (trimmed(count))
        if (count > 0) trimmed = buffer(1:count)
        out = make_set(trimmed)
    end function difference_set

    function intersection_set(lhs, rhs) result(out)
        type(int_set), intent(in) :: lhs, rhs
        type(int_set) :: out
        integer, allocatable :: buffer(:), trimmed(:)
        integer :: i, count

        allocate (buffer(min(size(lhs%values), size(rhs%values))))
        count = 0
        do i = 1, size(lhs%values)
            if (any(rhs%values == lhs%values(i))) then
                count = count + 1
                buffer(count) = lhs%values(i)
            end if
        end do

        allocate (trimmed(count))
        if (count > 0) trimmed = buffer(1:count)
        out = make_set(trimmed)
    end function intersection_set

    subroutine normalize(set_value)
        type(int_set), intent(inout) :: set_value
        integer, allocatable :: sorted(:), unique_values(:)
        integer :: i, count

        if (.not. allocated(set_value%values)) then
            allocate (set_value%values(0))
            return
        end if

        if (size(set_value%values) == 0) return

        sorted = set_value%values
        call sort_values(sorted)

        count = 1
        do i = 2, size(sorted)
            if (sorted(i) /= sorted(i - 1)) count = count + 1
        end do

        allocate (unique_values(count))
        unique_values(1) = sorted(1)
        count = 1
        do i = 2, size(sorted)
            if (sorted(i) /= sorted(i - 1)) then
                count = count + 1
                unique_values(count) = sorted(i)
            end if
        end do

        call move_alloc(unique_values, set_value%values)
    end subroutine normalize

    subroutine sort_values(values)
        integer, intent(inout) :: values(:)
        integer :: i, j, temp

        do i = 1, size(values) - 1
            do j = i + 1, size(values)
                if (values(j) < values(i)) then
                    temp = values(i)
                    values(i) = values(j)
                    values(j) = temp
                end if
            end do
        end do
    end subroutine sort_values

    subroutine print_set(this)
        class(int_set), intent(in) :: this
        integer :: i

        write (*, '(A)', advance='no') "{ "
        do i = 1, size(this%values)
            write (*, '(I0)', advance='no') this%values(i)
            if (i < size(this%values)) write (*, '(A)', advance='no') ", "
        end do
        write (*, '(A)') " }"
    end subroutine print_set

end module int_set_module

program Q3
    use int_set_module
    implicit none

    type(int_set) :: a, b, c

    a = make_set([1, 2, 3, 5, 8, 8, 5, 2])
    b = make_set([2, 4, 6, 8, 10, 2])

    call set_utf8_console()

    write (*, '(A)') "Q3：使用派生类型实现整数集合及运算符重载"
    write (*, '(A)', advance='no') "集合 A = "
    call a%print()
    write (*, '(A)', advance='no') "集合 B = "
    call b%print()

    c = a + b
    write (*, '(A)', advance='no') "A + B（并集）        = "
    call c%print()

    c = a - b
    write (*, '(A)', advance='no') "A - B（差集）        = "
    call c%print()

    c = a * b
    write (*, '(A)', advance='no') "A * B（交集）        = "
    call c%print()

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
end program Q3
