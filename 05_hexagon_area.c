#include <math.h>
#include <stdio.h>

/* 使用海伦公式计算三角形面积。 */
static double triangle_area(double a, double b, double c)
{
    double s;
    double value;

    if (a + b <= c || a + c <= b || b + c <= a) {
        return 0.0;
    }

    s = (a + b + c) / 2.0;
    value = s * (s - a) * (s - b) * (s - c);
    return sqrt(value);
}

/* 第5题：把六边形按辅助线拆成四个三角形求面积。 */
int main(void)
{
    const double l1 = 10.0;
    const double l2 = 20.0;
    const double l3 = 18.0;
    const double l4 = 15.0;
    const double l5 = 21.0;
    const double l6 = 14.0;
    const double l7 = 30.0;
    const double l8 = 36.0;
    const double l9 = 28.0;

    const double area1 = triangle_area(l1, l8, l9);
    const double area2 = triangle_area(l2, l7, l8);
    const double area3 = triangle_area(l3, l4, l7);
    const double area4 = triangle_area(l5, l6, l9);
    const double total = area1 + area2 + area3 + area4;

    printf("各三角形面积：\n");
    printf("(l1, l8, l9): %.4f\n", area1);
    printf("(l2, l7, l8): %.4f\n", area2);
    printf("(l3, l4, l7): %.4f\n", area3);
    printf("(l5, l6, l9): %.4f\n", area4);
    printf("六边形面积：%.4f\n", total);

    return 0;
}
