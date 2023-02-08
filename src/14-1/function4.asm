; function4.asm

extern printf
extern c_area
extern c_circum
extern r_area
extern r_circum

global pi

section .data
    pi     dq 3.141592654
    radius dq 10.0
    side1  dq 4
    side2  dq 5
    fmtf   db "%s %f", 10, 0
    fmti   db "%s %d", 10, 0
    ca     db "The circle area is ", 0
    cc     db "The circle circumference is ", 0
    ra     db "The rectangle area is ", 0
    rc     db "The rectangle circumference is ", 0

section .bss

section .text

global main

main:
    push rbp
    mov  rbp, rsp

    ; 圆面积
    movsd xmm0, qword [radius] ; 半径，xmm0 参数
    call c_area                ; 返回的面积存放在 xmm0 中

    ; 打印圆面积
    mov  rdi, fmtf
    mov  rsi, ca
    mov  rax, 1
    call printf

    ; 圆周长
    movsd xmm0, qword [radius] ; 半径，xmm0 参数
    call  c_circum             ; 返回的周长存放在 xmm0 中

    ; 打印圆周长
    mov  rdi, fmtf
    mov  rsi, cc
    mov  rax, 1
    call printf

    ; 矩形面积
    mov  rdi, [side1]
    mov  rsi, [side2]
    call r_area       ; 返回的面积存放在 rax 中

    ; 打印矩形面积
    mov  rdi, fmti
    mov  rsi, ra
    mov  rdx, rax
    mov  rax, 0
    call printf

    ; 矩形周长
    mov  rdi, [side1]
    mov  rsi, [side2]
    call r_circum     ; 返回周长存放在 rax 中

    ; 打印矩形周长
    mov  rdi, fmti
    mov  rsi, rc
    mov  rdx, rax
    mov  rax, 0
    call printf

    mov rsp, rbp
    pop rbp
    ret
