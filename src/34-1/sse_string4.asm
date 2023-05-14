; sse_string4.asm
; 查找一个字符
extern printf
extern print16b

section .data
    string1 db "qdacdekkfijlmdoza"
            db "becdfgdklkmdddaf"
            db "fffffffdedeee", 10, 0
    string2 db "e", 0
    string3 db "a", 0
    fmt     db "Find all the chraracter '%s' "
            db "and '%s' in:", 10, 0
    fmt_oc  db "I found %ld characters '%s'"
            db "and '%s'", 10, 0
    NL      db 10, 0

section .bss

section .text
    global main

; ------------------------------------
main:
    push rbp
    mov  rbp, rsp

    ; 打印搜索的字符
    mov  rdi, fmt
    mov  rsi, string2
    mov  rdx, string3
    xor  rax, rax
    call printf

    ; 打印目标字符串
    mov  rdi, string1
    xor  rax, rax
    call printf

    ; 搜索字符串并打印掩码
    mov  rdi, string1
    mov  rsi, string2
    mov  rdx, string3
    call pcharsrch

    ; 打印 string2 的出现 次数
    mov  rdi, fmt_oc
    mov  rsi, rax
    mov  rdx, string2
    mov  rcx, string3
    xor  rax, rax
    call printf

    leave
    ret

; ------------------------------------
pcharsrch:
    push rbp
    mov  rbp, rsp

    sub rsp, 16  ; 用于压入 xmm1 的栈空间
    xor r12, r12 ; 用于出现次数的总和
    xor rcx, rcx ; 用于发出结束信号
    xor rbx, rbx ; 用于地址计算
    mov rax, -16 ; 字节计数，避免标志设置

    ; 构建 xmm1，加载搜索字符
    pxor   xmm1, xmm1 ; 清除 xmm1
    pinsrb xmm1, byte [rsi], 0 ; 位于索引 0 的第一个字符
    pinsrb xmm1, byte [rdx], 1 ; 位于索引 1 的第二个字符
.loop:
    add       rax, 16           ; 避免 ZF 标志设置
    mov       rsi, 16           ; 如果没有终止 0，打印 16 字字符
    movdqu    xmm2, [rdi + rbx] ; 加载 16 字节
    pcmpistrm xmm1, xmm2, 40h   ; 'equal each' & 'byte mask in xmm0'
    setz      cl                ; 如果xmm2字符串中有终止符（ZF == 1），则设置 cl
    cmp       cl, 0
    je        .gotoprint        ; 如果xmm2字符串没有终止，则跳转到 .gotoprint

    ; 发现终止0
    ; 剩余少于 16 个字节
    ; rdi 包含字符串的地址
    ; rbx 包含迄今为止所处理的字节数量
    add  rdi, rbx
    push rcx      ; 调用者保存 rcx
    call pstrlen  ; 求长度
    pop  rcx
    dec  rax      ; 长度，不包括 0
    mov  rsi, rax ; rsi 包含剩余的字节数

    ; 打印掩码
.gotoprint:
    call   print_mask
    popcnt r13d, r13d ; 计算 bit 为 1 的数量
    add    r12d, r13d ; 在 r12 中累加
    or     cl, cl     ; 如果终止 0，退出
    jnz    .exit
    add    rbx, 16    ; 增加 16 字节偏移量
    jmp    .loop
.exit:
    mov    rdi, NL
    call   printf
    mov    rax, r12

    leave
    ret

; ------------------------------------
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

; ------------------------------------
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

; ------------------------------------
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