;alive.asm
section .data
    msg1   db "Hello, World!", 0      ; 带换行和0结尾的字符串
    msg2   db "Alive and Kicking!", 0 ; 带换行和0结尾的字符串
    radius dq 357                     ; 声明64bit变量
    pi     dq 3.14                    ; 声明64bit变量
    fmtstr db "%s", 10, 0             ; 打印字符器的格式
    fmtflt db "%lf", 10, 0            ; 打印浮点数的格式
    fmtint db "%d", 10, 0             ; 打印整数的格式

section .bss

section .text
    global main

extern printf

main:
    push rbp          ; 保存旧的栈基地址
    mov  rbp,rsp      ; 设置新的栈基地址

; print msg1
    mov  rax, 0       ; 没有浮点数
    mov  rdi, fmtstr
    mov  rsi, msg1
    call printf

; print msg2
    mov  rax, 0       ; 没有浮点数
    mov  rdi, fmtstr
    mov  rsi, msg2
    call printf

; print radius
    mov  rax, 0       ; 没有浮点数
    mov  rdi, fmtint
    mov  rsi, [radius]
    call printf

; print pi
    mov  rax, 1       ; 使用一个XMM寄存器
    mov  rdi, fmtflt
    movq xmm0, [pi]
    call printf

    mov     rsp,rbp      ; 恢复原栈顶指针（rsp）
    pop     rbp          ; 恢复原栈基地址
    ret