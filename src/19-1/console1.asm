; console1.asm

section .data
    msg1       db  "Hello, World!", 10, 0
    msg1len    equ $ - msg1
    msg2       db  "Your turn: ", 0
    msg2len    equ $ - msg2
    msg3       db  "You answered: ", 0
    msg3len    equ $ - msg3
    inputlen   equ 10 ; intputbuffer 的长度

section .bss
    input resb inputlen + 1

section .text
    global main

main:
    push rbp
    mov  rbp, rsp

    mov  rsi, msg1  ; 打印第一个字符串
    mov  rdx, msg1len
    call prints

    mov  rsi, msg2  ; 打印第二个字符串
    mov  rdx, msg2len
    call prints

    mov  rsi, input
    mov  rdx, inputlen
    call reads      ; 等待输入

    mov  rsi, msg3  ; 打印第三个字符串
    mov  rdx, msg3len
    call prints

    mov  rsi, input ; 打印 inputbuffer
    mov  rdx, inputlen
    call prints

    leave
    ret

; ----------------------------------
prints:
    push rbp
    mov  rbp, rsp

    mov rax, 1 ; write 系统调用号
    mov rdi, 1 ; 标准输出
    syscall

    leave
    ret

; ----------------------------------
reads:
    push rbp
    mov  rbp, rsp

    mov rax, 0 ; read 系统调用号
    mov rdi, 0 ; 标准输入
    syscall

    leave
    ret