!第1题
PROGRAM VERIFY
    IMPLICIT NONE
    REAL :: A, B, T, X
    INTEGER :: I, J, K

    ! 第1题初始值
    A = 1.0; B = 3.5; T = 10.0; X = 5.0
    I = -5; J = 7; K = 3

    PRINT *, "=== 第1题计算结果 ==="
    PRINT *, "A+T =", A+T
    PRINT *, "(B+(X/T))/(4.0*A) =", (B+(X/T))/(4.0*A)
    PRINT *, "(I*J)/K =", (I*J)/K
    PRINT *, "(I/K)*J+T/X =", REAL(I/K)*J+T/X
    PRINT *, "-(K+1)/5+I*A-B =", -(K+1)/5+I*A-B
    PRINT *, "SQRT(REAL(ABS(K)+1)) =", SQRT(REAL(ABS(K)+1))
    PRINT *, "MAX(J,MOD(J,K)) =", MAX(J, MOD(J,K))
    PRINT *, "J+INT(T/B)/2 =", J+INT(T/B)/2 
END PROGRAM VERIFY
