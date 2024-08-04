TITLE jrNIC Test Packet Driver Program 10
PAGE 66,80 ; 66 lines per page, 80 characters/line

%OUT Processing DRV EQUATES...
interrupt_vector_table_segment		EQU 0000h
int_dos_21					EQU	21h
    svc_dos_print_char		EQU 02h
	svc_dos_print_str		EQU 09h
	svc_dos_keep_resident	EQU 31h
		val_dos_terminate_0		EQU 00h
int_packet_driver			EQU 60h
	int_packet_driver_offset	EQU int_packet_driver * 4
	int_packet_driver_segment	EQU int_packet_driver_offset + 2
int_modem					EQU 0Ch ; Interrupt for the modem port
	int_modem_offset			EQU int_modem * 4
	int_modem_segment			EQU int_modem_offset + 2

mask_modem_bit				EQU	10h; xxx1 xxxx; (to enable, invert + AND -> 1110 1111)
port_pic_cmd				EQU 20h ; 8259A PIC Command port
port_pic_data				EQU 21h ; 8259A PIC data port
	val_pic_eoi					EQU 20h ; 8259A PIC "End of Interrupt" value

;; Packet Driver Error Codes
BAD_HANDLE		EQU 1	;1	BAD_HANDLE	Invalid handle number,
NO_CLASS		EQU 2	;2	NO_CLASS	No interfaces of specified class found,
NO_TYPE			EQU 3	;3	NO_TYPE		No interfaces of specified type found,
NO_NUMBER		EQU 4	;4	NO_NUMBER	No interfaces of specified number found,
BAD_TYPE		EQU 5	;5	BAD_TYPE	Bad packet type specified,
NO_MULTICAST	EQU 6	;6	NO_MULTICAST	This interface does not support multicast,
CANT_TERMINATE	EQU 7	;7	CANT_TERMINATE	This packet driver cannot terminate,
BAD_MODE		EQU 8	;8	BAD_MODE	An invalid receiver mode was specified,
NO_SPACE		EQU 9	;9	NO_SPACE	Operation failed because of insufficient space,
TYPE_INUSE		EQU 10	;10	TYPE_INUSE	The type had previously been accessed,
						;			and not released,
BAD_COMMAND		EQU 11	;11	BAD_COMMAND	The command was out of range, or not implemented,
CANT_SEND		EQU 12	;12	CANT_SEND	The packet couldn't be sent (usually hardware error),
CANT_SET		EQU 13	;13	CANT_SET	Hardware address couldn't be changed
						;			(more than 1 handle open),
BAD_ADDRESS		EQU 14	;14	BAD_ADDRESS	Hardware address has bad length or format,
CANT_RESET		EQU 15	;15	CANT_RESET	Couldn't reset interface (more than 1 handle open).

%OUT Processing DRV CODE Segment
CODESEG SEGMENT
	assume CS:CODESEG, DS:CODESEG, SS:CODESEG
ORG 100h
PROGRAM: ; Needed for COM to later terminate the program
jmp		MAIN
dbg_welcome_msg db "Hola Mundo! Packet Driver Invoked!$"
DRV_PKT_VERSION EQU 10
DRV_IFCLASS EQU 1
DRV_IFTYPE EQU 0FFFFh
DRV_IFNUM EQU 0
DRV_NAME db "jrNIC$",0
DRV_FUNC EQU 1

MAC_ADDRESS_TABLE LABEL BYTE
	db 00h, 03h, 01h, 04h, 01h, 05h ; Default made up source MAC address
MAC_ADDRESS_TABLE_L EQU $-MAC_ADDRESS_TABLE




;; This a printable message to denote when the the packet driver handler was called
UTIL_PRINT_STR MACRO str ; TODO replace UTILS with BIOS compatible ones
	push	dx
	push	ax
	push	ds
	mov		ax,cs
	mov		ds,ax ; Setup DS
	mov		dx,offset str
	mov		ah,svc_dos_print_str
	int		int_dos_21 ; Print the welcome message
	pop		ds
	pop		ax
	pop		dx
ENDM
UTIL_PRINT_NEWLINE MACRO
	UTIL_PRINT_CHAR 0Dh
	UTIL_PRINT_CHAR 0Ah
ENDM
UTIL_PRINT_CHAR MACRO chr
	push	dx
	push	ax
	mov		dl,chr
	mov		ah,svc_dos_print_char
	int		int_dos_21
	pop		ax
	pop		dx
ENDM
UTIL_PRINT_HEX MACRO nibbles
	push	cx
	mov		cx,nibbles ; number of nibbles starting from ah high nibble
	call	UTIL_PRINT_HEX_NIBBLES
	pop		cx
ENDM
UTIL_PRINT_HEX_NIBBLES PROC NEAR
	; CX = # Of nibbles to print
	; AX = 1-4 nibbles to print from AH high -> AL Low
	push	dx
	push	ax
UTIL_PRINT_HEX_NIBBLES_LOOP:
	rol		ax,1 ; Grab the highest nibble by Rotating left 4x into al low nibble
	rol		ax,1 ;
	rol		ax,1 ;
	rol		ax,1 ; 
	push	ax ; Save off the Nth rotated AX
	and		al,0Fh ; Isolate the nibble
	add		al,'0' ; Shift into the ASCII Numeric Range
	cmp		al,'9' ; Check if <= 9
	jle		UTIL_PRINT_HEX_NIBBLES_CONT
	add		al,'A'-'9'-1 ; If not, shift up to ASCII 'A' range
UTIL_PRINT_HEX_NIBBLES_CONT:
	mov		dl,al ; character to print
	mov		ah,svc_dos_print_char ; Select DOS Character Output service
	int		int_dos_21 ; Print current character
	pop		ax ; Restore Nth rotated AX
	loop	UTIL_PRINT_HEX_NIBBLES_LOOP ; dec CX until 0
	pop		ax
	pop		dx
	ret
UTIL_PRINT_HEX_NIBBLES ENDP

dbg_dump_ax db "AX: $"
dbg_dump_bx db "BX: $"
dbg_dump_cx db "CX: $"
dbg_dump_dx db "DX: $"
dbg_dump_ds db "DS: $"
dbg_dump_si db "SI: $"
dbg_dump_es db "ES: $"
dbg_dump_di db "DI: $"
UTIL_DUMP_REGS PROC NEAR
	push	ax ; preserve ax
	UTIL_PRINT_NEWLINE
	UTIL_PRINT_STR dbg_dump_ax ; Print welcome
	UTIL_PRINT_HEX 4 ; Print 4 hex nibbles of AH
	UTIL_PRINT_NEWLINE ; Print a newline to clean it up
	mov		ax,bx
	UTIL_PRINT_STR dbg_dump_bx ; Print welcome
	UTIL_PRINT_HEX 4 ; Print 4 hex nibbles of AH
	UTIL_PRINT_NEWLINE ; Print a newline to clean it up
	mov		ax,cx
	UTIL_PRINT_STR dbg_dump_cx ; Print welcome
	UTIL_PRINT_HEX 4 ; Print 4 hex nibbles of AH
	UTIL_PRINT_NEWLINE ; Print a newline to clean it up
	mov		ax,dx
	UTIL_PRINT_STR dbg_dump_dx ; Print welcome
	UTIL_PRINT_HEX 4 ; Print 4 hex nibbles of AH
	UTIL_PRINT_NEWLINE ; Print a newline to clean it up
	mov		ax,ds
	UTIL_PRINT_STR dbg_dump_ds ; Print welcome
	UTIL_PRINT_HEX 4 ; Print 4 hex nibbles of AH
	UTIL_PRINT_NEWLINE ; Print a newline to clean it up
	mov		ax,si
	UTIL_PRINT_STR dbg_dump_si ; Print welcome
	UTIL_PRINT_HEX 4 ; Print 4 hex nibbles of AH
	UTIL_PRINT_NEWLINE ; Print a newline to clean it up
	mov		ax,es
	UTIL_PRINT_STR dbg_dump_es ; Print welcome
	UTIL_PRINT_HEX 4 ; Print 4 hex nibbles of AH
	UTIL_PRINT_NEWLINE ; Print a newline to clean it up
	mov		ax,di
	UTIL_PRINT_STR dbg_dump_di ; Print welcome
	UTIL_PRINT_HEX 4 ; Print 4 hex nibbles of AH
	UTIL_PRINT_NEWLINE ; Print a newline to clean it up
	pop		ax;
	ret
UTIL_DUMP_REGS ENDP

UTIL_PRINT_REG_AS MACRO str
	UTIL_PRINT_STR str
	UTIL_PRINT_HEX 2
	UTIL_PRINT_NEWLINE
ENDM

UTIL_PRINT_WREG_AS MACRO str
	UTIL_PRINT_STR str
	UTIL_PRINT_HEX 4
	UTIL_PRINT_NEWLINE
ENDM

INCLUDE TXRX10.ASM ;; LOW LEVEL HW FUNCTIONS


SVC_00 PROC NEAR ; ERROR, BAD COMMAND, Redirect all bad commands here
	pop		si
	mov		dh,BAD_COMMAND
	stc
	jmp		SVC_RET
SVC_00 ENDP
SVC_01 PROC NEAR
	pop		si
	
	push	ax ; store AH
	mov		ax,cs
	mov		ds,ax ; Set DS
	mov		si,offset DRV_NAME ; Point SI to the driver name
	mov		bx,DRV_PKT_VERSION
	mov		ch,DRV_IFCLASS
	mov		dx,DRV_IFTYPE
	mov		cl,DRV_IFNUM
	pop		ax ; restore AH
	mov		al,DRV_FUNC

	clc				; Always return good
	jmp		SVC_RET
SVC_01 ENDP
SVC_02 PROC NEAR  ; access_type
	pop		si
SVC_02_CHK_IFCLASS:
	cmp		al,DRV_IFCLASS ; IFCLASS = 1
	je		SVC_02_CHK_IFTYPE
	mov		dh,NO_CLASS
	jmp		SVC_02_BAD
SVC_02_CHK_IFTYPE:
	cmp		bx,DRV_IFTYPE ; IFTYPE = wildcard
	je		SVC_02_CHK_IFNUM
	mov		dh,NO_TYPE
	jmp		SVC_02_BAD
SVC_02_CHK_IFNUM:
	cmp		dl,DRV_IFNUM ; IFNUM = 0, 1st interface
	je		SVC_02_CHK_TYPLEN
	mov		dh,NO_NUMBER
	jmp		SVC_02_BAD
SVC_02_CHK_TYPLEN:
	cmp		cx,0000h ; TYPELEN = 0, match any packet
	je		SVC_02_CHK_INUSE
	mov		dh,BAD_TYPE
	jmp		SVC_02_BAD
SVC_02_CHK_INUSE:
	push	ds
	push	ax
	mov		ax,cs
	mov		ds,ax
	cmp		[data_receiver_handle],0000h ; check if not in use by a previous application
	pop		ax
	pop		ds
	je		SVC_02_CHK_COMPLETE
	mov		dh,TYPE_INUSE
	jmp		SVC_02_BAD
SVC_02_CHK_COMPLETE:
	;; At this point, we're good
	;; Need to save the receiver and set the handle
	push	ds
	mov		ax,cs
	mov		ds,ax
	mov		ax,es
	mov		[data_receiver_segment],ax ; save receiver segment
	mov		[data_receiver_offset],di ; save receiver offset
	mov		ax,0001h ; in-use indicator
	mov		[data_receiver_handle],ax
	call	TXRX_ENABLE_RX
	call	TXRX_ACK_PKT ; safety call to reset addresses
	;call	TXRX_ENABLE_RX ; Enable reception
	pop		ds ; fall through to good
SVC_02_GOOD:
	clc
	jmp		SVC_02_DONE
SVC_02_BAD:
	call	UTIL_DUMP_REGS ; debug
	stc
SVC_02_DONE:
	jmp		SVC_RET
SVC_02 ENDP
SVC_03 PROC NEAR
	pop		si
	
	push	ds
	push	ax
	mov		ax,cs
	mov		ds,ax ; set DS
SVC_03_CHK_VALID:
	cmp		bx,0001h ; only valid possible handle
	je		SVC_03_CHK_INUSE
	mov		dh,BAD_HANDLE; else bad handle
	jmp		SVC_03_BAD
SVC_03_CHK_INUSE:
	cmp		[data_receiver_handle],bx ; check if BX is the current active handle
	je		SVC_03_RELEASE
	mov		dh,BAD_HANDLE; else bad handle
	jmp		SVC_03_BAD
SVC_03_RELEASE:
	call	TXRXH_RESET ; reset the adapter ;; HACK, TODO FIX
	mov		[data_receiver_handle],0000h ; Free current handle
SVC_03_GOOD:
	clc
	jmp		SVC_03_DONE
SVC_03_BAD:
	call	UTIL_DUMP_REGS ; debug
	stc
SVC_03_DONE:
	pop		ax
	pop		dx
	jmp		SVC_RET
SVC_03 ENDP
SVC_04 PROC NEAR
	pop		si
	
	;push	ds
	;push	ax
	;mov		ax,cs
	;mov		ds,ax
	
	;cmp		cx,1400 ; arbitrary max packet size for now
	;jae		SVC_04_BAD

	;; Send the Packet
	call	TXRX_SENDPKT
	jc		SVC_04_BAD ; if carry is set, couldn't sends
SVC_04_GOOD: ; otherwise we sent
	clc
	jmp		SVC_04_DONE
SVC_04_BAD:
	call	UTIL_DUMP_REGS ; debug	
	mov		dh,CANT_SEND
	stc
SVC_04_DONE:
	;pop		ax
	;pop		ds
	jmp		SVC_RET
SVC_04 ENDP
SVC_05 PROC NEAR
	pop		si
	mov		dh,BAD_HANDLE
	stc
	jmp		SVC_RET
SVC_05 ENDP
SVC_06 PROC NEAR
	pop		si
	push	ds
	push	ax
	mov		ax,cs
	mov		ds,ax
	cmp		bx,0001h ; only valid possible handle
	je		SVC_06_CHK_INUSE
	mov		dh,BAD_HANDLE; else bad handle
	jmp		SVC_06_BAD
SVC_06_CHK_INUSE:
	cmp		[data_receiver_handle],bx ; check if BX is the current active handle
	je		SVC_06_CHK_MAC_SP
	mov		dh,BAD_HANDLE; else bad handle
	jmp		SVC_06_BAD
SVC_06_CHK_MAC_SP:
	; Our MAC address is 6 bytes, make sure the caller allocated enough space
	cmp		cx,MAC_ADDRESS_TABLE_L ; 6 bytes
	jae		SVC_06_GOOD ; if cx < 6, not enough space!
	mov		dh,NO_SPACE
	jmp		SVC_06_BAD
SVC_06_GOOD:
	push	si
	mov		si, offset MAC_ADDRESS_TABLE ; DS is already set, set SI to offset of the mac address
	mov		cx,MAC_ADDRESS_TABLE_L ; Count = number of MAC address bytes
	rep		movsb ; Copy MAC address from DS:SI to ES:DI
	pop		si
	mov		cx,MAC_ADDRESS_TABLE_L ; Set MAC length for caller
	clc		; Set good return
	jmp		SVC_06_DONE
SVC_06_BAD:
	call	UTIL_DUMP_REGS ; debug
	stc		; Set bad return
SVC_06_DONE:
	pop		ax
	pop		ds
	jmp		SVC_RET
SVC_06 ENDP
SVC_07 PROC NEAR ; Reset
	pop		si
	
	push	ds
	push	ax
	mov		ax,cs
	mov		ds,ax ; set DS
SVC_07_CHK_VALID:
	cmp		bx,0001h ; only valid possible handle
	je		SVC_07_CHK_INUSE
	mov		dh,BAD_HANDLE; else bad handle
	jmp		SVC_07_BAD
SVC_07_CHK_INUSE:
	cmp		[data_receiver_handle],bx ; check if BX is the current active handle
	je		SVC_07_GOOD
	mov		dh,BAD_HANDLE; else bad handle
	jmp		SVC_07_BAD
SVC_07_GOOD:
	call	TXRXH_RESET;; TX RX High level FUNCTION!
	clc		; Set good return
	jmp		SVC_07_DONE
SVC_07_BAD:
	call	UTIL_DUMP_REGS ; debug
	stc		; Set bad return
SVC_07_DONE:
	pop		ax
	pop		ds
	jmp		SVC_RET
SVC_07 ENDP



INT_SVC_TABLE LABEL WORD
	dw		OFFSET SVC_00 ; Error
	dw		OFFSET SVC_01
	dw		OFFSET SVC_02 ; access_type
	dw		OFFSET SVC_03
	dw		OFFSET SVC_04
	dw		OFFSET SVC_05
	dw		OFFSET SVC_06
	dw		OFFSET SVC_07
INT_SVC_TABLE_L EQU $-INT_SVC_TABLE ; Length of table

;; This is the packet driver handler function that mTCP will call
INT_PKT_HANDLER PROC FAR
	jmp	INT_PKT_HANDLER_START
	pkt_signature db "PKT DRVR",00h
INT_PKT_HANDLER_START:
	; Interrupts are disabled now...
	sti				; Enable hardware interrupts to not block timers, etc.
;; INT_CODE_HERE_START
	UTIL_PRINT_STR dbg_welcome_msg ; Print welcome
	UTIL_PRINT_CHAR ':' ; Print a ascii colon 
	UTIL_PRINT_HEX 2 ; Print 2 hex nibbles of AH
	UTIL_PRINT_NEWLINE ; Print a newline to clean it up
	push	si		; Save SI
	push	ax		; Save AL
	mov		al,ah	; move SVC to AL
	xor		ah,ah	; set AH to 0
	sal		ax,1	; svc * 2 = INT_SVC_TABLE entry
	mov		si,ax	; SI = INT_SVC_TABLE entry
	pop		ax		; Restore AL
	cmp		si,INT_SVC_TABLE_L ; ensure entry is valid
	jb		EXECUTE_COMMAND ; 	
	xor		si,si	; Otherwise, set SI to 0 to force bad command handler
EXECUTE_COMMAND:
	jmp	WORD PTR CS:[SI + OFFSET INT_SVC_TABLE]
SVC_RET:
	;; Stack is currently only holding FLAGS, SEGMENT, OFFSET
	push	bp ; we need to use the BP, so add that to the Stack
	mov		bp, sp ; get bp
	jc		RET_BAD ; if carry was set by the function, we need to set the true carry
RET_GOOD:				; else we need to clear the carry flag
	and		word ptr ss:[bp+6],0FFFEh
	jmp		INT_EXIT
RET_BAD:
	or		word ptr ss:[bp+6],0001h
;; INT_CODE_HERE_DONE
INT_EXIT:
	pop			bp
	iret
INT_PKT_HANDLER ENDP

inter_msg db "Interrupt triggered...",0dh,0ah,"$"
inter_msg_handle db "HANDLE",0dh,0ah,"$"
inter_msg_ack db "ACK",0dh,0ah,"$"
inter_msg_cnt db "Count: $"
inter_msg_es db "ES: $"
inter_msg_di db "DI: $"
INT_PKT_RECV PROC FAR ;; This is the receive interrupt
	; Interrupts are disabled now...

	; this should clear the interrupt on the eth controller
	; clear the interrupt on the PCjr (IRQ4, Interrupt vector 0Ch )
	; and print
	sti ; re-enable interrupt
	push	ax ; we're going to use this
	
	;UTIL_PRINT_STR inter_msg
	
	;; Disable ability to receive further packets
	call	TXRX_DISABLE_RX	;; API provided by TXRX
	
	;; Disable global controller interrupts while servicing
	call	TXRX_DISABLE_GLOBAL_INT ;; API provided by TXRX
	;; If we use multiple interrupts, we would need to pole which one flag by flag
		
	;; Check if an application is listening
INT_PKT_RECV_CHK:
	push	ds
	mov		ax,cs
	mov		ds,ax ; set DS
	cmp		[data_receiver_handle],0000h ; check if it's valid
	je		INT_PKT_RECV_SHORT ; invalid
	jmp		INT_PKT_RECV_CONT
INT_PKT_RECV_SHORT:
	jmp		INT_PKT_RECV_CHK_CO
INT_PKT_RECV_CONT:
	;UTIL_PRINT_STR inter_msg_handle
; valid handle
	;; TODO make this a function call inside the packet driver
	;; Determine packet size
	; Set controller read pointer to start of the packet
	push	bx
	mov		ah,BANK0
	call	SET_CONTROLLER_BANK 
	mov		ax,(ERDPTH_REGISTER SHL 8) OR ERDPTL_REGISTER
	;mov		bx,[data_next_packet_start]
	mov		bx,RX_ADDRESS_START
	call	WRITE_REGISTER_LOW_HIGH
	pop		bx
	
	;; Two dummy reads to move the NEXT PTR off
	call	READ_BUFFER_MEMORY_BYTE
	call	READ_BUFFER_MEMORY_BYTE
	
	;update local read pointer, read first two bytes of current block
	;call	READ_BUFFER_MEMORY_BYTE
	;mov		BYTE PTR [data_next_packet_start][0],al ; Low byte
	;call	READ_BUFFER_MEMORY_BYTE
	;mov		BYTE PTR  [data_next_packet_start][1],al ; High byte
	
	; Read length of packet, bytes 3 and 4
	push	cx
	push	bx
	push	si
	push	es
	push	di
	call	READ_BUFFER_MEMORY_BYTE
	mov		cl,al ; Low byte
	call	READ_BUFFER_MEMORY_BYTE
	mov		ch,al ; high byte
	sub		cx,4 ; Remove Frame Check Sequence (CRC)
	
	mov		ax,cx ; Print count
	;UTIL_PRINT_STR inter_msg_cnt
	;UTIL_PRINT_HEX 4
	;UTIL_PRINT_NEWLINE
	
	push	cx ; save count
	
	;; Read the other 2 status bytes, disregard for now
	call	READ_BUFFER_MEMORY_BYTE
	call	READ_BUFFER_MEMORY_BYTE
	
	; Ask program for a buffer
	mov		bx,[data_receiver_handle]
	mov		ax,0 ; Request buffer
	pop		cx
	push	cx
	;; Offset from DS
	call	DWORD PTR [data_receiver_offset] ; returns ES:DI
	;; Transfer packet to buffer
	pop		cx ; retrieve count

	mov		ax,es
	;UTIL_PRINT_STR inter_msg_es
	;UTIL_PRINT_HEX 4
	;UTIL_PRINT_NEWLINE
	cmp		ax,0h
	je		INT_UNSTACK
	;UTIL_PRINT_STR inter_msg_ack
	mov		ax,di
	;UTIL_PRINT_STR inter_msg_di
	;UTIL_PRINT_HEX 4
	;UTIL_PRINT_NEWLINE
	
	;cmp		ax,0h
	;je		INT_UNSTACK
	;UTIL_PRINT_STR inter_msg_ack
	
	mov		ax,es
	mov		ds,ax ; set DS temporarily to the buffer segment
	mov		bx,di ; set BX to the buffer offset
	mov		ax,cs
	mov		es,ax ; set local pointer
	call	READ_BUFFER_MEMORY
	mov		bx,es:[data_receiver_handle] ; since we need to use DS
	mov		ax,1; Tell program we're ready
	call	DWORD PTR es:[data_receiver_offset]
INT_UNSTACK:
	pop		di
	pop		es
	pop		si
	pop		bx
	pop		cx
	
INT_PKT_RECV_CHK_CO:
	pop		ds
	
	;; Clear ethernet controller int (PKTIF) to acknowledge
	;call	TXRX_CLEAR_RX_FLAG ;; API provided by TXRX
INT_PKT_RECV_ACK:
	call	TXRX_ACK_PKT 
	
	;; Re-enable global interrupt
	call	TXRX_ENABLE_GLOBAL_INT ;; API provided by TXRX
			
	;; Re-enable Reception
	call	TXRX_ENABLE_RX	;; API provided by TXRX
	
	; Ack PIC interrupt that got us here
	mov		al,val_pic_eoi
	out		port_pic_cmd,al ; Ack hardware Interrupt
	
	pop		ax
	
	iret
INT_PKT_RECV ENDP




;; This procedure sets up the interrupt by hooking the vector
;	and pointing it at INT_PKT_DRVR
SETUP_INT PROC NEAR
	;; Setup SEND int
	mov		ax,offset	INT_PKT_HANDLER ; get the offset of the packet driver interrupt handler
	mov		es:[int_packet_driver_offset],ax
	mov		ax,cs
	mov		es:[int_packet_driver_segment],ax
	
	
	;; Mask IRQ4 prior to changing it
	in		al,port_pic_data
	or		al,mask_modem_bit ; 0001 0000 setup mask 
	out		port_pic_data,al
	
	;; Setup RECEIVE int
	mov		ax,offset	INT_PKT_RECV
	mov		es:[int_modem_offset],ax
	mov		ax,cs
	mov		es:[int_modem_segment],ax
	
	; Unmask IRQ4
	in		al,port_pic_data
	mov		ah,NOT mask_modem_bit ; 1110 1111 setup mask clear
	and		al,ah ; Clear modem port interrupt bit
	out		port_pic_data,al ; write interrupt controller mask reg to unmask modem
	
	ret
SETUP_INT ENDP

MAIN PROC NEAR
	mov		ax,cs
	mov		ds,ax ; set DS to ourselves
	mov		ax,interrupt_vector_table_segment
	mov		es,ax ; set ES to the interrupt vector table
;; SETUP_CODE_HERE_START
	call	SETUP_INT
	
	;; Set the handler to 0 to indicate no current users
	xor		ax,ax
	mov		[data_receiver_handle],ax
	
	;; Take control of the system
	mov		ah,02h ; access_type service request
	mov		al,DRV_IFCLASS
	mov		bx,DRV_IFTYPE
	; no need to set *type DS:SI
	mov		dl,DRV_IFNUM
	mov		cx,0h ; type len 0
	; no need to set receiver function since we won't be receiving anything
	int		int_packet_driver ; Access type to set handle
	
	;; Reset hardware adapter
	push	ax ; save handle
	mov		bx,ax ; set BX to handle
	mov		ah,07h ;  reset_interface
	int		int_packet_driver ; Reset hardware
	
	;; Setup initial packet start address ;; TODO, move this internal
	; Only ever 1 packet, comment out for now
	;mov		[data_next_packet_start],RX_ADDRESS_START ; Setup initial packet
	
	;; Release the interface
	pop		bx ; get handle back
	mov		ah,03h ; release_type
	int		int_packet_driver ; Reset hardware
		
	UTIL_PRINT_STR	dbg_goodbye_msg
;; SETUP_CODE_HERE_DONE
EXITTSRDOS:
	mov		dx,(offset END_OF_PROGRAM - offset PROGRAM + 100h + 15) SHR 4	; end-begin + PSP + round up to next paragraph, convert
																			;to paragraph
	mov		ax,(svc_dos_keep_resident SHL 8) OR val_dos_terminate_0
	int		int_dos_21 ;; EXIT to DOS
MAIN ENDP
dbg_goodbye_msg db "INT_PKT_HANDLER installed. Adios Mundo!$"

;; Next Packet ; TODO - move this into controller
data_next_packet_start dw ?

;; Store caller's information ; TODO - move this into controller
data_receiver_handle dw ?
data_receiver_offset dw ?
data_receiver_segment dw ?


;; TODO
; 1.) Implement receive
; 2.) Make functional on cartridge - detect if write to self, if not just exit, if so TSR
;; Things to save:
;		OLD PIC mask
;  		Old Receive interrupt + segment
;		Old PKT interrupt + Segment
;		For each handle
;			Handle ID (in use or not)
;			Segment
;			Offset



; 3.) Make packet interrupt selectable
; 4.) Make it unloadable (TSR & NOT TSR) + interrupts + mask

END_OF_PROGRAM:

CODESEG ENDS
END PROGRAM
