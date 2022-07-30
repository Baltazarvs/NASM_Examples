global _start

section .data
	name: db "Enter your name: ", 0x0
	nlen: equ $ - name

section .bss
	buff: resb 0x1E	

section .text
_start:
    	mov eax, 4      ; sys_write
	mov ebx, 1      ; stdout
	mov ecx, name   ; name's instruction message (Enter your name: )
	mov edx, nlen   ; size of name
	int 0x80        

	mov eax, 3	    ; sys_read
	mov ebx, 0	    ; stdin
	mov ecx, buff	; buffer to store input in (buff)
	mov edx, 0x1E	; buffer size (0x1E = 30)
	int 0x80
	
	mov ecx, 1      ; Assign the counter an initial value of 1 (i = 1)
    	push ecx        ; Push to the stack ecx, with the 0 as initial value.
    	jmp loop_it     ; Run the loop;

loop_it:
	mov eax, 4      ; sys_write
	mov ebx, 1      ; stdout
	mov ecx, buff   ; buffer that contains user's input data
	mov edx, 0x1E   ; buffer size
	int 0x80
	
    	pop ecx         ; Pop from the stack ecx
    	cmp ecx, 10     ; Check ecx, you can set this value to any you want (suggested to use > 5)
    	je exit_it      ; if ecx is greater than 5, jump to exit_it. Change jg if you know what you are doing. :)
    
    	inc ecx         ; Increase counter (ecx)
    	push ecx        ; Push to the stack ecx
    	jmp loop_it     ; Restart the loop. continue;

exit_it:
    	mov eax, 1      ; sys_exit
    	mov ebx, ecx    ; return ecx
    	int 0x80        ; syscall
