%define sys_write   4
%define sys_read    3
%define sys_exit    1

section .data
    msg: db "Enter number of rows: "
    len: equ $-msg
    star_chr: db '*'
    nl_chr: db 0x0A
    
section .bss
    numb_buff: resb 1

section .text
    global _start

_start:
    mov ecx, msg
    mov edx, len
    call _print_it
    
    mov eax, sys_read
    mov ebx, 0
    mov ecx, numb_buff
    mov edx, 1
    int 0x80
    
    sub [numb_buff], byte '0'
    add [numb_buff], byte 1
    
    mov ecx, nl_chr
    mov edx, 1
    call _print_it
    
    mov ecx, 0
    
.loop:
    cmp ecx, [numb_buff]
    je exit
    
    push ecx
    mov edx, ecx
    mov ecx, 0
    
    .loop_col:
        cmp ecx, edx
        je .loop_col_end
        
        push ecx
        push edx
        mov ecx, star_chr
        mov edx, 1
        call _print_it
        pop edx
        pop ecx
        
        inc ecx
        jmp .loop_col
        
    .loop_col_end:
        mov ecx, nl_chr
        mov edx, 1
        call _print_it
    
    pop ecx
    inc ecx
    jmp .loop

exit:
    mov eax, sys_exit
    int 0x80

_print_it:
    push ebp
    mov ebp,esp
    mov eax, sys_write
    mov ebx, 1
    int 0x80
    pop ebp
    ret
