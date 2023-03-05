; sse_string_search.asm

extern printf

section .data
    string1 db "the quick brown fox jumps over the lazy river", 0
    string2 db "e", 0
    fmt1    db "This is our string: %s ", 10, 0
    fmt2    db "The first '%s' is at position %d.", 10, 0
    fmt3    db "The last '%s' is at position %d.", 10, 0
    fmt4    db "The character '%s' didn't show up!.", 10, 0

section .bss

section .text
    global main

;==================================
main:
    push rbp
    mov  rbp, rsp

    mov  rdi, fmt1
    mov  rsi, string1
    xor  rax, rax
    call printf

    ; 找到首次出现
    mov  rdi, string1
    mov  rsi, string2
    call pstrscan_f
    cmp  rax, 0
    je   no_show
    mov  rdi, fmt2
    mov  rsi, string2
    mov  rdx, rax
    xor  rax, rax
    call printf

    ; 找到最后一次出现
    mov  rdi, string1
    mov  rsi, string2
    call pstrscan_l
    mov  rdi, fmt3
    mov  rsi, string2
    mov  rdx, rax
    xor  rax, rax
    call printf
    jmp  exit
no_show:
    mov  rdi, fmt4
    mov  rsi, string2
    xor  rax, rax
    call printf

exit:
    leave
    ret

;==================================
pstrscan_f:
    push rbp
    mov  rbp, rsp

    xor       rax, rax
    pxor      xmm0, xmm0
    pinsrb    xmm0, [rsi], 0               ; 将字符串加载到 xmm0 中
.block_loop:
    pcmpistri xmm0, [rdi + rax], 00000000b ; 若匹配 xmm0 中任意字符，则设置 CF；若 [rdi + rax] 中任意字符为 0，则设置 ZF
    jc        .found                       ; 若匹配到，则跳转到 .found
    jz        .none                        ; 若字符串已遇到结尾，则跳转到 .none
    add       rax, 16
    jmp       .block_loop
.found:
    add       rax, rcx
    inc       rax

    leave
    ret

.none:
    xor rax, rax
    leave
    ret

;==================================
pstrscan_l:
    push rbp
    mov  rbp, rsp

    push rbx ; 由被调用者保存的寄存器
    push r12 ; 由被调用者保存的寄存器

    xor       rax, rax
    pxor      xmm0, xmm0
    pinsrb    xmm0, [rsi], 0               ; 将字符串加载到 xmm0 中
    xor       r12, r12
.block_loop:
    pcmpistri xmm0, [rdi + rax], 01000000b ; 若匹配 xmm0 中任意字符，则设置 CF；若 [rdi + rax] 中任意字符为 0，则设置 ZF；结果 rcx 中为最高匹配位
    setz      bl                           ; 若 ZF 已被设置，则设置 bl。由于 ZF 会被后面的计算影响，因此将 ZF 保存到 bl 中
    jc        .found                       ; 若找到一个匹配，则跳转到 .found
    jz        .done                        ; 若字符串已遇到结尾，则跳转到 .done
    add       rax, 16
    jmp       .block_loop
.found:
    mov       r12, rax
    add       r12, rcx
    inc       r12
    cmp       bl, 1                        ; bl 保存了之前字符串搜索的状态结果，即字符串是否已遇到结尾
    je        .done                        ; 字符串已遇到结尾，则跳转到 .done
    add       rax, 16
    jmp       .block_loop
.done:
    mov rax, r12
    pop r12
    pop rbx

    leave
    ret