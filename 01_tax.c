#include <stdio.h>

/* 第1题：根据货物价格计算应缴税金。 */
int main(void)
{
    double price;
    double rate;

    printf("请输入货物价格：");
    if (scanf("%lf", &price) != 1 || price < 0.0) {
        printf("价格输入无效。\n");
        return 1;
    }

    /* 按价格区间确定税率。 */
    if (price >= 10000.0) {
        rate = 0.05;
    } else if (price >= 5000.0) {
        rate = 0.03;
    } else if (price >= 1000.0) {
        rate = 0.02;
    } else {
        rate = 0.0;
    }

    printf("税率：%.0f%%\n", rate * 100.0);
    printf("税金：%.2f\n", price * rate);

    return 0;
}
