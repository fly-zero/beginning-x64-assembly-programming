; sse_string2_imp.asm
; 比较字符串的隐式长度

extern printf

section  .data
    string1 db "the quick brown fox jumps over the lazy river", 10, 0
    string2 db "the quick brown fox jumps over the lazy river", 10, 0
    string3 db "the quick brown fox jumps over the lazy dog", 10, 0
    fmt1    db "Strings 1 and 2 are equal.", 10, 0
    fmt11   db "Strings 1 and 2 differ at position %i.", 10, 0
    fmt2    db "Strings 2 and 3 are equal.", 10, 0
    fmt22   db "Strings 2 and 3 differ at position %i.", 10, 0

section .bss

section .text
    global main

; ------------------------------------------
main:
    push rbp
    mov  rbp, rsp

    ; 打印 string1
    mov  rdi, string1
    xor  rax, rax
    call printf

    ; 打印 string2
    mov  rdi, string2
    xor  rax, rax
    call printf

    ; 打印 string3
    mov  rdi, string3
    xor  rax, rax
    call printf

    ; 比较 string1 和 string2
    mov  rdi, string1
    mov  rsi, string2
    call pstrcmp
    mov  rdi, fmt1
    cmp  rax, 0
    je   eql1
    mov  rdi, fmt11
eql1:
    mov  rsi, rax
    xor  rax, rax
    call printf

    ; 比较 string1 和 string2
    mov  rdi, string2
    mov  rsi, string3
    call pstrcmp
    mov  rdi, fmt2
    cmp  rax, 0
    je   eql2
    mov  rdi, fmt22
eql2:
    mov  rsi, rax
    xor  rax, rax
    call printf


    leave
    ret

; ------------------------------------------
pstrcmp:
    push rbp
    mov  rbp, rsp

    xor       rax, rax
    xor       rbx, rbx
.loop:
    movdqu    xmm1, [rdi + rbx]
    pcmpistri xmm1, [rsi + rbx], 0x18 ; 控制字 0x18：对每个字节进行比较，若相等，则设置 IntRes1 对应的位，否则清除 InteRes1 对应位，最后 IntRes2 = ~IntRes1
    jc        .differ                 ; 若 IntRes2 等于 0（即字符串相等），则复位 CF；否则设置 CF
    jz        .equal                  ; 若 xmm1 / mem 中有空字符（'\0'）时，则设置 ZF；否则复位 ZF
    add       rbx, 16
    jmp       .loop
.differ:
    mov       rax, rbx
    add       rax, rcx
    inc       rax

.equal:
    leave
    ret