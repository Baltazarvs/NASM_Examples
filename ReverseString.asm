;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Created by Baltazarus
; NASM_Examples
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

global _start

%define SYS_WRITE   4
%define SYS_READ    3

section .data
    msg: db "Enter a string [30]: ", 0x0
    len: equ $ - msg

section .bss
    input_str: resb 30              ; Used for user input.
    reversed_str: resb 30           ; Used to store reversed string.

section .text
_start:
    mov eax, SYS_WRITE              ; sys_write
    mov ebx, 1                      ; stdout
    mov ecx, msg                    ; msg's source
    mov edx, len                    ; msg's length
    int 0x80                        ; syscall

    mov eax, SYS_READ               ; sys_read
    mov ebx, 0                      ; stdin
    mov ecx, input_str              ; buffer source
    mov edx, 30                     ; buffer length
    int 0x80                        ; syscall

    mov ecx, 0                      ; Loop counter, starting from 0
    mov edx, 30                     ; Length of the string
    mov ebx, edx                    ; Store length inside the ebx register which value will be decreased for offset

main_loop:
    cmp ecx, edx                    ; Compare the counter and the length of string
    jg print_str                    ; If equal, print string and exit

    mov eax, [input_str+ebx-1]      ; Get the last character of the string
    mov [reversed_str+ecx], eax     ; Put that last character at the beginning of the string
    dec ebx                         ; Decrease ebx

    inc ecx                         ; Increase loop's counter
    jmp main_loop                   ; continue;

print_str:
    mov eax, SYS_WRITE
    mov ebx, 1
    mov ecx, reversed_str
    mov edx, 30
    int 0x80

    jmp exit                        ; Jump to exit

exit:
    mov eax, 1                      ; sys_exit
    mov ebx, 0                      ; no error
    int 0x80                        ; syscall