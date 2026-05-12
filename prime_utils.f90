module prime_utils
    implicit none
    private
    public :: is_prime, build_prime_table

contains

    logical function is_prime(n)
        integer, intent(in) :: n
        integer :: i, upper

        if (n < 2) then
            is_prime = .false.
            return
        end if

        if (n == 2) then
            is_prime = .true.
            return
        end if

        if (mod(n, 2) == 0) then
            is_prime = .false.
            return
        end if

        upper = int(sqrt(real(n)))
        is_prime = .true.
        do i = 3, upper, 2
            if (mod(n, i) == 0) then
                is_prime = .false.
                exit
            end if
        end do
    end function is_prime

    subroutine build_prime_table(prime_flags)
        logical, intent(out) :: prime_flags(0:)
        integer :: limit, i, j, upper

        limit = ubound(prime_flags, 1)
        prime_flags = .true.

        prime_flags(0) = .false.
        if (limit >= 1) prime_flags(1) = .false.

        upper = int(sqrt(real(limit)))
        do i = 2, upper
            if (.not. prime_flags(i)) cycle
            do j = i * i, limit, i
                prime_flags(j) = .false.
            end do
        end do
    end subroutine build_prime_table

end module prime_utils
