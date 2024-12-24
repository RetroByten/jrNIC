
;; PCjr Port Mapping
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
ERXNDH_REGISTER EQU   0Bh ; RX End Low Byte
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
	ERXFCON_UCEN_BIT	EQU 80h
	ERXFCON_CRCEN_BIT	EQU 20h
	ERXFCON_PMEN_BIT	EQU 10h
	ERXFCON_UCEN_SET	EQU 80h ; TODO, remove _SETs
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
;	MICMD_MIIRD_MASK_CLEAR	EQU 0FEh
	MICMD_MIIRD_BIT			EQU 01h
;	MICMD_MIIRD_SET			EQU 01h 
;	MICMD_MIIRD_CLEAR		EQU 00h 
MIREGADR_REGISTER		EQU 14h ;MAC/MII
MIWRL_REGISTER			EQU 16h ;MAC/MII
MIWRH_REGISTER			EQU 17h ;MAC/MII
MIRDL_REGISTER			EQU 18h ;MAC/MII
MIRDH_REGISTER			EQU 19h ;MAC/MII


BANK3						EQU 03h
; Note, the datasheet shows these in this order
MAADR5_REGISTER		EQU 00h ;MAC/MII
MAADR6_REGISTER		EQU 01h ;MAC/MII
MAADR3_REGISTER		EQU 02h ;MAC/MII
MAADR4_REGISTER		EQU 03h ;MAC/MII
MAADR1_REGISTER		EQU 04h ;MAC/MII
MAADR2_REGISTER		EQU 05h ;MAC/MII
MISTAT_REGISTER		EQU 0Ah ;MAC/MII
	MISTAT_BUSY_BIT		EQU 01h
;	MISTAT_BUSY_GET		EQU 01h 
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
	;ECON2_AUTOINC_MASK		EQU 80h
	ECON2_AUTOINC_BIT		EQU 80h
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

;;;;;;;;;;;;;;;;;
; Building Blocks
;;;;;;;;;;;;;;;;;

%OUT Processing jrNICHAL MACROS
;!! MACRO 
;!!		CS_HIGH
;!! Input
;!!		NONE
;!! Output
;!!		DX = eth_write_cs_high
;!! Uses directly
;!!		DX, AL(not affected)
;!! Calls
;!!		NONE
;!! Dependencies destroy
;!!		NONE
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		DX
CS_HIGH MACRO
	mov		dx,eth_write_cs_high	; Set DX
	out		dx,al					; Set ethernet controller CS line high, al is not affected
ENDM

; Destroys DX
;!! MACRO
;!!		CS_LOW
;!! Input
;!!		NONE
;!! Output
;!!		DX = eth_read_write_bit
;!! Uses directly
;!!		DX, AL(not affected)
;!! Calls
;!!		NONE
;!! Dependencies destroy
;!!		NONE
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		DX
CS_LOW MACRO
	mov		dx,eth_write_cs_low		; Set DX
	out		dx,al					; Set ethernet controller CS line low, al is irrelevant
	mov		dx,eth_read_write_bit	; Set DX to prepare for read/write op	
ENDM

;!! MACRO
;!!		CS_START
;!! Input
;!!		NONE
;!! Output
;!!		DX = eth_read_write_bit
;!! Uses directly
;!!		NONE
;!! Calls
;!!		CS_HIGH (destroys DX)
;!!		CS_LOW	(destroys DX)
;!! Dependencies destroy
;!!		DX
;!! Directly preserves
;!!		NONE	
;!! Total destroy
;!!		DX	
CS_START MACRO
	CS_HIGH ; CS_HIGH first to ensure fresh start
	CS_LOW ; CS_LOW to initialize transfer
ENDM

; Destroys DX
;!! MACRO
;!!		CS_END
;!! Input
;!!		NONE
;!! Output
;!!		DX = set to eth_write_cs_high
;!! Uses directly
;!!		NONE
;!! Calls
;!!		CS_HIGH (destroys DX)
;!! Dependencies destroy
;!!		DX
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		DX	
CS_END MACRO
	CS_HIGH ; CS_HIGH first to end transfer
ENDM

;!! MACRO
;!!		TXRX_BIT
;!! Input
;!!		CS_START was called previously
;!!		AH = nxxx xxxx - next bit to transmit
;!!		DX = eth_read_write_bit
;!! Output
;!!		AH = xxxx xxxc - c = current bit received
;!!		AL = nxxx xxxx - (original AH transmit unchanged)
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
TXRX_BIT MACRO
	in		al,dx	; Read low bit of receive
	and		al,1	; Only use low bit, other bits masked to 0
	xchg	ah,al	; Swap AH, AL, AL = transmit now
	out		dx,al	; Send high bit of transmit
ENDM

;!! MACRO
;!!		TXRX_SHIFT
;!! Input
;!!		CS_START was called previously
;!!		AH = xxxx xxxc - c = current bit received
;!!		AL = pnxx xxxx - p = previous transmited bit, n = next transmit bit
;!!		BL = xxxx xxxp - p = previous received bit
;!! Output
;!!		AH = nxxx xxxx - n = next bit to transmit
;!!		BL = xxxx xxpc - c = received bit, p = previous received bit 
;!! Uses directly
;!!		AX, BL, flags
;!! Calls
;!!		NONE
;!! Dependencies destroy
;!!		NONE	
;!! Directly preserves
;!!		NONE	
;!! Total destroy
;!!		AX, BX, flags
TXRX_SHIFT MACRO
	shl		bl,1	; Shift previous received byte left one
	or		bl,ah	; OR current received bit into BL
	shl		al,1	; shift sent byte one over
	;xchg	ah,al	; move transmite byte back to ah for next bit
	mov		ah,al	; move transmite byte back to ah for next bit
ENDM

;!! MACRO
;!!		TXRX_BIT_SHIFT
;!! Input
;!!		CS_START was called previously
;!!		AH = nfxx xxxx - next bit to transmit, future bit to transmit
;!!		BL = xxxx xxxp - p = previous received bit 
;!!		DX = eth_read_write_bit
;!! Output
;!!		AH = fxxx xxxx - f = future bit to transmit
;!!		BL = xxxx xxpc - c = received bit, p = previous received bit 	
;!! Uses directly
;!!		AX, BL, flags
;!! Uses directly
;!!		NONE
;!! Calls
;!!		TXRX_BIT (destroys AX, flags)
;!!		TXRX_SHIFT (destroys AX, BX, flags)
;!! Dependencies destroy
;!!		AX, BX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, BX, flags
TXRX_BIT_SHIFT MACRO
	TXRX_BIT
	TXRX_SHIFT
ENDM

;!! PROC
;!!		TXRX_BYTE
;!! Input
;!!		CS_START was called previously
;!!		AH = byte to transmit
;!!		DX = eth_read_write_bit
;!! Output
;!!		AL = received byte
;!! Uses directly
;!!		AX, BX, flags
;!! Calls
;!!		TXRX_BIT_SHIFT (destroys AX, BX, flags)
;!! Dependencies destroy
;!!		AX, BX, flags
;!! Directly preserves
;!!		BX
;!! Total destroy
;!!		AX, flags
TXRX_BYTE PROC NEAR
	push	bx
	xor		bl,bl ; used to build return value
	; ah = transmit byte
	TXRX_BIT_SHIFT ; 1 ; Unrolled 8 bit tx/rx/shift
	TXRX_BIT_SHIFT
	TXRX_BIT_SHIFT
	TXRX_BIT_SHIFT ; 4
	TXRX_BIT_SHIFT ; 5
	TXRX_BIT_SHIFT
	TXRX_BIT_SHIFT
	TXRX_BIT_SHIFT ; 8
	mov		al,bl ; set up return
	pop		bx
	ret
TXRX_BYTE ENDP

;;;;;;;;;;;;;;;;;
; CORE COMMANDS
;;;;;;;;;;;;;;;;;

;!! PROC
;!!		TXRX_SOFT_RESET
;!! Input
;!!		NONE
;!! Output
;!!		NONE
;!! Uses directly
;!!		AH
;!! Calls
;!!		CS_START (destroys DX)
;!!		TXRX_BYTE (destroys AX, flags)
;!!		CS_END (destroys DX)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, DX, flags
TXRX_SOFT_RESET PROC NEAR
	CS_START	; Sets DX
	or		ah,(SRC_OPCODE SHL 5) OR SRC_ARG ; ah = SRC opcode << 5 | SRC_ARG
	call	TXRX_BYTE ; ignore return, AL = received byte
	CS_END		; Sets DX
	;; TODO - Wait 50 microseconds per datasheet 11.2 (pg60)
	;; TODO - Wait until clock ready
	; while ( (read_eth_register(ESTAT_REGISTER) & ESTAT_CLKRDY_MASK_EXTRACT) != 1);
	ret
TXRX_SOFT_RESET ENDP

;!! PROC
;!!		READ_ETH_REGISTER
;!! Input
;!!		ETH:BANK was set previously
;!!		AH = Register
;!! Output
;!!		AL = value	
;!! Uses directly
;!!		AH
;!! Calls
;!!		CS_START (destroys DX)
;!!		TXRX_BYTE (destroys AX, flags)
;!!		CS_END (destroys DX)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, DX, flags
READ_ETH_REGISTER PROC NEAR
	CS_START	; Sets DX
	or		ah,(RCR_OPCODE SHL 5) ; ah = RCR opcode << 5 | reg (ah)
	call	TXRX_BYTE ; Send the opcode+reg byte, al returned is dummy
	call	TXRX_BYTE ; Send gibberish, Receive byte, al
	CS_END		; Sets DX
	ret
READ_ETH_REGISTER ENDP

;!! PROC
;!!		WRITE_REGISTER
;!! Input
;!!		ETH:BANK was set previously
;!!		AH = register
;!!		AL = value
;!! Output
;!!		NONE
;!! Uses directly
;!!		AX
;!! Calls
;!!		CS_START (destroys DX)
;!!		TXRX_BYTE (destroys AX, flags)
;!!		CS_END (destroys DX)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, DX, flags
WRITE_REGISTER PROC NEAR
	CS_START	; Sets DX
	push	ax ; Store AL value
	or		ah,(WCR_OPCODE SHL 5) ; ah = WCR opcode << 5 | reg (ah)
	call	TXRX_BYTE ; Send opcode + reg byte, al returned is dummy
	pop		ax ; value = al
	mov		ah,al ; move value to AH
	call	TXRX_BYTE ; Send AH value, al returned is dummy
	CS_END		; Sets DX
	ret
WRITE_REGISTER ENDP

;!! PROC
;!!		BIT_FIELD_SET
;!! Input
;!!		ETH:BANK was set previously
;!!		AH = register
;!!		AL = value
;!! Output
;!!		NONE
;!! Uses directly
;!!		AX
;!! Calls
;!!		CS_START (destroys DX)
;!!		TXRX_BYTE (destroys AX, flags)
;!!		CS_END (destroys DX)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, DX, flags
BIT_FIELD_SET PROC NEAR
	CS_START	; Sets DX
	push	ax ; Store AL value
	or		ah,(BFS_OPCODE SHL 5) ; ah = BFS opcode << 5 | reg (ah)
	call	TXRX_BYTE ; Send opcode + reg byte, al returned is dummy
	pop		ax ; value = al
	mov		ah,al ; move value to AH
	call	TXRX_BYTE ; Send AH value, al returned is dummy
	CS_END		; Sets DX
	ret
BIT_FIELD_SET ENDP

;!! PROC
;!!		BIT_FIELD_CLEAR
;!! Input
;!!		ETH:BANK was set previously
;!!		AH = register
;!!		AL = value
;!! Output
;!!		NONE
;!! Uses directly
;!!		AX
;!! Calls
;!!		CS_START (destroys DX)
;!!		TXRX_BYTE (destroys AX, flags)
;!!		CS_END (destroys DX)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, DX, flags
BIT_FIELD_CLEAR PROC NEAR
	CS_START	; Sets DX
	push	ax ; store AL value
	or		ah,(BFC_OPCODE SHL 5) ; ah = BFC opcode << 5 | reg (ah)
	call	TXRX_BYTE  ; Send opcode + reg byte, al returned is dummy
	pop		ax ; value = al
	mov		ah,al ; move value to AH
	call	TXRX_BYTE ; Send AH value, al returned is dummy
	CS_END		; Sets DX
	ret
BIT_FIELD_CLEAR ENDP

;!! PROC
;!!		READ_BUFFER_MEMORY_BYTE
;!! Input
;!!		ERDPT is set to start address
;!!		ECON2:AUTOINC is set (is by default)
;!! Output
;!!		AL = byte from memory(ERDPT)
;!! Uses directly
;!!		AX
;!! Calls
;!!		CS_START (destroys DX)
;!!		TXRX_BYTE (destroys AX, flags)
;!!		CS_END (destroys DX)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, DX, flags
READ_BUFFER_MEMORY_BYTE PROC NEAR
	CS_START	; Sets DX
	mov		ah,(RBM_OPCODE SHL 5) OR BUFF_MEM_ARG
	call	TXRX_BYTE  ; Send opcode + reg byte, al returned is dummy
	call	TXRX_BYTE ; read next byte into al
	CS_END		; Sets DX
	ret
READ_BUFFER_MEMORY_BYTE ENDP

;!! PROC
;!!		WRITE_BUFFER_MEMORY_BYTE
;!! Input
;!!		AL = byte to write
;!!		EWRPT is pointing at TX memory
;!!		ECON2:AUTOINC is set (is by default)
;!! Output
;!!		NONE (writes to card buffer memory)
;!! Uses directly
;!!		AX
;!! Calls
;!!		CS_START (destroys DX)
;!!		TXRX_BYTE (destroys AX, flags)
;!!		CS_END (destroys DX)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, DX, flags
WRITE_BUFFER_MEMORY_BYTE PROC NEAR
	CS_START	; Sets DX
	push	ax ; save AX
	mov		ah,(WBM_OPCODE SHL 5) OR BUFF_MEM_ARG
	call	TXRX_BYTE ; Send initial opcode
	pop		ax ; value = al
	mov		ah,al ; move value to AH
	call	TXRX_BYTE ; Send AH value, al returned is dummy
	CS_END		; Sets DX
	ret
WRITE_BUFFER_MEMORY_BYTE ENDP

;!! PROC
;!!		READ_BUFFER_MEMORY_WORD
;!! Input
;!!		ERDPT is set to start address
;!!		ECON2:AUTOINC is set (is by default)
;!! Output
;!!		AX = WORD from memory(ERDPT)
;!! Uses directly
;!!		AX, BX
;!! Calls
;!!		CS_START (destroys DX)
;!!		TXRX_BYTE (destroys AX, flags)
;!!		CS_END (destroys DX)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		BX
;!! Total destroy
;!!		AX, DX, flags
READ_BUFFER_MEMORY_WORD PROC NEAR
	CS_START
	push	bx
	mov		ah,(RBM_OPCODE SHL 5) OR BUFF_MEM_ARG
	call	TXRX_BYTE ; send initial opcode
	call	TXRX_BYTE ; read next byte into al
	mov		bl,al ; save low byte
	call	TXRX_BYTE ; read next byte into al
	mov		bh,al ; save high byte
	mov		ax,bx ; save result
	pop		bx
	CS_END
	ret ; return ax
READ_BUFFER_MEMORY_WORD ENDP

;!! PROC
;!!		WRITE_BUFFER_MEMORY_WORD
;!! Input
;!!		AX = word to write
;!!		EWRPT is pointing at TX memory
;!!		ECON2:AUTOINC is set (is by default)
;!! Output
;!!		NONE (writes to card buffer memory)
;!! Uses directly
;!!		AX
;!! Calls
;!!		CS_START (destroys DX)
;!!		TXRX_BYTE (destroys AX, flags)
;!!		CS_END (destroys DX)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, DX, flags
WRITE_BUFFER_MEMORY_WORD PROC NEAR
	CS_START
	;push	bx
	push	ax ; save AX
	mov		ah,(WBM_OPCODE SHL 5) OR BUFF_MEM_ARG
	call	TXRX_BYTE ; Send initial opcode
	pop		ax ; get back AX
	push	ax ; save for second byte
	mov		ah,al ; move low byte into AH
	call	TXRX_BYTE ; send low byte
	pop		ax ; ah contains high Byte
	call	TXRX_BYTE ; send high byte byte
	CS_END
	ret
WRITE_BUFFER_MEMORY_WORD ENDP

;!! PROC
;!!		READ_BUFFER_MEMORY
;!! Input
;!!		ES = PCjr memory segment to store data
;!!		DI = offset to store data
;!!		CX = number of bytes to read (>0)
;!!		ERDPT is set to start address
;!!		ECON2:AUTOINC is set (is by default)
;!! Output
;!!		Fills ES:DI
;!! Uses directly
;!!		ES, DI, AX, CX, flags
;!! Calls
;!!		CS_START (destroys DX)
;!!		TXRX_BYTE (destroys AX, flags)
;!!		CS_END (destroys DX)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		ES
;!! Total destroy
;!!		DI, AX, CX, DX, flags
READ_BUFFER_MEMORY PROC NEAR
	CS_START	; Sets DX
	mov		ah,(RBM_OPCODE SHL 5) OR BUFF_MEM_ARG
	call	TXRX_BYTE ; Send initial opcode
RBM_LOOP:
	; get next byte
	call	TXRX_BYTE ; stored in al
	stosb	; save byte, inc di
	loop	RBM_LOOP ; dec CX
	CS_END		; Sets DX
	ret
READ_BUFFER_MEMORY ENDP

; DS:SI PCjr Memory Pointer
; CX number of bytes to write, must be at least 1
; uses AX
; Assumes EWRPT is pointer is set
;!!		ECON2:AUTOINC is set (is by default)

;!! PROC
;!!		READ_BUFFER_MEMORY
;!! Input
;!!		DS = PCjr memory segment for data source
;!!		DI = offset for data
;!!		CX = number of bytes to read (>0)
;!!		EWRPT is pointing at TX memory
;!!		ECON2:AUTOINC is set (is by default)
;!! Output
;!!		NONE (writes to card buffer memory)
;!! Uses directly
;!!		DS, SI, AX, CX, flags
;!! Calls
;!!		CS_START (destroys DX)
;!!		TXRX_BYTE (destroys AX, flags)
;!!		CS_END (destroys DX)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		DS
;!! Total destroy
;!!		SI, AX, CX, DX, flags
WRITE_BUFFER_MEMORY PROC NEAR
	CS_START	; Sets DX
	mov		ah,(WBM_OPCODE SHL 5) OR BUFF_MEM_ARG
	call	TXRX_BYTE ; Send initial opcode
WBM_LOOP:
	; get next byte
	lodsb	; write byte to ds:[si], inc si
	mov		ah,al ; move over to ah for transmit
	call	TXRX_BYTE ; stored in al
	loop	WBM_LOOP ; dec CX
	CS_END		; Sets DX
	ret
WRITE_BUFFER_MEMORY ENDP


;;;;;;;;;;;;;;;;;
; COMPOUND COMMANDS
;;;;;;;;;;;;;;;;;

;!! PROC
;!!		READ_MAC_MII_REGISTER
;!! Input
;!!		AH = Register
;!! Output
;!!		AL = Value
;!! Uses directly
;!!		AH
;!! Calls
;!!		CS_START (destroys DX)
;!!		TXRX_BYTE (destroys AX, flags)
;!!		CS_END (destroys DX)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, DX, flags
READ_MAC_MII_REGISTER PROC NEAR
	CS_START
	or		ah,(RCR_OPCODE SHL 5) ; ah = rcr_opcode << 5 | reg (ah)
	call	TXRX_BYTE ; Send the opcode+reg byte, al returned is dummy
	call	TXRX_BYTE ; send dummy byte, this returned al byte is also a dummy for MAC/MII
	call	TXRX_BYTE ; send dummy byte, returned al is actual byte
	CS_END
	ret
READ_MAC_MII_REGISTER ENDP

;!! PROC
;!!		READ_PHY_REGISTER
;!! Input
;!!		AH = PHY Register
;!! Output
;!!		AX = Value
;!! Uses directly
;!!		AX, BX, flags
;!! Calls
;!!		GET_CONTROLLER_BANK (destroys AX, DX, flags)
;!!		SET_CONTROLLER_BANK (destroys AX, DX, flags, ETH:BANK)
;!!		WRITE_REGISTER (destroys AX, DX, flags)
;!!		BIT_FIELD_SET (destroys AX, DX, flags)
;!!		READ_MAC_MII_REGISTER (destroys AX, DX, flags)
;!! Dependencies destroy
;!!		AX, DX, flags, ETH:BANK
;!! Directly preserves
;!!		BX, ETH:BANK
;!! Total destroy
;!!		AX, DX, flags
READ_PHY_REGISTER PROC NEAR
	; Datasheet 3.3
	
	; 1.) Write the address of the PHY register into MIREGADR_REGISTER (BANK2)
	; 2.) Set MICMD.MIIRD bit (BANK2)
	; 3.) Poll MISTAT.BUSY until clear (BANK3)
	; 4.) Clear MICMD.MIIRD bit (BANK2)
	; 5.) Read the desired data from MIRDL and MIRDH (BANK2)
	
	push	bx ; Preserve BX
	push	ax ; save ah (input register) while swapping bank
	
	; 0.) Save current bank
	; Get current bank
	call	GET_CONTROLLER_BANK
	mov		bh,al ; BH contains original bank
	
	; Set BANK2
	mov		ah,BANK2
	call	SET_CONTROLLER_BANK
	
	; Get back AX (ah = input register)
	pop		ax
	
	; Save current bank
	push	bx

	; 1.) Write address of PHY register into MIREGADR_REGISTER (BANK2)
	mov		al,ah ; set value to PHY register
	mov		ah,MIREGADR_REGISTER
	call	WRITE_REGISTER
	
	; 2.) Set MICMD.MIIRD bit MICMD_MIIRD_BIT (BANK2)
	mov		ax,(MICMD_REGISTER SHL 8) OR MICMD_MIIRD_BIT
	call	BIT_FIELD_SET

	; 3.) Poll MISTAT.BUSY until clear (BANK3)
	; Set BANK 3
	mov		ah,BANK3
	call	SET_CONTROLLER_BANK
	; Poll MISTAT.BUSY
READ_PHY_REGISTER_BUSY:
	mov		ah,MISTAT_REGISTER
	call	READ_MAC_MII_REGISTER 
	test	al,MISTAT_BUSY_BIT
	jnz		READ_PHY_REGISTER_BUSY

	; 4.) Clear MICMD.MIIRD bit (BANK2)
	; Set BANK 2
	mov		ah,BANK2
	call	SET_CONTROLLER_BANK
	; Clear MICMD.MIIRD
	mov		ah,MICMD_REGISTER
	mov		al,MICMD_MIIRD_BIT
	call	BIT_FIELD_CLEAR
	
	; 5.) Read the desired data from MIRDL and MIRDH (BANK2)
	mov		ah,MIRDL_REGISTER
	call	READ_MAC_MII_REGISTER
	mov		bl,al ; store in bl, BX contains value
	mov		ah,MIRDH_REGISTER
	call	READ_MAC_MII_REGISTER
	mov		bh,al ; store in bh
		
	; 6.) Restore current bank
	pop		ax ; Get back current bank
	call	SET_CONTROLLER_BANK
	
	mov		ax,bx ; Set AX to return value

	pop		bx ; Restore BX
	ret
READ_PHY_REGISTER ENDP

;!! PROC
;!!		READ_PHY_REGISTER
;!! Input
;!!		AH = PHY Register
;!!		BX = Value
;!! Output
;!!		NONE
;!! Uses directly
;!!		AX, BX, flags
;!! Calls
;!!		GET_CONTROLLER_BANK (destroys AX, DX, flags)
;!!		SET_CONTROLLER_BANK (destroys AX, DX, flags, ETH:BANK)
;!!		WRITE_REGISTER (destroys AX, DX, flags)
;!!		BIT_FIELD_SET (destroys AX, DX, flags)
;!!		READ_MAC_MII_REGISTER (destroys AX, DX, flags)
;!! Dependencies destroy
;!!		AX, DX, flags, ETH:BANK
;!! Directly preserves
;!!		ETH:BANK
;!! Total destroy
;!!		AX, BX, DX, flags
WRITE_PHY_REGISTER PROC NEAR ; Compound operation
	; Datasheet 3.3
	
	;1.) Write address of PHY Register to MIREGADR (BANK2)
	;2.) Write lower byte to MIWRL_REGISTER (BANK2)
	;3.) Write upper byte to MIWRH (BANK2)
	;4.) Poll MISTAT.BUSY (BANK3) 

	push	bx ; preserve value
	push	ax ; preserve PHY register

	; Get controller bank
	call	GET_CONTROLLER_BANK
	mov		bh,al ; BH = current bank
	
	; Set BANK2
	mov		ah,BANK2
	call	SET_CONTROLLER_BANK
	
	;1.) Write address of PHY Register to MIREGADR (BANK2)
	pop		ax 	; Restore PHY register (AH)
	mov		al,ah ; set AL to PHY register
	mov		ah,MIREGADR_REGISTER
	call	WRITE_REGISTER

	;2.) Write lower byte to MIWRL_REGISTER (BANK2)
	pop		ax ; Restore Value (old BX)
	push	bx ; Preserve previous bank
	push	ax ; Preserve Value (high byte)
	mov		ah,MIWRL_REGISTER ; al holds Value (low byte)
	call	WRITE_REGISTER
	
	;3.) Write upper byte to MIWRH_REGISTER (BANK2)
	pop		ax ; Restore Value (high byte)
	mov		al,ah ; move high byte to al
	mov		ah,MIWRH_REGISTER
	call	WRITE_REGISTER
	
	;4.) Poll MISTAT.BUSY (BANK3) 
	; Set Bank 3
	mov		ah,BANK3
	call	SET_CONTROLLER_BANK
	
	; poll
	; Poll MISTAT.BUSY
WRITE_PHY_REGISTER_BUSY:
	mov		ah,MISTAT_REGISTER
	call	READ_MAC_MII_REGISTER 
	test	al,MISTAT_BUSY_BIT
	jnz		WRITE_PHY_REGISTER_BUSY

	; Restore Bank
	pop		ax ; Restore AH = original BANK
	call	SET_CONTROLLER_BANK

	ret
WRITE_PHY_REGISTER ENDP

;!! PROC
;!!		WRITE_REGISTER_LOW_HIGH
;!! Input
;!!		ETH:BANK was set previously
;!!		AX = REG_HIGH, REG_LOW
;!!		BX = VAL_HIGH, VAL_LOW
;!! Output
;!!		NONE
;!! Uses directly
;!!		AX, BX, flags
;!! Calls
;!!		WRITE_REGISTER (destroys AX, DX, flags)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, BX, DX, flags
WRITE_REGISTER_LOW_HIGH PROC NEAR
	xchg	al,bh	; AX = REG_HIGH, VAL_HIGH
					; BX = REG_LOW, VAL_LOW
	push	ax ; Save high WRITE_REGISTER+VAL
	mov		ax,bx
	call	WRITE_REGISTER ; Write REG_LOW, VAL_LOW
	pop		ax ; Restore high WRITE_REGISTER+VAL
	call	WRITE_REGISTER ; Write REG_HIGH, VAL_HIGH
	ret
WRITE_REGISTER_LOW_HIGH ENDP

;!! PROC
;!!		READ_ETH_REGISTER_LOW_HIGH
;!! Input
;!!		ETH:BANK was set previously
;!!		AX = REG_HIGH, REG_LOW
;!! Output
;!!		AX = VAL_HIGH, VAL_LOW
;!! Uses directly
;!!		AX, BX, flags
;!! Calls
;!!		READ_ETH_REGISTER (destroys AX, DX, flags)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		BX
;!! Total destroy
;!!		AX, DX, flags
READ_ETH_REGISTER_LOW_HIGH PROC NEAR
	push	bx
	push	ax ; save low register
	call	READ_ETH_REGISTER ; returns AL = VAL_HIGH
	mov		bh,al ; save high value
	pop		ax ; get low register
	mov		ah,al ; set low register
	call	READ_ETH_REGISTER ; returns AL = VAL_LOW
	mov		ah,bh ; get high value back
	pop		bx
	ret
READ_ETH_REGISTER_LOW_HIGH ENDP

;!! PROC
;!!		TXRX_CLEAR_MEMORY
;!! Input
;!!		NONE
;!! Output
;!!		NONE (clears card memory)
;!! Uses directly
;!!		AX, CX
;!! Calls
;!!		SET_EWRPT (destroys AX, DX, flags, ETH:BANK)
;!!		WRITE_BUFFER_MEMORY_BYTE (destroys AX, DX, flags)
;!! Dependencies destroy
;!!		AX, DX, flags, ETH:BANK
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, CX, DX, SI, flags, ETH:BANK
TXRX_CLEAR_MEMORY PROC NEAR
	mov		cx,RX_ADDRESS_END ; End of memory
	xor		ax,ax ; Beginning of memory
	call	SET_EWRPT ; Set write pointer to beginning of memory
TXRX_CLEAR_MEMORY_LOOP:
	xor		al,al ; Write 0 to every byte
	call	WRITE_BUFFER_MEMORY_BYTE
	loop	TXRX_CLEAR_MEMORY_LOOP
	ret
TXRX_CLEAR_MEMORY ENDP

;;;;;;;;;;;;;;;;;
; HAL_UTIL
;;;;;;;;;;;;;;;;;

;!! PROC
;!!		SET_CONTROLLER_BANK
;!! Input
;!!		CURRENT_BANK = ANY
;!!		AH = BANK (0-3)
;!! Output
;!!		NONE
;!! Uses directly
;!!		AX, BX
;!!		ETH: BANK
;!! Calls
;!!		READ_ETH_REGISTER (destroys AX, DX, flags)
;!!		WRITE_REGISTER (destroys AX, DX, flags)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		BX
;!! Total destroy
;!!		AX, DX, flags
;!!		ETH: BANK
SET_CONTROLLER_BANK PROC NEAR
	push	bx ; will use BX as temp
	push	ax ; Save ah (bank)
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

; Returns AL = Bank Value, Destroys AH
;!! PROC
;!!		GET_CONTROLLER_BANK
;!! Input
;!!		CURRENT_BANK = ANY
;!! Output
;!!		AL = Bank value (0-3)
;!! Uses directly
;!!		AX
;!! Calls
;!!		READ_ETH_REGISTER (destroys AX, DX, flags)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, DX, flags
GET_CONTROLLER_BANK PROC NEAR
	mov		ah,ECON1_REGISTER
	call	READ_ETH_REGISTER ; Returns AL = ECON1
	and		al,BANK_MASK ; Select BANK bits
	ret
GET_CONTROLLER_BANK ENDP

;!! PROC
;!!		SET_ERDPT
;!! Input
;!!		AX = VAL_HIGH, VAL_LOW
;!! Output
;!!		NONE
;!! Uses directly
;!!		AX, BX, flags
;!! Calls
;!!		SET_CONTROLLER_BANK (destroys AX, DX, flags, ETH:BANK)
;!!		WRITE_REGISTER_LOW_HIGH (destroys AX, BX, DX, flags)
;!! Dependencies destroy
;!!		AX, BX, DX, flags, ETH: BANK
;!! Directly preserves
;!!		BX
;!! Total destroy
;!!		AX, DX, flags, ETH:BANK	
SET_ERDPT PROC NEAR
	push	bx
	push	ax
	mov		ah,BANK0
	call	SET_CONTROLLER_BANK
	pop		bx ; get old AX value
	mov		ax,(ERDPTH_REGISTER SHL 8) OR ERDPTL_REGISTER
	call	WRITE_REGISTER_LOW_HIGH
	pop		bx
	ret
SET_ERDPT ENDP

;!! PROC
;!!		SET_EWRPT
;!! Input
;!!		AX = VAL_HIGH, VAL_LOW
;!! Output
;!!		NONE
;!! Uses directly
;!!		AX, BX, flags
;!! Calls
;!!		SET_CONTROLLER_BANK (destroys AX, DX, flags, ETH:BANK)
;!!		WRITE_REGISTER_LOW_HIGH (destroys AX, BX, DX, flags)
;!! Dependencies destroy
;!!		AX, BX, DX, flags, ETH: BANK
;!! Directly preserves
;!!		BX
;!! Total destroy
;!!		AX, DX, flags, ETH:BANK	
SET_EWRPT PROC NEAR
	push	bx
	push	ax
	mov		ah,BANK0
	call	SET_CONTROLLER_BANK
	pop		bx ; get old AX value
	mov		ax,(EWRPTH_REGISTER SHL 8) OR EWRPTL_REGISTER
	call	WRITE_REGISTER_LOW_HIGH
	pop		bx
	ret
SET_EWRPT ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; TODO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;
; Setup Functions
;;;;;;;;;;;;;;;;;

;!! PROC
;!!		SETUP_CONTROLLER_BUFFERS
;!! Input
;!!		NONE
;!! Output
;!!		NONE (sets up the controller memory buffer pointers)
;!! Uses directly
;!!		AX, BX, flags
;!! Calls
;!!		SET_CONTROLLER_BANK (destroys AX, DX, flags, ETH:BANK)
;!!		WRITE_REGISTER_LOW_HIGH (destroys AX, BX, DX, flags)
;!! Dependencies destroy
;!!		AX, BX, DX, flags, ETH:BANK
;!! Directly preserves
;!!		BX
;!! Total destroy
;!!		AX, DX, flags, ETH:BANK
SETUP_CONTROLLER_BUFFERS PROC NEAR
	push	bx ; Preserve BX
	;; Initialize Eth TX Start Memory Pointers to TX_ADDRESS_START
	;	ETXSTH_REGISTER,ETXSTL_REGISTER  (BANK0)
	;	TX_ADDRESS_START (0100h)
	mov		ah,BANK0
	call	SET_CONTROLLER_BANK
	mov		ax,(ETXSTH_REGISTER SHL 8) OR ETXSTL_REGISTER
	mov		bx,TX_ADDRESS_START
	call	WRITE_REGISTER_LOW_HIGH

	;; Initialize Eth TX End Memory Pointers to TX_ADDRESS_END	
	;	ETXNDH_REGISTER,ETXNDL_REGISTER (BANK0)
	;	TX_ADDRESS_END (06FFh)
	mov		ah,BANK0
	call	SET_CONTROLLER_BANK
	mov		ax,(ETXNDH_REGISTER SHL 8) OR ETXNDL_REGISTER
	mov		bx,TX_ADDRESS_END
	call	WRITE_REGISTER_LOW_HIGH
	
	;; Initialize Eth RX Start Memory Pointers to RX_ADDRESS_START	
	;	ERXNDH_REGISTER,ERXNDL_REGISTER (BANK0)
	;	RX_ADDRESS_START (0700h)
	mov		ah,BANK0
	call	SET_CONTROLLER_BANK
	mov		ax,(ERXSTH_REGISTER SHL 8) OR ERXSTL_REGISTER
	mov		bx,RX_ADDRESS_START
	call	WRITE_REGISTER_LOW_HIGH
	
	;; Initialize Eth RX END Memory Pointers to RX_ADDRESS_END	
	;	ERXNDH_REGISTER,ERXNDL_REGISTER (BANK0)
	;	RX_ADDRESS_START (0700h)
	mov		ah,BANK0
	call	SET_CONTROLLER_BANK
	mov		ax,(ERXNDH_REGISTER SHL 8) OR ERXNDL_REGISTER
	mov		bx,RX_ADDRESS_END
	call	WRITE_REGISTER_LOW_HIGH

	;; Initialize Eth RX Read Pointer to beginning of read memory
	;	ERXRDPTH_REGISTER, ERXRDPTL_REGISTER (BANK 0)
	;	RX_ADDRESS_START (0700h)
	mov		ah,BANK0
	call	SET_CONTROLLER_BANK
	mov		ax,(ERXRDPTH_REGISTER SHL 8) OR ERXRDPTL_REGISTER
	mov		bx,RX_ADDRESS_START
	call	WRITE_REGISTER_LOW_HIGH
	
	pop		bx
	ret
SETUP_CONTROLLER_BUFFERS ENDP

VERIFY_CONTROLLER_BUFFERS PROC NEAR
IF	DEBUG_VERIFY_BUFFER
	jmp		VERIFY_CONTROLLER_BUFFERS_T
	debug_str_ETXST db "ETXST$" ; BANK0
	debug_str_ETXND db "ETXND$" ; BANK0
	debug_str_ERXST db "ERXST$" ; BANK0
	debug_str_ERXND db "ERXND$" ; BANK0
	debug_str_ERXRDPT db "ERXRDPT$" ; BANK0
VERIFY_CONTROLLER_BUFFERS_T:
	mov		ah,BANK0
	call	SET_CONTROLLER_BANK
	mov		ax,(ETXSTH_REGISTER SHL 8) OR ETXSTL_REGISTER
	call	READ_ETH_REGISTER_LOW_HIGH
	UTILM_PRINT_WREG debug_str_ETXST,ax
	UTILM_PRINT_NEWLINE
	
	mov		ah,BANK0
	call	SET_CONTROLLER_BANK
	mov		ax,(ETXNDH_REGISTER SHL 8) OR ETXNDL_REGISTER
	call	READ_ETH_REGISTER_LOW_HIGH
	UTILM_PRINT_WREG debug_str_ETXND,ax
	UTILM_PRINT_NEWLINE
	
	mov		ah,BANK0
	call	SET_CONTROLLER_BANK
	mov		ax,(ERXSTH_REGISTER SHL 8) OR ERXSTL_REGISTER
	call	READ_ETH_REGISTER_LOW_HIGH
	UTILM_PRINT_WREG debug_str_ERXST,ax
	UTILM_PRINT_NEWLINE
	
	mov		ah,BANK0
	call	SET_CONTROLLER_BANK
	mov		ax,(ERXNDH_REGISTER SHL 8) OR ERXNDL_REGISTER
	call	READ_ETH_REGISTER_LOW_HIGH
	UTILM_PRINT_WREG debug_str_ERXND,ax
	UTILM_PRINT_NEWLINE
	
	mov		ah,BANK0
	call	SET_CONTROLLER_BANK
	mov		ax,(ERXRDPTH_REGISTER SHL 8) OR ERXRDPTL_REGISTER
	call	READ_ETH_REGISTER_LOW_HIGH
	UTILM_PRINT_WREG debug_str_ERXRDPT,ax
	UTILM_PRINT_NEWLINE
ENDIF
	ret
VERIFY_CONTROLLER_BUFFERS ENDP

;!! PROC
;!!		SETUP_CONTROLLER_FILTERS
;!! Input
;!!		NONE
;!! Output
;!!		NONE (sets up the controller memory buffer pointers)
;!! Uses directly
;!!		AX, BX, flags
;!! Calls
;!!		SET_CONTROLLER_BANK (destroys AX, DX, flags, ETH:BANK)
;!!		WRITE_REGISTER (destroys AX, DX, flags)
;!!		WRITE_REGISTER_LOW_HIGH (destroys AX, BX, DX, flags)
;!! Dependencies destroy
;!!		AX, BX, DX, flags, ETH:BANK
;!! Directly preserves
;!!		BX
;!! Total destroy
;!!		AX, DX, flags, ETH:BANK
SETUP_CONTROLLER_FILTERS PROC NEAR
	push	bx ; preserve BX
	;; Initialize Eth Receive Filter Configuration Register
	;	ERXFCON_REGISTER (BANK1)
	;ANDOR = 0, OR Packets, Packets will be accepted unless all enabled filters reject the packet
	;UCEN = 1, Unicast Filter Enable, Packets with a destination address matching local MAC will be accepted
	; - This covers everything aimed at us
	;CRCEN = 1, Post-filter CRC Check Enable - All packets with invalid CRC will be discarded
	;PMEN = 1, Pattern Match Filter Enable, Patterns which meet the Pattern Match criteria accepted
	; - This is to cover broadcast ARP but reject all other broadcast
	mov		ah,BANK1
	call	SET_CONTROLLER_BANK
	mov		ax,(ERXFCON_REGISTER SHL 8) OR (ERXFCON_UCEN_SET OR ERXFCON_CRCEN_SET OR ERXFCON_PMEN_SET)
	call	WRITE_REGISTER
	
	;; Initialize packet filters
	;TODO - this is from example, figure out what it means
	;The pattern to match on is therefore
	;Type     ETH.DST
	;ARP      BROADCAST
	;06 08 -- ff ff ff ff ff ff -> ip checksum for theses bytes=f7f9
	;in binary these poitions are:11 0000 0011 1111
	;This is hex 303F->EPMM0=0x3f,EPMM1=0x30
	
	;; Patter Match Mask Byte 0
	mov		ah,BANK1
	call	SET_CONTROLLER_BANK
	mov		ax,(EPMM0_REGISTER SHL 8) OR 3Fh
	call	WRITE_REGISTER

	;; Patter Match Mask Byte 1
	mov		ah,BANK1
	call	SET_CONTROLLER_BANK
	mov		ax,(EPMM1_REGISTER SHL 8) OR 30h
	call	WRITE_REGISTER

	;; Pattern match checksum
	;mov		ax,(EPMCSH_REGISTER SHL 8) OR 0F7h
	;call	WRITE_REGISTER
	;mov		ax,(EPMCSL_REGISTER SHL 8) OR 0F9h
	;call	WRITE_REGISTER
	mov		ah,BANK1
	call	SET_CONTROLLER_BANK
	mov		ax,(EPMCSH_REGISTER SHL 8) OR EPMCSL_REGISTER
	mov		bx,(0F7h SHL 8) OR 0F9h
	call	WRITE_REGISTER_LOW_HIGH
	
	pop		bx
	ret		
SETUP_CONTROLLER_FILTERS ENDP

VERIFY_CONTROLLER_FILTERS PROC NEAR
IF DEBUG_VERIFY_FILTER
	jmp		VERIFY_CONTROLLER_FILTERS_T
	debug_str_ERXFCON db "ERXFCON$" ; BANK1
	debug_str_EPMM0 db "EPMM0$" ; BANK1
	debug_str_EPMM1 db "EPMM1$" ; BANK1
	debug_str_EPMCS db "EPMCS$"	; BANK1
VERIFY_CONTROLLER_FILTERS_T:
	mov		ah,BANK1
	call	SET_CONTROLLER_BANK
	mov		ah,ERXFCON_REGISTER
	call	READ_ETH_REGISTER
	mov		ah,al
	UTILM_PRINT_BREG debug_str_ERXFCON,ax
	UTILM_PRINT_NEWLINE	

	mov		ah,BANK1
	call	SET_CONTROLLER_BANK
	mov		ah,EPMM0_REGISTER
	call	READ_ETH_REGISTER
	mov		ah,al
	UTILM_PRINT_BREG debug_str_EPMM0,ax
	UTILM_PRINT_NEWLINE
	
	mov		ah,BANK1
	call	SET_CONTROLLER_BANK
	mov		ah,EPMM1_REGISTER
	call	READ_ETH_REGISTER
	mov		ah,al
	UTILM_PRINT_BREG debug_str_EPMM1,ax
	UTILM_PRINT_NEWLINE
	
	mov		ah,BANK1
	call	SET_CONTROLLER_BANK
	mov		ax,(EPMCSH_REGISTER SHL 8) OR EPMCSL_REGISTER
	call	READ_ETH_REGISTER_LOW_HIGH
	UTILM_PRINT_WREG debug_str_EPMCS,ax
	UTILM_PRINT_NEWLINE
ENDIF
	ret
VERIFY_CONTROLLER_FILTERS ENDP

;!! PROC
;!!		SETUP_CONTROLLER_MODE
;!! Input
;!!		NONE
;!! Output
;!!		NONE (sets up the controller memory buffer pointers)
;!! Uses directly
;!!		AX, flags
;!! Calls
;!!		BIT_FIELD_SET (destroys AX, DX, flags)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, DX, flags
SETUP_CONTROLLER_MODE PROC NEAR
	jmp		SETUP_CONTROLLER_MODE_EXIT ; default has AUTOINC set by default
	;	ECON2_REGISTER (Any Bank) 
	mov		ax,(ECON2_REGISTER SHL 8) OR ECON2_AUTOINC_BIT
	call	BIT_FIELD_SET
SETUP_CONTROLLER_MODE_EXIT:
	ret
SETUP_CONTROLLER_MODE ENDP

VERIFY_CONTROLLER_MODE PROC NEAR
IF DEBUG_VERIFY_MODE
	jmp		VERIFY_CONTROLLER_MODE_T
	debug_str_ECON2 db "ECON2$" ; ANY BANK
VERIFY_CONTROLLER_MODE_T:
	mov		ah,ECON2_REGISTER
	call	READ_ETH_REGISTER
	mov		ah,al
	UTILM_PRINT_BREG debug_str_ECON2,ax
	UTILM_PRINT_NEWLINE	
ENDIF	
	ret
VERIFY_CONTROLLER_MODE ENDP


SETUP_CONTROLLER_MAC PROC NEAR
	push	bx
	
	;0.) Set BANK to 2 for next ops
	mov		ah,BANK2
	call	SET_CONTROLLER_BANK
		
	;1. Set MACON1_REGISTER (BANK2) to enable MAC:
	; (MACON1_MARXEN_SET|MACON1_TXPAUS_UNSET|MACON1_RXPAUS_UNSET),
	;	half-duplex mode
	mov		ax,(MACON1_REGISTER SHL 8) OR MACON1_MARXEN_SET OR MACON1_TXPAUS_UNSET OR MACON1_RXPAUS_UNSET
	call	WRITE_REGISTER
	
	;2. Set MACON3_REGISTER (Bank 2)
	; (MACON3_PADCFG2_SET|MACON3_PADCFG1_SET|MACON3_PADCFG0_SET|MACON3_TXCRCEN_SET
	;|MACON3_FULDPX_UNSET)
	; Line limits...splitting in two
	MACON_3_OR1 EQU MACON3_PADCFG2_SET OR MACON3_PADCFG1_SET OR MACON3_PADCFG0_SET
	MACON_3_OR2 EQU MACON3_TXCRCEN_SET OR MACON3_FULDPX_UNSET
	mov		ax,(MACON3_REGISTER SHL 8) OR MACON_3_OR1 OR MACON_3_OR2
	call	WRITE_REGISTER
	
	;3.) Set MACON4_REGISTER (BANK2) (MACON4_DEFER_SET)
	mov		ax,(MACON4_REGISTER SHL 8) OR MACON4_DEFER_SET
	call	WRITE_REGISTER
	
	; 4.) Set MAMXFLL_REGISTER & MAMXFLH_REGISTER (BANK2)
	mov		ax,(MAMXFLH_REGISTER SHL 8) OR MAMXFLL_REGISTER
	mov		bx,MAX_FRAME_LENGTH
	call	WRITE_REGISTER_LOW_HIGH
	
	;5.) Set MABBIPG_REGISTER (BANK2) Back-to-Back inter-packet gap
	mov		ax,(MABBIPG_REGISTER SHL 8) OR B2BINTERPACKETGAP
	call	WRITE_REGISTER

	;6/7.) Configure Non-Back-to-Back Inter-Packet Gap low byte + high byte
	mov		ax,(MAIPGH_REGISTER SHL 8) OR MAIPGL_REGISTER
	mov		bx,NB2BINTERPACKETGAP
	call	WRITE_REGISTER_LOW_HIGH
	
	;; Set MAADR1_REGISTER-MAADR6_REGISTER (BANK 3)
	; MAC Address 0-5
	mov		ah,BANK3
	call	SET_CONTROLLER_BANK 
	
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
	
	;- Will use default reset values for now
;  Serial.println("8.) Program Retransmission and Collision window registers (MACLCON1 & 2)");
;  Serial.println("Setting MACLCON1 (Retransmission window)");
;  Serial.println("Setting MACLCON2 - Collision window");
;  
	pop		bx
	ret
SETUP_CONTROLLER_MAC ENDP

VERIFY_CONTROLLER_MAC PROC NEAR
IF DEBUG_VERIFY_MODE
	jmp		VERIFY_CONTROLLER_MAC_T
	debug_str_MACON1 db "MACON1_REGISTER$" ; BANK2, MAC/MII
	debug_str_MACON3 db "MACON3_REGISTER$" ; BANK2, MAC/MII
	debug_str_MACON4 db "MACON4_REGISTER$" ; BANK2, MAC/MII
VERIFY_CONTROLLER_MAC_T:
ENDIF
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

TXRX_ENABLE_RX_INT PROC NEAR
	push	ax
	mov		ax,(EIE_REGISTER SHL 8) OR (EIE_PKTIE)
	call	BIT_FIELD_SET
	pop		ax
TXRX_ENABLE_RX_INT ENDP

TXRX_ENABLE_GLOBAL_INT PROC NEAR
	push	ax
	mov		ax,(EIE_REGISTER SHL 8) OR (EIE_INTIE)
	call	BIT_FIELD_SET
	pop		ax
	ret
TXRX_ENABLE_GLOBAL_INT ENDP

SETUP_CONTROLLER_INT PROC NEAR
	call	TXRX_ENABLE_RX_INT
	call	TXRX_ENABLE_GLOBAL_INT
	ret
SETUP_CONTROLLER_INT ENDP

TXRX_ENABLE_RX PROC NEAR
	push	ax
	mov		ax,(ECON1_REGISTER SHL 8) OR (ECON1_RXEN_MASK)
	call	BIT_FIELD_SET
	pop		ax
	ret
TXRX_ENABLE_RX ENDP

txrx_str_reset db "Resetting...$"
TXRXH_INIT PROC NEAR ;; USED TO BE TXRXH_RESET
	call	TXRX_SOFT_RESET
	UTILM_PRINT_STRN txrx_str_reset ; DEBUG API
	
	call	SETUP_CONTROLLER_BUFFERS
	call	VERIFY_CONTROLLER_BUFFERS
	
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
TXRXH_INIT ENDP

HAL_INIT PROC NEAR
	call	TXRX_SOFT_RESET
	call	SETUP_CONTROLLER_BUFFERS
	call	VERIFY_CONTROLLER_BUFFERS
	call	SETUP_CONTROLLER_FILTERS
	call	VERIFY_CONTROLLER_FILTERS
	call	SETUP_CONTROLLER_MODE ; Not necessary since ECON2 is already in autoinc
	call	VERIFY_CONTROLLER_MODE
	call	SETUP_CONTROLLER_MAC
	call	VERIFY_CONTROLLER_MAC
	;call	SETUP_CONTROLLER_PHY
	;call	VERIFY_CONTROLLER_PHY
	;call	SETUP_CONTROLLER_INT
	;call	TXRX_ENABLE_RX ; enable receiving
	ret
HAL_INIT ENDP

