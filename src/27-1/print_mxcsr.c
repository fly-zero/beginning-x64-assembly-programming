// print_mxcsr.c

#include <stdio.h>

void print_mxcsr(long long n) {
    long long s, c;
    for (c = 15; c >= 0; --c) {
        s = n >> c;
        if ((c + 1) % 4 == 0)
            printf(" ");
        printf("%c", (char)('0' + (s & 1)));
    }
    printf("\n");
}