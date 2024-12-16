%OUT Processing TXRX...

%OUT Processing TXRX EQUATES...
;; jrNIC write controls
eth_write_cs_low			EQU 3ffh
eth_write_cs_high			EQU 3feh
eth_read_write_bit			EQU 3fdh

;; Ethernet controller registers
RCR_OPCODE					EQU 00h ; Read control register
RBM_OPCODE					EQU 01h ; Read Buffer memory
WCR_OPCODE					EQU 02h ; Write control register
WBM_OPCODE					EQU 03h ; Write Buffer memory
	BUFF_MEM_ARG			EQU 1Ah ; Read/Write buffer memory arg
BFS_OPCODE					EQU 04h ; Bit Field Set
BFC_OPCODE					EQU 05h ; Bit Field Clear
SRC_OPCODE					EQU 07h ; System Reset Command (soft reset)
	SRC_ARG						EQU 1Fh ; Arg for SRC reset

BANK_MASK					EQU 03h

BANK0						EQU 00h
ERDPTL_REGISTER EQU   00h
ERDPTH_REGISTER EQU   01h
EWRPTL_REGISTER EQU   02h
EWRPTH_REGISTER EQU   03h
ETXSTL_REGISTER EQU   04h ; TX Start Low Byte
ETXSTH_REGISTER EQU   05h ; TX Start High Byte
ETXNDL_REGISTER EQU   06h ; TX Start Low Byte
ETXNDH_REGISTER EQU   07h ; TX Start High Byte
ERXSTL_REGISTER EQU   08h ; RX Start Low Byte
ERXSTH_REGISTER EQU   09h ;RX Start High Byte
ERXNDL_REGISTER EQU   0Ah ; RX End Low Byte
ERXNDH_REGISTER EQU   0B ; RX End Low Byte
ERXRDPTL_REGISTER EQU 0Ch ; Read pointer low
ERXRDPTH_REGISTER EQU 0Dh ; Read pointer high
ERXWRPTL_REGISTER EQU 0Eh 
ERXWRPTH_REGISTER EQU 0Fh 
EDMASTL_REGISTER EQU  10h
EDMASTH_REGISTER EQU  11h
EDMANDL_REGISTER EQU  12h
EDMANDH_REGISTER EQU  13h
EDMADSTL_REGISTER EQU 14h
EDMADSTH_REGISTER EQU 15h
EDMACSL_REGISTER EQU  16h
EDMACSH_REGISTER EQU  17h

BANK1						EQU 01h
EHT0_REGISTER		EQU 00h
EHT1_REGISTER		EQU 01h
EHT2_REGISTER 		EQU 02h
EHT3_REGISTER		EQU 03h
EHT4_REGISTER		EQU 04h
EHT5_REGISTER		EQU 05h
EHT6_REGISTER		EQU 06h
EHT7_REGISTER		EQU 07h
EPMM0_REGISTER		EQU 08h
EPMM1_REGISTER		EQU 09h
EPMM2_REGISTER		EQU 0Ah
EPMM3_REGISTER		EQU 0Bh
EPMM4_REGISTER		EQU 0Ch
EPMM5_REGISTER		EQU 0Dh
EPMM6_REGISTER		EQU 0Eh
EPMM7_REGISTER		EQU 0Fh
EPMCSL_REGISTER		EQU 10h
EPMCSH_REGISTER		EQU 11h
EPMOL_REGISTER		EQU 14h
EPMOH_REGISTER		EQU 15h
ERXFCON_REGISTER	EQU 18h ; Receive Filter control register
	ERXFCON_UCEN_SET	EQU 80h
	ERXFCON_CRCEN_SET	EQU 20h
	ERXFCON_PMEN_SET	EQU 10h
EPKTCNT_REGISTER	EQU 19h

BANK2						EQU 02h
MACON1_REGISTER			EQU 00h ;MAC/MII
	MACON1_MARXEN_SET	EQU 01h 
	MACON1_TXPAUS_SET	EQU 04h 
	MACON1_TXPAUS_UNSET	EQU 00h 
	MACON1_RXPAUS_SET	EQU 08h 
	MACON1_RXPAUS_UNSET	EQU 00h 
MACON3_REGISTER			EQU 02h ;MAC/MII
	MACON3_FULDPX_SET	EQU 01h 
	MACON3_FULDPX_UNSET	EQU 00h 
	MACON3_TXCRCEN_SET	EQU 10h 
	MACON3_PADCFG0_SET	EQU 20h 
	MACON3_PADCFG1_SET	EQU 40h 
	MACON3_PADCFG2_SET	EQU 80h 

MACON4_REGISTER			EQU 03h ;MAC/MII
	MACON4_DEFER_SET		EQU 40h 
MABBIPG_REGISTER		EQU 04h ;MAC/MII
MAIPGL_REGISTER			EQU 06h ;MAC/MII
MAIPGH_REGISTER			EQU 07h ;MAC/MII
MACLCON1_REGISTE		EQU 08h ;MAC/MII
MACLCON2_REGISTE		EQU 09h ;MAC/MII
MAMXFLL_REGISTER		EQU 0Ah ;MAC/MII
MAMXFLH_REGISTER		EQU 0Bh ;MAC/MII
MICMD_REGISTER			EQU 12h ;MAC/MII
	MICMD_MIIRD_MASK_CLEAR	EQU 0FEh 
	MICMD_MIIRD_SET			EQU 01h 
	MICMD_MIIRD_CLEAR		EQU 00h 
MIREGADR_REGISTER		EQU 14h ;MAC/MII
MIWRL_REGISTER			EQU 16h ;MAC/MII
MIWRH_REGISTER			EQU 17h ;MAC/MII
MIRDL_REGISTER			EQU 18h ;MAC/MII
MIRDH_REGISTER			EQU 19h ;MAC/MII


BANK3						EQU 03h
MAADR5_REGISTER		EQU 00h ;MAC/MII
MAADR6_REGISTER		EQU 01h ;MAC/MII
MAADR3_REGISTER		EQU 02h ;MAC/MII
MAADR4_REGISTER		EQU 03h ;MAC/MII
MAADR1_REGISTER		EQU 04h ;MAC/MII
MAADR2_REGISTER		EQU 05h ;MAC/MII
MISTAT_REGISTER		EQU 0Ah ;MAC/MII
	MISTAT_BUSY_GET		EQU 01h 
EBSTSD_REGISTER		EQU 06h 
EBSTCON_REGISTER	EQU 07h 
EBSTCSL_REGISTER	EQU 08h 
EBSTCSH_REGISTER	EQU 09h 
MISTAT_REGISTER		EQU 0Ah ;MAC/MII
EREVID_REGISTER		EQU 12h 
ECOCON_REGISTER		EQU 15h 
EFLOCON_REGISTER	EQU 17h 
EPAUSL_REGISTER		EQU 18h 
EPAUSH_REGISTER		EQU 19h 

; ALL Banks
EIE_REGISTER			EQU 1Bh
	EIE_INTIE				EQU 80h
	EIE_PKTIE				EQU 40h
	EIE_DMAIE				EQU 20h
	EIE_LINKIE				EQU 10h
	EIE_TXIE				EQU 08h
	EIE_TXERIE				EQU 02h
	EIE_RXERIE				EQU 01h

EIR_REGISTER			EQU 1Ch
	EIR_PKTIF				EQU 40h
	EIR_DMAIF				EQU 20h
	EIR_LINKIF				EQU 10h
	EIR_TXIF				EQU 08h
	EIR_TXERIF				EQU 02h
	EIR_RXERIF				EQU 01h
ESTAT_REGISTER			EQU 1Dh
	ESTAT_CLKRDY_MASK_EXTRACT	EQU 01h
ECON2_REGISTER			EQU 1Eh
	ECON2_AUTOINC_MASK		EQU 80h
	ECON2_PKTDEC_MASK		EQU 40h
ECON1_REGISTER			EQU 1Fh
	ECON1_RXEN_MASK		EQU 04h
	ECON1_TXRTS_MASK	EQU 08h
	
; PHY
PHCON1_REGISTER			EQU 00h
	PHCON1_PDPXMD_EXTRACT	EQU 0100h
	PHCON1_PDPXMD_SET		EQU 0100h
	PHCON1_PPWRSV_SET		EQU 0800h
	PHCON1_PLOOPBK_SET		EQU 4000h
PHSTAT1_REGISTER		EQU 01h
	PHSTAT1_LLSTAT			EQU 0004h
PHID1_REGISTER			EQU 02h
PHID2_REGISTER			EQU 03h
PHCON2_REGISTER			EQU 10h
	PHCON2_HDLDIS_SET		EQU 0100h
PHSTAT2_REGISTER		EQU 11h
	PHSTAT2_LSTAT			EQU 0400h
PHIE_REGISTER			EQU 12h
	PHIE_PLNKIE				EQU 0010h
	PHIE_PGEIE				EQU 0002h
PHIR_REGISTER			EQU 13h
	PHIR_PLNKIF				EQU 0010h
	PHIR_PGIF				EQU 0004h
PHLCON_REGISTER			EQU 14h

; Hard coded properties
MAX_FRAME_LENGTH		EQU 1518 ; decimal bytes, 5EEh
B2BINTERPACKETGAP		EQU	12h ; Half-duplex, full would be 15h
NB2BINTERPACKETGAP		EQU 0C12h ; half-duplex

; Ethernet controller memory blocks
RESERVED_MEMORY_START		EQU	0000h ; Used to store handles, receive addresses, etc.
RESERVED_MEMORY_END			EQU 00FFh
TX_ADDRESS_START 			EQU	0100h ; Start of transmit memory
TX_ADDRESS_END				EQU 06FFh ; 1535 bytes (256-1791)
RX_ADDRESS_START			EQU 0700h ; 0x700 - 0x1FFF
RX_ADDRESS_END				EQU 1FFFh ; End of memory

;; Send control byte
SEND_CTRL_BYTE db 00h

%OUT Processing TXRX CODE
;;; DONE
CS_HIGH PROC NEAR ; AX isn't written, so it is already preserved
	push	dx						; Save DX
	mov		dx,eth_write_cs_high	; Set DX
	out		dx,al					; Set ethernet controller CS line high, al is irrelevant
	pop		dx						; Restore DX
	ret
CS_HIGH ENDP
;;; DONE
CS_LOW PROC NEAR ; AX isn't written, so it is already preserved
	push	dx						; Save DX
	mov		dx,eth_write_cs_low		; Set DX
	out		dx,al					; Set ethernet controller CS line low, al is irrelevant	
	pop		dx						; Restore DX
	ret
CS_LOW ENDP
;;; DONE
CS_START PROC NEAR
	call	CS_HIGH					; call CS_HIGH first to ensure fresh start
	call	CS_LOW					; call CS_LOW to initialize transfer
	ret
CS_START ENDP
;;; DONE
CS_END PROC NEAR
	call	CS_HIGH					; call CS_HIGH to end transfer
	ret
CS_END ENDP

;;; DONE
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

;;; DONE
;; Assumes CS_START was called
;; Assumes AH = byte to transmit
;; Returns  AL
TXRX_BYTE PROC NEAR
	push	dx ;;; NEW
	mov		dx,eth_read_write_bit ;;; NEW	; Set input/output address
	; ah = transmit byte
	push	bx						; used to build and temporarily store return value
	xor		bl,bl					; set BL to 0
	push	cx						; used as counter
	mov		cx,8					; Set counter to 8
TXRX_BYTE_LOOP:
	;call	TXRX_BIT				; ah = received bit xxxx xxx1, 
									; al = as-is (though sent MSB)
									
	;;; BEGIN NEW TXRX BIT
	in		al,dx					; Read low bit
	and		al,1					; Only use low bit, other bits forced to 0
	xchg	ah,al					; Swap AH and AL
	out		dx,al					; Send high bit
	;;; END NEW TXRXBIT
	shl		bl,1					; shift receive byte left one
	or		bl,ah					; OR received bit into BL
	shl		al,1					; shift sent byte one over
	xchg	ah,al					; move transmit byte back to ah
	loop	TXRX_BYTE_LOOP
	pop		cx						; Restore CX
	mov		al,bl					; move final received byte to al
	pop		bx						; Restore BX
	pop		dx ;;; NEW
	ret								; Returns AL
TXRX_BYTE ENDP

;;; DONE
TXRX_BYTE3 PROC NEAR
	push	dx
	push	bx
	xor		bl,bl					; set BL to 0
	;; BIT 1
		;;; BEGIN NEW TXRX BIT
	in		al,dx					; Read low bit
	and		al,1					; Only use low bit, other bits forced to 0
	xchg	ah,al					; Swap AH and AL
	out		dx,al					; Send high bit
	;;; END NEW TXRXBIT
	shl		bl,1					; shift receive byte left one
	or		bl,ah					; OR received bit into BL
	shl		al,1					; shift sent byte one over
	xchg	ah,al					; move transmit byte back to ah
	;; BIT 2
		;;; BEGIN NEW TXRX BIT
	in		al,dx					; Read low bit
	and		al,1					; Only use low bit, other bits forced to 0
	xchg	ah,al					; Swap AH and AL
	out		dx,al					; Send high bit
	;;; END NEW TXRXBIT
	shl		bl,1					; shift receive byte left one
	or		bl,ah					; OR received bit into BL
	shl		al,1					; shift sent byte one over
	xchg	ah,al					; move transmit byte back to ah
	;; BIT 3
		;;; BEGIN NEW TXRX BIT
	in		al,dx					; Read low bit
	and		al,1					; Only use low bit, other bits forced to 0
	xchg	ah,al					; Swap AH and AL
	out		dx,al					; Send high bit
	;;; END NEW TXRXBIT
	shl		bl,1					; shift receive byte left one
	or		bl,ah					; OR received bit into BL
	shl		al,1					; shift sent byte one over
	xchg	ah,al					; move transmit byte back to ah
	;; BIT 4
		;;; BEGIN NEW TXRX BIT
	in		al,dx					; Read low bit
	and		al,1					; Only use low bit, other bits forced to 0
	xchg	ah,al					; Swap AH and AL
	out		dx,al					; Send high bit
	;;; END NEW TXRXBIT
	shl		bl,1					; shift receive byte left one
	or		bl,ah					; OR received bit into BL
	shl		al,1					; shift sent byte one over
	xchg	ah,al					; move transmit byte back to ah
	;; BIT 5
		;;; BEGIN NEW TXRX BIT
	in		al,dx					; Read low bit
	and		al,1					; Only use low bit, other bits forced to 0
	xchg	ah,al					; Swap AH and AL
	out		dx,al					; Send high bit
	;;; END NEW TXRXBIT
	shl		bl,1					; shift receive byte left one
	or		bl,ah					; OR received bit into BL
	shl		al,1					; shift sent byte one over
	xchg	ah,al					; move transmit byte back to ah
	;; BIT 6
		;;; BEGIN NEW TXRX BIT
	in		al,dx					; Read low bit
	and		al,1					; Only use low bit, other bits forced to 0
	xchg	ah,al					; Swap AH and AL
	out		dx,al					; Send high bit
	;;; END NEW TXRXBIT
	shl		bl,1					; shift receive byte left one
	or		bl,ah					; OR received bit into BL
	shl		al,1					; shift sent byte one over
	xchg	ah,al					; move transmit byte back to ah
	;; BIT 7
		;;; BEGIN NEW TXRX BIT
	in		al,dx					; Read low bit
	and		al,1					; Only use low bit, other bits forced to 0
	xchg	ah,al					; Swap AH and AL
	out		dx,al					; Send high bit
	;;; END NEW TXRXBIT
	shl		bl,1					; shift receive byte left one
	or		bl,ah					; OR received bit into BL
	shl		al,1					; shift sent byte one over
	xchg	ah,al					; move transmit byte back to ah
	;; BIT 8
		;;; BEGIN NEW TXRX BIT
	in		al,dx					; Read low bit
	and		al,1					; Only use low bit, other bits forced to 0
	xchg	ah,al					; Swap AH and AL
	out		dx,al					; Send high bit
	;;; END NEW TXRXBIT
	shl		bl,1					; shift receive byte left one
	or		bl,ah					; OR received bit into BL
	shl		al,1					; shift sent byte one over
	xchg	ah,al					; move transmit byte back to ah
	;; DONE BITS
	mov		al,bl					; move final received byte to al
	pop		bx
	pop		dx
	ret
TXRX_BYTE3 ENDP

;;; DONE
SOFT_RESET PROC NEAR
	push	ax
	call	CS_START
	or		ah,(SRC_OPCODE SHL 5) OR SRC_ARG
	call	TXRX_BYTE ; ignore return, affects AL
	call	CS_END
	pop		ax
	;; TODO - Wait 50 microseconds per datasheet 11.2 (pg60)
	;; TODO - Wait until clock ready
	; while ( (read_eth_register(ESTAT_REGISTER) & ESTAT_CLKRDY_MASK_EXTRACT) != 1);
	ret
SOFT_RESET ENDP

;;; DONE
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

;;; DONE
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

;;; DONE
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

;;; DONE
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

; Assumes ERDPT is set!
; AX returns single byte (AL)
READ_BUFFER_MEMORY_BYTE PROC NEAR
	call	CS_START
	mov		ah,(RBM_OPCODE SHL 5) OR BUFF_MEM_ARG
	call	TXRX_BYTE ; send initial opcode
	call	TXRX_BYTE ; read next byte into al
	call	CS_END
	ret ; return al
READ_BUFFER_MEMORY_BYTE ENDP





; Assumes ERDPT is set!
; AX returns single byte (AL)
READ_BUFFER_MEMORY_WORD PROC NEAR
	call	CS_START
	push	bx
	mov		ah,(RBM_OPCODE SHL 5) OR BUFF_MEM_ARG
	call	TXRX_BYTE ; send initial opcode
	call	TXRX_BYTE ; read next byte into al
	mov		bl,al ; save low byte
	;mov		ah,(RBM_OPCODE SHL 5) OR BUFF_MEM_ARG
	;call	TXRX_BYTE ; send initial opcode
	call	TXRX_BYTE ; read next byte into al
	mov		bh,al ; save high byte
	mov		ax,bx ; save result
	pop		bx
	call	CS_END
	ret ; return ax
READ_BUFFER_MEMORY_WORD ENDP

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
	;; Debug
	;push	ax
	;UTIL_PRINT_NEWLINE
	;mov		ah,al
	;UTIL_PRINT_HEX 2
	;UTIL_PRINT_NEWLINE
	;pop		ax
	;; END DEBUG
	inc		bx
	loop	RBM_LOOP  ; dec CX ;; TODO - switch this to DI based stuff?
	pop		ax ; restore AX
	call	CS_END
	ret
READ_BUFFER_MEMORY ENDP

; ax contains word
; Assumes autoinc in ECON2 is set
; Assumes EWRPT is pointing to the beginning of TX memory!
WRITE_BUFFER_MEMORY_WORD PROC NEAR
	call	CS_START
	push	bx
	push	ax ; save AX
	mov		ah,(WBM_OPCODE SHL 5) OR BUFF_MEM_ARG
	call	TXRX_BYTE ; Send initial opcode
	pop		ax ; get back AX
	push	ax ; save for second byte
	xchg	ah,al ; move low byte into AH
	call	TXRX_BYTE ; send low byte
	mov		bl,al
	pop		ax ; ah contains high Byte
	call	TXRX_BYTE ; send high byte byte
	mov		bh,al ; get high byte
	mov		ax,bx ; store in ax
	pop		bx ; recover BX
	call	CS_END
	ret
WRITE_BUFFER_MEMORY_WORD ENDP

; al contains byte
; Assumes autoinc in ECON2 is set
; Assumes EWRPT is pointing to the beginning of TX memory!
WRITE_BUFFER_MEMORY_BYTE PROC NEAR
	call	CS_START
	push	ax ; save AX
	mov		ah,(WBM_OPCODE SHL 5) OR BUFF_MEM_ARG
	call	TXRX_BYTE ; Send initial opcode
	pop		ax ; get back AX
	xchg	ah,al ; move low byte into AH
	call	TXRX_BYTE ; send byte AH
	call	CS_END
	ret
WRITE_BUFFER_MEMORY_BYTE ENDP

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
	;UTIL_PRINT_HEX 2 ; used for debugging
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


;;;;;;;;;;;;;;;;;;;; HIGH LEVEL FUNCTIONS

msg_soft_reset db "SOFT RESET COMPLETE$"
SETUP_CONTROLLER_RESET PROC NEAR
	call	SOFT_RESET
	UTIL_PRINT_STR msg_soft_reset;; Debug API provided by PKT DRIVER!!!
	UTIL_PRINT_NEWLINE			;; Debug API provided by PKT DRIVER!!!
	ret
SETUP_CONTROLLER_RESET ENDP

SETUP_CONTROLLER_BUFFERS PROC NEAR
	push	bx ; save bx
	push	ax; save ax
	mov		ah,BANK0
	call	SET_CONTROLLER_BANK
	
	; 8K Buffer, PCjr transmission will be controlled, so set the transmit
	; buffer to be small and receive buffer to be large
	; Set TX Memory Start High/Low
	mov		ax,(ETXSTH_REGISTER SHL 8) OR ETXSTL_REGISTER
	mov		bx,TX_ADDRESS_START
	call	WRITE_REGISTER_LOW_HIGH
		
	; Set TX End High/Low
	mov		ax,(ETXNDH_REGISTER SHL 8) OR ETXNDL_REGISTER
	mov		bx,TX_ADDRESS_END
	call	WRITE_REGISTER_LOW_HIGH
	
	; Set RX buffer Start High/Low
	mov		ax,(ERXSTH_REGISTER SHL 8) OR ERXSTL_REGISTER
	mov		bx,RX_ADDRESS_START
	call	WRITE_REGISTER_LOW_HIGH
		
	; Set RX Buffer End High/Low
	mov		ax,(ERXNDH_REGISTER SHL 8) OR ERXNDL_REGISTER
	mov		bx,RX_ADDRESS_END
	call	WRITE_REGISTER_LOW_HIGH
	
	; Set Read Memory Pointers
	mov		ax,(ERXRDPTH_REGISTER SHL 8) OR ERXRDPTL_REGISTER
	mov		bx,RX_ADDRESS_START
	call	WRITE_REGISTER_LOW_HIGH
	
	; Restore registers
	pop		ax
	pop		bx
	ret
SETUP_CONTROLLER_BUFFERS ENDP

ETXSTH_msg db "ETXSTH: $"
ETXSTL_msg db "ETXSTL: $"
ETXNDH_msg db "ETXNDH: $"
ETXNDL_msg db "ETXNDL: $"
ERXSTH_msg db "ERXSTH: $"
ERXSTL_msg db "ERXSTL: $"
ERXNDH_msg db "ERXNDH: $"
ERXNDL_msg db "ERXNDL: $"
ERXRDPTH_msg db "ERXRDPTH: $"
ERXRDPTL_msg db "ERXRDPTL: $"
VERIFY_CONTROLLER_BUFFERS PROC NEAR
	push	ax
	mov		ah,BANK0
	call	SET_CONTROLLER_BANK

	; Debug ETXSTH/ETXSTL
	mov		ah,ETXSTH_REGISTER
	call	READ_ETH_REGISTER
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS ETXSTH_msg
	mov		ah,ETXSTL_REGISTER
	call	READ_ETH_REGISTER
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS ETXSTL_msg
	UTIL_PRINT_NEWLINE
	
	; Debug ETXNDH/ETXNDL
	mov		ah,ETXNDH_REGISTER
	call	READ_ETH_REGISTER
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS ETXNDH_msg
	mov		ah,ETXNDL_REGISTER
	call	READ_ETH_REGISTER
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS ETXNDL_msg
	UTIL_PRINT_NEWLINE
	
	; Debug ERXSTH/ERXSTL
	mov		ah,ERXSTH_REGISTER
	call	READ_ETH_REGISTER
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS ERXSTH_msg
	mov		ah,ERXSTL_REGISTER
	call	READ_ETH_REGISTER
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS ERXSTL_msg
	UTIL_PRINT_NEWLINE
	
	; Debug ERXNDH,ERXNDL
	mov		ah,ERXNDH_REGISTER
	call	READ_ETH_REGISTER
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS ERXNDH_msg
	mov		ah,ERXNDL_REGISTER
	call	READ_ETH_REGISTER
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS ERXNDL_msg
	UTIL_PRINT_NEWLINE
	
	; Debug ERXRDPTH/ERXRDPTL
	mov		ah,ERXRDPTH_REGISTER
	call	READ_ETH_REGISTER
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS ERXRDPTH_msg
	mov		ah,ERXRDPTL_REGISTER
	call	READ_ETH_REGISTER
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS ERXRDPTL_msg
	UTIL_PRINT_NEWLINE
	pop		ax
	ret
VERIFY_CONTROLLER_BUFFERS ENDP


SETUP_CONTROLLER_FILTERS PROC NEAR
	push	ax
	mov		ah,BANK1
	call	SET_CONTROLLER_BANK 
	
;ANDOR = 0, OR Packets, Packets will be accepted unless all enabled filters reject the packet
;UCEN = 1, Unicast Filter Enable, Packets with a destination address matching local MAC will be accepted
; - This covers everything aimed at us
;CRCEN = 1, Post-filter CRC Check Enable - All packets with invalid CRC will be discarded
;PMEN = 1, Pattern Match Filter Enable, Patterns which meet the Pattern Match criteria accepted
; - This is to cover broadcast ARP but reject all other broadcast
	mov		ax,(ERXFCON_REGISTER SHL 8) OR (ERXFCON_UCEN_SET OR ERXFCON_CRCEN_SET OR ERXFCON_PMEN_SET)
	;; DEBUGING
	; ANDOR = 0
	;mov		ax,(ERXFCON_REGISTER SHL 8) OR (ERXFCON_CRCEN_SET) ; Check CRC only
	call	WRITE_REGISTER

;TODO - this is from example, figure out what it means
;The pattern to match on is therefore
;Type     ETH.DST
;ARP      BROADCAST
;06 08 -- ff ff ff ff ff ff -> ip checksum for theses bytes=f7f9
;in binary these poitions are:11 0000 0011 1111
;This is hex 303F->EPMM0=0x3f,EPMM1=0x30

	;; DEBUGING - this ends up not being used
	mov		ax,(EPMM0_REGISTER SHL 8) OR 3Fh
	call	WRITE_REGISTER

	mov		ax,(EPMM1_REGISTER SHL 8) OR 30h
	call	WRITE_REGISTER

	mov		ax,(EPMCSH_REGISTER SHL 8) OR 0F7h
	call	WRITE_REGISTER

	mov		ax,(EPMCSL_REGISTER SHL 8) OR 0F9h
	call	WRITE_REGISTER
	pop		ax
	ret
SETUP_CONTROLLER_FILTERS ENDP

ERXFCON_msg db "ERXFCON: $"
EPMM0_msg db "EPMM0: $"
EPMM1_msg db "EPMM1: $"
EPMCSL_msg db "EPMCSL: $"
EPMCSH_msg db "EPMCSH: $"
VERIFY_CONTROLLER_FILTERS PROC NEAR
	push	ax
	mov		ah,BANK1
	call	SET_CONTROLLER_BANK 
	
	; Debug ERXFCON
	mov		ah,ERXFCON_REGISTER
	call	READ_ETH_REGISTER
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS ERXFCON_msg
	UTIL_PRINT_NEWLINE

	; Debug EPMM0/EPPM1
	mov		ah,EPMM0_REGISTER
	call	READ_ETH_REGISTER
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS EPMM0_msg
	mov		ah,EPMM1_REGISTER
	call	READ_ETH_REGISTER
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS EPMM1_msg
	UTIL_PRINT_NEWLINE
	
	; Debug EPMCSH/EPMCSL
	mov		ah,EPMCSH_REGISTER
	call	READ_ETH_REGISTER
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS EPMCSH_msg
	mov		ah,EPMCSL_REGISTER
	call	READ_ETH_REGISTER
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS EPMCSL_msg
	UTIL_PRINT_NEWLINE
	pop		ax
	ret
VERIFY_CONTROLLER_FILTERS ENDP


SETUP_CONTROLLER_MODE PROC NEAR
	; works from any bank
	push	ax
	mov		ax,(ECON2_REGISTER SHL 8) OR ECON2_AUTOINC_MASK ;; This is the default
	call	BIT_FIELD_SET
	pop		ax
	ret
SETUP_CONTROLLER_MODE ENDP

SETUP_CONTROLLER_MAC PROC NEAR
	push	ax
	push	bx
	mov		ah,BANK2
	call	SET_CONTROLLER_BANK 
	
	;1. Set MACON1 to enable MAC (MACON1_MARXEN_SET|MACON1_TXPAUS_UNSET|MACON1_RXPAUS_UNSET),
	;	half-duplex mode
	mov		ax,(MACON1_REGISTER SHL 8) OR MACON1_MARXEN_SET OR MACON1_TXPAUS_UNSET OR MACON1_RXPAUS_UNSET
	call	WRITE_REGISTER
	
	;2. Set MACON3 register (MACON3_PADCFG2_SET|MACON3_PADCFG1_SET|MACON3_PADCFG0_SET|MACON3_TXCRCEN_SET
	;|MACON3_FULDPX_UNSET)
	; Line limits...splitting in two
	MACON_3_OR1 EQU MACON3_PADCFG2_SET OR MACON3_PADCFG1_SET OR MACON3_PADCFG0_SET
	MACON_3_OR2 EQU MACON3_TXCRCEN_SET OR MACON3_FULDPX_UNSET
	mov		ax,(MACON3_REGISTER SHL 8) OR MACON_3_OR1 OR MACON_3_OR2
	call	WRITE_REGISTER
		
	;3.) Set MACON4 (MACON4_DEFER_SET)
	mov		ax,(MACON4_REGISTER SHL 8) OR MACON4_DEFER_SET
	call	WRITE_REGISTER
	
	; 4.) Set MAMXFLL & MAMXFLH
	mov		ax,(MAMXFLH_REGISTER SHL 8) OR MAMXFLL_REGISTER
	mov		bx,MAX_FRAME_LENGTH
	call	WRITE_REGISTER_LOW_HIGH
	
	;5.) Set MABBIPG Back-to-Back inter-packet gap
	mov		ax,(MABBIPG_REGISTER SHL 8) OR B2BINTERPACKETGAP
	call	WRITE_REGISTER

		;6/7.) Configure Non-Back-to-Back Inter-Packet Gap low byte + high byte
	mov		ax,(MAIPGH_REGISTER SHL 8) OR MAIPGL_REGISTER
	mov		bx,NB2BINTERPACKETGAP
	call	WRITE_REGISTER_LOW_HIGH
	
;- Will use default reset values for now
;  Serial.println("8.) Program Retransmission and Collision window registers (MACLCON1 & 2)");
;  Serial.println("Setting MACLCON1 (Retransmission window)");
;  Serial.println("Setting MACLCON2 - Collision window");
;  
	mov		ah,BANK3
	call	SET_CONTROLLER_BANK 
	
	;; Set MAC Address 0-5
	mov		ah,MAADR1_REGISTER
	mov		al,MAC_ADDRESS_TABLE[0] ;; PROVIDED BY PKT_DRIVER!!
	call	WRITE_REGISTER

	mov		ah,MAADR2_REGISTER
	mov		al,MAC_ADDRESS_TABLE[1]
	call	WRITE_REGISTER
	
	mov		ah,MAADR3_REGISTER
	mov		al,MAC_ADDRESS_TABLE[2]
	call	WRITE_REGISTER

	mov		ah,MAADR4_REGISTER
	mov		al,MAC_ADDRESS_TABLE[3]
	call	WRITE_REGISTER

	mov		ah,MAADR5_REGISTER
	mov		al,MAC_ADDRESS_TABLE[4]
	call	WRITE_REGISTER
	
	mov		ah,MAADR6_REGISTER
	mov		al,MAC_ADDRESS_TABLE[5]
	call	WRITE_REGISTER
	pop		bx
	pop		ax
	ret
SETUP_CONTROLLER_MAC ENDP

MACON1_msg db "MACON1: $"
MACON3_msg db "MACON3: $"
MACON4_msg db "MACON4: $"
MAMXFLH_msg db "MAMXFLH: $"
MAMXFLL_msg db "MAMXFLL: $"
MABBIPG_msg db "MABBIPG: $"
MAIPGH_msg db "MAIPGH: $"
MAIPGL_msg db "MAIPGL: $"
MAADR1_msg db "MAADR1: $"
MAADR2_msg db "MAADR2: $"
MAADR3_msg db "MAADR3: $"
MAADR4_msg db "MAADR4: $"
MAADR5_msg db "MAADR5: $"
MAADR6_msg db "MAADR6: $"
VERIFY_CONTROLLER_MAC PROC NEAR
	push	ax
	mov		ah,BANK2
	call	SET_CONTROLLER_BANK 
	; Debug MACON1
	mov		ah,MACON1_REGISTER
	call	READ_MAC_MII_REGISTER ;; MAC/MII
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS MACON1_msg

	; Debug MACON3
	mov		ah,MACON3_REGISTER
	call	READ_MAC_MII_REGISTER ;; MAC/MII
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS MACON3_msg

	; Debug MACON4
	mov		ah,MACON4_REGISTER
	call	READ_MAC_MII_REGISTER ;; MAC/MII
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS MACON4_msg
	UTIL_PRINT_NEWLINE
	
	; Debug MAMXFLH / MAMXFLL
	mov		ah,MAMXFLH_REGISTER
	call	READ_MAC_MII_REGISTER
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS MAMXFLH_msg
	mov		ah,MAMXFLL_REGISTER
	call	READ_MAC_MII_REGISTER
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS MAMXFLL_msg
	UTIL_PRINT_NEWLINE
	
	; Debug MABBIPG
	mov		ah,MABBIPG_REGISTER
	call	READ_MAC_MII_REGISTER ;; MAC/MII
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS MABBIPG_msg

	; Debug MAIPGH/MAIPGL
	mov		ah,MAIPGH_REGISTER
	call	READ_MAC_MII_REGISTER
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS MAIPGH_msg
	mov		ah,MAIPGL_REGISTER
	call	READ_MAC_MII_REGISTER
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS MAIPGL_msg
	UTIL_PRINT_NEWLINE
	
	mov		ah,BANK3
	call	SET_CONTROLLER_BANK 
	; Debug MAADR1
	mov		ah,MAADR1_REGISTER
	call	READ_MAC_MII_REGISTER ;; MAC/MII
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS MAADR1_msg
	; Debug MAADR2
	mov		ah,MAADR2_REGISTER
	call	READ_MAC_MII_REGISTER ;; MAC/MII
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS MAADR2_msg
		; Debug MAADR3
	mov		ah,MAADR3_REGISTER
	call	READ_MAC_MII_REGISTER ;; MAC/MII
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS MAADR3_msg
		; Debug MAADR4
	mov		ah,MAADR4_REGISTER
	call	READ_MAC_MII_REGISTER ;; MAC/MII
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS MAADR4_msg
		; Debug MAADR5
	mov		ah,MAADR5_REGISTER
	call	READ_MAC_MII_REGISTER ;; MAC/MII
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS MAADR5_msg
	; Debug MAADR6
	mov		ah,MAADR6_REGISTER
	call	READ_MAC_MII_REGISTER ;; MAC/MII
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS MAADR6_msg
	UTIL_PRINT_NEWLINE
	pop		ax
	ret
VERIFY_CONTROLLER_MAC ENDP


SETUP_CONTROLLER_PHY PROC NEAR
;; TODO - pick up here, also implement PHY read/write
;; Will probably need to fake some timing loops
; Or maybe not, seems like there's a status bit to check
	push	ax
	push	bx
	;; TODO - Confirm PDXMD is clear - xxxx xxx0 xxxx xxxx???
	mov		ah,PHCON1_REGISTER ; & PHCON1_PDPXMD_EXTRACT
	call	READ_PHY_REGISTER

	;Set PHCON2 HDLDIS to prevent automatic loopback
	mov		ah,PHCON2_REGISTER
	mov		bx,PHCON2_HDLDIS_SET
	call	WRITE_PHY_REGISTER

	;; TODO - add debugging statements
	pop		bx
	pop		ax
	ret
SETUP_CONTROLLER_PHY ENDP

PHCON1_msg db "PHCON1: $"
PHCON2_msg db "PHCON2: $"
VERIFY_CONTROLLER_PHY PROC NEAR
	; Debug - PHCON1 reg
	mov		ah,PHCON1_REGISTER ; & PHCON1_PDPXMD_EXTRACT
	call	READ_PHY_REGISTER
	UTIL_PRINT_WREG_AS PHCON1_msg
	; Debug - PHCON2 reg
	mov		ah,PHCON2_REGISTER ; & PHCON1_PDPXMD_EXTRACT
	call	READ_PHY_REGISTER
	UTIL_PRINT_WREG_AS PHCON2_msg
	UTIL_PRINT_NEWLINE
	ret
VERIFY_CONTROLLER_PHY ENDP

SETUP_CONTROLLER_INT PROC NEAR
	call	TXRX_ENABLE_RX_INT
	call	TXRX_ENABLE_GLOBAL_INT
	ret
SETUP_CONTROLLER_INT ENDP


TXRXH_RESET PROC NEAR
	call	SETUP_CONTROLLER_RESET

	call	SETUP_CONTROLLER_BUFFERS
	;call	VERIFY_CONTROLLER_BUFFERS
	
	call	SETUP_CONTROLLER_FILTERS
	;call	VERIFY_CONTROLLER_FILTERS
	
	;call	SETUP_CONTROLLER_MODE ; Not necessary since ECON2 is already in autoinc
	;call	VERIFY_CONTROLLER_MODE
	
	call	SETUP_CONTROLLER_MAC
	;call	VERIFY_CONTROLLER_MAC
	
	call	SETUP_CONTROLLER_PHY
	;call	VERIFY_CONTROLLER_PHY
	
	call	SETUP_CONTROLLER_INT
	
	call	TXRX_ENABLE_RX ; enable receiving
	ret
TXRXH_RESET ENDP

TXRX_INIT_RD_PT PROC NEAR
	push	ax
	push	bx
	mov		ah,BANK0
	call	SET_CONTROLLER_BANK 
	mov		ax,(ERDPTH_REGISTER SHL 8) OR ERDPTL_REGISTER
	mov		bx,RX_ADDRESS_START
	call	WRITE_REGISTER_LOW_HIGH
	pop		bx
	pop		ax
	ret
TXRX_INIT_RD_PT ENDP

; AX = address
TXRX_SET_WR_PT PROC NEAR

	push	bx ; save bx
	push	ax ; save address
	
	mov		ah,BANK0
	call	SET_CONTROLLER_BANK
	mov		ax,(EWRPTH_REGISTER SHL 8) OR EWRPTL_REGISTER
	pop		bx ; retrieve address
	call	WRITE_REGISTER_LOW_HIGH ; BX is set above
	pop		bx ; restore bx

	ret
TXRX_SET_WR_PT ENDP

; AX = address
TXRX_SET_RD_PT PROC NEAR
	
	push	bx
	push	ax ; save address
	
	mov		ah,BANK0
	call	SET_CONTROLLER_BANK
	mov		ax,(ERDPTH_REGISTER SHL 8) OR ERDPTL_REGISTER
	pop		bx ; retrieve address
	call	WRITE_REGISTER_LOW_HIGH ; BX is set above
	pop		bx
	
	ret
TXRX_SET_RD_PT ENDP

TXRX_CLEAR_RX_FLAG PROC NEAR
	push	ax
	mov		ax,(EIR_REGISTER SHL 8) OR (EIR_PKTIF)
	call	BIT_FIELD_CLEAR
	pop		ax
TXRX_CLEAR_RX_FLAG ENDP

TXRX_DISABLE_RX_INT PROC NEAR
	push	ax
	mov		ax,(EIE_REGISTER SHL 8) OR (EIE_PKTIE)
	call	BIT_FIELD_CLEAR
	pop		ax
TXRX_DISABLE_RX_INT ENDP

TXRX_ENABLE_RX_INT PROC NEAR
	push	ax
	mov		ax,(EIE_REGISTER SHL 8) OR (EIE_PKTIE)
	call	BIT_FIELD_SET
	pop		ax
TXRX_ENABLE_RX_INT ENDP

TXRX_DISABLE_GLOBAL_INT PROC NEAR
	push	ax
	mov		ax,(EIE_REGISTER SHL 8) OR (EIE_INTIE)
	call	BIT_FIELD_CLEAR
	pop		ax
	ret
TXRX_DISABLE_GLOBAL_INT ENDP

TXRX_ENABLE_GLOBAL_INT PROC NEAR
	push	ax
	mov		ax,(EIE_REGISTER SHL 8) OR (EIE_INTIE)
	call	BIT_FIELD_SET
	pop		ax
	ret
TXRX_ENABLE_GLOBAL_INT ENDP

TXRX_ENABLE_RX PROC NEAR
	push	ax
	mov		ax,(ECON1_REGISTER SHL 8) OR (ECON1_RXEN_MASK)
	call	BIT_FIELD_SET
	pop		ax
	ret
TXRX_ENABLE_RX ENDP

TXRX_DISABLE_RX PROC NEAR
	push	ax
	mov		ax,(ECON1_REGISTER SHL 8) OR (ECON1_RXEN_MASK)
	call	BIT_FIELD_CLEAR
	pop		ax
	ret
TXRX_DISABLE_RX ENDP

TXRX_ACK_PKT PROC NEAR
	push	ax
	
	;push	cx;
	; read current pktcnt
	;mov		ah,ECON2_REGISTER
	;call	READ_ETH_REGISTER
	;mov		cl,al ; move value to ah
	;xor		ch,ch ; zero ch
	
;TXRX_ACK_LOOP:
;;	mov		ax,(ECON2_REGISTER SHL 8) OR (ECON2_PKTDEC_MASK)
;;	call	BIT_FIELD_SET
	;loop	TXRX_ACK_LOOP
	
	;pop		cx ; restore CX
	
	
	push	cx;
	; read current pktcnt
	mov		ah,BANK1
	call	SET_CONTROLLER_BANK 
	mov		ah,EPKTCNT_REGISTER
	call	READ_ETH_REGISTER
	mov		cl,al ; move value to ah
	xor		ch,ch ; zero ch
	
TXRX_ACK_LOOP:
	mov		ax,(ECON2_REGISTER SHL 8) OR (ECON2_PKTDEC_MASK)
	call	BIT_FIELD_SET
	loop	TXRX_ACK_LOOP
	
	pop		cx ; restore CX
	
	
	push	bx
	mov		ah,BANK0
	call	SET_CONTROLLER_BANK 
	; Set RX buffer Start High/Low
	mov		ax,(ERXSTH_REGISTER SHL 8) OR ERXSTL_REGISTER
	mov		bx,RX_ADDRESS_START
	call	WRITE_REGISTER_LOW_HIGH
		
	; Set RX Buffer End High/Low
	mov		ax,(ERXNDH_REGISTER SHL 8) OR ERXNDL_REGISTER
	mov		bx,RX_ADDRESS_END
	call	WRITE_REGISTER_LOW_HIGH
	
	; Set Read Memory Pointers
	mov		ax,(ERXRDPTH_REGISTER SHL 8) OR ERXRDPTL_REGISTER
	mov		bx,RX_ADDRESS_START
	call	WRITE_REGISTER_LOW_HIGH
	pop		bx
	
	pop		ax
	ret
TXRX_ACK_PKT ENDP


; DS:SI = packet to Send
; CX = bytes
TXRX_SENDPKT PROC NEAR
	push	ax
	push	bx
	push	cx
	
;	Check if transmit is already in progress, if so set carry and bail
	; Read ECON1 - available in all Banks
	mov		ah,ECON1_REGISTER
	call	READ_ETH_REGISTER ; al = result
	and		al,ECON1_TXRTS_MASK
	jz		TXRX_SENDPKT_TX ; no transmission currently occuring
	stc		; otherwise, throw an error
	jmp		TXRX_SENDPKT_DONE
	
TXRX_SENDPKT_TX:
	
	
	mov		ax,TX_ADDRESS_START
	call	TXRX_SET_WR_PT
	
	;1.) Set BANK for EWRPT ; Controller Write Pointer
	;mov		ah,BANK0
	;call	SET_CONTROLLER_BANK
	
	; 2.) Set EWRPT ; Controller Write Pointer
	;mov		ax,(EWRPTH_REGISTER SHL 8) OR EWRPTL_REGISTER
	;mov		bx,TX_ADDRESS_START
	;call	WRITE_REGISTER_LOW_HIGH
	
	; 3.) Write Ethernet controller packet control byte
	push	ds
	push	ax
	mov		ax,cs
	mov		ds,ax ; set DS for control byte
	mov		bx,offset SEND_CTRL_BYTE
	mov		cx,1
	call	WRITE_BUFFER_MEMORY
	pop		ax
	pop		ds
	
	; 4.) Assume caller setup the whole packet - TODO, verify...
	pop		cx ; set number of bytes
	push	cx ; re-save number of bytes
	mov		bx,si ; move offset to BX
	call	WRITE_BUFFER_MEMORY
	
	; 5.) Set ETXST & ETXND
	mov	ax,(ETXSTH_REGISTER SHL 8) OR ETXSTL_REGISTER
	mov bx,TX_ADDRESS_START
	call	WRITE_REGISTER_LOW_HIGH
	
	mov	ax,(ETXNDH_REGISTER SHL 8) OR ETXNDL_REGISTER
	mov bx,TX_ADDRESS_START
	pop		cx
	push	cx
	add		bx,cx ; the senders bytes
	inc		bx ; the Control Bit
	add		bx,4 ; TEST to see if this fills in CRC
	;add	bx,4+2+6+6+1 ; all the bits
	call	WRITE_REGISTER_LOW_HIGH
	
		; 6.) Transmit by setting ECON1.TXRTS
	mov		ax,(ECON1_REGISTER SHL 8) OR ECON1_TXRTS_MASK
	call	BIT_FIELD_SET
	
	; 7.) Wait until transmit completes
TXRX_SENDPKT_WAIT:
	; Read ECON1
	; Check if TXRTS
	; Loop if not zero
	mov		ah,ECON1_REGISTER
	call	READ_ETH_REGISTER ; al = result
	and		al,ECON1_TXRTS_MASK
	jnz	TXRX_SENDPKT_WAIT
	clc	; clear carry bit since we finished sending
	
TXRX_SENDPKT_DONE:	
	pop		cx
	pop		bx
	pop		ax
	ret
TXRX_SENDPKT ENDP
