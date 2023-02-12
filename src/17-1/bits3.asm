; bits3.asm

extern printb
extern printf

section .data
    msg1     db "No bits are set:", 10, 0
    msg2     db 10, "set bit #4, that is the 5th bit:", 10, 0
    msg3     db 10, "set bit #7, that is the 8th bit:", 10, 0
    msg4     db 10, "set bit #8, that is the 9th bit:", 10, 0
    msg5     db 10, "set bit #61, that is the 62th bit:", 10, 0
    msg6     db 10, "Clear bit #8, that is the 9th bit:", 10, 0
    msg7     db 10, "Test bit #61, and display rdi:", 10, 0
    bitflags dq 0

section .bss

section .text
global main
main:
    push rbp
    mov  rbp, rsp

    ; 打印标题
    mov  rdi, msg1
    xor  rax, rax
    call printf

    ; 打印 bitflags
    mov  rdi, [bitflags]
    call printb

    ; 设置 bit4
    mov  rdi, msg2
    xor  rax, rax
    call printf

    bts qword [bitflags], 4
    mov rdi, [bitflags]
    call printb

    ; 设置 bit7
    mov  rdi, msg3
    xor  rax, rax
    call printf

    bts  qword [bitflags], 7
    mov  rdi, [bitflags]
    call printb

    ; 设置 bit8
    mov  rdi, msg4
    xor  rax, rax
    call printf

    bts  qword [bitflags], 8
    mov  rdi, [bitflags]
    call printb

    ; 设置 bit61
    mov  rdi, msg5
    xor  rax, rax
    call printf

    bts  qword [bitflags], 61
    mov  rdi, [bitflags]
    call printb

    ; 清除 bit8
    mov  rdi, msg6
    xor  rax, rax
    call printf

    btr  qword [bitflags], 8
    mov  rdi, [bitflags]
    call printb

    ; 测试 bit61（如果为 1，将设置 CF）
    mov  rdi, msg7
    xor  rax, rax
    call printf

    mov  rax, 61
    xor  rdi, rdi
    bt   [bitflags], rax
    setc dil             ; 如果设置了 CF，则将 rdi 的低位置 1
    call printb

    leave
    ret