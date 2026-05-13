#include <stdio.h>

#define MAX_N 20

/* 第6题 C 语言版：按 n 打印杨辉三角。 */
void yang(int n)
{
    long long a[MAX_N][MAX_N] = {{0}};
    int i;
    int j;
    int k;

    /* 先计算杨辉三角中每个位置的数值。 */
    for (i = 0; i < n; ++i) {
        a[i][0] = 1;
        a[i][i] = 1;
        for (j = 1; j < i; ++j) {
            a[i][j] = a[i - 1][j - 1] + a[i - 1][j];
        }
    }

    for (i = 0; i < n; ++i) {
        for (k = 0; k < n - i - 1; ++k) {
            printf("  ");
        }
        for (j = 0; j <= i; ++j) {
            printf("%4lld", a[i][j]);
        }
        printf("\n");
    }
}

int main(void)
{
    int n;

    printf("请输入 n（1-%d）：", MAX_N);
    if (scanf("%d", &n) != 1 || n < 1 || n > MAX_N) {
        printf("n 输入无效。\n");
        return 1;
    }

    yang(n);

    return 0;
}
