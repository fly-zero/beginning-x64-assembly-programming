; cpu.asm

extern printf

section .data
    fmt_no_sse db "This cpu does not support SSE", 10, 0
    fmt_sse42  db "This cpu supports SSE 4.2", 10, 0
    fmt_sse41  db "This cpu supports SSE 4.1", 10, 0
    fmt_ssse3  db "This cpu supports SSSE 3", 10, 0
    fmt_sse3   db "This cpu supports SSE 3", 10, 0
    fmt_sse2   db "This cpu supports SSE 2", 10, 0
    fmt_sse    db "This cpu supports SSE", 10, 0

section .bss

section .text

global main

; =================================================================
main:
    push rbp
    mov  rbp, rsp

    call cpu_sse ; 如果支持 SSE，则在 rax 中返回 1，否则返回 0

    leave
    ret

; =================================================================
cpu_sse:
    push rbp
    mov  rbp, rsp

    xor r12, r12  ; SSE 标志可用
    mov eax, 1    ; 请求 CPU 功能标志
    cpuid

    ; SSE 测试
    test edx, 2000000h ; 测试 bit 25 (SSE)
    jz   sse2          ; SSE 可用
    mov  r12, 1
    xor  rax, rax
    mov  rdi, fmt_sse
    push rcx
    push rdx
    call printf
    pop  rdx
    pop  rcx
sse2:
    test edx, 4000000h ; 测试 bit 26 (SSE 2)
    jz   sse3
    mov  r12, 1
    xor  rax, rax
    mov  rdi, fmt_sse2
    push rcx
    push rdx
    call printf
    pop  rdx
    pop  rcx
sse3:
    test ecx, 1 ; 测试 bit 0 (SSE 3)
    jz   ssse3
    mov  r12, 1
    xor  rax, rax
    mov  rdi, fmt_sse3
    push rcx
    sub  rsp, 8 ; 原书中代码存在bug：在较新的 printf 中会使用到 xmm 寄存器加载栈上内存，因此这里需要将栈指针对齐到 16 字节
    call printf
    add  rsp, 8
    pop  rcx
ssse3:
    test ecx, 9h ; 测试 bit 0、bit 3 (SSSE 3)
    jz   sse41
    mov  r12, 1
    xor  rax, rax
    mov  rdi, fmt_ssse3
    push rcx
    sub  rsp, 8 ; 原书中代码存在bug：在较新的 printf 中会使用到 xmm 寄存器加载栈上内存，因此这里需要将栈指针对齐到 16 字节
    call printf
    add  rsp, 8
    pop  rcx
sse41:
    test ecx, 80000h ; 测试 bit 19 (SSE 4.1)
    jz   sse42
    mov  r12, 1
    xor  rax, rax
    mov  rdi, fmt_sse41
    push rcx
    sub  rsp, 8 ; 原书中代码存在bug：在较新的 printf 中会使用到 xmm 寄存器加载栈上内存，因此这里需要将栈指针对齐到 16 字节
    call printf
    add  rsp, 8
    pop  rcx
sse42:
    test ecx, 100000h ; 测试 bit 20 (SSE 4.2)
    jz   wrapup
    mov  r12, 1
    xor  rax, rax
    mov  rdi, fmt_sse42
    push rcx
    sub  rsp, 8 ; 原书中代码存在bug：在较新的 printf 中会使用到 xmm 寄存器加载栈上内存，因此这里需要将栈指针对齐到 16 字节
    call printf
    add  rsp, 8
    pop  rcx
wrapup:
    cmp  r12, 1
    je   sse_ok          ; 如果不支持 SSE，则打印消息
    mov  rdi, fmt_no_sse
    xor  rax, rax
    call printf
    jmp  the_exit
sse_ok:
    mov  rax, r12 ; 如果支持 SSE，则返回值为 1

the_exit:
    leave
    ret