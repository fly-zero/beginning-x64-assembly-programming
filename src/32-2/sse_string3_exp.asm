; sse_string3_exp.asm
; 比较字符串电显式长度

extern printf

section .data
    string1    db  "the quick brown fox jumps over the lazy river"
    string1Len equ $ - string1
    string2    db  "the quick brown fox jumps over the lazy river"
    string2Len equ $ - string2
    dummy      db  "confuse the world"
    string3    db  "the quick brown fox jumps over the lazy dog"
    string3Len equ $ - string3
    fmt1       db  "Strings 1 and 2 are equal.", 10, 0
    fmt11      db  "Strings 1 and 2 differ at position %i.", 10, 0
    fmt2       db  "Strings 2 and 3 are equal.", 10, 0
    fmt22      db  "Strings 2 and 3 differ at position %i.", 10, 0

section .bss
    buffer resb 64

section .text
    global main

main:
    push rbp
    mov rbp, rsp

    ; 比较 string1 和 string2
    mov  rsi, string1
    mov  rdi, string2
    mov  rdx, string1Len
    mov  rcx, string2Len
    call pstrcmp
    push rax ; 将结果压入栈，以便后面使用
    sub  rsp, 8 ; 为了对齐栈，减去 8

; 打印 string1、string2 以及结果
;-------------------------------------------
; 首先用换行符构建字符串并以 0 终止
; string1
    mov rsi, string1
    mov rdi, buffer
    mov rcx, string1Len
    rep movsb
    mov byte [rdi], 10 ; 将换行符写入缓冲区
    inc rdi            ; 将终止 0 写入缓冲区
    mov byte [rdi], 0
; 打印
    mov  rdi, buffer
    xor  rax, rax
    call printf
; string2
    mov rsi, string2
    mov rdi, buffer
    mov rcx, string2Len
    rep movsb
    mov byte [rdi], 10 ; 将换行符写入缓冲区
    inc rdi            ; 将终止 0 写入缓冲区
    mov byte [rdi], 0
; 打印
    mov  rdi, buffer
    xor  rax, rax
    call printf
;-------------------------------------------
; 打印比较结果
    add rsp, 8 ; 前面为了对齐，减去了 8
    pop rax
    mov rdi, fmt1
    cmp rax, 0
    je  eql1
    mov rdi, fmt11
eql1:
    mov  rsi, rax
    xor  rax, rax
    call printf
; 比较 string2 和 string3
    mov  rsi, string2
    mov  rdi, string3
    mov  rdx, string2Len
    mov  rcx, string3Len
    call pstrcmp
    push rax ; 将结果压入栈，以便后面使用
    sub  rsp, 8 ; 为了对齐栈，减去 8
; 打印 string3 和结果
;-------------------------------------------
; 首先用换行符构建字符串并以 0 终止
; string3
    mov rsi, string3
    mov rdi, buffer
    mov rcx, string3Len
    rep movsb
    mov byte [rdi], 10 ; 将换行符写入缓冲区
    inc rdi            ; 将终止 0 写入缓冲区
    mov byte [rdi], 0
; 打印
    mov  rdi, buffer
    xor  rax, rax
    call printf
;-------------------------------------------
; 打印比较结果
    add rsp, 8 ; 前面为了对齐，减去了 8
    pop rax
    mov rdi, fmt2
    cmp rax, 0
    je  eql2
    mov rdi, fmt22
eql2:
    mov  rsi, rax
    xor  rax, rax
    call printf

    mov rax, 0
    leave
    ret
;-------------------------------------------
pstrcmp:
    push rbp
    mov rbp, rsp

    xor rbx, rbx
    mov rax, rdx ; rax = string1Len
    mov rdx, rcx ; rdx = string2Len
    xor rcx, rcx ; rcx = i
.loop:
    movdqu    xmm1, [rdi + rbx]
    pcmpestri xmm1, [rsi + rbx], 0x18 ; equal each | neg.polarity
    jc        .differ                 ; IntRes2 为 0 时，CF 复位
    jz        .equal                  ; RDX < 16 时，ZF 置位
    add       rbx, 16
    sub       rax, 16
    sub       rdx, 16
    jmp       .loop
.differ:
    mov       rax, rbx
    add       rax, rcx ; rax += i
    inc       rax
    jmp       exit
.equal:
    xor       rax, rax
exit:
    leave
    ret