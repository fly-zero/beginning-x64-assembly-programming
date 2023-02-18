; console2.asm

section .data
    msg1     db  "Hello, World", 10, 0
    msg2     db  "Your turn (only a-z): ", 0
    msg3     db  "Your answered: ", 0
    inputlen equ 10
    NL       db   0xa

section .bss
    input resb inputlen + 1

section .text
    global main

main:
    push rbp
    mov  rbp, rsp

    mov  rdi, msg1     ; 打印第一个字符串
    call prints

    mov  rdi, msg2     ; 打印第二个字符串
    call prints

    mov  rdi, input
    mov  rsi, inputlen
    call reads         ; 等待输入

    mov  rdi, msg3     ; 打印第三个字符串
    call prints

    mov  rdi, input    ; 打印 input
    call prints

    mov  rdi, NL
    call prints

    leave
    ret

; ---------------------------------------------
prints:
    push rbp
    mov  rbp, rsp

    push r12

    ; 字符计数
    xor rdx, rdx
    mov r12, rdi
.lengthloop:
    cmp byte [r12], 0
    je  .lengthfound
    inc rdx
    inc r12
    jmp .lengthloop
.lengthfound:         ; 打印字符串
    cmp rdx, 0        ; 判断字符串长度是否为0
    je  .done
    mov rsi, rdi      ; 将 prints 函数的第一个参数（字符串地址）移动 rsi 中，作为 write 的第二个参数
    mov rax, 1        ; write 的系统调用号（1）
    mov rdi, 1        ; 第一个参数，标准输出
    syscall           ; 发起 write 系统调用，第三个参数（长度）在 rdx 中
.done:
    pop r12
    leave
    ret

; ---------------------------------------------
reads:
section .data

section .bss
    .inputchar resb 1

section .text
    push rbp
    mov  rbp, rsp

    push r12      ; r12 ~ r15 为被调用者保存寄存器（其实就是按照调用约定，被调函数在使用前负责 push，在使用后 负责pop 的寄存器）
    push r13
    push r14
    mov  r12, rdi          ; 缓冲区地址
    mov  r13, rsi          ; 缓冲区长度
    xor  r14, r14          ; 字符计数器
.readc:
    xor  rax, rax          ; read 系统调用号（0）
    mov  rdi, 0            ; 标准输入
    lea  rsi, [.inputchar] ; 输入缓冲区地址
    mov  rdx, 1            ; 输入缓冲区长度
    syscall                ; 发起 read 系统调用
    mov  al, [.inputchar]
    cmp  al, byte [NL]     ; 将输入字符与换行符比较
    je   .done             ; 是换行，则结束
    cmp  al, 97            ; 将输入字符与字符 'a' 比较
    jl   .readc            ; 若小于字符 'a'，则跳转到 .readc
    cmp  al, 122           ; 将输入字符与字符 'z' 比较
    jg   .readc            ; 若大于字符 'z'，则跳转到 .readc
    inc  r14               ; 增加计数器
    cmp  r14, r13          ; 比较计数器与缓冲区长度
    ja   .readc            ; 超过缓冲区长度了，再次跳转到 .readc
    mov  byte [r12], al    ; 保存字符到缓冲区
    inc  r12               ; 增加缓冲区指针的值
    jmp  .readc
.done:
    inc  r12
    mov  byte [r12], 0     ; 在缓冲区末尾添加 0
    pop r14
    pop r13
    pop r12

    leave
    ret