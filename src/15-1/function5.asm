; function5.asm

extern printf

section .data
    first   db "A", 0
    second  db "B", 0
    third   db "C", 0
    fourth  db "D", 0
    fifth   db "E", 0
    sixth   db "F", 0
    seventh db "G", 0
    eighth  db "H", 0
    ninth   db "I", 0
    tenth   db "J", 0
    fmt1    db "The string is: %s%s%s%s%s%s%s%s%s%s", 10, 0
    fmt2    db "PI = %f", 10, 0
    pi      dq 3.14

section .bss

section .text
global main

main:
    push rbp
    mov  rbp, rsp

    mov rdi, fmt1 
    mov rsi, first  ; first 使用寄存器
    mov rdx, second
    mov rcx, third
    mov r8, fourth
    mov r9, fifth

    sub  rsp, 8 ; 原书中不需要这一行，但是在较新的 printf 实现中，即使没有打印浮点数，也会使用到 XMM 寄存器加载指令
                ; 后面 push 了奇数个 8 字节，因此在 push 之前将 rsp 向下移动 8 个字节，从而使栈最终是对齐到 16 字节

    push tenth  ; 现在开始在栈上以相反顺序压入参数
    push ninth
    push eighth
    push seventh
    push sixth

    mov  rax, 0
    call printf

    ; and   rsp, 0xfffffffffffffff0 ; 之前已经做了对齐，因此原书中这行代码不再需要

    movsd xmm0, [pi]              ; 打印一个浮点数
    mov   rax, 1                  ; 有 1 个浮点参数
    mov   rdi, fmt2
    call  printf

    mov rsp, rbp
    pop rbp
    ret