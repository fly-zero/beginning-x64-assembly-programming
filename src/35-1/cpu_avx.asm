; cpu_avx.asm

extern printf

section .data
    fmt_noavx    db "This CPU does not support AVX.", 10, 0
    fmt_avx      db "This CPU supports AVX.", 10, 0
    fmt_noavx2   db "This CPU does not support AVX2.", 10, 0
    fmt_avx2     db "This CPU supports AVX2.", 10, 0
    fmt_noavx512 db "This CPU does not support AVX512.", 10, 0
    fmt_avx512   db "This CPU supports AVX512.", 10, 0

section .bss

section .text
    global main

; -------------------------------------------------
main:
    push rbp
    mov rbp, rsp

    call cpu_sse ; 如果支持 AVX，则在 rax 中返回 1，否则返回 0

    leave
    ret

; -------------------------------------------------
cpu_sse:
    push rbp
    mov rbp, rsp

    ; 测试 CPU 是否支持 AVX
    mov  eax, 1  ; 请求 CPU 功能标志
    cpuid
    mov  eax, 28 ; 在 ecx 中测试位 28
    bt   ecx, eax
    jnc  no_avx
    xor  rax, rax
    mov  rdi, fmt_avx
    call printf

    ; 测试 CPU 是否支持 AVX2
    mov  eax, 7  ; 请求 CPU 功能标志
    mov  ecx, 0  ; 子功能号
    cpuid
    mov  eax, 5  ; 在 ebx 中测试位 5
    bt   ebx, eax
    jnc  the_exit
    xor  rax, rax
    mov  rdi, fmt_avx2
    call printf

    ; 测试 CPU 是否支持 AVX512
    mov  eax, 7  ; 请求 CPU 功能标志
    mov  ecx, 0  ; 子功能号
    cpuid
    mov  eax, 16 ; 在 ebx 中测试位 16
    bt   ebx, eax
    jnc  no_avx512
    xor  rax, rax
    mov  rdi, fmt_avx512
    call printf
    jmp  the_exit

no_avx:
    mov  rdi, fmt_noavx
    xor  rax, rax
    call printf
    xor  rax, rax ; 设置返回值为 0
    jmp  the_exit

no_avx2:
    mov  rdi, fmt_noavx2
    xor  rax, rax
    call printf
    xor  rax, rax ; 设置返回值为 0
    jmp  the_exit

no_avx512:
    mov  rdi, fmt_noavx512
    xor  rax, rax
    call printf
    xor  rax, rax ; 设置返回值为 0
    jmp  the_exit

the_exit:
    leave
    ret