; sse_string_length.asm

extern printf

section .data
    string1 db "The quick brown fox jumps over the lazy river.", 0
    fmt1    db "This is our string: %s ", 10, 0
    fmt2    db "Our string is %d characters long.", 10, 0

section .bss

section .text
    global main

;======================================================
main:
    push rbp
    mov  rbp, rsp

    mov  rdi, fmt1
    mov  rsi, string1
    xor  rax, rax
    call printf
    mov  rdi, string1
    call pstrlen
    mov  rdi, fmt2
    mov  rsi, rax
    xor  rax, rax
    call printf

    mov  rsp, rbp
    pop  rbp
    ret

;======================================================
pstrlen:
    push      rbp
    mov       rbp, rsp

    mov       rax, -16                     ; rax 为长度计数，初始化为 -16
    pxor      xmm0, xmm0                   ; xmm0 全部初始化了 0
.not_found:
    add       rax, 16                      ; 每个循环开始，先将 rax 增加 16
    pcmpistri xmm0, [rdi + rax], 00001000b ; 在字符中 [rdi + rax] 中匹配 xmm0；若 [rdi + rax] 内存中存在 0 字符，则设置 ZF
    jnz       .not_found                   ; 字符串已遇到结尾
    add       rax, rcx                     ; 找到 0，rcx 中包含匹配中的字符偏移
    inc       rax                          ; rax 是以 0 开头的索引，增加 1 即为字符串长度

    leave
    ret