#include <stdio.h>
#include <string.h>

#define MAX_LEN 256

/* 删除 fgets 读入字符串末尾的换行符。 */
static void chomp(char s[])
{
    size_t len = strlen(s);

    if (len > 0 && s[len - 1] == '\n') {
        s[len - 1] = '\0';
    }
}

static int contains_char(const char *s, char ch)
{
    while (*s != '\0') {
        if (*s == ch) {
            return 1;
        }
        ++s;
    }
    return 0;
}

/* 第3题：删除 s1 中所有与 s2 任意字符相同的字符。 */
void squeeze(char *s1, const char *s2)
{
    char *src = s1;
    char *dst = s1;

    while (*src != '\0') {
        if (!contains_char(s2, *src)) {
            *dst = *src;
            ++dst;
        }
        ++src;
    }
    *dst = '\0';
}

int main(void)
{
    char s1[MAX_LEN];
    char s2[MAX_LEN];

    printf("请输入字符串 s1：");
    if (fgets(s1, sizeof(s1), stdin) == NULL) {
        printf("输入无效。\n");
        return 1;
    }

    printf("请输入字符串 s2：");
    if (fgets(s2, sizeof(s2), stdin) == NULL) {
        printf("输入无效。\n");
        return 1;
    }

    chomp(s1);
    chomp(s2);
    squeeze(s1, s2);

    printf("删除后的字符串：%s\n", s1);

    return 0;
}
