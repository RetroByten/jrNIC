TITLE jrNIC Program
PAGE 66,80 ; 66 lines per page, 80 characters/line

;; This program is intended to test connectivity to the jrNIC

%OUT Processing EQUATES...

;; jrNIC write controls
eth_write_cs_low			EQU 3ffh
eth_write_cs_high			EQU 3feh
eth_read_write_bit			EQU 3fdh

RCR_OPCODE					EQU 00h ; Read control register
RBM_OPCODE					EQU 01h ; Read Buffer memory
WCR_OPCODE					EQU 02h ; Write control register
WBM_OPCODE					EQU 03h ; Write Buffer memory
	BUFF_MEM_ARG			EQU 1Ah ; Read/Write buffer memory arg
BFS_OPCODE					EQU 04h ; Bit Field Set
BFC_OPCODE					EQU 05h ; Bit Field Clear
SRC_OPCODE					EQU 07h ; System Reset Command (soft reset)
	SRC_ARG						EQU 1Fh ; Arg for SRC reset

	
TX_ADDRESS_START 			EQU	0000h ; Start of memory
TX_ADDRESS_END				EQU 05FFh ; 1536 bytes (0-1535)
RX_ADDRESS_START			EQU 0600h ; 0x600 - 0x1FFF
RX_ADDRESS_END				EQU 1FFFh ; End of memory

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
ECON1_REGISTER			EQU 1Fh 
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


MAX_FRAME_LENGTH		EQU 1518 ; decimal bytes, 5EEh
B2BINTERPACKETGAP		EQU	12h ; Half-duplex, full would be 15h
NB2BINTERPACKETGAP		EQU 0C12h ; half-duplex


interrupt_vector_table_segment		EQU 0000h

int_modem					EQU 0Ch
int_modem_offset			EQU int_modem * 4
int_modem_segment			EQU int_modem_offset + 2

mask_modem_bit				EQU	10h; xxx1 xxxx; (to enable, invert + AND -> 1110 1111)
port_pic_cmd					EQU 20h ; 8259A PIC Command port
port_pic_data				EQU 21h ; 8259A PIC data port
	val_pic_eoi					EQU 20h ; 8259A PIC "End of Interrupt" value


int_keyboard				EQU 16h
	svc_read_key				EQU 00h
	

int_video						EQU	10h
	svc_video_write_char_tty	EQU	0Eh
	tty_page					EQU 00h

int_dos_21					EQU	21h
	svc_dos_print_str		EQU 09h
	svc_dos_terminate		EQU	4Ch
		val_dos_terminate_0	EQU 00h

%OUT Processing CODE Segment
CODESEG SEGMENT
	assume CS:CODESEG, DS:CODESEG, SS:CODESEG
ORG 100h
PROGRAM: ; Needed for COM to later terminate the program
jmp		MAIN

INCLUDE UTIL.ASM
INCLUDE	TXRX.ASM

;; EXAMPLE READ REG SEQUENCE
; CS_HIGH - safety
; CS_LOW - Initiate transaction
; mov	dx,eth_read_write_bit
; mov	ah,(rcr_opcode SHL 5) OR econ1_register ; set write byte
; TXRX_BYTE; returns bl = received byte
; mov	bh,bl ; save off received byte
; xor	ah,ah ; set dummy write byte, probably unnecessary
; TXRX_BYTE ; returns bl = received byte
; CS_HIGH - End transaction
; END: bh = dummy returned byte, bl = actual returned byte

msg_test_rd db "Testing READ_BYTE: $"
TEST_READ_BYTE PROC NEAR
	push	ax
	mov		ax,5AA5h ; test word
	call	CS_START
	call	TXRX_BYTE ; send the opcode+reg byte, al returned
	call	CS_END
	mov		ah,al
	UTIL_PRINT_REG_AS msg_test_rd
	pop		ax
	ret		
TEST_READ_BYTE ENDP

msg_rd_estat db "ESTAT_REG: $"
TEST_RD_ESTAT PROC NEAR
	push	ax
	mov		ah,ESTAT_REGISTER
	call	READ_ETH_REGISTER ; returns al = reg value
	mov		ah,al ; move returned byte to ah
	UTIL_PRINT_REG_AS msg_rd_estat
	pop		ax
	ret
TEST_RD_ESTAT ENDP


msg_rd_econ1 db "ECON1_REG: $"
TEST_BANK_SWAP PROC NEAR
	mov		ah,ECON1_REGISTER
	call	READ_ETH_REGISTER ; returns ah = reg value
	mov		al,ah ; move returned value
	UTIL_PRINT_REG_AS msg_rd_econ1
	and		al,NOT BANK_MASK
	or		al,BANK3 ; swap banks
	mov		ah,ECON1_REGISTER
	call	WRITE_REGISTER
	mov		ah,ECON1_REGISTER
	call	READ_ETH_REGISTER ; returns ah = reg value
	mov		ah,al ; move returned byte to ah
	UTIL_PRINT_REG_AS msg_rd_econ1
	ret
TEST_BANK_SWAP ENDP

msg_soft_reset db "SOFT RESET COMPLETE$"
SETUP_CONTROLLER_RESET PROC NEAR
	call	SOFT_RESET
	UTIL_PRINT_STRING msg_soft_reset
	call	UTIL_PRINT_NEWLINE
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
	call	UTIL_PRINT_NEWLINE
	
	; Debug ETXNDH/ETXNDL
	mov		ah,ETXNDH_REGISTER
	call	READ_ETH_REGISTER
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS ETXNDH_msg
	mov		ah,ETXNDL_REGISTER
	call	READ_ETH_REGISTER
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS ETXNDL_msg
	call	UTIL_PRINT_NEWLINE
	
	; Debug ERXSTH/ERXSTL
	mov		ah,ERXSTH_REGISTER
	call	READ_ETH_REGISTER
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS ERXSTH_msg
	mov		ah,ERXSTL_REGISTER
	call	READ_ETH_REGISTER
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS ERXSTL_msg
	call	UTIL_PRINT_NEWLINE
	
	; Debug ERXNDH,ERXNDL
	mov		ah,ERXNDH_REGISTER
	call	READ_ETH_REGISTER
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS ERXNDH_msg
	mov		ah,ERXNDL_REGISTER
	call	READ_ETH_REGISTER
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS ERXNDL_msg
	call	UTIL_PRINT_NEWLINE
	
	; Debug ERXRDPTH/ERXRDPTL
	mov		ah,ERXRDPTH_REGISTER
	call	READ_ETH_REGISTER
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS ERXRDPTH_msg
	mov		ah,ERXRDPTL_REGISTER
	call	READ_ETH_REGISTER
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS ERXRDPTL_msg
	call	UTIL_PRINT_NEWLINE
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
	call	WRITE_REGISTER

;TODO - this is from example, figure out what it means
;The pattern to match on is therefore
;Type     ETH.DST
;ARP      BROADCAST
;06 08 -- ff ff ff ff ff ff -> ip checksum for theses bytes=f7f9
;in binary these poitions are:11 0000 0011 1111
;This is hex 303F->EPMM0=0x3f,EPMM1=0x30
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


SETUP_CONTROLLER_MODE PROC NEAR
	; works from any bank
	push	ax
	mov		ax,(ECON2_REGISTER SHL 8) OR ECON2_AUTOINC_MASK ;; This is the default
	call	BIT_FIELD_SET
	pop		ax
	ret
SETUP_CONTROLLER_MODE ENDP

ECON2_msg db "ECON2: $"
VERIFY_CONTROLLER_MODE PROC NEAR
	push	ax
	; works from any bank
	mov		ah,ECON2_REGISTER
	call	READ_ETH_REGISTER
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS ECON2_msg
	call UTIL_PRINT_NEWLINE
	pop		ax
	ret
VERIFY_CONTROLLER_MODE ENDP


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
	call UTIL_PRINT_NEWLINE

	; Debug EPMM0/EPPM1
	mov		ah,EPMM0_REGISTER
	call	READ_ETH_REGISTER
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS EPMM0_msg
	mov		ah,EPMM1_REGISTER
	call	READ_ETH_REGISTER
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS EPMM1_msg
	call UTIL_PRINT_NEWLINE
	
	; Debug EPMCSH/EPMCSL
	mov		ah,EPMCSH_REGISTER
	call	READ_ETH_REGISTER
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS EPMCSH_msg
	mov		ah,EPMCSL_REGISTER
	call	READ_ETH_REGISTER
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS EPMCSL_msg
	call UTIL_PRINT_NEWLINE
	pop		ax
	ret
VERIFY_CONTROLLER_FILTERS ENDP

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
	mov		al,MAC_ADDRESS[0]
	call	WRITE_REGISTER

	mov		ah,MAADR2_REGISTER
	mov		al,MAC_ADDRESS[1]
	call	WRITE_REGISTER
	
	mov		ah,MAADR3_REGISTER
	mov		al,MAC_ADDRESS[2]
	call	WRITE_REGISTER

	mov		ah,MAADR4_REGISTER
	mov		al,MAC_ADDRESS[3]
	call	WRITE_REGISTER

	mov		ah,MAADR5_REGISTER
	mov		al,MAC_ADDRESS[4]
	call	WRITE_REGISTER
	
	mov		ah,MAADR6_REGISTER
	mov		al,MAC_ADDRESS[5]
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
	call UTIL_PRINT_NEWLINE
	
	; Debug MAMXFLH / MAMXFLL
	mov		ah,MAMXFLH_REGISTER
	call	READ_MAC_MII_REGISTER
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS MAMXFLH_msg
	mov		ah,MAMXFLL_REGISTER
	call	READ_MAC_MII_REGISTER
	mov		ah,al ; move value to ah
	UTIL_PRINT_REG_AS MAMXFLL_msg
	call UTIL_PRINT_NEWLINE
	
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
	call UTIL_PRINT_NEWLINE
	
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
	call UTIL_PRINT_NEWLINE
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
	call UTIL_PRINT_NEWLINE
	ret
VERIFY_CONTROLLER_PHY ENDP

SETUP_CONTROLLER_INT PROC NEAR
	;; Need to only enable for Receive
	; Need to disable when about to transmit;
	
	;; Worst case scenario 1:
	; App initiates transmit Packet
	; During transmit, packet is received
	; Received packet is handed to App
	; app immediately tries to transmit
	;  -- will disable receive interrupt on entry so at least we can finish the transmit
	;  -- but that doesn't mean we can garantee clearing the stack
	; 

	; Worst case scenario 2:
	; We receive a packet, interrupt, notify App
	; it attempts to transmit before the receive finishes
	
	
	;; If we're fully stateless - it may not be possbile to note a receive operation is in flight
	; We may "always" disable receive interrupt, can use that as a flag to say "something"
	; is in progress, therefore just fail the caller
	push	ax
	push	bx
	; Clear LINKIF
	mov		ah,PHIR_REGISTER
	call	READ_PHY_REGISTER
	
	; Set PHIE.PLNKIE + PHIE.PGEIE
	mov		ah,PHIE_REGISTER
	mov		bx,(PHIE_PLNKIE OR PHIE_PGEIE)
	call	WRITE_PHY_REGISTER
	
	; Enable interrupt for LINKIF
	mov		ax,(EIE_REGISTER SHL 8) OR (EIE_INTIE OR EIE_LINKIE)
	call	WRITE_REGISTER
	pop		bx
	pop		ax
	ret
SETUP_CONTROLLER_INT ENDP

SETUP_PCJR_INT PROC NEAR
	push	ax
	push	es
		
	; Save IRQ4 mask - will be used to restore setup
	in		al,port_pic_data ; Read in interrupt controller mask reg
	mov		[OLD_INT_MASK],al
	
	; Mask IRQ 4 prior to changing it
	or		al,mask_modem_bit ; 0001 0000 setup mask 
	out		port_pic_data,al ; write interrupt controller mask reg to mask modem
	
	; Setup es to point at the interrupt vector table
	mov		ax,interrupt_vector_table_segment
	mov		es,ax
	
	; Save old Interrupt
	mov		ax,es:[int_modem_offset]
	mov		[OLD_INT_OFFSET],ax
	mov		ax,es:[int_modem_segment]
	mov		[OLD_INT_SEGMENT],ax
	
	; Set Receive interrupt
	mov		ax,offset PCJR_RECV_INT
	mov		es:[int_modem_offset],ax ; Set Modem Interrupt Offset
	mov		ax,cs ; Save off Segment
	mov		es:[int_modem_segment],ax ; Set Modem interrupt Segment
	
	; And unmask IRQ4
	in		al,port_pic_data ; Read in interrupt controller mask reg
	mov		ah,NOT mask_modem_bit ; 1110 1111 setup mask clear
	and		al,ah ; Clear modem port interrupt bit
	out		port_pic_data,al ; write interrupt controller mask reg to unmask modem
	
	pop		es ; restore ES
	pop		ax
	
	
	ret
SETUP_PCJR_INT ENDP

CLEANUP_PCJR_INT PROC NEAR
	; this should mask IRQ4
	in		al,port_pic_data
	mov		ah,mask_modem_bit ; 0001 0000
	or		al,ah
	out		port_pic_data,al
	; and reset the interrupt vector to D_EOI
	;; TODO LATER...
	ret
CLEANUP_PCJR_INT ENDP

inter_msg db "Interrupt triggered...",0dh,0ah,"$"
PCJR_RECV_INT PROC FAR ;; This is the receive interrupt
	; Interrupts are disabled now...
	
	
	; this should clear the interrupt on the eth controller
	; clear the interrupt on the PCjr (IRQ4, Interrupt vector 0Ch )
	; and print
	
	; MUST SAVE *ALL* REGS used through all calls
	sti ; re-enable interrupts
	push	ax
	push	ds
	push	dx
	mov		ax,cs
	mov		ds,ax
	UTIL_PRINT_STRING inter_msg
	
	; Read PHIR_Register to clear LINKIF
	mov		dx,eth_read_write_bit
	mov		ah,PHIR_REGISTER
	call	READ_PHY_REGISTER
	pop		dx	
	pop		ds
	; Ack interrupt
	mov		al,val_pic_eoi
	out		port_pic_cmd,al ; Ack hardware Interrupt
	pop		ax
	iret
PCJR_RECV_INT ENDP


TW_msg db "Test write buffer...$"
TW_msg1 db "Setting Bank...$"
TW_msg2 db "Setting EWRPT...$"
TW_msg3 db "Writing buffer memory...$"

TEST_WRITE_BUFFER PROC NEAR
	; BX = PCjr Memory pointer
	; CX = number of bytes to send
	; Assumes autoinc in ECON2 is set
	; Assumes EWRPT H/L is pointing to the beginning of TX memory!
	push	ax
	push	bx
	push	cx
	
	UTIL_PRINT_STRING TW_msg
	call UTIL_PRINT_NEWLINE
	
	; 1. Set bank for EWRPT
	; bank0
	UTIL_PRINT_STRING TW_msg1
	call UTIL_PRINT_NEWLINE
	mov		ah,BANK0
	call	SET_CONTROLLER_BANK
	
	; 2. Set EWRPT
	UTIL_PRINT_STRING TW_msg2
	call UTIL_PRINT_NEWLINE
	mov		ax,(EWRPTH_REGISTER SHL 8) OR EWRPTL_REGISTER
	mov		bx,TX_ADDRESS_START
	call	WRITE_REGISTER_LOW_HIGH
	
	;3.) Write buffered memory
	UTIL_PRINT_STRING TW_msg3
	call UTIL_PRINT_NEWLINE
	mov		bx,offset DATA_BUFFER1
	mov		cx,4
	call	WRITE_BUFFER_MEMORY
	pop		cx
	pop		bx
	pop		ax
	ret
TEST_WRITE_BUFFER ENDP

TR_msg db "Test read buffer: $"
TR_msg1 db "Setting Bank...$"
TR_msg2 db "Setting ERDPT...$"
TR_msg3 db "Reading buffered memory...$"
TR_msg4 db "Printing result...$"
TEST_READ_BUFFER PROC NEAR
	; BX PCjr Memory pointer
	; CX Number of bytes to receive
	; Assumes ERDPT is pointing to the beginning of RX memory!
	push	ax
	push	bx
	push	cx
	UTIL_PRINT_STRING TR_msg
	call UTIL_PRINT_NEWLINE

	; 1.) Set bank for ERDPTmamain
	UTIL_PRINT_STRING TR_msg1
	call UTIL_PRINT_NEWLINE
	mov		ah,BANK0
	call	SET_CONTROLLER_BANK
	
	; 2. Set ERDPT
	UTIL_PRINT_STRING TR_msg2
	call UTIL_PRINT_NEWLINE
	mov		ax,(ERDPTH_REGISTER SHL 8) OR ERDPTL_REGISTER
	mov		bx,TX_ADDRESS_START
	call	WRITE_REGISTER_LOW_HIGH

	;3.) Read buffered memory
	UTIL_PRINT_STRING TR_msg3
	call UTIL_PRINT_NEWLINE
	mov		bx,offset DATA_BUFFER2
	mov		cx,4
	call	READ_BUFFER_MEMORY

	; 4.) Print buffered memory
	UTIL_PRINT_STRING TR_msg4
	call UTIL_PRINT_NEWLINE
	mov		cx,4
	mov		bx,offset DATA_BUFFER2
TRLOOP:
	mov		ah,[bx]
	call UTIL_PRINT_BYTE
	call UTIL_PRINT_NEWLINE
	inc		bx
	loop	TRLOOP
	
	
	pop		cx
	pop		bx
	pop		ax
	ret
TEST_READ_BUFFER ENDP
	

;; TODO List
; 1.) Set autoinc of econ2 - CONTROLLER_MODE - not Needed
; 2.) Write Buffer memory function exists
; 3.) Read Buffer memory function exists

TSP_msg db "Testing packet send...$"
TEST_SEND_PACKET PROC NEAR
	push	ax
	push	bx
	push	cx
	UTIL_PRINT_STRING TSP_msg
	call UTIL_PRINT_NEWLINE
	
	; 1. Set bank for EWRPT
	; bank0
	mov		ah,BANK0
	call	SET_CONTROLLER_BANK
	
	; 2. Set EWRPT
	mov		ax,(EWRPTH_REGISTER SHL 8) OR EWRPTL_REGISTER
	mov		bx,TX_ADDRESS_START
	call	WRITE_REGISTER_LOW_HIGH
	
	; 3.) Write Control byte
	mov		bx,offset SEND_CTRL_BYTE
	mov		cx,1
	call	WRITE_BUFFER_MEMORY
	
	; 4.) Write DEST address
	mov		bx,offset DEST_MAC
	mov		cx,6
	call	WRITE_BUFFER_MEMORY
	; 5.) Write SRC address
	mov		bx,offset MAC_ADDRESS
	mov		cx,6
	call	WRITE_BUFFER_MEMORY
	; 6.) Write Length address
	mov		bx,offset MAC_LEN
	mov		cx,2
	call	WRITE_BUFFER_MEMORY
	; 7.) Write data
	mov		bx,offset SEND_PKT_DATA
	mov		cx,4
	call	WRITE_BUFFER_MEMORY
	
	; 8.) Setup ETXST & ETXND
	mov	ax,(ETXSTH_REGISTER SHL 8) OR ETXSTL_REGISTER
	mov bx,TX_ADDRESS_START
	call	WRITE_REGISTER_LOW_HIGH
	
	mov	ax,(ETXNDH_REGISTER SHL 8) OR ETXNDL_REGISTER
	mov bx,TX_ADDRESS_START
	add	bx,4+2+6+6+1 ; all the bits
	call	WRITE_REGISTER_LOW_HIGH
	
	
	; 9.) Transmit by setting ECON1.TXRTS
	mov		ax,(ECON1_REGISTER SHL 8) OR ECON1_TXRTS_MASK
	call	BIT_FIELD_SET
	pop		cx
	pop		bx
	pop		ax
	ret
TEST_SEND_PACKET ENDP


press_key db "Press any key to exit...$"
MAIN PROC NEAR
	mov		ax,cs
	mov		ds,ax ; Setup DS
	
	; Used to test read all 0's / all 1's by tying CIPO to
	; 5V or ground
	;call TEST_READ_BYTE 
	;jmp EXIT2DOS
	
	;call	TEST_RD_ESTAT
	;call	TEST_BANK_SWAP
		
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

	call	SETUP_PCJR_INT
	
	
	;call	TEST_WRITE_BUFFER
	;call	TEST_READ_BUFFER
	call	TEST_SEND_PACKET
	
	UTIL_PRINT_STRING press_key
	call UTIL_PRINT_NEWLINE
	
	; Plug and unplug cable at will
	
	mov		ah,svc_read_key
	int		int_keyboard

	call	CLEANUP_PCJR_INT

EXIT2DOS:
	mov		ax,(svc_dos_terminate SHL 8) OR val_dos_terminate_0 
	int		int_dos_21 ;; EXIT to DOS
HALT:
	jmp		HALT ; In case DOS somehow doesn't end the program, should never reach
MAIN ENDP

OLD_INT_SEGMENT dw 0000h
OLD_INT_OFFSET dw 0000h
OLD_INT_MASK	db 00h

IP_ADDRESS db 10,0,0,2

DATA_BUFFER1 db 0AAh, 055h, 0AAh, 055h
DATA_BUFFER2 db 00h, 00h, 00h, 00h

SEND_CTRL_BYTE db 00h
MAC_LEN db 00,64 ; 64
DEST_MAC db 00h,01h,02h,03h,04h,05h ; Insert your destination MAC here
MAC_ADDRESS	db 00h,03h,01h,04h,01h,05h ; Made up source MAC

SEND_PKT_DATA db "HOLA"

;; Control Packet

;; Ethernet Frame Packet header
;    6 - Destination address
;    6 - Source address
;    2 - Type/Length
;    XX - data
;    


CODESEG ENDS
END PROGRAM
