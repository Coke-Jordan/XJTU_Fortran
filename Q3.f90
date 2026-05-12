!第3题
!改后的程序
PROGRAM MAIN
    IMPLICIT NONE
    INTEGER :: I, J, K
    REAL :: ANS

    I = 1
    J = 3
    K = 5
    ANS = SQRT(REAL(I+J) / K)   
    PRINT *, "计算结果为：", ANS
END PROGRAM MAIN
