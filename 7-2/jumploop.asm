extern printf

section .data
    number dq 1000000000
    fmt    db "The sum from 0 to %ld is %ld", 10, 0

section .bss

section .text
    global main

main:
    push rbp
    mov  rbp, rsp
    mov  rbx, 0   ; 计数器
    mov  rax, 0   ; sum放在rax中
jloop:
    add  rax, rbx
    inc  rbx
    cmp  rbx, [number] ; 比较rbx和number是否相等
    jle  jloop         ; 如果rbx小于等于number，则继续循环
    mov  rdi, fmt
    mov  rsi, [number]
    mov  rdx, rax
    mov  rax, 0
    call printf
    mov  rsp, rbp
    pop  rbp
    ret