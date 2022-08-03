;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Created by Baltazarus
; NASM_Examples
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%define SYS_WRITE   4
%define SYS_READ    3
%define STDOUT      1
%define STDIN       0

global name_prompt

section .data
    emsg: db "Enter your name: ", 0x0
    elen: equ $ - emsg

    hmsg: db "Hello, ", 0x0
    hlen: equ $ - hmsg

section .bss
    name_buff: resb 0x1E

section .text
name_prompt:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, emsg
    mov edx, elen
    int 0x80

    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, name_buff
    mov edx, 0x1E
    int 0x80

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, hmsg
    mov edx, hlen
    int 0x80

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, name_buff
    mov edx, 0x1E
    int 0x80
