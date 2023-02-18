; cmdline.asm

extern printf

section .data
    msg db "The command and arguments: ", 10, 0
    fmt db "%s", 10, 0

section .bss

section .text
    global main

main:
    push rbp
    mov  rbp, rsp

    mov  r12, rdi ; argc
    mov  r13, rsi ; argv
    mov  rdi, msg
    call printf
    xor  r14, r14
.ploop:            ; 循环打印 main 函数参数
    mov  rdi, fmt
    mov  rsi, qword [r13 + r14 * 8]
    call printf
    inc  r14
    cmp  r14, r12
    jl   .ploop

    leave
    ret
