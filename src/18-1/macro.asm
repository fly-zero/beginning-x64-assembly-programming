; macro.asm

extern printf

%define double_it(r)    sal r, 1 ; 单行宏

%macro  prntf 2 ; 带有两个参数的多行宏
    section .data                   ; 在宏中定义变量，使用 %% 告诉编译器每次使用宏时生产新的变量实例；否则会产生重定义错误
        %%arg1   db %1, 0           ; 第一个参数
        %%fmtint db "%s %ld", 10, 0 ; 格式字符串

    section .text
        mov  rdi, %%fmtint
        mov  rsi, %%arg1
        mov  rdx, [%2]              ; 第二个参数
        xor  rax, rax
        call printf
%endmacro

section .data
    number dq 15

section .bss

section .text
global main
main:
    push rbp
    mov  rbp, rsp

    prntf "The number is", number
    mov   rax, [number]
    double_it(rax)
    mov   [number], rax
    prntf "The number times 2 is", number

    leave
    ret
