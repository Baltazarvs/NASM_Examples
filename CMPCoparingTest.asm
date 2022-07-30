;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Created by Baltazarus
; NASM_Examples
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

global _start

section .data
	cmsg: db "Checking if ecx is less than 30", 0xA, 0x0
	clen: equ $ - cmsg
	
	gmsg: db "ecx value is greater than 30", 0xA, 0x0
	glen: equ $ - gmsg

	lmsg: db "ecx is less than 30", 0xA, 0x0
	llen: equ $ - lmsg	

	emsg: db "ecx is equal to 30", 0xA, 0x0
	elen: equ $ - emsg
	
section .text
_start:
	mov eax, 4	; sys_write
	mov ebx, 1	; stdout
	mov ecx, cmsg	; msg to output
	mov edx, clen	; msg's length
	int 0x80
	
	mov ecx, 29	; TODO: Change this value to any you want.
	cmp ecx, 30
	je print_je	; If ecx is equal to 30
	jle print_jle   ; If ecx is less than 30
	
	mov eax, 4
	mov ebx, 1
	mov ecx, gmsg
	mov edx, glen
	int 0x80
	
	jmp exit_it

print_je:
	mov eax, 4
	mov ebx, 1
	mov ecx, emsg
	mov edx, elen
	int 0x80

	jmp exit_it
	
print_jle:
	mov eax, 4
	mov ebx, 1
	mov ecx, lmsg
	mov edx, llen
	int 0x80
	
	jmp exit_it
	
exit_it:
	mov eax, 1	; sys_exit
	mov ebx, 0	; return 0
	int 0x80	; syscall

