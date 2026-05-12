!第4题
PROGRAM POPULATION
    IMPLICIT NONE
    REAL :: P0 = 14.05E8       ! 初始人口（单位：人）
    REAL :: r = -0.0028        ! 年增长率（-0.28%）
    REAL :: P
    INTEGER :: n

    PRINT *, "请输入年数 n:"
    READ *, n
    P = P0 * (1 + r) ** n
    PRINT *, n, "年后人口为：", P, "人"
END PROGRAM POPULATION
