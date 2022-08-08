;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Created by Baltazarus
; NASM_Examples
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

global _start

%define SYS_WRITE   4
%define SYS_READ    3

section .data
    ; [255] indicates maximum string length to input. (0xFF)
    msg: db "Enter a string [255]: ", 0x0
    len: equ $ - msg

    inputed_string: db "Original: ", 0xA, 0x9, 0x0
    inplen: equ $ - inputed_string

    reversed_string: db "Reversed: ", 0xA, 0x9, 0x0
    revlen: equ $ - reversed_string
    
    nl: db 0xA

section .bss
    input_str: resb 0xFF                ; Used for user input.
    reversed_str: resb 0xFF             ; Used to store reversed string.

section .text
_start:
    mov eax, SYS_WRITE                  ; sys_write
    mov ebx, 1                          ; stdout
    mov ecx, msg                        ; msg's source
    mov edx, len                        ; msg's length
    int 0x80                            ; syscall

    mov eax, SYS_READ                   ; sys_read
    mov ebx, 0                          ; stdin
    mov ecx, input_str                  ; buffer source
    mov edx, 0xFF                       ; buffer length
    int 0x80                            ; syscall

    mov ecx, 0x00                       ; Loop counter, starting from 0
    mov edx, 0xFF                       ; Length of the string
    mov ebx, edx                        ; Store length inside the ebx register which value will be decreased for offset

main_loop:
    cmp ecx, edx                        ; Compare the counter and the length of string
    jg find_new_line                    ; If equal, print string and exit

    mov eax, [input_str+ebx-1]          ; Get the last character of the string
    mov [reversed_str+ecx], eax         ; Put that last character at the beginning of the string
    dec ebx                             ; Decrease ebx

    inc ecx                             ; Increase loop's counter
    jmp main_loop                       ; continue;

print_str:
    mov ecx, inputed_string
    mov edx, inplen
    call print_text

    mov ecx, input_str                  ;/
    mov edx, 0xFF                       ;| Print original string.
    call print_text                     ;\

    mov ecx, reversed_string
    mov edx, revlen
    call print_text

    mov ecx, reversed_str               ;/
    mov edx, 0xFF                       ;| Print reversed string.
    call print_text                     ;\

    mov ecx, nl                         ;/
    mov edx, 1                          ;| Print new line.
    call print_text                     ;\

    jmp exit                            ; Jump to exit

find_new_line:
    mov ecx, 0                          ; Use ECX as counter and set to 0
    mov edx, 0xFF                       ; Use EDX as maximum length of the string [255]

check_nl:
    cmp ecx, 0xFF                       ; Check if counter equals 0xFF [255] (i == 255)
    je print_str                        ; If so, print output.
                                        ; If counter doesn't equal 0xFF [255], continue through loop.
    cmp [reversed_str+ecx], byte 0xA    ; Compare byte at specified location with 0xA '\n'
    je remove_new_line                  ; If matches, jump to label and replace it with 0

    inc ecx                             ; Increase counter of the loop
    jmp check_nl                        ; continue;

remove_new_line:
    mov [reversed_str+ecx], byte 0x00   ; Replace the character at matching location.
    jmp print_str                       ; Jump to print_str

print_text:
    mov eax, SYS_WRITE                  ; sys_write
    mov ebx, 1                          ; stdout
    int 0x80                            ; syscall
    ret

exit:
    mov eax, 1                          ; sys_exit
    mov ebx, 0                          ; no error
    int 0x80                            ; syscall