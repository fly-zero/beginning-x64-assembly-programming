; stack.asm

extern printf

section .data
    string    db  "ABCDE",0
    stringLen equ $-string-1 ; declare string length: &stringLen - &string - 1
    fmt1      db  "The original string: %s",10,0
    fmt2      db  "The reserved string: %s",10,0

section .bss

section .text
    global main
main:
    push rbp
    mov  rbp, rsp

    ; print original string
    mov  rdi, fmt1
    mov  rsi, string
    mov  rax, 0
    call printf

    ; push charactor into stack
    xor  rax, rax
    mov  rbx, string
    mov  rcx, stringLen
    mov  r12, 0
pushLoop:
    mov  al, byte [rbx + r12]
    push rax
    inc  r12
    loop pushLoop

    ; pop charactor back to string
    mov  rbx, string
    mov  rcx, stringLen
    mov  r12, 0
popLoop:
    pop  rax
    mov  byte [rbx + r12], al
    inc  r12
    loop popLoop
    mov  byte [rbx + r12], 0

    ; print reversed string
    mov  rdi, fmt2
    mov  rsi, string
    mov  rax, 0
    call printf

    mov rsp,rbp
    pop rbp
    ret