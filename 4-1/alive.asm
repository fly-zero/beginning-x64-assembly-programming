;alive.asm
section .data
    msg1    db  "Hello, World!",10,0      ; 带换行和0结尾的字符串
    msg1Len equ $-msg1-1                  ; 声明常量msg1Len，值为msg1字符串的长度（需要减去末尾的0），长度计算原理：当前内存位置 - msg1内存位置 - 1
    msg2    db  "Alive and Kicking!",10,0 ; 带换行和0结尾的字符串
    msg2Len equ $-msg2-1                  ; 声明常量msg2Len，值为msg2字符串的长度（需要减去末尾的0），长度计算原理：当前内存位置 - msg1内存位置 - 1
    radius  dq  357                       ; 声明64bit变量
    pi      dq  3.14                      ; 声明64bit变量
section .bss
section .text
    global main
main:
    push    rbp          ; 保存旧的栈基地址
    mov     rbp,rsp      ; 设置新的栈基地址
    mov     rax, 1       ; 设置系统调用代号1（sys_write）
    mov     rdi, 1       ; sys_write参数1：标准输出编号
    mov     rsi, msg1    ; sys_write参数2：字符串地址
    mov     rdx, msg1Len ; sys_write参数3：字符串长度
    syscall              ; 调用系统调用sys_write(1, msg1, msg1Len)
    mov     rax, 1       ; 设置系统调用代号1（sys_write）
    mov     rdi, 1       ; sys_write参数1：标准输出编号
    mov     rsi, msg2    ; sys_write参数2：字符串地址
    mov     rdx, msg2Len ; sys_write参数3：字符串长度
    syscall              ; 调用系统调用sys_write(1, msg2, msg2Len)
    mov     rsp,rbp      ; 恢复原栈顶指针（rsp）
    pop     rbp          ; 恢复原栈基地址
    mov     rax, 60      ; 设置系统代号60（sys_exit）
    mov     rdi, 0       ; sys_exit参数1：退出代码
    syscall              ; 调用系统调用sys_exit(0)