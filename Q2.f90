!第2题
PROGRAM VERIFY
    IMPLICIT NONE
    REAL ::  A, B, C
    ! 第2题初始值
    A = 2.0; B = 1.0; C = -2.0

    PRINT *, "=== 第2题计算结果 ==="
    PRINT *, "(1) (3*a**2+4*b**2)/(a-b) =", (3*A**2+4*B**2)/(A-B)
    PRINT *, "(2) (-b+SQRT(b**2-4*a*c))/(2*a) =", (-B+SQRT(B**2-4*A*C))/(2*A)
    PRINT *, "(3) 6*LOG((b+c)**2)/(140/(3+a)) =", 6*LOG((B+C)**2)/(140.0/(3.0+A))
    PRINT *, "(4) COS(b/SQRT(a**2+b**2))*SIN(ATAN(SQRT(a**2+b**2)/ABS(c))) =", &
               COS(B/SQRT(A**2+B**2))*SIN(ATAN(SQRT(A**2+B**2)/ABS(C)))
END PROGRAM VERIFY
