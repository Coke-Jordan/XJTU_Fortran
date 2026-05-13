#include <stdio.h>
#include <string.h>

/* 第4题：统计位数、顺序输出各位数字，并逆序输出整数。 */
int main(void)
{
    int n;
    char digits[16];
    int len;
    int i;

    printf("请输入一个不多于5位的正整数：");
    if (scanf("%d", &n) != 1 || n <= 0 || n > 99999) {
        printf("数字输入无效。\n");
        return 1;
    }

    sprintf(digits, "%d", n);
    len = (int)strlen(digits);

    printf("位数：%d\n", len);

    printf("从高位到低位输出：");
    for (i = 0; i < len; ++i) {
        if (i > 0) {
            printf(" ");
        }
        printf("%c", digits[i]);
    }
    printf("\n");

    printf("逆序输出：");
    for (i = len - 1; i >= 0; --i) {
        printf("%c", digits[i]);
    }
    printf("\n");

    return 0;
}
