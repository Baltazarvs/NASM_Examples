;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Created by Baltazarus
; NASM_Examples
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Define macros that will indicate syscall-s and IO
%define SYS_WRITE 4
%define SYS_READ 3
%define STDOUT 1
%define STDIN 0

global _start

section .data
    amsg: db "Enter A: ", 0x0
    alen: equ $ - amsg

    bmsg: db "Enter B: ", 0x0
    blen: equ $ - bmsg

    rmsg: db "Result: ", 0x0
    rlen: equ $ - rmsg

section .bss
    a_var: resb 2
    b_var: resb 2
    res: resb 1

section .text
_start:
    mov eax, SYS_WRITE  ; Using macro to replace with 4
    mov ebx, STDOUT     ; Using macro to replace with 1
    mov ecx, amsg
    mov edx, alen
    int 0x80

    mov eax, SYS_READ   ; Using macro to replace with 3
    mov ebx, STDIN      ; Using macro to replace with 0
    mov ecx, a_var
    mov edx, 2
    int 0x80

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, bmsg
    mov edx, blen
    int 0x80

    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, b_var
    mov edx, 2
    int 0x80

    mov eax, [a_var]    ; Move the contents of a_var into eax
    sub eax, '0'        ; Subtract '0' (ASCII-hex: 0x30) from the eax.
                        ; e.g. 0x36 - 0x30 => '6' - '0' = 6 (0x06)
    mov ebx, [b_var]
    sub ebx, '0'        ; Same for ebx
    
    add eax, ebx        ; eax += ebx
    add eax, '0'        ; Add '0' (0x30) to eax which is number to reconvert to ascii
    
    mov [res], eax      ; Move result to the res's memory.

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, rmsg
    mov edx, rlen
    int 0x80

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, res
    mov edx, 2
    int 0x80

    mov eax, 1
    int 0x80
