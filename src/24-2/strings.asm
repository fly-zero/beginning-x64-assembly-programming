; strings.asm

extern printf

section .data
    string1  db  "This is the 1st string.", 10, 0
    string2  db  "This is the 2nd string.", 10, 0
    strlen2  equ $ - string2 - 2
    string21 db  "Comparing strings: The strings do not differ.", 10, 0
    string22 db  "Comparing strings: The strings differ."
             db  "starting at position: %d.", 10, 0
    string3  db  "The quick brown fox jumps over the lazy dog.", 0
    strlen3  equ $ - string3 - 1
    string33 db  "Now look at this string: %s", 10, 0
    string4  db  "z", 0
    string44 db  "The character '%s' was found at position: %d.", 10, 0
    string45 db  "The character '%s' was not found.", 10, 0
    string46 db  "Scanning for the character '%s'.", 10, 0

section .bss
section .text
    global main

main:
    push rbp
    mov  rbp, rsp

    ; 打印两个字符串
    xor  rax, rax
    mov  rdi, string1
    call printf
    mov  rdi, string2
    call printf

    ; 比较两个字符串
    lea  rdi, [string1]
    lea  rsi, [string2]
    mov  rdx, strlen2
    call compare1
    cmp  rax, 0
    jnz  not_equal1

    ; 字符串相同，打印
    mov  rdi, string21
    call printf
    jmp  otherversion

not_equal1:
    ; 字符串不相同，打印
    mov  rdi, string22
    mov  rsi, rax
    xor  rax, rax
    call printf

otherversion:
    ; 比较两个字符串，其它版本
    lea  rdi, [string1]
    lea  rsi, [string2]
    mov  rdx, strlen2
    call compare2
    cmp  rax, 0
    jnz  not_equal2

    ; 字符串相同，打印
    mov  rdi, string21
    call printf
    jmp  scanning

not_equal2:
    ; 字符串不相同，打印
    mov  rdi, string22
    mov  rsi, rax
    xor  rax, rax
    call printf

    ; 扫描字符串中的一个字符
    ; 首先打印字符串
    mov  rdi, string33
    mov  rsi, string33
    xor  rax, rax
    call printf

    ; 然后打印搜索参数，只能是 1 个字符
    mov  rdi, string46
    mov  rsi, string4
    xor  rax, rax
    call printf
scanning:
    lea  rdi, [string3]
    lea  rsi, [string4]
    mov  rdx, strlen3
    call cscan
    cmp  rax, 0
    jz   char_not_found

    ; 找到字符，打印
    mov  rdi, string44
    mov  rsi, string4
    mov  rdx, rax
    xor  rax, rax
    call printf
    jmp  exit

char_not_found:
    ; 找不到字符，打印
    mov  rdi, string45
    mov  rsi, string4
    xor  rax, rax
    call printf

exit:
    leave
    ret

; --------------------------------------------------
; 比较两个字符串
compare1:
    mov rcx, rdx
    cld
cmpr:
    cmpsb
    jne  notequal
    loop cmpr
    xor  rax, rax
    ret
notequal:
    mov rax, rdx
    dec rcx
    sub rax, rcx
    ret

; --------------------------------------------------
; 比较两个字符串
compare2:
    mov  rcx, rdx
    cld
    repe cmpsb ; repe 终止条件：rcx 为零或者 ZF 为 0
    je   equal12
    mov  rax, rdx
    sub  rax, rcx
    ret
equal12:
    xor  rax, rax
    ret

; --------------------------------------------------
; 从一个字符串中查找另一个字符串
cscan:
    mov   rcx, rdx
    lodsb
    cld
    repne scasb ; repne 终止条件：rcx 为零或者 ZF 为 1
    jne   char_notfound
    mov   rax, rdx
    sub   rax, rcx
    ret
char_notfound:
    xor rax, rax
    ret