; hello.asm
extern printf ; 声明外部函数

section .data
    msg    db "Hello, World!",0
    fmtstr db "This is our string: %s", 10, 0 ; 输出格式

section .bss

section .text
    global main

main:
    push rbp         ; 保存旧的栈基地址
    mov  rbp, rsp    ; 设置新的栈基地址
    mov  rdi, fmtstr ; printf函数参数1：字符串格式
    mov  rsi, msg    ; printf函数参数2：可变参数
    mov  rax, 0      ; 不涉及XMM寄存器
    call printf      ; 调用printf函数
    mov  rsp, rbp    ; 恢复原栈顶指针（rsp）
    pop  rbp         ; 恢复原栈基地址
    mov  rax, 60     ; 设置系统代号60（sys_exit）
    mov     rdi, 0   ; sys_exit参数1：退出代码
    syscall          ; 调用系统调用sys_exit(0)