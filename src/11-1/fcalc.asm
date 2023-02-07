; fcalc.adm

extern printf

section .data
    number1  dq 9.0
    number2  dq 73.0
    fmt      db "The numbers are %f and %f", 10, 0
    fmtfloat db "%s %f", 10, 0
    f_sum    db "The float sum of %f and %f is %f", 10, 0
    f_dif    db "The float difference of %f and %f is %f", 10, 0
    f_mul    db "The float product of %f and %f is %f", 10, 0
    f_div    db "The float division of %f by %f is %f", 10, 0
    f_sqrt   db "The float squareroot of %f is %f", 10, 0

section .bss

section .text
    global main

main:
    push rbp
    mov  rbp, rsp

    ; 打印数字
    movsd xmm0, [number1]
    movsd xmm1, [number2]
    mov   rdi, fmt
    mov   rax, 2 ; 使用了两个浮点数
    call  printf

    ; 和（sum）
    movsd xmm2, [number2] ; 将双精度数放入 xmm
    addsd xmm2, [number1] ; 将一个双精度浮点数加到 xmm 中

    ; 打印结果
    movsd xmm0, [number1]
    movsd xmm1, [number2]
    mov   rdi, f_sum
    mov   rax, 3 ; 使用了两个浮点数
    call  printf

    ; 差（difference）
    movsd xmm2, [number1] ; 将双精度数放入 xmm
    subsd xmm2, [number2] ; 从 xmm 中的双精度浮点数减去 number2

    ; 打印结果
    movsd xmm0, [number1]
    movsd xmm1, [number2]
    mov   rdi, f_dif
    mov   rax, 3 ; 使用了两个浮点数
    call  printf

    ; 积（multiplication）
    movsd xmm2, [number1] ; 将双精度数放入 xmm
    mulsd xmm2, [number2] ; 将 xmm 中的的浮点数乘以 number2

    ; 打印结果
    movsd xmm0, [number1]
    movsd xmm1, [number2]
    mov   rdi, f_mul
    mov   rax, 3 ; 使用了两个浮点数
    call  printf

    ; 除（division）
    movsd xmm2, [number1]
    divsd xmm2, [number2]

    ; 打印结果
    movsd xmm0, [number1]
    movsd xmm1, [number2]
    mov   rdi, f_div
    mov   rax, 3 ; 使用了两个浮点数
    call  printf

    ; 平方根（squreroot）
    sqrtsd xmm1, [number1] ; 双精度浮点数 number1 开平方根，结果放入 xmm1 中

    ; 打印结果
    movsd xmm0, [number1]
    mov   rdi, f_sqrt
    mov   rax, 2 ; 使用了两个浮点数
    call  printf

    ; exit
    mov rsp, rbp
    pop rbp
    ret