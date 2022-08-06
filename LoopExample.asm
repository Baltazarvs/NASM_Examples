;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Created by Baltazarus
; NASM_Examples
;
; This program is an example of loop in ASM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

global _start

section .data
    msg: db "Hello World!", 0xA, 0x0
    len: equ $ - msg

section .text
_start:
    mov ecx, 0      ; Assign the counter an initial value of 0 (i = 0)
    push ecx        ; Push to the stack ecx, with the 0 as initial value.

loop_it:
    mov eax, 4      ; sys_write
    mov ebx, 1      ; stdout
    mov ecx, msg    ; msg ("Hello World!\n\0")
    mov edx, len    ; len [14]
    int 0x80

    pop ecx         ; Pop from the stack ecx
    cmp ecx, 5      ; Check ecx
    jg exit_it      ; if ecx is greater than 5, jump to exit_it
    
    inc ecx         ; Increase counter (ecx)
    push ecx        ; Push to the stack ecx
    jmp loop_it     ; Restart the loop. continue;

exit_it:
    mov eax, 1      ; sys_exit
    mov ebx, ecx    ; return ecx
    int 0x80        ; syscall
