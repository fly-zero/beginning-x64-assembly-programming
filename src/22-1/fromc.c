#include <stdio.h>
#include <string.h>

extern int rarea(int, int);
extern int rcircum(int, int);
extern double carea(double);
extern double ccircum(double);
extern void sreverse(char *, int);
extern void adouble(double[], int);
extern double asum(double[], int);

int main()
{
    char rstring[64];
    int side1, side2, r_area, r_circum;
    double radius, c_area, c_circum;
    double darray[] = { 70.0, 83.2, 91.5, 72.1, 55.5 };
    long int len;
    double sum;

    // 使用 int 参数调用汇编函数
    printf("Compute area and circumference of a rectangle\n");
    printf("Enter the length of one side: \n");
    scanf("%d", &side1);
    printf("Enter the length of the other side: \n");
    scanf("%d", &side2);

    r_area = rarea(side1, side2);
    r_circum = rcircum(side1, side2);

    printf("The area of the rectangle = %d\n", r_area);
    printf("The circumference of the rectangle = %d\n\n", r_circum);

    // 使用双精度浮点数参数调用汇编函数
    printf("Compute area and circumference of a circle\n");
    printf("Enter the radius:\n");
    scanf("%lf", &radius);

    c_area = carea(radius);
    c_circum = ccircum(radius);

    printf("The area of the circle = %lf\n", c_area);
    printf("The circumference of the circle = %lf\n\n", c_circum);

    // 使用字符串参数调用汇编函数
    printf("Reverse a string\n");
    printf("Enter the string: \n");
    scanf("%s", rstring);
    printf("The string is = %s\n", rstring);

    sreverse(rstring, strlen(rstring));

    printf("The reversed string is = %s\n\n", rstring);

    // 使用数组参数调用汇编函数
    printf("Some array manipulations\n");
    len = sizeof darray / sizeof darray[0];

    printf("The array has %lu elements\n", len);
    printf("The elements of the array are: \n");
    for (int i = 0; i < len; ++i) {
        printf("Elements %d = %lf\n", i, darray[i]);
    }

    sum = asum(darray, len);
    printf("The sum of the elements of this array = %lf\n", sum);

    adouble(darray, len);
    printf("The elements of the doubled array are: \n");
    for (int i = 0; i < len; ++i) {
        printf("Elements %d = %lf\n", i, darray[i]);
    }

    sum = asum(darray, len);
    printf("The sum of the elements of this doubled array = %lf\n", sum);

    return 0;
}