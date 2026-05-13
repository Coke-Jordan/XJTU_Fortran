#include <stdio.h>

#define MAX_N 100

/* 使用插入排序将数组按从小到大排列。 */
static void sort_ascending(int a[], int n)
{
    int i;

    for (i = 1; i < n; ++i) {
        int key = a[i];
        int j = i - 1;

        while (j >= 0 && a[j] > key) {
            a[j + 1] = a[j];
            --j;
        }
        a[j + 1] = key;
    }
}

static void print_array(const int a[], int n)
{
    int i;

    for (i = 0; i < n; ++i) {
        if (i > 0) {
            printf(" ");
        }
        printf("%d", a[i]);
    }
    printf("\n");
}

/* 第2题：将一个新数插入已经排好序的一维数组。 */
int main(void)
{
    int a[MAX_N + 1];
    int n;
    int x;
    int i;

    printf("请输入数据个数（1-%d）：", MAX_N);
    if (scanf("%d", &n) != 1 || n < 1 || n > MAX_N) {
        printf("数据个数输入无效。\n");
        return 1;
    }

    printf("请输入%d个整数：", n);
    for (i = 0; i < n; ++i) {
        if (scanf("%d", &a[i]) != 1) {
            printf("数据输入无效。\n");
            return 1;
        }
    }

    sort_ascending(a, n);
    printf("排序后的数组：");
    print_array(a, n);

    printf("请输入要插入的数：");
    if (scanf("%d", &x) != 1) {
        printf("插入数据输入无效。\n");
        return 1;
    }

    /* 从后向前移动元素，给新数腾出合适位置。 */
    i = n - 1;
    while (i >= 0 && a[i] > x) {
        a[i + 1] = a[i];
        --i;
    }
    a[i + 1] = x;
    ++n;

    printf("插入后的数组：");
    print_array(a, n);

    return 0;
}
