; rect.asm
section .data

section .bss

section .text

global rarea
rarea:
section .text
    push rbp
    mov  rbp, rsp

    mov  rax, rdi
    imul rax, rsi

    leave
    ret

global rcircum
rcircum:
section .text
    push rbp
    mov  rbp, rsp

    mov  rax, rdi
    add  rax, rsi
    sal  rax, 1

    leave
    ret