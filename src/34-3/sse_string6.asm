; sse_string6.asm
; 查找一个子串

extern print16b
extern printf

section .data
    string1 db "a quick pink dinosour jumps over the "
            db "lazy river and the lazy dinosour ",
            db "doesn't mind", 10, 0
    string2 db "dinosour", 0
    NL      db 10, 0
    fmt     db "Find the substring '%s' in:", 10, 0
    fmt_oc  db "I founc %ld %ss", 10, 0

section .bss

section .text
    global main

; --------------------------------
main:
    push rbp
    mov  rbp, rsp

    ; 打印字符串
    mov  rdi, fmt
    mov  rsi, string2
    xor  rax, rax
    call printf
    mov  rdi, string1
    xor  rax, rax
    call printf

    ; 查找子串
    mov  rdi, string1
    mov  rsi, string2
    call psubstringsrch

    ; 打印结果
    mov  rdi, fmt_oc
    mov  rsi, rax
    mov  rdx, string2
    xor  rax, rax
    call printf

    leave
    ret

; --------------------------------
; 用于搜索子串并打印掩码的函数
psubstringsrch:
    push rbp
    mov  rbp, rsp

    sub  rsp, 16 ; 为保存 xmm1，在栈上分配空间
    xor  r12, r12
    xor  rcx, rcx
    xor  rbx, rbx
    mov  rax, -16

    ; 构建 xmm1，加载子串
    pxor   xmm1, xmm1
    movdqu xmm1, [rsi]
.loop:
    add       rax, 16
    mov       rsi, 16
    movdqu    xmm2, [rdi + rbx]
    pcmpistrm xmm1, xmm2, 01001100b ; equal ordered | byte mask in xmm0
    setz      cl

    ; 如果发现终止0，确定位置
    cmp  cl, 0
    je   .gotoprint ; 如果 cl == 0，即字符串没有终止，跳转到打印
    add  rdi, rbx   ; 否则，处理结尾的字符串
    push rcx
    call pstrlen
    pop  rcx
    dec  rax
    mov  rsi, rax

    ; 打印掩码
.gotoprint:
    call   print_mask
    popcnt r13d, r13d ; print_mask 函数中修改了 r13d，r13d 为出现的次数
    add    r12d, r13d ; 次数累加到 r12d
    or     cl, cl
    jnz    .exit
    add    rbx, 16
    jmp    .loop
.exit:
    mov    rdi, NL
    xor    rax, rax
    call   printf
    mov    rax, r12

    leave
    ret

; --------------------------------
pstrlen:
    push rbp
    mov  rbp, rsp

    sub    rsp, 16          ; 用于压入 xmm0 的栈空间
    movdqu [rbp - 16], xmm0 ; 保存 xmm0
    mov    rax, -16
    pxor   xmm0, xmm0
.loop:
    add       rax, 16
    pcmpistri xmm0, [rdi + rax], 0x08 ; 'equal each'
    jnz       .loop
    add       rax, rcx
    movdqu    xmm0, [rbp - 16]

    leave
    ret

; --------------------------------
print_mask:
    push rbp
    mov  rbp, rsp

    sub      rsp, 16
    call     reverse_xmm0     ; 反转掩码
    pmovmskb r13d, xmm0       ; 将掩码移动到 r13d
    movdqu   [rbp - 16], xmm1 ; 保存 xmm0
    push     rdi              ; 保存 rdi
    mov      edi, r13d        ; 将掩码移动到 rdi
    push     rdx              ; 保存 rdx
    push     rcx              ; 保存 rcx
    call     print16b         ; 打印掩码
    pop      rcx              ; 恢复 rcx
    pop      rdx              ; 恢复 rdx
    pop      rdi              ; 恢复 rdi
    movdqu   xmm1, [rbp - 16] ; 恢复 xmm1

    leave
    ret

; --------------------------------
reverse_xmm0:
section .data
    .bytereverse db 15, 14, 13, 12, 11, 10, 9, 8
                 db 7, 6, 5, 4, 3, 2, 1, 0

section .text
    push rbp
    mov  rbp, rsp

    sub    rsp, 16
    movdqu [rbp - 16], xmm2     ; 保存 xmm2
    movdqu xmm2, [.bytereverse] ; 加载反转表
    pshufb xmm0, xmm2           ; 反转掩码
    movdqu xmm2, [rbp - 16]     ; 恢复 xmm2

    leave
    ret