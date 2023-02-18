; move_strings.asm

%macro prnt 2
    mov rax, 1  ; write 系统调用号
    mov rdi, 1  ; 标准输出
    mov rsi, %1
    mov rdx, %2
    syscall
    mov rax, 1  ; write 系统调用号
    mov rdi, 1  ; 标准输出
    mov rsi, NL
    mov rdx, 1
    syscall
%endmacro

section .data
    length  equ 95
    NL      db  0xa
    string1 db "my_string of ASCII:"
    string2 db 10, "my_string of zeros:"
    string3 db 10, "my_string of ones:"
    string4 db 10, "again my_string of ASCII:"
    string5 db 10, "copy my_string to other_string:"
    string6 db 10, "reverse copy my_string to other_string:"

section .bss
    my_string    resb length
    other_string resb length

section .text
    global main

main:
    push rbp
    mov  rbp, rsp

; ----------------------------------------
; 用可打印的 ascii 字符填充字符串
    prnt string1, 19
    mov  rax, 32
    mov  rdi, my_string
    mov  rcx, length
str_loop1:
    mov  byte [rdi], al
    inc  rdi
    inc  al
    loop str_loop1
    prnt my_string, length
; ----------------------------------------
; 用 ascii 编码的 0 填充字符串
    prnt string2, 20
    mov  rax, 48
    mov  rdi, my_string
    mov  rcx, length
str_loop2:
    stosb                  ; 将 al 写到 [rdi]，并且 rdi 自增
    loop str_loop2         ; 跳转到 str_loop2，并且 rcx 自减，直到 rcx 为零
    prnt my_string, length
; ----------------------------------------
; 用 ascii 编码的 1 填充字符串
    prnt string3, 19
    mov  rax, 49
    mov  rdi, my_string
    mov  rcx, length
    rep  stosb              ; 将 al 写到 [rdi]，并且 rdi 自增，rcx 自减，直到 rcx 为零
    prnt my_string, length
; ----------------------------------------
; 用可打印的 ascii 字符串再次填充字符串
    prnt string4, 26
    mov  rax, 32
    mov  rdi, my_string
    mov  rcx, length
str_loop3:
    mov  byte [rdi], al
    inc  rdi
    inc  al
    loop str_loop3
    prnt my_string, length
; ----------------------------------------
; 将 my_string 复制到 other_string
    prnt string5, 32
    mov  rsi, my_string
    mov  rdi, other_string
    mov  rcx, length
    rep  movsb             ; [rdi++] = [rsi++]; rcx--
    prnt other_string, length
; ----------------------------------------
; 将 my_string 返回复制到 other_string
    prnt string6, 40
    mov  rax, 48
    mov  rdi, other_string
    mov  rcx, length
    rep  stosb
    lea  rsi, [my_string + length - 5]    ; lea 指令即取地上：rsi = my_string + length - 5，使用 lea 指令一次完成取地址和偏移计算
    lea  rdi, [other_string + length - 1] ; 
    mov  rcx, 26                          ; 复制 26 个字符，原书中代码有内存写越界的问题
    std                                   ; 设置 DF 标志位
    rep  movsb                            ; 由于设置了 DF，movsb 是反向的，[--rdi] = [--rsi]; rcx--
    prnt other_string, length

    leave
    ret