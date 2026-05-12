PROGRAM SQRT_ITER
    IMPLICIT NONE
    REAL :: A, x_old, x_new, error

    PRINT *, "请输入一个非负实数 A:"
    READ *, A

    IF (A < 0) THEN
        PRINT *, "错误：负数没有实数平方根！"
        STOP
    END IF

    IF (A == 0.0) THEN
        PRINT *, "平方根为:0.0"
        STOP
    END IF

    x_old = A / 2.0   ! 初始值取 A/2
    DO
        x_new = (x_old + A / x_old) / 2.0   
        error = ABS(x_new - x_old)
        IF (error < 0.001) EXIT
        x_old = x_new
    END DO

    PRINT *, "平方根的近似值为：", x_new
END PROGRAM SQRT_ITER
