// printb.c

#include <stdio.h>

void printb(long long n) {
    long long s, c;
    for (c = 63; c >= 0; --c) {
        s = n >> c;
        if ((c + 1) % 8 == 0)
            printf(" ");

        printf(((s & 1) ? "1" : "0"));
    }
    printf("\n");
}