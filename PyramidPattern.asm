global _start

%define sys_write   4
%define sys_read    3
%define sys_exit    1

section .data
    brick: db '*'                   ; This will be used for printing stars.
    nl: db 0xA                      ; This is for new lines after finishing line

    imsg: db "How much rows do you wish [9]: ", 0x0
    ilen: equ $ - imsg

    izmsg: db "0 rows requested, exiting the program.", 0xA, 0x0
    izlen: equ $ - izmsg

section .bss
    rows: resb 1                    ; Contains number of the rows of the stars. It will be converted to number after inputing.

section .text
_start:
    mov ecx, imsg
    mov edx, ilen
    call print_text                 ; Not specifying EAX and EBX here since it's done in print_text function.

    mov eax, sys_read               ; sys_read. Read user input and store it as rows.
    mov ebx, 0
    mov ecx, rows
    mov edx, 1
    int 0x80

    cmp [rows], byte '0'            ; Check if user inputed 0 rows
    je input_zero_msg               ; If so, print exit message and exit.

    cmp [rows], byte '1'            ; If there is only one row, just print one star.
    je print_one_star               ; Jump to output one star and new line.

    sub [rows], byte '0'            ; Convert rows counter to the number

    mov ecx, 1                      ; Loop counter, starting from 1 (i = 1) because it will control stars' amount too.
    mov ebx, ecx                    ; EBX controls amount of stars per line.

main_loop:
    cmp ecx, [rows]                 ; If counter equals limit (rows), exit
    je exit

    mov edx, 0
    jmp print_stars

    inc ecx                         ; Increase the counter (++i)
    jmp main_loop                   ; continue;

print_stars:
    cmp edx, ebx                    ; Check if counter equals the limit of stars per line.
    je print_new_line               ; If so, print new line and go back to main loop.

    push ecx                        ; Push main loop's counter to the stack because of the syscall.
    push edx                        ; And so EDX (this loop's counter).

    mov ecx, brick
    mov edx, 1
    call print_text

    pop edx                         ; Pop EDX from the stack after finishing.
    pop ecx                         ; Pop ECX from the stack after finishing.

    inc edx
    jmp print_stars

print_new_line:
    push ecx                        ; Push counter to the stack because of register requirement of syscall (print_text)
    mov ecx, nl
    mov edx, 1
    call print_text
    pop ecx                         ; Pop counter from the stack.

    inc ebx                         ; Increase amount of stars to be printed per line (same as ECX counter).
    mov ecx, ebx                    ; Since ECX (main_loop's counter) is always equal to number of stars per line...
    dec ecx                         ; Decrease it since it needs to match rows number (remove if want to experiment).
    jmp main_loop

print_text:
    mov ebp, esp
    push ebx                        ; Push stars per line counter because of the syscall register requirement (STDOUT)

    mov eax, sys_write
    mov ebx, 1
    int 0x80

    pop ebx                         ; Pop EBX from the stack after finishing.
    mov esp, ebp
    ret

input_zero_msg:                     ; Here we don't need any stack operations for ECX and EBX since this will terminate the program.
    mov ecx, izmsg
    mov edx, izlen
    call print_text
    jmp exit

print_one_star:
    mov ecx, brick
    mov edx, 1
    call print_text                 ; Print one star

    mov ecx, nl
    mov edx, 1
    call print_text                 ; Print new line

    jmp exit                        ; Exit

exit:
    mov eax, sys_exit               ; sys_exit call.
    mov ebx, 0
    int 0x80                        ; syscall