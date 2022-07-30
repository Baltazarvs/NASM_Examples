;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Created by Baltazarus
; NASM_Examples
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

global _start

section .data
	msg: db "Enter something: ", 0x0
	len: equ $ - msg

	msg_o: db "You entered: ", 0x0
	len_o: equ $ - msg_o


section .bss
	buff: resb 0x1E
	
section .text
_start:
	mov eax, 4	; sys_write
	mov ebx, 1	; stdout
	mov ecx, msg	; msg's source
	mov edx, len	; msg's len
	int 0x80
	
	mov eax, 3	; sys_read
	mov ebx, 0	; stdin
	mov ecx, buff	; buffer buff
	mov edx, 0x1E	; buff's size (30 bytes)
	int 0x80
	
	mov eax, 4
	mov ebx, 1
	mov ecx, msg_o
	mov edx, len_o
	int 0x80

	mov eax, 4
	mov ebx, 1
	mov ecx, buff
	mov edx, 0x1E
	int 0x80
	
	mov eax, 1
	mov ebx, 0
    	int 0x80
