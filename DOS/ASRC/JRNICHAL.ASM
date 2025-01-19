
;; PCjr Port Mapping
eth_write_cs_low	EQU 3ffh
eth_write_cs_high	EQU 3feh
eth_read_write_bit	EQU 3fdh

;; Ethernet controller registers
RCR_OPCODE			EQU 00h ; Read control register
RBM_OPCODE			EQU 01h ; Read Buffer memory
WCR_OPCODE			EQU 02h ; Write control register
WBM_OPCODE			EQU 03h ; Write Buffer memory
	BUFF_MEM_ARG		EQU 1Ah ; Read/Write buffer memory arg
BFS_OPCODE			EQU 04h ; Bit Field Set
BFC_OPCODE			EQU 05h ; Bit Field Clear
SRC_OPCODE			EQU 07h ; System Reset Command (soft reset)
	SRC_ARG				EQU 1Fh ; Arg for SRC reset

BANK_MASK			EQU 03h

BANK0					EQU 00h
ERDPTL_REGISTER		EQU 00h
ERDPTH_REGISTER		EQU 01h
EWRPTL_REGISTER		EQU 02h
EWRPTH_REGISTER		EQU 03h
ETXSTL_REGISTER		EQU 04h ; TX Start Low Byte
ETXSTH_REGISTER		EQU 05h ; TX Start High Byte
ETXNDL_REGISTER		EQU 06h ; TX Start Low Byte
ETXNDH_REGISTER		EQU 07h ; TX Start High Byte
ERXSTL_REGISTER		EQU 08h ; RX Start Low Byte
ERXSTH_REGISTER		EQU 09h ;RX Start High Byte
ERXNDL_REGISTER		EQU 0Ah ; RX End Low Byte
ERXNDH_REGISTER		EQU 0Bh ; RX End Low Byte
ERXRDPTL_REGISTER	EQU 0Ch ; Read pointer low
ERXRDPTH_REGISTER	EQU 0Dh ; Read pointer high
ERXWRPTL_REGISTER	EQU 0Eh 
ERXWRPTH_REGISTER	EQU 0Fh 
EDMASTL_REGISTER	EQU 10h
EDMASTH_REGISTER	EQU 11h
EDMANDL_REGISTER	EQU 12h
EDMANDH_REGISTER	EQU 13h
EDMADSTL_REGISTER	EQU 14h
EDMADSTH_REGISTER	EQU 15h
EDMACSL_REGISTER	EQU 16h
EDMACSH_REGISTER	EQU 17h
; 18h - unused
; 19h - unused
; 1Ah - reserved

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
; 12h - unused
; 13h - unused
EPMOL_REGISTER		EQU 14h
EPMOH_REGISTER		EQU 15h
; 16h - reserved
; 17h - reserved
ERXFCON_REGISTER	EQU 18h ; Receive Filter control register
	ERXFCON_UCEN_BIT	EQU 80h
	ERXFCON_ANDOR_BIT	EQU 40h
	ERXFCON_CRCEN_BIT	EQU 20h
	ERXFCON_PMEN_BIT	EQU 10h
	ERXFCON_MPEN_BIT	EQU 08h
	ERXFCON_HTEN_BIT	EQU 04h
	ERXFCON_MCEN_BIT	EQU 02h
	ERXFCON_BCEN_BIT	EQU 01h
EPKTCNT_REGISTER	EQU 19h
; 1Ah - reserved

BANK2						EQU 02h
MACON1_REGISTER			EQU 00h ;MAC/MII
	MACON1_TXPAUS_BIT		EQU 08h 
	MACON1_RXPAUS_BIT		EQU 04h 
	MACON1_PASSALL_BIT		EQU 02h 
	MACON1_MARXEN_BIT		EQU 01h 
; 01h - reserved
MACON3_REGISTER			EQU 02h ;MAC/MII
	MACON3_PADCFG2_BIT		EQU 80h 
	MACON3_PADCFG1_BIT		EQU 40h 
	MACON3_PADCFG0_BIT		EQU 20h 
	MACON3_TXCRCEN_BIT		EQU 10h
	MACON3_PHDREN_BIT		EQU 08h
	MACON3_HFRMEN_BIT		EQU 04h
	MACON3_FRMLNEN_BIT		EQU 02h
	MACON3_FULDPX_BIT		EQU 01h
MACON4_REGISTER			EQU 03h ;MAC/MII
	MACON4_DEFER_BIT		EQU 40h 
	MACON4_BPEN_BIT			EQU 20h
	MACON4_NOBKOFF_BIT		EQU 10h
MABBIPG_REGISTER		EQU 04h ;MAC/MII
; 05h - unused
MAIPGL_REGISTER			EQU 06h ;MAC/MII
MAIPGH_REGISTER			EQU 07h ;MAC/MII
MACLCON1_REGISTER		EQU 08h ;MAC/MII
MACLCON2_REGISTER		EQU 09h ;MAC/MII
MAMXFLL_REGISTER		EQU 0Ah ;MAC/MII
MAMXFLH_REGISTER		EQU 0Bh ;MAC/MII
; 0Ch - reserved
; 0Dh - reserved
; 0Eh - reserved
; 0Fh - unused
; 10h - reserved
; 11h - reserved
MICMD_REGISTER			EQU 12h ;MAC/MII
	MICMD_MIIRD_BIT			EQU 01h
; 13h - unused
MIREGADR_REGISTER		EQU 14h ;MAC/MII
; 15h - reserved
MIWRL_REGISTER			EQU 16h ;MAC/MII
MIWRH_REGISTER			EQU 17h ;MAC/MII
MIRDL_REGISTER			EQU 18h ;MAC/MII
MIRDH_REGISTER			EQU 19h ;MAC/MII
; 1Ah - reserved

BANK3						EQU 03h
; Note, the datasheet shows these in this order
MAADR5_REGISTER		EQU 00h ;MAC/MII
MAADR6_REGISTER		EQU 01h ;MAC/MII
MAADR3_REGISTER		EQU 02h ;MAC/MII
MAADR4_REGISTER		EQU 03h ;MAC/MII
MAADR1_REGISTER		EQU 04h ;MAC/MII
MAADR2_REGISTER		EQU 05h ;MAC/MII
EBSTSD_REGISTER		EQU 06h 
EBSTCON_REGISTER	EQU 07h 
EBSTCSL_REGISTER	EQU 08h 
EBSTCSH_REGISTER	EQU 09h 
MISTAT_REGISTER		EQU 0Ah ;MAC/MII
	MISTAT_BUSY_BIT		EQU 01h
; 0Bh - unused
; 0Ch - unused
; 0Dh - unused
; 0Eh - unused
; 0Fh - unused
; 10h - unused
; 11h - unused
EREVID_REGISTER		EQU 12h 
; 13h - unused
; 14h - unused
ECOCON_REGISTER		EQU 15h 
; 16h - reserved
EFLOCON_REGISTER	EQU 17h 
EPAUSL_REGISTER		EQU 18h 
EPAUSH_REGISTER		EQU 19h 
; 1Ah - reserved

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
	;ESTAT_CLKRDY_MASK_EXTRACT	EQU 01h
	ESTAT_CLKRDY_BIT		EQU 01h
ECON2_REGISTER			EQU 1Eh
	ECON2_AUTOINC_BIT		EQU 80h
	ECON2_PKTDEC_BIT		EQU 40h
ECON1_REGISTER			EQU 1Fh
	ECON1_RXEN_BIT		EQU 04h
	ECON1_TXRTS_BIT		EQU 08h ; 1 if attempting to transmit
	
; PHY
PHCON1_REGISTER			EQU 00h
	PHCON1_PRST_BIT			EQU 8000h ; 0 when done
	PHCON1_PDPXMD_BIT		EQU 0100h ; 0 = half-duplex
PHSTAT1_REGISTER		EQU 01h
	PHSTAT1_LLSTAT			EQU 0004h
PHID1_REGISTER			EQU 02h
PHID2_REGISTER			EQU 03h
; 04h - 0Fh - unused
PHCON2_REGISTER			EQU 10h
	PHCON2_HDLDIS_BIT		EQU 0100h
PHSTAT2_REGISTER		EQU 11h
	PHSTAT2_LSTAT_BIT		EQU 0400h
PHIE_REGISTER			EQU 12h
	PHIE_PLNKIE_BIT			EQU 0010h
	PHIE_PGEIE_BIT			EQU 0002h
PHIR_REGISTER			EQU 13h
	PHIR_PLNKIF_BIT			EQU 0010h
	PHIR_PGIF_BIT			EQU 0004h
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
;!!		HW_CS_HIGH
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
HW_CS_HIGH MACRO
	mov		dx,eth_write_cs_high	; Set DX
	out		dx,al					; Set ethernet controller CS line high, al is not affected
ENDM

; Destroys DX
;!! MACRO
;!!		HW_CS_LOW
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
HW_CS_LOW MACRO
	mov		dx,eth_write_cs_low		; Set DX
	out		dx,al					; Set ethernet controller CS line low, al is irrelevant
	mov		dx,eth_read_write_bit	; Set DX to prepare for read/write op	
ENDM

;!! MACRO
;!!		HW_CS_START
;!! Input
;!!		NONE
;!! Output
;!!		DX = eth_read_write_bit
;!! Uses directly
;!!		NONE
;!! Calls
;!!		HW_CS_HIGH (destroys DX)
;!!		HW_CS_LOW	(destroys DX)
;!! Dependencies destroy
;!!		DX
;!! Directly preserves
;!!		NONE	
;!! Total destroy
;!!		DX	
HW_CS_START MACRO
	HW_CS_HIGH ; HW_CS_HIGH first to ensure fresh start
	HW_CS_LOW ; HW_CS_LOW to initialize transfer
ENDM

;!! MACRO
;!!		HW_CS_END
;!! Input
;!!		NONE
;!! Output
;!!		DX = set to eth_write_cs_high
;!! Uses directly
;!!		NONE
;!! Calls
;!!		HW_CS_HIGH (destroys DX)
;!! Dependencies destroy
;!!		DX
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		DX	
HW_CS_END MACRO
	HW_CS_HIGH ; HW_CS_HIGH first to end transfer
ENDM

;!! MACRO
;!!		HW_TXRX_BIT
;!! Input
;!!		HW_CS_START was called previously
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
HW_TXRX_BIT MACRO
	in		al,dx	; Read low bit of receive
	and		al,1	; Only use low bit, other bits masked to 0
	xchg	ah,al	; Swap AH, AL, AL = transmit now
	out		dx,al	; Send high bit of transmit
ENDM

;!! MACRO
;!!		HW_TXRX_SHIFT
;!! Input
;!!		HW_CS_START was called previously
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
HW_TXRX_SHIFT MACRO
	shl		bl,1	; Shift previous received byte left one
	or		bl,ah	; OR current received bit into BL
	shl		al,1	; shift sent byte one over
	;xchg	ah,al	; move transmite byte back to ah for next bit
	mov		ah,al	; move transmite byte back to ah for next bit
ENDM

;!! MACRO
;!!		HW_TXRX_BIT_SHIFT
;!! Input
;!!		HW_CS_START was called previously
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
;!!		HW_TXRX_BIT (destroys AX, flags)
;!!		HW_TXRX_SHIFT (destroys AX, BX, flags)
;!! Dependencies destroy
;!!		AX, BX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, BX, flags
HW_TXRX_BIT_SHIFT MACRO
	HW_TXRX_BIT
	HW_TXRX_SHIFT
ENDM

;!! PROC
;!!		HW_TXRX_BYTE
;!! Input
;!!		HW_CS_START was called previously
;!!		AH = byte to transmit
;!!		DX = eth_read_write_bit
;!! Output
;!!		AL = received byte
;!! Uses directly
;!!		AX, BX, flags
;!! Calls
;!!		HW_TXRX_BIT_SHIFT (destroys AX, BX, flags)
;!! Dependencies destroy
;!!		AX, BX, flags
;!! Directly preserves
;!!		BX
;!! Total destroy
;!!		AX, flags
HW_TXRX_BYTE PROC NEAR
	push	bx
	xor		bl,bl ; used to build return value
	; ah = transmit byte
	HW_TXRX_BIT_SHIFT ; 1 ; Unrolled 8 bit tx/rx/shift
	HW_TXRX_BIT_SHIFT
	HW_TXRX_BIT_SHIFT
	HW_TXRX_BIT_SHIFT ; 4
	HW_TXRX_BIT_SHIFT ; 5
	HW_TXRX_BIT_SHIFT
	HW_TXRX_BIT_SHIFT
	HW_TXRX_BIT_SHIFT ; 8
	mov		al,bl ; set up return
	pop		bx
	ret
HW_TXRX_BYTE ENDP

;;;;;;;;;;;;;;;;;
; CORE COMMANDS
;;;;;;;;;;;;;;;;;

;!! PROC
;!!		HW_SOFT_RESET
;!! Input
;!!		NONE
;!! Output
;!!		NONE
;!! Uses directly
;!!		AH
;!! Calls
;!!		HW_CS_START (destroys DX)
;!!		HW_TXRX_BYTE (destroys AX, flags)
;!!		HW_CS_END (destroys DX)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, DX, flags, card state
;!!	Note
;!!		Ensure you wait for CLK READY
HW_SOFT_RESET PROC NEAR
	HW_CS_START	; Sets DX
	or		ah,(SRC_OPCODE SHL 5) OR SRC_ARG ; ah = SRC opcode << 5 | SRC_ARG
	call	HW_TXRX_BYTE ; ignore return, AL = received byte
	HW_CS_END		; Sets DX
	ret
HW_SOFT_RESET ENDP

;!! PROC
;!!		HW_READ_ETH_REGISTER
;!! Input
;!!		ETH:BANK was set previously
;!!		AH = Register
;!! Output
;!!		AL = value	
;!! Uses directly
;!!		AH
;!! Calls
;!!		HW_CS_START (destroys DX)
;!!		HW_TXRX_BYTE (destroys AX, flags)
;!!		HW_CS_END (destroys DX)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, DX, flags
HW_READ_ETH_REGISTER PROC NEAR
	HW_CS_START	; Sets DX
	or		ah,(RCR_OPCODE SHL 5) ; ah = RCR opcode << 5 | reg (ah)
	call	HW_TXRX_BYTE ; Send the opcode+reg byte, al returned is dummy
	call	HW_TXRX_BYTE ; Send gibberish, Receive byte, al
	HW_CS_END		; Sets DX
	ret
HW_READ_ETH_REGISTER ENDP

;!! PROC
;!!		HW_WRITE_REGISTER
;!! Input
;!!		ETH:BANK was set previously
;!!		AH = register
;!!		AL = value
;!! Output
;!!		NONE
;!! Uses directly
;!!		AX
;!! Calls
;!!		HW_CS_START (destroys DX)
;!!		HW_TXRX_BYTE (destroys AX, flags)
;!!		HW_CS_END (destroys DX)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, DX, flags
HW_WRITE_REGISTER PROC NEAR
	HW_CS_START	; Sets DX
	push	ax ; Store AL value
	or		ah,(WCR_OPCODE SHL 5) ; ah = WCR opcode << 5 | reg (ah)
	call	HW_TXRX_BYTE ; Send opcode + reg byte, al returned is dummy
	pop		ax ; value = al
	mov		ah,al ; move value to AH
	call	HW_TXRX_BYTE ; Send AH value, al returned is dummy
	HW_CS_END		; Sets DX
	ret
HW_WRITE_REGISTER ENDP

;!! PROC
;!!		HW_BIT_FIELD_SET
;!! Input
;!!		ETH:BANK was set previously
;!!		AH = register
;!!		AL = value
;!! Output
;!!		NONE
;!! Uses directly
;!!		AX
;!! Calls
;!!		HW_CS_START (destroys DX)
;!!		HW_TXRX_BYTE (destroys AX, flags)
;!!		HW_CS_END (destroys DX)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, DX, flags
HW_BIT_FIELD_SET PROC NEAR
	HW_CS_START	; Sets DX
	push	ax ; Store AL value
	or		ah,(BFS_OPCODE SHL 5) ; ah = BFS opcode << 5 | reg (ah)
	call	HW_TXRX_BYTE ; Send opcode + reg byte, al returned is dummy
	pop		ax ; value = al
	mov		ah,al ; move value to AH
	call	HW_TXRX_BYTE ; Send AH value, al returned is dummy
	HW_CS_END		; Sets DX
	ret
HW_BIT_FIELD_SET ENDP

;!! PROC
;!!		HW_BIT_FIELD_CLEAR
;!! Input
;!!		ETH:BANK was set previously
;!!		AH = register
;!!		AL = value
;!! Output
;!!		NONE
;!! Uses directly
;!!		AX
;!! Calls
;!!		HW_CS_START (destroys DX)
;!!		HW_TXRX_BYTE (destroys AX, flags)
;!!		HW_CS_END (destroys DX)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, DX, flags
HW_BIT_FIELD_CLEAR PROC NEAR
	HW_CS_START	; Sets DX
	push	ax ; store AL value
	or		ah,(BFC_OPCODE SHL 5) ; ah = BFC opcode << 5 | reg (ah)
	call	HW_TXRX_BYTE  ; Send opcode + reg byte, al returned is dummy
	pop		ax ; value = al
	mov		ah,al ; move value to AH
	call	HW_TXRX_BYTE ; Send AH value, al returned is dummy
	HW_CS_END		; Sets DX
	ret
HW_BIT_FIELD_CLEAR ENDP

;!! PROC
;!!		HW_READ_BUFFER_MEMORY_BYTE
;!! Input
;!!		ERDPT is set to start address
;!!		ECON2:AUTOINC is set (is by default)
;!! Output
;!!		AL = byte from memory(ERDPT)
;!! Uses directly
;!!		AX
;!! Calls
;!!		HW_CS_START (destroys DX)
;!!		HW_TXRX_BYTE (destroys AX, flags)
;!!		HW_CS_END (destroys DX)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, DX, flags
HW_READ_BUFFER_MEMORY_BYTE PROC NEAR
	HW_CS_START	; Sets DX
	mov		ah,(RBM_OPCODE SHL 5) OR BUFF_MEM_ARG
	call	HW_TXRX_BYTE  ; Send opcode + reg byte, al returned is dummy
	call	HW_TXRX_BYTE ; read next byte into al
	HW_CS_END		; Sets DX
	ret
HW_READ_BUFFER_MEMORY_BYTE ENDP

;!! PROC
;!!		HW_WRITE_BUFFER_MEMORY_BYTE
;!! Input
;!!		AL = byte to write
;!!		EWRPT is pointing at TX memory
;!!		ECON2:AUTOINC is set (is by default)
;!! Output
;!!		NONE (writes to card buffer memory)
;!! Uses directly
;!!		AX
;!! Calls
;!!		HW_CS_START (destroys DX)
;!!		HW_TXRX_BYTE (destroys AX, flags)
;!!		HW_CS_END (destroys DX)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, DX, flags
HW_WRITE_BUFFER_MEMORY_BYTE PROC NEAR
	HW_CS_START	; Sets DX
	push	ax ; save AX
	mov		ah,(WBM_OPCODE SHL 5) OR BUFF_MEM_ARG
	call	HW_TXRX_BYTE ; Send initial opcode
	pop		ax ; value = al
	mov		ah,al ; move value to AH
	call	HW_TXRX_BYTE ; Send AH value, al returned is dummy
	HW_CS_END		; Sets DX
	ret
HW_WRITE_BUFFER_MEMORY_BYTE ENDP

;!! PROC
;!!		HW_READ_BUFFER_MEMORY_WORD
;!! Input
;!!		ERDPT is set to start address
;!!		ECON2:AUTOINC is set (is by default)
;!! Output
;!!		AX = WORD from memory(ERDPT)
;!! Uses directly
;!!		AX, BX
;!! Calls
;!!		HW_CS_START (destroys DX)
;!!		HW_TXRX_BYTE (destroys AX, flags)
;!!		HW_CS_END (destroys DX)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		BX
;!! Total destroy
;!!		AX, DX, flags
HW_READ_BUFFER_MEMORY_WORD PROC NEAR
	HW_CS_START
	push	bx
	mov		ah,(RBM_OPCODE SHL 5) OR BUFF_MEM_ARG
	call	HW_TXRX_BYTE ; send initial opcode
	call	HW_TXRX_BYTE ; read next byte into al
	mov		bl,al ; save low byte
	call	HW_TXRX_BYTE ; read next byte into al
	mov		bh,al ; save high byte
	mov		ax,bx ; save result
	pop		bx
	HW_CS_END
	ret ; return ax
HW_READ_BUFFER_MEMORY_WORD ENDP

;!! PROC
;!!		HW_WRITE_BUFFER_MEMORY_WORD
;!! Input
;!!		AX = word to write
;!!		EWRPT is pointing at TX memory
;!!		ECON2:AUTOINC is set (is by default)
;!! Output
;!!		NONE (writes to card buffer memory)
;!! Uses directly
;!!		AX
;!! Calls
;!!		HW_CS_START (destroys DX)
;!!		HW_TXRX_BYTE (destroys AX, flags)
;!!		HW_CS_END (destroys DX)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, DX, flags
HW_WRITE_BUFFER_MEMORY_WORD PROC NEAR
	HW_CS_START
	;push	bx
	push	ax ; save AX
	mov		ah,(WBM_OPCODE SHL 5) OR BUFF_MEM_ARG
	call	HW_TXRX_BYTE ; Send initial opcode
	pop		ax ; get back AX
	push	ax ; save for second byte
	mov		ah,al ; move low byte into AH
	call	HW_TXRX_BYTE ; send low byte
	pop		ax ; ah contains high Byte
	call	HW_TXRX_BYTE ; send high byte byte
	HW_CS_END
	ret
HW_WRITE_BUFFER_MEMORY_WORD ENDP

;!! PROC
;!!		HW_READ_BUFFER_MEMORY
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
;!!		HW_CS_START (destroys DX)
;!!		HW_TXRX_BYTE (destroys AX, flags)
;!!		HW_CS_END (destroys DX)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		ES
;!! Total destroy
;!!		DI, AX, CX, DX, flags
HW_READ_BUFFER_MEMORY PROC NEAR
	HW_CS_START	; Sets DX
	mov		ah,(RBM_OPCODE SHL 5) OR BUFF_MEM_ARG
	call	HW_TXRX_BYTE ; Send initial opcode
RBM_LOOP:
	; get next byte
	call	HW_TXRX_BYTE ; stored in al
	cld
	stosb	; save byte, inc di
	loop	RBM_LOOP ; dec CX
	HW_CS_END		; Sets DX
	ret
HW_READ_BUFFER_MEMORY ENDP

; DS:SI PCjr Memory Pointer
; CX number of bytes to write, must be at least 1
; uses AX
; Assumes EWRPT is pointer is set
;!!		ECON2:AUTOINC is set (is by default)

;!! PROC
;!!		HW_READ_BUFFER_MEMORY
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
;!!		HW_CS_START (destroys DX)
;!!		HW_TXRX_BYTE (destroys AX, flags)
;!!		HW_CS_END (destroys DX)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		DS
;!! Total destroy
;!!		SI, AX, CX, DX, flags
HW_WRITE_BUFFER_MEMORY PROC NEAR
	HW_CS_START	; Sets DX
	mov		ah,(WBM_OPCODE SHL 5) OR BUFF_MEM_ARG
	call	HW_TXRX_BYTE ; Send initial opcode
WBM_LOOP:
	; get next byte
	cld
	lodsb	; write byte to ds:[si], inc si
	mov		ah,al ; move over to ah for transmit
	call	HW_TXRX_BYTE ; stored in al
	loop	WBM_LOOP ; dec CX
	HW_CS_END		; Sets DX
	ret
HW_WRITE_BUFFER_MEMORY ENDP


;;;;;;;;;;;;;;;;;
; COMPOUND COMMANDS
;;;;;;;;;;;;;;;;;




;!! PROC
;!!		HW_READ_MAC_MII_REGISTER
;!! Input
;!!		AH = Register
;!! Output
;!!		AL = Value
;!! Uses directly
;!!		AH
;!! Calls
;!!		HW_CS_START (destroys DX)
;!!		HW_TXRX_BYTE (destroys AX, flags)
;!!		HW_CS_END (destroys DX)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, DX, flags
HW_READ_MAC_MII_REGISTER PROC NEAR
	HW_CS_START
	or		ah,(RCR_OPCODE SHL 5) ; ah = rcr_opcode << 5 | reg (ah)
	call	HW_TXRX_BYTE ; Send the opcode+reg byte, al returned is dummy
	call	HW_TXRX_BYTE ; send dummy byte, this returned al byte is also a dummy for MAC/MII
	call	HW_TXRX_BYTE ; send dummy byte, returned al is actual byte
	HW_CS_END
	ret
HW_READ_MAC_MII_REGISTER ENDP

;!! PROC
;!!		HW_READ_PHY_REGISTER
;!! Input
;!!		AH = PHY Register
;!! Output
;!!		AX = Value
;!! Uses directly
;!!		AX, BX, flags
;!! Calls
;!!		HW_GET_CONTROLLER_BANK (destroys AX, DX, flags)
;!!		HW_SET_CONTROLLER_BANK (destroys AX, DX, flags, ETH:BANK)
;!!		HW_WRITE_REGISTER (destroys AX, DX, flags)
;!!		HW_BIT_FIELD_SET (destroys AX, DX, flags)
;!!		HW_READ_MAC_MII_REGISTER (destroys AX, DX, flags)
;!! Dependencies destroy
;!!		AX, DX, flags, ETH:BANK
;!! Directly preserves
;!!		BX, ETH:BANK
;!! Total destroy
;!!		AX, DX, flags
HW_READ_PHY_REGISTER PROC NEAR
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
	call	HW_GET_CONTROLLER_BANK
	mov		bh,al ; BH contains original bank
	
	; Set BANK2
	mov		ah,BANK2
	call	HW_SET_CONTROLLER_BANK
	
	; Get back AX (ah = input register)
	pop		ax
	
	; Save current bank
	push	bx

	; 1.) Write address of PHY register into MIREGADR_REGISTER (BANK2)
	mov		al,ah ; set value to PHY register
	mov		ah,MIREGADR_REGISTER
	call	HW_WRITE_REGISTER
	
	; 2.) Set MICMD.MIIRD bit MICMD_MIIRD_BIT (BANK2) ; Cannot use bit field set on MAC/MII!
	;mov		ax,(MICMD_REGISTER SHL 8) OR MICMD_MIIRD_BIT
	;call	HW_BIT_FIELD_SET
	; 2a.) Read MICMD (BANK2), MAC/MII
	mov		ah,MICMD_REGISTER
	call	HW_READ_MAC_MII_REGISTER
	; 2b.) Set MICMID_MIIRD_BIT
	or		al,MICMD_MIIRD_BIT ; Set MICMD_MIIRD_BIT
	; 2c.) Write MICMD (BANK2)
	mov		ah,MICMD_REGISTER
	call	HW_WRITE_REGISTER
	

	; 3.) Poll MISTAT.BUSY until clear (BANK3)
	; Set BANK 3
	mov		ah,BANK3
	call	HW_SET_CONTROLLER_BANK
	; Poll MISTAT.BUSY
HW_READ_PHY_REGISTER_BUSY:
	mov		ah,MISTAT_REGISTER
	call	HW_READ_MAC_MII_REGISTER 
	test	al,MISTAT_BUSY_BIT
	jnz		HW_READ_PHY_REGISTER_BUSY

	; 4.) Clear MICMD.MIIRD bit (BANK2)
	; Set BANK 2
	mov		ah,BANK2
	call	HW_SET_CONTROLLER_BANK
	; 4a.) Clear MICMD.MIIRD (can't use HW_BIT_FIELD_CLEAR)
	;mov		ah,MICMD_REGISTER
	;mov		al,MICMD_MIIRD_BIT
	;call	HW_BIT_FIELD_CLEAR
	mov		ah,MICMD_REGISTER
	call	HW_READ_MAC_MII_REGISTER
	; 4b.) Set MICMD_MIIRD_BIT to 0
	and		al,NOT MICMD_MIIRD_BIT
	; 4c.) Write MICMD (BANK2), MAC/MII
	mov		ah,MICMD_REGISTER
	call	HW_WRITE_REGISTER
	
	
	; 5.) Read the desired data from MIRDL and MIRDH (BANK2)
	mov		ah,MIRDL_REGISTER
	call	HW_READ_MAC_MII_REGISTER
	mov		bl,al ; store in bl, BX contains value
	mov		ah,MIRDH_REGISTER
	call	HW_READ_MAC_MII_REGISTER
	mov		bh,al ; store in bh
		
	; 6.) Restore current bank
	pop		ax ; Get back current bank
	call	HW_SET_CONTROLLER_BANK
	
	mov		ax,bx ; Set AX to return value

	pop		bx ; Restore BX
	ret
HW_READ_PHY_REGISTER ENDP

;!! PROC
;!!		HW_WRITE_PHY_REGISTER
;!! Input
;!!		AH = PHY Register
;!!		BX = Value
;!! Output
;!!		NONE
;!! Uses directly
;!!		AX, BX, flags
;!! Calls
;!!		HW_GET_CONTROLLER_BANK (destroys AX, DX, flags)
;!!		HW_SET_CONTROLLER_BANK (destroys AX, DX, flags, ETH:BANK)
;!!		HW_WRITE_REGISTER (destroys AX, DX, flags)
;!!		HW_BIT_FIELD_SET (destroys AX, DX, flags)
;!!		HW_READ_MAC_MII_REGISTER (destroys AX, DX, flags)
;!! Dependencies destroy
;!!		AX, DX, flags, ETH:BANK
;!! Directly preserves
;!!		ETH:BANK
;!! Total destroy
;!!		AX, BX, DX, flags
HW_WRITE_PHY_REGISTER PROC NEAR ; Compound operation
	; Datasheet 3.3
	
	;1.) Write address of PHY Register to MIREGADR (BANK2)
	;2.) Write lower byte to MIWRL_REGISTER (BANK2)
	;3.) Write upper byte to MIWRH (BANK2)
	;4.) Poll MISTAT.BUSY (BANK3) 

	push	bx ; preserve value
	push	ax ; preserve PHY register

	; Get controller bank
	call	HW_GET_CONTROLLER_BANK
	mov		bh,al ; BH = current bank
	
	; Set BANK2
	mov		ah,BANK2
	call	HW_SET_CONTROLLER_BANK
	
	;1.) Write address of PHY Register to MIREGADR (BANK2)
	pop		ax 	; Restore PHY register (AH)
	mov		al,ah ; set AL to PHY register
	mov		ah,MIREGADR_REGISTER
	call	HW_WRITE_REGISTER

	;2.) Write lower byte to MIWRL_REGISTER (BANK2)
	pop		ax ; Restore Value (old BX)
	push	bx ; Preserve previous bank
	push	ax ; Preserve Value (high byte)
	mov		ah,MIWRL_REGISTER ; al holds Value (low byte)
	call	HW_WRITE_REGISTER
	
	;3.) Write upper byte to MIWRH_REGISTER (BANK2)
	pop		ax ; Restore Value (high byte)
	mov		al,ah ; move high byte to al
	mov		ah,MIWRH_REGISTER
	call	HW_WRITE_REGISTER
	
	;4.) Poll MISTAT.BUSY (BANK3) 
	; Set Bank 3
	mov		ah,BANK3
	call	HW_SET_CONTROLLER_BANK
	
	; poll
	; Poll MISTAT.BUSY
HW_WRITE_PHY_REGISTER_BUSY:
	mov		ah,MISTAT_REGISTER
	call	HW_READ_MAC_MII_REGISTER 
	test	al,MISTAT_BUSY_BIT
	jnz		HW_WRITE_PHY_REGISTER_BUSY

	; Restore Bank
	pop		ax ; Restore AH = original BANK
	call	HW_SET_CONTROLLER_BANK

	ret
HW_WRITE_PHY_REGISTER ENDP

;!! PROC
;!!		HW_WRITE_REGISTER_LOW_HIGH
;!! Input
;!!		ETH:BANK was set previously
;!!		AX = REG_HIGH, REG_LOW
;!!		BX = VAL_HIGH, VAL_LOW
;!! Output
;!!		NONE
;!! Uses directly
;!!		AX, BX, flags
;!! Calls
;!!		HW_WRITE_REGISTER (destroys AX, DX, flags)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, BX, DX, flags
HW_WRITE_REGISTER_LOW_HIGH PROC NEAR
	xchg	al,bh	; AX = REG_HIGH, VAL_HIGH
					; BX = REG_LOW, VAL_LOW
	push	ax ; Save high HW_WRITE_REGISTER+VAL
	mov		ax,bx
	call	HW_WRITE_REGISTER ; Write REG_LOW, VAL_LOW
	pop		ax ; Restore high HW_WRITE_REGISTER+VAL
	call	HW_WRITE_REGISTER ; Write REG_HIGH, VAL_HIGH
	ret
HW_WRITE_REGISTER_LOW_HIGH ENDP

;!! PROC
;!!		HW_READ_ETH_REGISTER_LOW_HIGH
;!! Input
;!!		ETH:BANK was set previously
;!!		AX = REG_HIGH, REG_LOW
;!! Output
;!!		AX = VAL_HIGH, VAL_LOW
;!! Uses directly
;!!		AX, BX, flags
;!! Calls
;!!		HW_READ_ETH_REGISTER (destroys AX, DX, flags)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		BX
;!! Total destroy
;!!		AX, DX, flags
HW_READ_ETH_REGISTER_LOW_HIGH PROC NEAR
	push	bx
	push	ax ; save low register
	call	HW_READ_ETH_REGISTER ; returns AL = VAL_HIGH
	mov		bh,al ; save high value
	pop		ax ; get low register
	mov		ah,al ; set low register
	call	HW_READ_ETH_REGISTER ; returns AL = VAL_LOW
	mov		ah,bh ; get high value back
	pop		bx
	ret
HW_READ_ETH_REGISTER_LOW_HIGH ENDP

;!! PROC
;!!		TXRX_CLEAR_MEMORY
;!! Input
;!!		NONE
;!! Output
;!!		NONE (clears card memory)
;!! Uses directly
;!!		AX, CX
;!! Calls
;!!		HW_SET_EWRPT (destroys AX, DX, flags, ETH:BANK)
;!!		HW_WRITE_BUFFER_MEMORY_BYTE (destroys AX, DX, flags)
;!! Dependencies destroy
;!!		AX, DX, flags, ETH:BANK
;!! Directly preserves
;!!		CX
;!! Total destroy
;!!		AX, CX, DX, flags, ETH:BANK
HW_CLEAR_MEMORY PROC NEAR
	push	cx
	mov		cx,RX_ADDRESS_END ; End of memory
	xor		ax,ax ; Beginning of memory
	call	HW_SET_EWRPT ; Set write pointer to beginning of memory
HW_CLEAR_MEMORY_LOOP:
	xor		al,al ; Write 0 to every byte
	call	HW_WRITE_BUFFER_MEMORY_BYTE
	loop	HW_CLEAR_MEMORY_LOOP
	pop		cx
	ret
HW_CLEAR_MEMORY ENDP

;;;;;;;;;;;;;;;;;
; HAL_UTIL
;;;;;;;;;;;;;;;;;

;!! PROC
;!!		HW_SET_CONTROLLER_BANK
;!! Input
;!!		CURRENT_BANK = ANY
;!!		AH = BANK (0-3)
;!! Output
;!!		NONE
;!! Uses directly
;!!		AX, BX
;!!		ETH: BANK
;!! Calls
;!!		HW_READ_ETH_REGISTER (destroys AX, DX, flags)
;!!		HW_WRITE_REGISTER (destroys AX, DX, flags)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		BX
;!! Total destroy
;!!		AX, DX, flags
;!!		ETH: BANK
HW_SET_CONTROLLER_BANK PROC NEAR
	push	bx ; will use BX as temp
	push	ax ; Save ah (bank)
	mov		ah,ECON1_REGISTER ; Works from all banks
	call	HW_READ_ETH_REGISTER ; returns AL = ECON1 value
	and		al,NOT BANK_MASK ; force current bank bits to 0
	pop		bx ; Get back old AX (Desired Bank = bh now)
	or		al,bh ; AL now contains old ECON1 but with new bank
	mov		ah,ECON1_REGISTER
	call	HW_WRITE_REGISTER
	pop		bx ; Restore BX
	ret
HW_SET_CONTROLLER_BANK ENDP

; Returns AL = Bank Value, Destroys AH
;!! PROC
;!!		HW_GET_CONTROLLER_BANK
;!! Input
;!!		CURRENT_BANK = ANY
;!! Output
;!!		AL = Bank value (0-3)
;!! Uses directly
;!!		AX
;!! Calls
;!!		HW_READ_ETH_REGISTER (destroys AX, DX, flags)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, DX, flags
HW_GET_CONTROLLER_BANK PROC NEAR
	mov		ah,ECON1_REGISTER
	call	HW_READ_ETH_REGISTER ; Returns AL = ECON1
	and		al,BANK_MASK ; Select BANK bits
	ret
HW_GET_CONTROLLER_BANK ENDP

;!! PROC
;!!		HW_SET_ERDPT
;!! Input
;!!		AX = VAL_HIGH, VAL_LOW
;!! Output
;!!		NONE
;!! Uses directly
;!!		AX, BX, flags
;!! Calls
;!!		HW_SET_CONTROLLER_BANK (destroys AX, DX, flags, ETH:BANK)
;!!		HW_WRITE_REGISTER_LOW_HIGH (destroys AX, BX, DX, flags)
;!! Dependencies destroy
;!!		AX, BX, DX, flags, ETH: BANK
;!! Directly preserves
;!!		BX
;!! Total destroy
;!!		AX, DX, flags, ETH:BANK	
HW_SET_ERDPT PROC NEAR
	push	bx
	push	ax
	mov		ah,BANK0
	call	HW_SET_CONTROLLER_BANK
	pop		bx ; get old AX value
	mov		ax,(ERDPTH_REGISTER SHL 8) OR ERDPTL_REGISTER
	call	HW_WRITE_REGISTER_LOW_HIGH
	pop		bx
	ret
HW_SET_ERDPT ENDP

;!! PROC
;!!		HW_SET_EWRPT
;!! Input
;!!		AX = VAL_HIGH, VAL_LOW
;!! Output
;!!		NONE
;!! Uses directly
;!!		AX, BX, flags
;!! Calls
;!!		HW_SET_CONTROLLER_BANK (destroys AX, DX, flags, ETH:BANK)
;!!		HW_WRITE_REGISTER_LOW_HIGH (destroys AX, BX, DX, flags)
;!! Dependencies destroy
;!!		AX, BX, DX, flags, ETH: BANK
;!! Directly preserves
;!!		BX
;!! Total destroy
;!!		AX, DX, flags, ETH:BANK	
HW_SET_EWRPT PROC NEAR
	push	bx
	push	ax
	mov		ah,BANK0
	call	HW_SET_CONTROLLER_BANK
	pop		bx ; get old AX value
	mov		ax,(EWRPTH_REGISTER SHL 8) OR EWRPTL_REGISTER
	call	HW_WRITE_REGISTER_LOW_HIGH
	pop		bx
	ret
HW_SET_EWRPT ENDP

;!! PROC
;!!		HW_SEND
;!! Input
;!!		CX = end size
;!! Output
;!!		NONE
;!! Uses directly
;!!		AX, BX, flags
;!! Calls
;!!		HW_SET_CONTROLLER_BANK (destroys AX, DX, flags, ETH:BANK)
;!!		HW_WRITE_REGISTER_LOW_HIGH (destroys AX, BX, DX, flags)
;!! Dependencies destroy
;!!		AX, BX, DX, flags, ETH: BANK
;!! Directly preserves
;!!		BX
;!! Total destroy
;!!		AX, DX, flags, ETH:BANK	
HW_SEND PROC NEAR
	mov		ah,BANK0
	call	HW_SET_CONTROLLER_BANK
	
	;; Set ETXST (BANK0) to beginning of transmit buffer
	push	bx
	mov		ax,(ETXSTH_REGISTER SHL 8) OR ETXSTL_REGISTER
	mov		bx,TX_ADDRESS_START
	call	HW_WRITE_REGISTER_LOW_HIGH
	
	;; Set ETXND (BANK0) to end of transmit buffer
	mov		ax,(ETXNDH_REGISTER SHL 8) OR ETXNDL_REGISTER
	mov		bx,TX_ADDRESS_START
	add		bx,cx
	add		bx,5 ; (Packet Size (CX) + 1 (control byte) + 4 (CRC bytes)
	call	HW_WRITE_REGISTER_LOW_HIGH
	pop		bx
	
	;; Set ECON1_TXRTS_BIT to initiate transmit
	mov		ax,(ECON1_REGISTER SHL 8) OR ECON1_TXRTS_BIT
	call	HW_BIT_FIELD_SET	

	ret
HW_SEND ENDP

;!! PROC
;!!		HW_WAIT_SEND_COMPLETE
;!! Input
;!!		NONE
;!! Output
;!!		NONE
;!! Uses directly
;!!		AX, flags
;!! Calls
;!!		HW_READ_ETH_REGISTER (destroys AX, DX, flags)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, DX, flags	
HW_WAIT_SEND_COMPLETE PROC NEAR
	mov		ah,ECON1_REGISTER ; (all banks)
	call	HW_READ_ETH_REGISTER ; returns AL = ECON1 value
	test	al,ECON1_TXRTS_BIT ; 1 if attempting to transmit
	jnz		HW_WAIT_SEND_COMPLETE ; If not zero, loop until transmit complete
	ret
HW_WAIT_SEND_COMPLETE ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; TODO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;
; Setup Functions
;;;;;;;;;;;;;;;;;

;!! PROC
;!!		HW_SETUP_CONTROLLER_BUFFERS
;!! Input
;!!		NONE
;!! Output
;!!		NONE (sets up the controller memory buffer pointers)
;!! Uses directly
;!!		AX, BX, flags
;!! Calls
;!!		HW_SET_CONTROLLER_BANK (destroys AX, DX, flags, ETH:BANK)
;!!		HW_WRITE_REGISTER_LOW_HIGH (destroys AX, BX, DX, flags)
;!! Dependencies destroy
;!!		AX, BX, DX, flags, ETH:BANK
;!! Directly preserves
;!!		BX
;!! Total destroy
;!!		AX, DX, flags, ETH:BANK
HW_SETUP_CONTROLLER_BUFFERS PROC NEAR
	push	bx ; Preserve BX
	;; Initialize Eth TX Start Memory Pointers to TX_ADDRESS_START
	;	ETXSTH_REGISTER,ETXSTL_REGISTER  (BANK0)
	;	TX_ADDRESS_START (0100h)
	mov		ah,BANK0
	call	HW_SET_CONTROLLER_BANK
	mov		ax,(ETXSTH_REGISTER SHL 8) OR ETXSTL_REGISTER
	mov		bx,TX_ADDRESS_START
	call	HW_WRITE_REGISTER_LOW_HIGH

	;; Initialize Eth TX End Memory Pointers to TX_ADDRESS_END	
	;	ETXNDH_REGISTER,ETXNDL_REGISTER (BANK0)
	;	TX_ADDRESS_END (06FFh)
	mov		ah,BANK0
	call	HW_SET_CONTROLLER_BANK
	mov		ax,(ETXNDH_REGISTER SHL 8) OR ETXNDL_REGISTER
	mov		bx,TX_ADDRESS_END
	call	HW_WRITE_REGISTER_LOW_HIGH
	
	;; Initialize Eth RX Start Memory Pointers to RX_ADDRESS_START	
	;	ERXNDH_REGISTER,ERXNDL_REGISTER (BANK0)
	;	RX_ADDRESS_START (0700h)
	mov		ah,BANK0
	call	HW_SET_CONTROLLER_BANK
	mov		ax,(ERXSTH_REGISTER SHL 8) OR ERXSTL_REGISTER
	mov		bx,RX_ADDRESS_START
	call	HW_WRITE_REGISTER_LOW_HIGH
	
	;; Initialize Eth RX END Memory Pointers to RX_ADDRESS_END	
	;	ERXNDH_REGISTER,ERXNDL_REGISTER (BANK0)
	;	RX_ADDRESS_START (0700h)
	mov		ah,BANK0
	call	HW_SET_CONTROLLER_BANK
	mov		ax,(ERXNDH_REGISTER SHL 8) OR ERXNDL_REGISTER
	mov		bx,RX_ADDRESS_END
	call	HW_WRITE_REGISTER_LOW_HIGH

	;; Initialize Eth RX Read Pointer to beginning of read memory
	;	ERXRDPTH_REGISTER, ERXRDPTL_REGISTER (BANK 0)
	;	RX_ADDRESS_START (0700h)
	mov		ah,BANK0
	call	HW_SET_CONTROLLER_BANK
	mov		ax,(ERXRDPTH_REGISTER SHL 8) OR ERXRDPTL_REGISTER
	mov		bx,RX_ADDRESS_START
	call	HW_WRITE_REGISTER_LOW_HIGH
	
	pop		bx
IF	DEBUG_VERIFY_BUFFER	
	call	HW_VERIFY_CONTROLLER_BUFFERS
ENDIF
	ret
HW_SETUP_CONTROLLER_BUFFERS ENDP

IF DEBUG_VERIFY_BUFFER
HW_VERIFY_CONTROLLER_BUFFERS PROC NEAR
	jmp		HW_VERIFY_CONTROLLER_BUFFERS_T
	debug_str_ETXST db "ETXST$" ; BANK0
	debug_str_ETXND db "ETXND$" ; BANK0
	debug_str_ERXST db "ERXST$" ; BANK0
	debug_str_ERXND db "ERXND$" ; BANK0
	debug_str_ERXRDPT db "ERXRDPT$" ; BANK0
HW_VERIFY_CONTROLLER_BUFFERS_T:
	mov		ah,BANK0
	call	HW_SET_CONTROLLER_BANK
	mov		ax,(ETXSTH_REGISTER SHL 8) OR ETXSTL_REGISTER
	call	HW_READ_ETH_REGISTER_LOW_HIGH
	UTILM_PRINT_WREG debug_str_ETXST,ax
	UTILM_PRINT_NEWLINE
	
	mov		ah,BANK0
	call	HW_SET_CONTROLLER_BANK
	mov		ax,(ETXNDH_REGISTER SHL 8) OR ETXNDL_REGISTER
	call	HW_READ_ETH_REGISTER_LOW_HIGH
	UTILM_PRINT_WREG debug_str_ETXND,ax
	UTILM_PRINT_NEWLINE
	
	mov		ah,BANK0
	call	HW_SET_CONTROLLER_BANK
	mov		ax,(ERXSTH_REGISTER SHL 8) OR ERXSTL_REGISTER
	call	HW_READ_ETH_REGISTER_LOW_HIGH
	UTILM_PRINT_WREG debug_str_ERXST,ax
	UTILM_PRINT_NEWLINE
	
	mov		ah,BANK0
	call	HW_SET_CONTROLLER_BANK
	mov		ax,(ERXNDH_REGISTER SHL 8) OR ERXNDL_REGISTER
	call	HW_READ_ETH_REGISTER_LOW_HIGH
	UTILM_PRINT_WREG debug_str_ERXND,ax
	UTILM_PRINT_NEWLINE
	
	mov		ah,BANK0
	call	HW_SET_CONTROLLER_BANK
	mov		ax,(ERXRDPTH_REGISTER SHL 8) OR ERXRDPTL_REGISTER
	call	HW_READ_ETH_REGISTER_LOW_HIGH
	UTILM_PRINT_WREG debug_str_ERXRDPT,ax
	UTILM_PRINT_NEWLINE
	ret
HW_VERIFY_CONTROLLER_BUFFERS ENDP
ENDIF

;!! PROC
;!!		HW_SETUP_CONTROLLER_FILTERS
;!! Input
;!!		NONE
;!! Output
;!!		NONE (sets up the controller memory buffer pointers)
;!! Uses directly
;!!		AX, BX, flags
;!! Calls
;!!		HW_SET_CONTROLLER_BANK (destroys AX, DX, flags, ETH:BANK)
;!!		HW_WRITE_REGISTER (destroys AX, DX, flags)
;!!		HW_WRITE_REGISTER_LOW_HIGH (destroys AX, BX, DX, flags)
;!! Dependencies destroy
;!!		AX, BX, DX, flags, ETH:BANK
;!! Directly preserves
;!!		BX
;!! Total destroy
;!!		AX, DX, flags, ETH:BANK
HW_SETUP_CONTROLLER_FILTERS PROC NEAR
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
	call	HW_SET_CONTROLLER_BANK
	mov		ax,(ERXFCON_REGISTER SHL 8) OR (ERXFCON_UCEN_BIT OR ERXFCON_CRCEN_BIT OR ERXFCON_PMEN_BIT)
	call	HW_WRITE_REGISTER
	
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
	call	HW_SET_CONTROLLER_BANK
	mov		ax,(EPMM0_REGISTER SHL 8) OR 3Fh
	call	HW_WRITE_REGISTER

	;; Patter Match Mask Byte 1
	mov		ah,BANK1
	call	HW_SET_CONTROLLER_BANK
	mov		ax,(EPMM1_REGISTER SHL 8) OR 30h
	call	HW_WRITE_REGISTER

	;; Pattern match checksum
	;mov		ax,(EPMCSH_REGISTER SHL 8) OR 0F7h
	;call	HW_WRITE_REGISTER
	;mov		ax,(EPMCSL_REGISTER SHL 8) OR 0F9h
	;call	HW_WRITE_REGISTER
	mov		ah,BANK1
	call	HW_SET_CONTROLLER_BANK
	mov		ax,(EPMCSH_REGISTER SHL 8) OR EPMCSL_REGISTER
	mov		bx,(0F7h SHL 8) OR 0F9h
	call	HW_WRITE_REGISTER_LOW_HIGH
	
	pop		bx
IF DEBUG_VERIFY_FILTER
	call	HW_VERIFY_CONTROLLER_FILTERS
ENDIF
	ret		
HW_SETUP_CONTROLLER_FILTERS ENDP

IF DEBUG_VERIFY_FILTER
HW_VERIFY_CONTROLLER_FILTERS PROC NEAR
	jmp		HW_VERIFY_CONTROLLER_FILTERS_T
	debug_str_ERXFCON db "ERXFCON$" ; BANK1
	debug_str_EPMM0 db "EPMM0$" ; BANK1
	debug_str_EPMM1 db "EPMM1$" ; BANK1
	debug_str_EPMCS db "EPMCS$"	; BANK1
HW_VERIFY_CONTROLLER_FILTERS_T:
	mov		ah,BANK1
	call	HW_SET_CONTROLLER_BANK
	mov		ah,ERXFCON_REGISTER
	call	HW_READ_ETH_REGISTER
	mov		ah,al
	UTILM_PRINT_BREG debug_str_ERXFCON,ax
	UTILM_PRINT_NEWLINE	

	mov		ah,BANK1
	call	HW_SET_CONTROLLER_BANK
	mov		ah,EPMM0_REGISTER
	call	HW_READ_ETH_REGISTER
	mov		ah,al
	UTILM_PRINT_BREG debug_str_EPMM0,ax
	UTILM_PRINT_NEWLINE
	
	mov		ah,BANK1
	call	HW_SET_CONTROLLER_BANK
	mov		ah,EPMM1_REGISTER
	call	HW_READ_ETH_REGISTER
	mov		ah,al
	UTILM_PRINT_BREG debug_str_EPMM1,ax
	UTILM_PRINT_NEWLINE
	
	mov		ah,BANK1
	call	HW_SET_CONTROLLER_BANK
	mov		ax,(EPMCSH_REGISTER SHL 8) OR EPMCSL_REGISTER
	call	HW_READ_ETH_REGISTER_LOW_HIGH
	UTILM_PRINT_WREG debug_str_EPMCS,ax
	UTILM_PRINT_NEWLINE
	ret
HW_VERIFY_CONTROLLER_FILTERS ENDP
ENDIF

;!! PROC
;!!		HW_SETUP_CONTROLLER_MODE
;!! Input
;!!		NONE
;!! Output
;!!		NONE (sets up the controller memory buffer pointers)
;!! Uses directly
;!!		AX, flags
;!! Calls
;!!		HW_BIT_FIELD_SET (destroys AX, DX, flags)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, DX, flags
HW_SETUP_CONTROLLER_MODE PROC NEAR
	jmp		HW_SETUP_CONTROLLER_MODE_EXIT ; default has AUTOINC set by default
	;	ECON2_REGISTER (Any Bank) 
	mov		ax,(ECON2_REGISTER SHL 8) OR ECON2_AUTOINC_BIT
	call	HW_BIT_FIELD_SET
HW_SETUP_CONTROLLER_MODE_EXIT:
IF DEBUG_VERIFY_MODE
	call	HW_VERIFY_CONTROLLER_MODE
ENDIF
	ret
HW_SETUP_CONTROLLER_MODE ENDP

IF DEBUG_VERIFY_MODE
HW_VERIFY_CONTROLLER_MODE PROC NEAR
	jmp		HW_VERIFY_CONTROLLER_MODE_T
	debug_str_ECON2 db "ECON2$" ; ANY BANK
HW_VERIFY_CONTROLLER_MODE_T:
	mov		ah,ECON2_REGISTER
	call	HW_READ_ETH_REGISTER
	mov		ah,al
	UTILM_PRINT_BREG debug_str_ECON2,ax
	UTILM_PRINT_NEWLINE	
	ret
HW_VERIFY_CONTROLLER_MODE ENDP
ENDIF

;!! PROC
;!!		HW_SETUP_CONTROLLER_MAC
;!! Input
;!!		NONE
;!! Output
;!!		NONE (sets up the controller memory buffer pointers)
;!! Uses directly
;!!		AX, flags
;!! Calls
;!!		HW_SET_CONTROLLER_BANK (destroys AX, DX, flags, ETH:BANK)
;!!		HW_BIT_FIELD_SET (destroys AX, DX, flags)
;!!		HW_WRITE_REGISTER (destroys AX, DX, flags)
;!! Dependencies destroy
;!!		AX, DX, flags, ETH:BANK
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, DX, flags
HW_SETUP_CONTROLLER_MAC PROC NEAR
	;0.) Set BANK to 2 for next ops
	mov		ah,BANK2
	call	HW_SET_CONTROLLER_BANK
		
	;1. Set MACON1_REGISTER (BANK2) to enable MAC:
	; (MACON1_MARXEN_SET|MACON1_TXPAUS_UNSET|MACON1_RXPAUS_UNSET),
	;	half-duplex mode
	mov		ax,(MACON1_REGISTER SHL 8) OR MACON1_MARXEN_BIT
	call	HW_BIT_FIELD_SET
	MACON1_UNSET_BITS1 EQU MACON1_TXPAUS_BIT OR MACON1_RXPAUS_BIT
	MACON1_UNSET_BITS2 EQU MACON1_PASSALL_BIT
	MACON1_UNSET_BITS EQU MACON1_UNSET_BITS1 OR MACON1_UNSET_BITS2
	mov		ax,(MACON1_REGISTER SHL 8) OR MACON1_UNSET_BITS
	call	HW_BIT_FIELD_CLEAR

	;2. Set MACON3_REGISTER (Bank 2)
	; (MACON3_PADCFG2_SET|MACON3_PADCFG1_SET|MACON3_PADCFG0_SET|MACON3_TXCRCEN_SET
	;|MACON3_FULDPX_UNSET)
	; Line limits...splitting in two
	MACON3_SET_BITS1 EQU MACON3_PADCFG2_BIT OR MACON3_PADCFG1_BIT OR MACON3_PADCFG0_BIT
	MACON3_SET_BITS2 EQU MACON3_TXCRCEN_BIT
	MACON3_SET_BITS EQU MACON3_SET_BITS1 OR MACON3_SET_BITS2
	mov		ax,(MACON3_REGISTER SHL 8) OR MACON3_SET_BITS
	call	HW_BIT_FIELD_SET
	MACON3_UNSET_BITS1 EQU MACON3_PHDREN_BIT OR MACON3_HFRMEN_BIT 
	MACON3_UNSET_BITS2 EQU MACON3_FRMLNEN_BIT OR MACON3_FULDPX_BIT
	MACON3_UNSET_BITS EQU MACON3_UNSET_BITS1 OR MACON3_UNSET_BITS2
	mov		ax,(MACON3_REGISTER SHL 8) OR MACON3_UNSET_BITS
	call	HW_BIT_FIELD_CLEAR
		
	;3.) Set MACON4_REGISTER (BANK2) (MACON4_DEFER_SET)
	mov		ax,(MACON4_REGISTER SHL 8) OR MACON4_DEFER_BIT
	call	HW_BIT_FIELD_SET
	MACON4_UNSET_BITS EQU MACON4_BPEN_BIT OR MACON4_NOBKOFF_BIT
	mov		ax,(MACON4_REGISTER SHL 8) OR MACON4_UNSET_BITS
	call	HW_BIT_FIELD_CLEAR
	
	; 4.) Set MAMXFLL_REGISTER & MAMXFLH_REGISTER (BANK2)
	mov		ax,(MAMXFLH_REGISTER SHL 8) OR MAMXFLL_REGISTER
	mov		bx,MAX_FRAME_LENGTH
	call	HW_WRITE_REGISTER_LOW_HIGH
	
	;5.) Set MABBIPG_REGISTER (BANK2) Back-to-Back inter-packet gap
	mov		ax,(MABBIPG_REGISTER SHL 8) OR B2BINTERPACKETGAP
	call	HW_WRITE_REGISTER

	;6/7.) Configure Non-Back-to-Back Inter-Packet Gap low byte + high byte
	mov		ax,(MAIPGH_REGISTER SHL 8) OR MAIPGL_REGISTER
	mov		bx,NB2BINTERPACKETGAP
	call	HW_WRITE_REGISTER_LOW_HIGH
	
		;- Will use default reset values for now
;  Serial.println("8.) Program Retransmission and Collision window registers (MACLCON1 & 2)");
;  Serial.println("Setting MACLCON1 (Retransmission window)");
;  Serial.println("Setting MACLCON2 - Collision window");
	
	;; Set MAADR1_REGISTER-MAADR6_REGISTER (BANK 3)
	; MAC Address 0-5
	mov		ah,BANK3
	call	HW_SET_CONTROLLER_BANK 
	
	mov		ah,MAADR1_REGISTER
	mov		al,MAC_ADDRESS_TABLE[0] ;; PROVIDED BY PKT_DRIVER!!
	call	HW_WRITE_REGISTER

	mov		ah,MAADR2_REGISTER
	mov		al,MAC_ADDRESS_TABLE[1]
	call	HW_WRITE_REGISTER
	
	mov		ah,MAADR3_REGISTER
	mov		al,MAC_ADDRESS_TABLE[2]
	call	HW_WRITE_REGISTER

	mov		ah,MAADR4_REGISTER
	mov		al,MAC_ADDRESS_TABLE[3]
	call	HW_WRITE_REGISTER

	mov		ah,MAADR5_REGISTER
	mov		al,MAC_ADDRESS_TABLE[4]
	call	HW_WRITE_REGISTER
	
	mov		ah,MAADR6_REGISTER
	mov		al,MAC_ADDRESS_TABLE[5]
	call	HW_WRITE_REGISTER
IF	DEBUG_VERIFY_MODE
	call	HW_VERIFY_CONTROLLER_MAC
ENDIF
	ret
HW_SETUP_CONTROLLER_MAC ENDP

IF DEBUG_VERIFY_MODE
HW_VERIFY_CONTROLLER_MAC PROC NEAR
	jmp		HW_VERIFY_CONTROLLER_MAC_T
	debug_str_MACON1 db "MACON1$" ; BANK2, MAC/MII
	debug_str_MACON3 db "MACON3$" ; BANK2, MAC/MII
	debug_str_MACON4 db "MACON4$" ; BANK2, MAC/MII
	debug_str_MAMXFLH db "MAMXFLH$" ; BANK2, MAC/MII
	debug_str_MAMXFLL db "MAMXFLL$" ; BANK2, MAC/MII
	debug_str_MABBIPG db "MABBIPG$" ; BANK2, MAC/MII
	debug_str_MAIPGH db "MAIPGH$" ; BANK2, MAC/MII
	debug_str_MAIPGL db "MAIPGL$" ; BANK2, MAC/MII
	
	debug_str_MACLCON1 db "MACLCON1$" ; BANK2, MAC/MII
	debug_str_MACLCON2 db "MACLCON2$" ; BANK2, MAC/MII
	
	debug_str_MAADR1 db "MAADR1$" ; BANK3, MAC/MII
	debug_str_MAADR2 db "MAADR2$" ; BANK3, MAC/MII
	debug_str_MAADR3 db "MAADR3$" ; BANK3, MAC/MII
	debug_str_MAADR4 db "MAADR4$" ; BANK3, MAC/MII
	debug_str_MAADR5 db "MAADR5$" ; BANK3, MAC/MII
	debug_str_MAADR6 db "MAADR6$" ; BANK3, MAC/MII
HW_VERIFY_CONTROLLER_MAC_T:
	mov		ah,BANK2
	call	HW_SET_CONTROLLER_BANK
	
	mov		ah,MACON1_REGISTER
	call	HW_READ_MAC_MII_REGISTER
	mov		ah,al
	UTILM_PRINT_BREG debug_str_MACON1,ax
	UTILM_PRINT_NEWLINE

	mov		ah,MACON3_REGISTER
	call	HW_READ_MAC_MII_REGISTER
	mov		ah,al
	UTILM_PRINT_BREG debug_str_MACON3,ax
	UTILM_PRINT_NEWLINE

	mov		ah,MACON4_REGISTER
	call	HW_READ_MAC_MII_REGISTER
	mov		ah,al
	UTILM_PRINT_BREG debug_str_MACON4,ax
	UTILM_PRINT_NEWLINE

	mov		ah,MAMXFLH_REGISTER
	call	HW_READ_MAC_MII_REGISTER
	mov		ah,al
	UTILM_PRINT_BREG debug_str_MAMXFLH,ax
	UTILM_PRINT_NEWLINE
	
	mov		ah,MAMXFLL_REGISTER
	call	HW_READ_MAC_MII_REGISTER
	mov		ah,al
	UTILM_PRINT_BREG debug_str_MAMXFLL,ax
	UTILM_PRINT_NEWLINE

	mov		ah,MABBIPG_REGISTER
	call	HW_READ_MAC_MII_REGISTER
	mov		ah,al
	UTILM_PRINT_BREG debug_str_MABBIPG,ax
	UTILM_PRINT_NEWLINE

	mov		ah,MAIPGH_REGISTER
	call	HW_READ_MAC_MII_REGISTER
	mov		ah,al
	UTILM_PRINT_BREG debug_str_MAIPGH,ax
	UTILM_PRINT_NEWLINE
	
	mov		ah,MAIPGL_REGISTER
	call	HW_READ_MAC_MII_REGISTER
	mov		ah,al
	UTILM_PRINT_BREG debug_str_MAIPGL,ax
	UTILM_PRINT_NEWLINE

	mov		ah,MACLCON1_REGISTER
	call	HW_READ_MAC_MII_REGISTER
	mov		ah,al
	UTILM_PRINT_BREG debug_str_MACLCON1,ax
	UTILM_PRINT_NEWLINE
	
	mov		ah,MACLCON2_REGISTER
	call	HW_READ_MAC_MII_REGISTER
	mov		ah,al
	UTILM_PRINT_BREG debug_str_MACLCON2,ax
	UTILM_PRINT_NEWLINE

	mov		ah,BANK3
	call	HW_SET_CONTROLLER_BANK 

	mov		ah,MAADR1_REGISTER
	call	HW_READ_MAC_MII_REGISTER
	mov		ah,al
	UTILM_PRINT_BREG debug_str_MAADR1,ax
	UTILM_PRINT_NEWLINE
	
	mov		ah,MAADR2_REGISTER
	call	HW_READ_MAC_MII_REGISTER
	mov		ah,al
	UTILM_PRINT_BREG debug_str_MAADR2,ax
	UTILM_PRINT_NEWLINE
	
	mov		ah,MAADR3_REGISTER
	call	HW_READ_MAC_MII_REGISTER
	mov		ah,al
	UTILM_PRINT_BREG debug_str_MAADR3,ax
	UTILM_PRINT_NEWLINE
	
	mov		ah,MAADR4_REGISTER
	call	HW_READ_MAC_MII_REGISTER
	mov		ah,al
	UTILM_PRINT_BREG debug_str_MAADR4,ax
	UTILM_PRINT_NEWLINE
	
	mov		ah,MAADR5_REGISTER
	call	HW_READ_MAC_MII_REGISTER
	mov		ah,al
	UTILM_PRINT_BREG debug_str_MAADR5,ax
	UTILM_PRINT_NEWLINE
	
	mov		ah,MAADR6_REGISTER
	call	HW_READ_MAC_MII_REGISTER
	mov		ah,al
	UTILM_PRINT_BREG debug_str_MAADR6,ax
	UTILM_PRINT_NEWLINE
	ret
HW_VERIFY_CONTROLLER_MAC ENDP
ENDIF

HW_SETUP_CONTROLLER_PHY PROC NEAR
	push	bx ; Preserve BX
	; 0.) Confirm PHY is not in reset
HW_SETUP_CONTROLLER_PHY_LOOP:
	mov		ah,PHCON1_REGISTER
	call	HW_READ_PHY_REGISTER ; returns AX
	test	ax,PHCON1_PRST_BIT ; 0 when done
	jnz		HW_SETUP_CONTROLLER_PHY_LOOP

	; 1.) Get current PHCON1_REGISTER (PHY) value
	mov		ah,PHCON1_REGISTER
	call	HW_READ_PHY_REGISTER ; returns AX
	
	; 2.) Set PHCON1_PDPXMD_BIT to 0 (Half-Duplex)
	and		ax,NOT PHCON1_PDPXMD_BIT

	; 3.) Write PHY value
	mov		bx,ax ; set value to BX
	mov		ah,PHCON1_REGISTER
	call	HW_WRITE_PHY_REGISTER
	
	; 4.) Get current PHCON2_REGISTER (PHY) value
	mov		ah,PHCON2_REGISTER
	call	HW_READ_PHY_REGISTER ; returns AX

	; 5.) Set PHCON2_HDLDIS_BIT to 1 to disable automatic loopback
	or		ax,PHCON2_HDLDIS_BIT
	
	; 6.) Write PHY value
	mov		bx,ax ; set value to BX
	mov		ah,PHCON2_REGISTER
	call	HW_WRITE_PHY_REGISTER
	
	pop		bx
IF DEBUG_VERIFY_PHY
	call	HW_VERIFY_CONTROLLER_PHY
ENDIF

	ret
HW_SETUP_CONTROLLER_PHY ENDP

IF DEBUG_VERIFY_PHY
HW_VERIFY_CONTROLLER_PHY PROC NEAR
	jmp		HW_VERIFY_CONTROLLER_PHY_T
	debug_str_PHCON1 db "PHCON1$" ; PHY
	debug_str_PHCON2 db "PHCON2$" ; PHY
HW_VERIFY_CONTROLLER_PHY_T:
	mov		ah,PHCON1_REGISTER
	call	HW_READ_PHY_REGISTER ; returns AX
	UTILM_PRINT_WREG debug_str_PHCON1,ax
	UTILM_PRINT_NEWLINE
	
	mov		ah,PHCON2_REGISTER
	call	HW_READ_PHY_REGISTER ; returns AX
	UTILM_PRINT_WREG debug_str_PHCON2,ax
	UTILM_PRINT_NEWLINE
	ret
HW_VERIFY_CONTROLLER_PHY ENDP
ENDIF

;; HAL Functions - exposed to the Packet Driver

;!! PROC
;!!		HAL_SEND_PKT
;!! Input
;!!		DS:SI = PCjr Memory containing packet
;!!		CX = packet_size
;!! Output
;!!		NONE
;!! Uses directly
;!!		AX 
;!! Calls
;!!		HW_WAIT_SEND_COMPLETE (destroys AX, DX, flags)
;!!		HW_SET_EWRPT (destroys AX, DX, flags, ETH:BANK)
;!!		WRITE_BUFFER_MEMORY_BYTE (destroys AX, DX, flags)
;!!		WRITE_BUFFER_MEMORY (destroys SI, AX, CX, DX, flags)
;!!		HW_SET_ETXST_ND
;!! Dependencies destroy
;!!		AX, DX, flags, ETH:BANK
;!! Directly preserves
;!!		SI, CX
;!! Total destroy
;!!		AX, DX, flags
HAL_SEND_PKT PROC NEAR

	;; 0.) Wait until previous send (if any) completes
	call	HW_WAIT_SEND_COMPLETE ; will loop until free

	;; 1.) Set Write Pointer
	mov		ax,TX_ADDRESS_START
	call	HW_SET_EWRPT
	
	;; 2.) Write Ethernet controller packet control byte
	mov		al,SEND_CTRL_BYTE
	call	HW_WRITE_BUFFER_MEMORY_BYTE ; expects AL to be the byte
	
	;; 3.) Write rest of packet to buffer
	push	si
	push	cx
	call	HW_WRITE_BUFFER_MEMORY
	pop		cx
	pop		si
	
	;; 4.) Tell card where and how big packet is and send it
	call	HW_SEND
	
	ret
HAL_SEND_PKT ENDP

;!! PROC
;!!		HAL_GET_PACKET_SIZE
;!! Input
;!!		NONE
;!! Output
;!!		AX = packet size
;!! Uses directly
;!!		AX
;!! Calls
;!!		HW_SET_ERDPT (AX, DX, flags, ETH:BANK) 
;!!		HW_READ_BUFFER_MEMORY_WORD (AX, DX, flags)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, DX, flags
HAL_GET_PACKET_SIZE PROC NEAR
	;; Set read pointer to beginning of memory
	mov		ax,RX_ADDRESS_START
	call	HW_SET_ERDPT
	;; First two bytes are "next packet pointer", discard those
	call	HW_READ_BUFFER_MEMORY_WORD
	;; Second two bytes are the size
	call	HW_READ_BUFFER_MEMORY_WORD
	push	ax ; Save packet size
	;; Discard 3rd 2 bytes (remainder of status) to align the pointer
	call	HW_READ_BUFFER_MEMORY_WORD
	pop		ax ; Return AX which now has the packet size
	ret
HAL_GET_PACKET_SIZE ENDP


; ES:DI has destination buffer
; CX has the length
;!! PROC
;!!		HAL_GET_PACKET_SIZE
;!! Input
;!!		ES:DI = destination buffer
;!!		CX = length
;!!		Assumes ERDPT is set
;!! Output
;!!		Packet copied to buffer
;!! Uses directly
;!!		NONE
;!! Calls
;!!		HW_READ_BUFFER_MEMORY_MEMORY (AX, CX, DI, DX, flags)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, DX, flags
HAL_RX PROC NEAR
	call	HW_READ_BUFFER_MEMORY
	ret
HAL_RX ENDP

;!! PROC
;!!		HAL_ENABLE_RX
;!! Input
;!!		NONE
;!! Output
;!!		NONE
;!! Uses directly
;!!		AX, BX, CX
;!! Calls
;!!		HW_SET_CONTROLLER_BANK (AX, DX, flags, BANK)
;!!		HW_READ_ETH_REGISTER (AX, DX, flags)
;!!		HW_BIT_FIELD_SET (AX, DX, flags)
;!!		HW_WRITE_REGISTER_LOW_HIGH (AX, BX, DX, flags)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		BX, CX
;!! Total destroy
;!!		AX, DX, flags, card state
HAL_ENABLE_RX PROC NEAR ; Page 43 / Section 7.2
	push	bx
	push	cx
	;; 1.) Ack all packets (we only process one at a time and dump the rest)
	mov		ah,BANK1
	call	HW_SET_CONTROLLER_BANK
	
	mov		ah,EPKTCNT_REGISTER; - BANK1
	call	HW_READ_ETH_REGISTER
	mov		cl,al
	test	cl,cl ; Test if currently zero
	jz		HAL_ENABLE_RX_CONT
	xor		ch,ch
HAL_ENABLE_RX_DEC_PKT_LOOP:
	mov		ax,(ECON2_REGISTER SHL 8) OR (ECON2_PKTDEC_BIT); (Any BANK)
	call	HW_BIT_FIELD_SET
	loop	HAL_ENABLE_RX_DEC_PKT_LOOP

HAL_ENABLE_RX_CONT:
	;; Reset read pointers
	mov		ah,BANK0
	call	HW_SET_CONTROLLER_BANK
	
		; Set RX buffer Start High/Low
	mov		ax,(ERXSTH_REGISTER SHL 8) OR ERXSTL_REGISTER
	mov		bx,RX_ADDRESS_START
	call	HW_WRITE_REGISTER_LOW_HIGH
		
		; Set RX Buffer End High/Low
	mov		ax,(ERXNDH_REGISTER SHL 8) OR ERXNDL_REGISTER
	mov		bx,RX_ADDRESS_END
	call	HW_WRITE_REGISTER_LOW_HIGH
	
		; Set Read Memory Pointers
	mov		ax,(ERXRDPTH_REGISTER SHL 8) OR ERXRDPTL_REGISTER
	mov		bx,RX_ADDRESS_START
	call	HW_WRITE_REGISTER_LOW_HIGH
	
	;; Clear Packet Interrupt flag
	mov		ax,(EIR_REGISTER SHL 8) OR EIR_PKTIF
	call	HW_BIT_FIELD_SET
	
	;; Enable card interrupt (EIE_REGISTER - ANY BANK)
	mov		ax,(EIE_REGISTER SHL 8) OR EIE_PKTIE OR EIE_INTIE
	call	HW_BIT_FIELD_SET
	
	;; Enable card receive (ECON1_REGISTER - ANY BANK)
	mov		ax,(ECON1_REGISTER SHL 8) OR ECON1_RXEN_BIT
	call	HW_BIT_FIELD_SET
	
	pop		cx
	pop		bx
	ret
HAL_ENABLE_RX ENDP

;!! PROC
;!!		HAL_DISABLE_RX
;!! Input
;!!		NONE
;!! Output
;!!		NONE
;!! Uses directly
;!!		AX
;!! Calls
;!!		HW_BIT_FIELD_CLEAR (AX, DX, flags)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		NONE
;!! Total destroy
;!!		AX, DX, flags, card state
HAL_DISABLE_RX PROC NEAR
	;; Disable card receive (ECON1_REGISTER - ANY BANK)
	mov		ax,(ECON1_REGISTER SHL 8) OR ECON1_RXEN_BIT
	call	HW_BIT_FIELD_CLEAR

	;; Disable card interrupt (EIE_REGISTER - ANY BANK)
	mov		ax,(EIE_REGISTER SHL 8) OR EIE_PKTIE OR EIE_INTIE
	call	HW_BIT_FIELD_CLEAR

	;; TODO: Wait until card is not receiving?

	ret
HAL_DISABLE_RX ENDP

;!! PROC
;!!		HAL_RESET
;!! Input
;!!		AH = Register
;!! Output
;!!		AL = Value
;!! Uses directly
;!!		AH
;!! Calls
;!!		TXRX_SOFT_RESET (AX, DX, flags, card state)
;!!		HW_READ_ETH_REGISTER (AX, DX, flags)
;!!		TXRX_CLEAR_MEMORY (AX, CX, DX, SI, flags, ETH:BANK)
;!! Dependencies destroy
;!!		AX, DX, flags
;!! Directly preserves
;!!		CX, SI
;!! Total destroy
;!!		AX, DX, flags, ETH:BANK, card state
HAL_RESET PROC NEAR
	push	cx
	push	si
	; 1.) Soft reset the card
	call	HW_SOFT_RESET
	; 2.) Wait until the card recovers
HAL_RESET_WAIT: ; Wait for reset to complete
	mov		ah,ESTAT_REGISTER; (ANY_BANK)
	call	HW_READ_ETH_REGISTER
	test	al,ESTAT_CLKRDY_BIT
	jz		HAL_RESET_WAIT ; Wait until Clock ready
	; 3.) Clear the card buffer memory
	call	HW_CLEAR_MEMORY ; Clear the controller's memory
	pop		si
	pop		cx
	ret
HAL_RESET ENDP

HAL_INIT PROC NEAR
	; Card Initialization
	call	HAL_RESET ; 1.) Reset
	call	HW_SETUP_CONTROLLER_BUFFERS ; 2.) Setup Send + Receive Buffers
	call	HW_SETUP_CONTROLLER_FILTERS ; 3.) Setup Receive filters
	call	HW_SETUP_CONTROLLER_MODE ; 4.) Not necessary since ECON2 is already in autoinc
	call	HW_SETUP_CONTROLLER_MAC ; 5.) Setup Media Access Control Layer
	call	HW_SETUP_CONTROLLER_PHY ; 6.) Setup Physical Layer 
	ret
HAL_INIT ENDP

