; mxcsr.asm

extern printf
extern print_mxcsr
extern print_hex

section .data
    eleven   dq 11.0
    two      dq 2.0
    three    dq 3.0
    ten      dq 10.0
    zero     dq 0.0
    hex      db "0x", 0
    fmt1     db 10, "Divede, default mxcsr:", 10, 0
    fmt2     db 10, "Divede by zero, default mxcsr:", 10, 0
    fmt4     db 10, "Divede, round up:", 10, 0
    fmt5     db 10, "Divede, round down:", 10, 0
    fmt6     db 10, "Divede, truncate:", 10, 0
    f_div    db "%.1f divided by %.1f is %.16f, in hex: ", 0
    f_before db 10, "mxcsr before:", 9, 0
    f_after  db "mxcsr after:", 9, 0

    ; mxcsr 值
    default_mxcsr dd 0001111110000000b
    round_nearest dd 0001111110000000b
    round_down    dd 0011111110000000b
    round_up      dd 0101111110000000b
    truncate      dd 0111111110000000b

section .bss
    mxcsr_before resd 1
    mxcsr_after  resd 1
    xmm          resq 1

section .text
global main

; =============================================
main:
    push rbp
    mov  rbp, rsp

    ; 除法
    ; 默认 mxcsr
    mov  rdi, fmt1
    mov  rsi, ten
    mov  rdx, two
    mov  ecx, [default_mxcsr]
    call apply_mxcsr

    ; 除法（精度误差）
    ; 默认 mxcsr
    mov  rdi, fmt1
    mov  rsi, ten
    mov  rdx, three
    mov  ecx, [default_mxcsr]
    call apply_mxcsr

    ; 除以零
    ; 默认 mxcsr
    mov  rdi, fmt2
    mov  rsi, ten
    mov  rdx, zero
    mov  ecx, [default_mxcsr]
    call apply_mxcsr

    ; 除法（精度误差）
    ; 向上取整
    mov  rdi, fmt4
    mov  rsi, ten
    mov  rdx, three
    mov  ecx, [round_up]
    call apply_mxcsr

    ; 除法（精度误差）
    ; 向下取整
    mov  rdi, fmt5
    mov  rsi, ten
    mov  rdx, three
    mov  ecx, [round_down]
    call apply_mxcsr

    ; 除法（精度误差）
    ; 截断
    mov  rdi, fmt6
    mov  rsi, ten
    mov  rdx, three
    mov  ecx, [truncate]
    call apply_mxcsr

    ; 除法（精度误差）
    ; 默认 mxcsr
    mov  rdi, fmt1
    mov  rsi, eleven
    mov  rdx, three
    mov  ecx, [default_mxcsr]
    call apply_mxcsr

    ; 除法（精度误差）
    ; 向上取整
    mov  rdi, fmt4
    mov  rsi, eleven
    mov  rdx, three
    mov  ecx, [round_up]
    call apply_mxcsr

    ; 除法（精度误差）
    ; 向下取整
    mov  rdi, fmt5
    mov  rsi, eleven
    mov  rdx, three
    mov  ecx, [round_down]
    call apply_mxcsr

    ; 除法（精度误差）
    ; 截断
    mov  rdi, fmt6
    mov  rsi, eleven
    mov  rdx, three
    mov  ecx, [truncate]
    call apply_mxcsr

    leave
    ret

; =============================================
; apply_mxcsr(const char *, double *, double *, unsinged int)
apply_mxcsr:
    push rbp
    mov  rbp, rsp

    push rsi
    push rdx
    push rcx
    sub  rsp, 8
    call printf
    add  rsp, 8
    pop  rcx
    pop  rdx
    pop  rsi

    mov     [mxcsr_before], ecx ; apply_mxcsr 第四个参数中保存着要使用的 mxcsr 寄存器值
    ldmxcsr [mxcsr_before]
    movsd   xmm2, [rsi]         ; apply_mxcsr 第二个参数所指向的 double 数据加载到 xmm2 中
    divsd   xmm2, [rdx]         ; xmm2 除以 pply_mxcsr 第三个参数所指向的 double 数据
    stmxcsr [mxcsr_after]       ; 保存 mxcsr
    movsd   [xmm], xmm2         ; 供 print_xmm 使用
    mov     rdi, f_div
    movsd   xmm0, [rsi]         ; printf 参数列表中使用的第一个浮点数（除数）
    movsd   xmm1, [rdx]         ; printf 参数列表中使用的第二个浮点数（被除数）
    call    printf
    call    print_xmm

    mov     rdi, f_before
    call    printf
    mov     rdi, [mxcsr_before]
    call    print_mxcsr
    mov     rdi, f_after
    call    printf
    mov     rdi, [mxcsr_after]
    call    print_mxcsr

    leave
    ret

; =============================================
print_xmm:
    push rbp
    mov  rbp, rsp

    mov  rdi, hex ; 打印 0x
    call printf
    mov  rcx, 8
.loop:
    xor  rdi, rdi
    mov  dil, [xmm + rcx - 1]
    push rcx
    sub  rsp, 8    ; 将栈对齐到 16 字节边界，防止 printf 发生 coredump
    call print_hex
    add  rsp, 8
    pop  rcx
    loop .loop

    leave
    ret