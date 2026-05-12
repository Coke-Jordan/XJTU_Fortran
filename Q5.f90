!第5题
PROGRAM SORT4
    IMPLICIT NONE
    REAL :: A, B, C, D, temp

    PRINT *, "请输入四个实数（用空格或回车分隔）："
    READ *, A, B, C, D
    IF (A < B) THEN; temp = A; A = B; B = temp; END IF
    IF (A < C) THEN; temp = A; A = C; C = temp; END IF
    IF (A < D) THEN; temp = A; A = D; D = temp; END IF
    IF (B < C) THEN; temp = B; B = C; C = temp; END IF
    IF (B < D) THEN; temp = B; B = D; D = temp; END IF
    IF (C < D) THEN; temp = C; C = D; D = temp; END IF

    PRINT *, "降序排列结果：", A, B, C, D
END PROGRAM SORT4
