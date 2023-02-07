; function2.asm

extern printf

section .data
    radius dq 10.0

section .bss

section .text

; -----------------------------
area:
section .data
    .pi dq 3.141592654 ; area 的局部变量

section .text
    push rbp
    mov  rbp, rsp

    movsd xmm0, [radius]
    mulsd xmm0, [radius]
    mulsd xmm0, [.pi]

    leave
    ret

; -----------------------------
circum:
section .data
    .pi dq 3.14 ; circum 的局部变量

section .text

    push rbp
    mov  rbp, rsp

    movsd xmm0, [radius]
    addsd xmm0, [radius]
    mulsd xmm0, [.pi]

    leave
    ret

; -----------------------------
circle:
section .data
    .fmt_area   db "The area is %f", 10, 0
    .fmt_circum db "The circumference is %f", 10, 0

section .text
    push rbp
    mov  rbp, rsp

    call area
    mov  rdi, .fmt_area
    mov  rax, 1 ; area 函数返回的面积在 xmm0 中
    call printf

    call circum
    mov  rdi, .fmt_circum
    mov  rax, 1; circum 函数返回的周长在 xmm0 中
    call printf

    leave
    ret

; -----------------------------
global main

main:
    push rbp
    mov  rbp, rsp

    call circle

    leave
    ret