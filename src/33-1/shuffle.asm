; shuffle.asm

extern printf

section .data
    fmt0        db "These are the numbers in memory: ", 10, 0
    fmt00       db "This is xmm0: ", 10, 0
    fmt1        db "%d ", 0
    fmt2        db "Shuffle-broadcast double word %i:", 10, 0
    fmt3        db "%d %d %d %d", 10, 0
    fmt4        db "Shuffle-reverse double words:", 10, 0
    fmt5        db "Shuffle-reverse packed bytes in xmm0:", 10, 0
    fmt6        db "Shuffle-rotate left:", 10, 0
    fmt7        db "Shuffle-rotate right:", 10, 0
    fmt8        db "%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c", 10, 0
    fmt9        db "Packed bytes in xmm0:", 10, 0
    NL          db 10, 0
    number1     dd 1
    number2     dd 2
    number3     dd 3
    number4     dd 4
    char        db "abcdefghijklmnop"
    bytereverse db 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0

section .bss

section .text
    global main

;==============================================================================
main:
    push   rbp
    mov    rbp, rsp

    sub    rsp, 32  ; 为原始 xmm0 和修改后的 xmm0 分配栈空间

    ; 重排双字
    ; 首先反向打印数字
    mov    rdi, fmt0
    call   printf
    mov    rdi, fmt1
    mov    rsi, [number4]
    xor    rax, rax
    call   printf
    mov    rdi, fmt1
    mov    rsi, [number3]
    xor    rax, rax
    call   printf
    mov    rdi, fmt1
    mov    rsi, [number2]
    xor    rax, rax
    call   printf
    mov    rdi, fmt1
    mov    rsi, [number1]
    xor    rax, rax
    call   printf
    mov    rdi, NL
    call   printf

    ; 用数字构建 xmm0
    pxor   xmm0, xmm0
    pinsrd xmm0, dword [number1], 0
    pinsrd xmm0, dword [number2], 1
    pinsrd xmm0, dword [number3], 2
    pinsrd xmm0, dword [number4], 3
    movdqu [rbp - 16], xmm0         ; 保存原始 xmm0
    mov    rdi, fmt00
    call   printf
    movdqu xmm0, [rbp - 16]         ; printf 可能会修改 xmm0，所以要重新加载
    call   print_xmm0d              ; 打印 xmm0

    ; SHUFFLE-BROADCAST（重排-广播）
    ; 重排：广播最双字（索引 0）
    movdqu xmm0, [rbp - 16]         ; 加载原始 xmm0
    pshufd xmm0, xmm0, 0            ; 重排
    mov    rdi, fmt2
    mov    rsi, 0
    movdqu [rbp - 32], xmm0         ; 保存修改后的 xmm0
    call   printf
    movdqu xmm0, [rbp - 32]         ; 加载原始 xmm0
    call   print_xmm0d              ; 打印 xmm0

    ; 重排：广播双字（索引 1）
    movdqu xmm0, [rbp - 16]         ; 加载原始 xmm0
    pshufd xmm0, xmm0, 01010101b    ; 重排
    mov    rdi, fmt2
    mov    rsi, 1
    movdqu [rbp - 32], xmm0         ; 保存修改后的 xmm0
    call   printf
    movdqu xmm0, [rbp - 32]         ; 加载原始 xmm0
    call   print_xmm0d              ; 打印 xmm0

    ; 重排：广播双字（索引 2）
    movdqu xmm0, [rbp - 16]         ; 加载原始 xmm0
    pshufd xmm0, xmm0, 10101010b    ; 重排
    mov    rdi, fmt2
    mov    rsi, 2
    movdqu [rbp - 32], xmm0         ; 保存修改后的 xmm0
    call   printf
    movdqu xmm0, [rbp - 32]         ; 加载原始 xmm0
    call   print_xmm0d              ; 打印 xmm0

    ; 重排：广播双字（索引 3）
    movdqu xmm0, [rbp - 16]         ; 加载原始 xmm0
    pshufd xmm0, xmm0, 11111111b    ; 重排
    mov    rdi, fmt2
    mov    rsi, 3
    movdqu [rbp - 32], xmm0         ; 保存修改后的 xmm0
    call   printf
    movdqu xmm0, [rbp - 32]         ; 加载原始 xmm0
    call   print_xmm0d              ; 打印 xmm0

    ; SHUFFLE-REVERSE（重排-反转）
    ; 反转双字
    movdqu xmm0, [rbp - 16]         ; 加载原始 xmm0
    pshufd xmm0, xmm0, 00011011b    ; 重排
    mov    rdi, fmt4
    movdqu [rbp - 32], xmm0         ; 保存修改后的 xmm0
    call   printf
    movdqu xmm0, [rbp - 32]         ; 加载原始 xmm0
    call   print_xmm0d              ; 打印 xmm0

    ; SHUFFLE-ROTATE-LEFT（重排-左旋）
    movdqu xmm0, [rbp - 16]         ; 加载原始 xmm0
    pshufd xmm0, xmm0, 10010011b    ; 重排
    mov    rdi, fmt6
    movdqu [rbp - 32], xmm0         ; 保存修改后的 xmm0
    call   printf
    movdqu xmm0, [rbp - 32]         ; 加载原始 xmm0
    call   print_xmm0d              ; 打印 xmm0

    ; SHUFFLE-ROTATE-RIGHT（重排-右旋）
    movdqu xmm0, [rbp - 16]         ; 加载原始 xmm0
    pshufd xmm0, xmm0, 00111001b    ; 重排
    mov    rdi, fmt7
    movdqu [rbp - 32], xmm0         ; 保存修改后的 xmm0
    call   printf
    movdqu xmm0, [rbp - 32]         ; 加载原始 xmm0
    call   print_xmm0d              ; 打印 xmm0

    ; SHUFFLE BYTES（重排字节）
    mov    rdi, fmt9
    call   printf                   ; 打印标题
    movdqu xmm0, [char]             ; 加载字符串
    movdqu [rbp - 32], xmm0         ; 保存 xmm0
    call   print_xmm0b              ; 打印 xmm0
    movdqu xmm0, [rbp - 32]         ; 加载 xmm0
    movdqu xmm1, [bytereverse]      ; 加载掩码
    pshufb xmm0, xmm1               ; 重排字节
    mov    rdi, fmt5                ; 打印标题
    movdqu [rbp - 32], xmm0         ; 保存 xmm0
    call   printf
    movdqu xmm0, [rbp - 32]         ; 加载 xmm0
    call   print_xmm0b              ; 打印 xmm0

    leave
    ret

;==============================================================================
print_xmm0d:
    push rbp
    mov  rbp, rsp

    mov    rdi, fmt3
    xor    rax, rax
    pextrd esi, xmm0, 3 ; 读取双字，索引 3
    pextrd edx, xmm0, 2 ; 读取双字，索引 2
    pextrd ecx, xmm0, 1 ; 读取双字，索引 1
    pextrd r8d, xmm0, 0 ; 读取双字，索引 0
    call   printf

    leave
    ret

;==============================================================================
print_xmm0b:
    push rbp
    mov  rbp, rsp

    mov    rdi, fmt8
    xor    rax, rax
    pextrb esi, xmm0, 0
    pextrb edx, xmm0, 1
    pextrb ecx, xmm0, 2
    pextrb r8d, xmm0, 3
    pextrb r9d, xmm0, 4
    pextrb eax, xmm0, 15
    push   rax
    pextrb eax, xmm0, 14
    push   rax
    pextrb eax, xmm0, 13
    push   rax
    pextrb eax, xmm0, 12
    push   rax
    pextrb eax, xmm0, 11
    push   rax
    pextrb eax, xmm0, 10
    push   rax
    pextrb eax, xmm0, 9
    push   rax
    pextrb eax, xmm0, 8
    push   rax
    pextrb eax, xmm0, 7
    push   rax
    pextrb eax, xmm0, 6
    push   rax
    pextrb eax, xmm0, 5
    push   rax
    sub    rsp, 8       ; 将 rsp 对齐到 16 字节
    xor    rax, rax
    call   printf
    add    rsp, 8

    leave
    ret