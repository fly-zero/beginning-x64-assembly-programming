; function6.asm

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
    fmt     db "The string is: %s", 10, 0

section .bss
    flist   resb 11 ; 在全局未初始化数据段中预留 11 字节空间

section .text
global main
main:
    push rbp
    mov  rbp, rsp

    mov  rdi, flist ; 长度
    mov  rsi, first
    mov  rdx, second
    mov  rcx, third
    mov  r8, fourth
    mov  r9, fifth
    push tenth
    push ninth
    push eighth
    push seventh
    push sixth
    call lfunc

    ; 打印结果
    mov  rdi, fmt
    mov  rsi, flist
    mov  rax, 0
    call printf

    leave
    ret

;--------------------------------
lfunc:
    push rbp
    mov  rbp, rsp

    xor rax, rax
    mov al, byte[rsi]
    mov [rdi], al
    mov al, byte[rdx]
    mov [rdi + 1], al
    mov al, byte[rcx]
    mov [rdi + 2], al
    mov al, byte[r8]
    mov [rdi + 3], al
    mov al, byte[r9]
    mov [rdi + 4], al

    ; 获取堆栈中的参数
    push rbx
    xor  rbx, rbx
    mov  rax, qword[rbp + 16] ; 跳过 rbp, rip，取堆栈中的长度，计算方式如下：
                              ; push rbp 的操作顺序为： ++rsp; *rsp = rbp
                              ; 因此当前函数栈帧的 rbp 向上偏移 16 字节即为
                              ; 上一个函数给的栈中的参数
    mov  bl, byte[rax]
    mov  [rdi + 5], bl
    mov  rax, qword[rbp + 24]
    mov  bl, byte[rax]
    mov  [rdi + 6], bl
    mov  rax, qword[rbp + 32]
    mov  bl, byte[rax]
    mov  [rdi + 7], bl
    mov  rax, qword[rbp + 40]
    mov  bl, byte[rax]
    mov  [rdi + 8], bl
    mov  rax, qword[rbp + 48]
    mov  bl, byte[rax]
    mov  [rdi + 9], bl
    mov  bl, 0
    mov  [rdi + 10], bl
    pop  rbx

    leave
    ret