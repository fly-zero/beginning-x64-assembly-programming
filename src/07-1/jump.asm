extern printf

section .data
    number1 dq 42
    number2 dq 41
    fmt1 db "NUMBER1 >= NUMBER2", 10, 0
    fmt2 db "NUMBER1 < NUMBER2", 10, 0

section .bss

section .text
    global main

main:
    push rbp
    mov  rbp, rsp
    mov  rax, [number1]
    mov  rbx, [number2]
    cmp  rax, rbx
    jge  greater
    mov  rdi, fmt2
    jmp  call_print
greater:
    mov  rdi, fmt1
call_print:
    mov  rax, 0
    call printf
    mov  rsp, rbp
    pop  rbp
    ret