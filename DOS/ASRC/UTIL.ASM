%OUT Processing UTIL...

UTIL_PRINT_HEX_NIBBLES PROC NEAR
	; CX = # Of nibbles to print
	; AX = 1-4 nibbles to print from AH high -> AL Low
	push	bx
UTIL_PRINT_HEX_NIBBLES_LOOP:
	rol		ax,1 ; Grab the highest nibble by Rotating left 4x
	rol		ax,1 ;
	rol		ax,1 ;
	rol		ax,1 ; 
	push	ax ; Save off the Nth rotated AX
	and		al,00Fh ; Isolate the nibble
	add		al,'0' ; Shift into the ASCII Numeric Range
	cmp		al,'9' ; Check if <= 9
	jle		UTIL_PRINT_HEX_NIBBLES_CONT
	add		al,'A'-'9'-1 ; If not, shift up to ASCII 'A' range
UTIL_PRINT_HEX_NIBBLES_CONT:
	mov		ah,svc_video_write_char_tty ; Select DOS Print TTY service
	mov		bh,tty_page
	int		int_video ; Print current character
	pop		ax ; Restore Nth rotated AX
	loop	UTIL_PRINT_HEX_NIBBLES_LOOP ; dec CX until 0
	pop		bx
	ret
UTIL_PRINT_HEX_NIBBLES ENDP

UTIL_PRINT_BYTE PROC NEAR
	; Print 2 Nibbles from AH
	; AH = byte
	push	cx
	mov		cx,02h
	call 	UTIL_PRINT_HEX_NIBBLES
	pop		cx
	ret
UTIL_PRINT_BYTE ENDP

UTIL_PRINT_WORD PROC NEAR
	; Print 4 Nibbles from AX
	; AX = word
	push	cx
	mov		cx,04h
	call 	UTIL_PRINT_HEX_NIBBLES
	pop		cx
	ret
UTIL_PRINT_WORD ENDP

UTIL_PRINT_NEWLINE PROC NEAR
	;; Print \r\n
	push	ax
	mov		ax,(svc_video_write_char_tty SHL 8) OR 0Dh ; /r
	push	bx
	mov		bh,tty_page
	int		int_video
	mov		ax,(svc_video_write_char_tty SHL 8) OR 0Ah ; /n
	mov		bh,tty_page
	int		int_video
	pop		bx
	pop		ax
	ret
UTIL_PRINT_NEWLINE ENDP

UTIL_PRINT_STRING MACRO str
; Assumes DS is set
		push	dx
		mov		dx,offset str
		push	ax
		mov		ah,svc_dos_print_str
		int		int_dos_21
		pop		ax
		pop		dx
ENDM

UTIL_PRINT_REG_AS MACRO str
	UTIL_PRINT_STRING str
	call	UTIL_PRINT_BYTE
	call	UTIL_PRINT_NEWLINE
ENDM

UTIL_PRINT_WREG_AS MACRO str
	UTIL_PRINT_STRING str
	call	UTIL_PRINT_WORD
	call	UTIL_PRINT_NEWLINE
ENDM

