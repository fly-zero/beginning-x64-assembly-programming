; asum.asm

section .data

section .bss

section .text
global asum
asum:
    mov   rcx, rsi
    mov   rbx, rdi
    xor   r12, r12
    movsd xmm0, qword [rbx + r12 * 8]
    dec   rcx
sloop:
    inc   r12
    addsd xmm0, qword [rbx + r12 * 8]
    loop  sloop
    ret
