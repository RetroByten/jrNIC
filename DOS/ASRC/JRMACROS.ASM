; Input: None
; Output: 
;	jz, zero flag set (1) if interrupt was unmasked before call (Active,0)
;	jnz, zero flag clear (0) if interrupt was masked before call (card in use,1)
;	IRQ4 Masked
; Destroys AH, Flags
FORCE_MASK_IRQ_CHECKM MACRO
	in		al,port_pic_data	; Read current IRQ masks
	mov		ah,al				; Save current IRQ masks
	or		al,mask_modem_bit	; Unconditionally mask (if it's already masked its no loss)
	test	ah,mask_modem_bit	; Check if saved IRQ masks has modem masked
ENDM

;!! MACRO
;!!		MASK_IRQ4M
;!! Input
;!!		NONE
;!! Output
;!!		NONE
;!! Uses directly
;!!		AX, flags
;!! Calls
;!!		NONE
;!! Dependencies destroy
;!!		AX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, flags
MASK_IRQ4M MACRO
	in		al,port_pic_data
	or		al,mask_modem_bit ; 0001 0000 mask IRQ off
	out		port_pic_data,al
ENDM

;!! MACRO
;!!		UNMASK_IRQ4M
;!! Input
;!!		NONE
;!! Output
;!!		NONE
;!! Uses directly
;!!		AX, flags
;!! Calls
;!!		NONE
;!! Dependencies destroy
;!!		NONE
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, flags
UNMASK_IRQ4M MACRO
	in		al,port_pic_data
	and		al,NOT mask_modem_bit ; 1110 1111 clear/activate IRQ
	out		port_pic_data,al ; write interrupt controller mask reg to unmask modem
ENDM

;!! MACRO
;!!		ACK_IRQM
;!! Input
;!!		NONE
;!! Output
;!!		NONE
;!! Uses directly
;!!		AX
;!! Calls
;!!		NONE
;!! Dependencies destroy
;!!		NONE
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX
ACK_IRQM MACRO
	mov		al,val_pic_eoi		; Unconditionally ACK hardware Interrupt
	out		port_pic_cmd,al
ENDM

;!! MACRO
;!!		MASK_NMI
;!! Input
;!!		NONE
;!! Output
;!!		NONE
;!! Uses directly
;!!		AX, flags
;!! Calls
;!!		NONE
;!! Dependencies destroy
;!!		AX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, flags
MASK_NMI MACRO
	mov		al,nmi_disable
	out		port_nmi_mask_reg,al
ENDM

;!! MACRO
;!!		UNMASK_NMI
;!! Input
;!!		NONE
;!! Output
;!!		NONE
;!! Uses directly
;!!		AX, flags
;!! Calls
;!!		NONE
;!! Dependencies destroy
;!!		AX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, flags
UNMASK_NMI MACRO
	mov		al,nmi_enable
	out		port_nmi_mask_reg,al
	in		al,port_nmi_mask_reg	; Read Port to clear latch,
									; For case a key was pressed
									; while NMI was masked
ENDM

PARA_ALIGN_MACRO MACRO
	IF ($-BEGINOFPROG) MOD 16 ; If not paragraph aligned
		ORG ($-BEGINOFPROG)+16-(($-BEGINOFPROG) MOD 16) ; Round up
	ENDIF
ENDM

;!! MACRO
;!!		UTILM_PRINT_STR
;!! Input
;!!		str = offset from CS
;!! Output
;!!		NONE (prints to screen TTY)
;!! Uses directly
;!!		DS, DX, flags
;!! Calls
;!!		UTIL_PRINT_STR (destroys AX, SI, flags)
;!! Dependencies destroy
;!!		AX, SI, flags
;!! Directly preserves
;!!		DS, DX, SI, AX
;!! Total destroy
;!!		flags
UTILM_PRINT_STR MACRO str
	push	ds ; Preserve DS
	
	push	cs
	pop		ds ; set DS to CS
	
	push	dx ; Preserve DX
	mov		dx,offset str ; set DX to string offset
	
	push	si ; Preserve SI
	push	ax ; Preserve AX
	call	UTIL_PRINT_STR
	;; Restore preserved regs
	pop		ax
	pop		si
	pop		dx
	pop		ds
ENDM

;!! MACRO
;!!		UTILM_PRINT_CHAR
;!! Input
;!!		chr = character (al or constant) to print
;!! Output
;!!		NONE (prints to screen TTY)
;!! Uses directly
;!!		AX, BX flags
;!! Calls
;!!		UTIL_PRINT_CHAR (destroys AX, flags)
;!! Dependencies destroy
;!!		AX, flags
;!! Directly preserves
;!!		AX, BX
;!! Total destroy
;!!		flags
UTILM_PRINT_CHAR MACRO chr ; Assumes al or constant
	push	bx
	push	ax ; in case user passed us al
	mov		al, chr
	call	UTIL_PRINT_CHAR
	pop		ax
	pop		bx
ENDM

;!! MACRO
;!!		UTILM_PRINT_NEWLINE
;!! Input
;!!		NONE
;!! Output
;!!		NONE (prints to screen TTY)
;!! Uses directly
;!!		NONE
;!! Calls
;!!		UTILM_PRINT_CHAR (destroys flags)
;!! Dependencies destroy
;!!		flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		flags
UTILM_PRINT_NEWLINE MACRO
	UTILM_PRINT_CHAR 0dh ; \r
	UTILM_PRINT_CHAR 0ah ; \n
ENDM

;!! MACRO
;!!		UTILM_PRINT_STRN
;!! Input
;!!		str = CS offset of string to print
;!! Output
;!!		NONE (prints to screen TTY)
;!! Uses directly
;!!		NONE
;!! Calls
;!!		UTILM_PRINT_STR (destroys flags)
;!!		UTILM_PRINT_NEWLINE (destroys flags)
;!! Dependencies destroy
;!!		flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		flags
UTILM_PRINT_STRN MACRO str
	UTILM_PRINT_STR str
	UTILM_PRINT_NEWLINE
ENDM

;!! MACRO
;!!		UTILM_PRINT_SPACE
;!! Input
;!!		NONE
;!! Output
;!!		NONE (prints to screen TTY)
;!! Uses directly
;!!		NONE
;!! Calls
;!!		UTILM_PRINT_CHAR (destroys flags)
;!! Dependencies destroy
;!!		flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		flags
UTILM_PRINT_SPACE MACRO
	UTILM_PRINT_CHAR " "
ENDM

;!! MACRO
;!!		UTILM_PRINT_COLON
;!! Input
;!!		NONE
;!! Output
;!!		NONE (prints to screen TTY)
;!! Uses directly
;!!		NONE
;!! Calls
;!!		UTILM_PRINT_CHAR (destroys flags)
;!! Dependencies destroy
;!!		flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		flags
UTILM_PRINT_COLON MACRO
	UTILM_PRINT_CHAR ":"
ENDM

;!! MACRO
;!!		UTILM_PRINT_HEX_NIBBLES
;!! Input
;!!		nibbles = constant # of nibbles to print from AX -> AL
;!! Output
;!!		NONE (prints to screen TTY)
;!! Uses directly
;!!		AX, CX, flags
;!! Calls
;!!		UTIL_PRINT_HEX_NIBBLES (destroys AX, CX, flags)
;!! Dependencies destroy
;!!		AX, CX, flags
;!! Directly preserves
;!!		AX, CX
;!! Total destroy
;!!		flags
UTILM_PRINT_HEX_NIBBLES MACRO nibbles
	push	cx
	push	ax
	mov		cx,nibbles
	call	UTIL_PRINT_HEX_NIBBLES
	pop		ax
	pop		cx
ENDM

;!! MACRO
;!!		UTILM_PRINT_WREG
;!! Input
;!!		str = offset of string from CS to print
;!!		reg = register containing value to print
;!! Output
;!!		NONE (prints to screen TTY)
;!! Uses directly
;!!		AX, flags
;!! Calls
;!!		UTILM_PRINT_HEX_NIBBLES (destroys flags)
;!! Dependencies destroy
;!!		flags
;!! Directly preserves
;!!		AX
;!! Total destroy
;!!		flags
UTILM_PRINT_WREG MACRO str,reg
	UTILM_PRINT_STR str
	UTILM_PRINT_COLON
	push	ax
	mov		ax,reg
	UTILM_PRINT_HEX_NIBBLES 4
	pop		ax
ENDM

;!! MACRO
;!!		UTILM_PRINT_BREG
;!! Input
;!!		str = offset of string from CS to print
;!!		reg = register containing value to print
;!! Output
;!!		NONE (prints to screen TTY)
;!! Uses directly
;!!		AX, flags
;!! Calls
;!!		UTILM_PRINT_HEX_NIBBLES (destroys flags)
;!! Dependencies destroy
;!!		flags
;!! Directly preserves
;!!		AX	
;!! Total destroy
;!!		flags
UTILM_PRINT_BREG MACRO str,reg
	UTILM_PRINT_STR str
	UTILM_PRINT_COLON
	push	ax
	mov		ax,reg
	UTILM_PRINT_HEX_NIBBLES 2
	pop		ax
ENDM

;!! MACRO
;!!		UTILM_PRINT_SEGS
;!! Input
;!!		NONE
;!! Output
;!!		NONE (prints to screen TTY)
;!! Uses directly
;!!		NONE
;!! Calls
;!!		UTILM_PRINT_WREG (destroys flags)
;!!		UTILM_PRINT_SPACE (destroys flags)
;!!		UTILM_PRINT_NEWLINE (destroys flags)
;!! Dependencies destroy
;!!		flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		flags
UTILM_PRINT_SEGS MACRO
	UTILM_PRINT_WREG str_cs,cs
	UTILM_PRINT_SPACE
	UTILM_PRINT_WREG str_ds,ds
	UTILM_PRINT_SPACE
	UTILM_PRINT_WREG str_es,es
	UTILM_PRINT_SPACE
	UTILM_PRINT_WREG str_ss,ss
	UTILM_PRINT_SPACE
	UTILM_PRINT_WREG str_sp,sp
	UTILM_PRINT_SPACE
	UTILM_PRINT_NEWLINE
ENDM

;!! MACRO
;!!		UTILM_DELAY
;!! Input
;!!		del = number of loops
;!! Output
;!!		NONE (delays execution)
;!! Uses directly
;!!		CX (loop), flags
;!! Calls
;!!		NONE
;!! Dependencies destroy
;!!		NONE
;!! Directly preserves
;!!		CX
;!! Total destroy
;!!		flags
UTILM_DELAY MACRO del
	local	UTILM_DELAY_LOOP
	push	cx
	mov		cx,del
UTILM_DELAY_LOOP:
	loop	UTILM_DELAY_LOOP
	pop		cx
ENDM

;!! MACRO
;!!		UTILM_DELAY_ITER
;!! Input
;!!		iter = number of FFFF delay loops to call
;!! Output
;!!		NONE (delays execution)
;!! Uses directly
;!!		CX (loop), flags
;!! Calls
;!!		UTILM_DELAY (destroys flags)
;!! Dependencies destroy
;!!		flags
;!! Directly preserves
;!!		CX
;!! Total destroy
;!!		flags
UTILM_DELAY_ITER MACRO iter
	local	UTILM_DELAY_ITER_LOOP
	push	cx
	mov		cx,iter
UTILM_DELAY_ITER_LOOP:
	UTILM_DELAY 0FFFFh
	loop	UTILM_DELAY_ITER_LOOP
	pop		cx
ENDM
