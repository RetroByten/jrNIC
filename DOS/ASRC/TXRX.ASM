%OUT Processing TXRX...

CS_HIGH PROC NEAR
	push	dx						; Save DX
	mov		dx,eth_write_cs_high	; Set DX
	out		dx,al					; Set ethernet controller CS line high, al is irrelevant
	pop		dx						; Restore DX
	ret
CS_HIGH ENDP

CS_LOW PROC NEAR
	push	dx						; Save DX
	mov		dx,eth_write_cs_low		; Set DX
	out		dx,al					; Set ethernet controller CS line low, al is irrelevant	
	pop		dx						; Restore DX
	ret
CS_LOW ENDP

CS_START PROC NEAR
	call	CS_HIGH					; call CS_HIGH first to ensure fresh start
	call	CS_LOW					; call CS_LOW to initialize transfer
	ret
CS_START ENDP

CS_END PROC NEAR
	call	CS_HIGH					; call CS_HIGH to end transfer
	ret
CS_END ENDP

;; Assumes CS_START was called
;; Assumes AH = 1xxx xxxx - bit to transmit
;; Returns AH = xxxx xxx1 - bit received
;; Returns AL = original AH transmit unchanged
TXRX_BIT PROC NEAR
	push	dx
	mov		dx,eth_read_write_bit	; Set inputt/output address
	in		al,dx					; Read low bit
	and		al,1					; Only use low bit, other bits forced to 0
	xchg	ah,al					; Swap AH and AL
	out		dx,al					; Send high bit
	pop		dx
	ret
TXRX_BIT ENDP

;; Assumes CS_START was called
;; Assumes AH = byte to transmit
;; Returns  AL
TXRX_BYTE PROC NEAR
	; ah = transmit byte
	push	bx						; used to build and temporarily store return value
	xor		bl,bl					; set BL to 0
	push	cx						; used as counter
	mov		cx,8					; Set counter to 8
TXRX_BYTE_LOOP:
	call	TXRX_BIT				; ah = received bit xxxx xxx1, 
									; al = as-is (though sent MSB)
	shl		bl,1					; shift receive byte left one
	or		bl,ah					; OR received bit into BL
	shl		al,1					; shift sent byte one over
	xchg	ah,al					; move transmit byte back to ah
	loop	TXRX_BYTE_LOOP
	pop		cx						; Restore CX
	mov		al,bl					; move final received byte to al
	pop		bx						; Restore BX
	ret								; Returns AL
TXRX_BYTE ENDP

SOFT_RESET PROC NEAR
	call	CS_START
	push	ax
	or		ah,(SRC_OPCODE SHL 5) OR SRC_ARG
	call	TXRX_BYTE ; ignore return, affects AL
	pop		ax
	call	CS_END
	;; TODO - Wait 50 microseconds per datasheet 11.2 (pg60)
	;; TODO - Wait until clock ready
	; while ( (read_eth_register(ESTAT_REGISTER) & ESTAT_CLKRDY_MASK_EXTRACT) != 1);
	ret
SOFT_RESET ENDP

; ah, INPUT = register
; al, OUTPUT = value
READ_ETH_REGISTER PROC NEAR
	call	CS_START
	or		ah,(RCR_OPCODE SHL 5) ; ah = rcr_opcode << 5 | reg (ah)
	call	TXRX_BYTE ; Send the opcode+reg byte, al returned is dummy
	call	TXRX_BYTE ; Send gibberish, Receive byte, al
	call	CS_END
	ret
READ_ETH_REGISTER ENDP

; ah, INPUT = register
; al, OUTPUT = value
READ_MAC_MII_REGISTER PROC NEAR
	call	CS_START
	or		ah,(RCR_OPCODE SHL 5) ; ah = rcr_opcode << 5 | reg (ah)
	call	TXRX_BYTE ; Send the opcode+reg byte, bl returned is dummy
	call	TXRX_BYTE ; send dummy byte, this returned al byte is also a dummy for MAC/MII
	call	TXRX_BYTE ; send dummy byte, returned al is actual byte
	call	CS_END
	ret
READ_MAC_MII_REGISTER ENDP

; ah, INPUT = register
; bx, 16 bit value
WRITE_PHY_REGISTER PROC NEAR ; Compound operation
	push	bx ; save 16-bit value
	push	ax ; save input (AH)
	call	GET_CONTROLLER_BANK ; returns al
	mov		bh,al ; move current_bank to bh

	; Set Bank 2
	mov		ah,BANK2
	call	SET_CONTROLLER_BANK
	
	;; Select PHY register
	pop		ax ; restore input (AH)
	mov		al,ah ; move input to al
	mov		ah,MIREGADR_REGISTER
	call	WRITE_REGISTER
	
	;; Write low byte
	pop		ax ; get original 16-bit value (old BX)
	push	bx ; store current bank (bh)
	push	ax ; store high byte
	mov		ah,MIWRL_REGISTER ; al holds low byte
	call	WRITE_REGISTER
	
	; Write high byte
	pop		ax ; get high byte
	mov		al,ah ; move high byte to al
	mov		ah,MIWRH_REGISTER
	call	WRITE_REGISTER

	; Set bank to bank 3
	mov		ah,BANK3
	call	SET_CONTROLLER_BANK
	
	; Wait for MISTAT.BUSY to clear
WRITE_PHY_REGISTER_BUSY:
	mov		ah,MISTAT_REGISTER
	call	READ_MAC_MII_REGISTER
	and		al,MISTAT_BUSY_GET
	cmp		al,00h
	jne		WRITE_PHY_REGISTER_BUSY
	
	;; Restore Bank
	pop		ax ; ah contains original bank
	call	SET_CONTROLLER_BANK
	
	ret
WRITE_PHY_REGISTER ENDP

; ah, INPUT = register
; ax, OUTPUT = value
READ_PHY_REGISTER PROC NEAR ; Compound operation
		; Datasheet 3.3
	push	bx ; used as a temporary
	push	ax ; save ah (input register)
	
	; Step 0 Save current Bank
	call	GET_CONTROLLER_BANK
	mov		bh,al ; move current_bank to bh
	
	; Set BANK2
	mov		ah,BANK2
	call	SET_CONTROLLER_BANK
	
	pop		ax ; get input register back (ah)
	push	bx ; push current bank (bh)
	
	; Step 1, ah = desired PHY register, write that as data to MIREGADR
	mov		al,ah ; move PHY reg to al
	mov		ah,MIREGADR_REGISTER
	call	WRITE_REGISTER
	
	; Step 2, Set MIIRD in MICMD register to initiate read, Sets MISTAT.BUSY until complete
	mov		ax,(MICMD_REGISTER SHL 8) OR MICMD_MIIRD_SET
	call	WRITE_REGISTER
	
	; Step 3, Wait until MISTAT.BUSY is cleared
	mov		ah,BANK3
	call	SET_CONTROLLER_BANK 
READ_PHY_REGISTER_BUSY:
	mov		ah,MISTAT_REGISTER
	call	READ_MAC_MII_REGISTER 
	and		al,MISTAT_BUSY_GET
	cmp		al,00h
	jne		READ_PHY_REGISTER_BUSY

	; Step 4, now that the value is ready, clear the MICMD bit
	mov		ah,BANK2
	call	SET_CONTROLLER_BANK
	mov		ax,(MICMD_REGISTER SHL 8) OR 0 ; 0 value to clear MICMD
	call	WRITE_REGISTER
	
	; Step 5, Read 16 bit value from MIRDH/MIRDL
	mov		ah,MIRDH_REGISTER
	call	READ_MAC_MII_REGISTER
	mov		bh,al ; save high byte
	mov		ah,MIRDL_REGISTER
	call	READ_MAC_MII_REGISTER
	mov		bl,al ; save low byte, BX now contains value

	; Step 6, Restore bank
	pop		ax ; ah = original bank
	call	SET_CONTROLLER_BANK

	; Step 7, move output value to AX and restore BX
	mov		ax,bx ; move output value
	pop		bx ; restore original BX
	ret
READ_PHY_REGISTER ENDP

; AH = REG, AL = value
WRITE_REGISTER PROC NEAR
	call	CS_START
	push	ax ; store value
	or		ah,(WCR_OPCODE SHL 5) ; ah = wcr opcode << 5 | reg
	call	TXRX_BYTE ; Send opcode + reg byte, al returned is dummy
	pop		ax ; value = al
	xchg	ah,al ; move value to AH
	call	TXRX_BYTE ; Send value, al returned is dummy
	call	CS_END
	ret
WRITE_REGISTER ENDP

; AX = REG_HIGH, REG_LOW
; BX = VAL_HIGH, VAL_LOW
WRITE_REGISTER_LOW_HIGH PROC NEAR
	xchg	al,bh	; AX = REG_HIGH, VAL_HIGH
					; BX = REG_LOW, VAL_LOW
	push	ax ; Save high WRITE_REGISTER+VAL
	mov		ax,bx
	call	WRITE_REGISTER
	pop		ax ; Restore high WRITE_REGISTER+VAL
	call	WRITE_REGISTER
	ret
WRITE_REGISTER_LOW_HIGH ENDP

; AH = REG, AL = value
BIT_FIELD_SET PROC NEAR
	call	CS_START
	push	ax ; store value
	or		ah,(BFS_OPCODE SHL 5) ; ah = BFS opcode << 5 | reg (ah)
	call	TXRX_BYTE
	pop		ax ; value = al
	mov		ah,al ; move value to AH
	call	TXRX_BYTE
	call	CS_END
	ret
BIT_FIELD_SET ENDP

; AH = REG, AL = value
BIT_FIELD_CLEAR PROC NEAR
	call	CS_START
	push	ax ; store value
	or		ah,(BFC_OPCODE SHL 5) ; ah = BFS opcode << 5 | reg (ah)
	call	TXRX_BYTE
	pop		ax ; value = al
	mov		ah,al ; move value to AH
	call	TXRX_BYTE
	call	CS_END
	ret
BIT_FIELD_CLEAR ENDP

; BX PCjr Memory pointer
; CX Number of bytes to receive
; Assumes ERDPT is pointing to the beginning of RX memory!
READ_BUFFER_MEMORY PROC NEAR
	call	CS_START
	push	ax ; save AX
	mov		ah,(RBM_OPCODE SHL 5) OR BUFF_MEM_ARG
	call	TXRX_BYTE ; send initial opcode
RBM_LOOP:
	call	TXRX_BYTE ; read next byte into al
	mov		[bx],al ; save byte
	inc		bx
	loop	RBM_LOOP  ; dec CX ;; TODO - switch this to DI based stuff?
	pop		ax ; restore AX
	call	CS_END
	ret
READ_BUFFER_MEMORY ENDP

; BX = PCjr Memory pointer
; CX = number of bytes to send
; Assumes autoinc in ECON2 is set
; Assumes EWRPT is pointing to the beginning of TX memory!
WRITE_BUFFER_MEMORY PROC NEAR
	call	CS_START
	push	ax ; save AX
	mov		ah,(WBM_OPCODE SHL 5) OR BUFF_MEM_ARG
	call	TXRX_BYTE ; Send initial opcode
WBM_LOOP:
	mov		ah,[bx] ; get byte to Send
	call	TXRX_BYTE
	inc		bx
	loop	WBM_LOOP ; dec CX
	pop		ax ; restore AX
	call	CS_END
	ret
WRITE_BUFFER_MEMORY ENDP

; Returns AL = Bank Value, Destroys AH
GET_CONTROLLER_BANK PROC NEAR
	mov		ah,ECON1_REGISTER
	call	READ_ETH_REGISTER ; al = bank value
	and		al,BANK_MASK
	ret
GET_CONTROLLER_BANK ENDP

; ah = bank
SET_CONTROLLER_BANK PROC NEAR
	push	bx ; will use BX as temp
	push	ax ; Save bank
	mov		ah,ECON1_REGISTER ; Works from all banks
	call	READ_ETH_REGISTER ; returns AL = ECON1 value
	and		al,NOT BANK_MASK ; force current bank bits to 0
	pop		bx ; Get back old AX (Desired Bank = bh now)
	or		al,bh ; AL now contains old ECON1 but with new bank
	mov		ah,ECON1_REGISTER
	call	WRITE_REGISTER
	pop		bx ; Restore BX
	ret
SET_CONTROLLER_BANK ENDP
