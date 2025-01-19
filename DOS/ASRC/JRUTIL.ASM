;;; PROC template

;!! PROC
;!!		PROC_NAME
;!! Input
;!!		
;!! Output
;!!		
;!! Uses directly
;!!		
;!! Calls
;!!		
;!! Dependencies destroy
;!!		
;!! Directly preserves
;!!		
;!! Total destroy
;!!		


;!! PROC
;!!		UTIL_PRINT_CHAR
;!!Input
;!!		AL = character to print
;!! Output
;!!		NONE (prints to screen TTY)
;!! Uses directly
;!!		AX, BX, flags
;!! Calls
;!!		int_bios_video_10
;!!			svc_bios_video_getmode_0F(destroys AX, BX, flags)
;!!			svc_bios_video_tty_0E (destroys AX, flags) 
;!! Dependencies destroy
;!!		AX, BX, flags
;!!	Directly preserves
;!!		BX
;!!	Total destroy
;!!		AX, flags
UTIL_PRINT_CHAR PROC NEAR ; Assumes al or constant
	push	bx
	push	ax ; Temporarily store AL
	mov		ah,svc_bios_video_getmode_0F ; Get video mode for page
	int		int_bios_video_10 ; bh = active page now
	mov		bl,val_bios_video_col_white_0F
	pop		ax ; Retrieve AL
	
	mov		ah,svc_bios_video_tty_0E ; Req: AL = chr, BH = pag, bl = col
	int		int_bios_video_10
	pop		bx
	ret
UTIL_PRINT_CHAR ENDP

;!! PROC
;!!		UTIL_PRINT_HEX_NIBBLES
;!! Input
;!!		CX = # of nibbles to print
;!!		AX = 1-4 nibbles to print from AH high -> AL low
;!! Output
;!!		NONE (prints to screen TTY)
;!! Uses directly
;!!		AX, CX(loop), flags
;!! Calls
;!!		UTIL_PRINT_CHAR (destroys AX, Flags)
;!! Dependencies destroy
;!!		AX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, CX, flags
UTIL_PRINT_HEX_NIBBLES PROC NEAR ; BIOS compatible
UTIL_PRINT_HEX_NIBBLES_LOOP:
	rol		ax,1 ; Grab the highest nibble by Rotating left 4x into al low nibble
	rol		ax,1 ;
	rol		ax,1 ;
	rol		ax,1 	; AL now contains "highest remaining nibble"
	push	ax ; Save off the Nth rotated AX
	and		al,0Fh ; Isolate nibble
	add		al,'0' ; Attempt to shift into ASCII numeric range
	cmp		al,'9' ; Check if <= '9' ASCII
	jle		UTIL_PRINT_HEX_NIBBLES_CONT ; Yup, continue
	add		al,'A'-'9'-1 ; If not, shift up to ASCII 'A' range
UTIL_PRINT_HEX_NIBBLES_CONT:
	call	UTIL_PRINT_CHAR
	pop		ax ; recover AX
	loop	UTIL_PRINT_HEX_NIBBLES_LOOP ; dec CX until 0
	ret
UTIL_PRINT_HEX_NIBBLES ENDP

;!! PROC
;!!		UTIL_PRINT_STR
;!! Input
;!!		DS = segment of message
;!!		DX = offset of message
;!! Output
;!!		NONE (prints to screen TTY), mimics DOS INT 21, SVC 09h
;!! Uses directly
;!!		AL, DX, SI, flags
;!! Calls
;!!		UTIL_PRINT_CHAR (destroys AX, flags)
;!! Dependencies destroy
;!!		AX, flags
;!! Directly preserves
;!!		DX
;!! Total destroy
;!!		AX, SI, flags
UTIL_PRINT_STR PROC NEAR ; Uses BIOS function
	xchg		si,dx ; Use SI as index, save old SI
UTIL_PRINT_STR_LOOP:
	cld
	lodsb	; mov al,ds:[si], inc si
	cmp		al,'$'
	je		UTIL_PRINT_STR_DONE
	call	UTIL_PRINT_CHAR
	jmp		SHORT UTIL_PRINT_STR_LOOP
UTIL_PRINT_STR_DONE:
	mov		si,dx ; Get back SI
	ret
UTIL_PRINT_STR ENDP

;!! PROC
;!!		UTIL_PRINT_MEM
;!! Input
;!!		DS = segment of message
;!!		SI = offset of message
;!! Output
;!!		NONE (prints to screen TTY)
;!! Uses directly
;!!		AX, CX, SI, flags
;!! Calls
;!!		UTIL_PRINT_CHAR (destroys AX, flags)
;!! Dependencies destroy
;!!		AX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, CX, SI, flags
UTIL_PRINT_MEM PROC NEAR
	cld
	lodsb		; mov al,ds:[si], inc si
	mov			ah,al
	push		cx
	mov			cx,0002h ; 2 nibbles ah
	call		UTIL_PRINT_HEX_NIBBLES
	pop			cx
	loop		UTIL_PRINT_MEM
	ret
UTIL_PRINT_MEM ENDP

;!! PROC
;!!		UTIL_ASCII_NUM_TO_HEX
;!! Input
;!!		AL = ASCII '0'-'9', 'A'-'F', 'a'-'f'
;!! Output
;!!		Success	CF=0, AL = 00h - 0Fh
;!!		Error	CF=1, AL = undefined/don't care
;!! Uses directly
;!!		AL, flags
;!! Calls
;!!		NONE
;!! Dependencies destroy
;!!		NONE
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AL, flags
UTIL_ASCII_NUM_TO_HEX PROC NEAR
	sub		al,'0' ; Check if between '0'-'9'
	cmp		al,9
	jbe		UTIL_ASCII_NUM_TO_HEX_S0 ; jump if below or equal
	sub		al,'A' - '0' ; Check result if between 'A'-'F'
	cmp		al,05h ; 10-15 shifted down 10
	jbe		UTIL_ASCII_NUM_TO_HEX_S10
	sub		al,'a'-'A' ; Check result if between 'a'-'f'
	cmp		al,05h ; 10-15 shifted down 10
	jbe		UTIL_ASCII_NUM_TO_HEX_S10
UTIL_ASCII_NUM_TO_HEX_F: ; Fail
	stc
	ret ; No need to jump, we're done
UTIL_ASCII_NUM_TO_HEX_S10: ; Success
	add		al,0Ah
UTIL_ASCII_NUM_TO_HEX_S0:
	clc
	ret
UTIL_ASCII_NUM_TO_HEX ENDP
