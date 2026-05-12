module ModuleSORT
    implicit none
    private
    public :: bubble_sort

contains

    subroutine bubble_sort(a)
        integer, intent(inout) :: a(:)
        integer :: i, j, temp, n

        n = size(a)
        do i = n, 2, -1
            do j = 1, i - 1
                if (a(j + 1) < a(j)) then
                    temp = a(j)
                    a(j) = a(j + 1)
                    a(j + 1) = temp
                end if
            end do
        end do
    end subroutine bubble_sort

end module ModuleSORT
