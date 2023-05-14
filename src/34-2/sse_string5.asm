; sse_string5.asm
; 查找一系列字符串

extern print16b
extern printf

section .data
    string1    db "eeAecdkkFijlmeoZa"
               db "bcefgeKlkmeDad"
               db "fdsafadfaseeE", 10, 0
    startrange db "A", 10, 0
    stoprange  db "Z", 10, 0
    NL         db 10, 0
    fmt        db "Find the uppercase letters in:", 10, 0
    fmt_oc     db "I found %ld uppercase letters.", 10, 0

section .bss

section .text
    global main

main:
    push rbp
    mov rbp, rsp

    ; 打印搜索目标字符串
    mov  rdi, fmt
    xor  rax, rax
    call printf
    mov  rdi, string1
    xor  rax, rax
    call printf

    ; 搜索字符串
    mov  rdi, string1    ; 搜索目标字符串
    mov  rsi, startrange ; 范围搜索开始字符
    mov  rdx, stoprange  ; 范围搜索结束字符
    call prangesrch

    ; 打印出现的次数
    mov  rdi, fmt_oc
    mov  rsi, rax
    xor  rax, rax
    call printf

    leave
    ret

; ----------------------------------------------
; 用于搜索和打印掩码的函数
prangesrch:
    push rbp
    mov  rbp, rsp

    sub rsp, 16  ; 栈上预留空间，用于保存 xmm1
    xor r12, r12 ; 用于记录出现次数
    xor rcx, rcx
    xor rbx, rbx
    mov rax, -16

    ; 构建 xmm1
    pxor xmm1, xmm1
    pinsrb xmm1, byte [rsi], 0 ; 范围搜索开始字符
    pinsrb xmm1, byte [rdx], 1 ; 范围搜索结束字符

.loop:
    add       rax, 16
    mov       rsi, 16
    movdqu    xmm2, [rdi + rbx]
    pcmpistrm xmm1, xmm2, 01000100b ; equal each | byte mask in xmm0
    setz      cl                    ; 删除终止 0

    ; 如果找到终止0，确定位置
    cmp cl, 0
    je  .gotoprint

    ; 如果找到终止0，则是最后一块字符串，求最后一块字符串长度
    add  rdi, rbx
    push rcx
    call pstrlen
    pop  rcx
    dec  rax
    mov  rsi, rax

.gotoprint:
    call   print_mask ; 打印匹配结果（xmm0）的掩码（print_mask 函数内部将 xmm0 掩码保存到 r13）
    popcnt r13d, r13d ; 计算 r13d 中 bit 为 1 的数量，保存到 r13d
    add    r12d, r13d ; 累加出现次数
    or     cl, cl
    jnz    .exit
    add    rbx, 16    ; 为下一次循环准备
    jmp    .loop

.exit:
    mov    rdi, NL
    call   printf
    mov    rax, r12

    leave
    ret

; ----------------------------------------------
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

; ----------------------------------------------
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

; ----------------------------------------------
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