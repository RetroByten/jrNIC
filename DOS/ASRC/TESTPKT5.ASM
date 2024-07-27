TITLE jrNIC Test Packet Driver Program 5
PAGE 66,80 ; 66 lines per page, 80 characters/line

%OUT Processing EQUATES...
interrupt_vector_table_segment		EQU 0000h
int_dos_21					EQU	21h
    svc_dos_print_char		EQU 02h
	svc_dos_print_str		EQU 09h
	svc_dos_keep_resident	EQU 31h
		val_dos_terminate_0		EQU 00h
int_packet_driver			EQU 60h
	int_packet_driver_offset	EQU int_packet_driver * 4
	int_packet_driver_segment	EQU int_packet_driver_offset + 2

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

%OUT Processing CODE Segment
CODESEG SEGMENT
	assume CS:CODESEG, DS:CODESEG, SS:CODESEG
ORG 100h
PROGRAM: ; Needed for COM to later terminate the program
jmp		MAIN
dbg_welcome_msg db "Hola Mundo! Packet Driver Invoked!$"

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

SVC_00 PROC NEAR ; ERROR, BAD COMMAND, Redirect all bad commands here
	pop		si
	mov		dh,BAD_COMMAND
	stc
	jmp		SVC_RET
SVC_00 ENDP
SVC_01 PROC NEAR
	pop		si
	mov		dh,BAD_HANDLE
	stc
	jmp		SVC_RET
SVC_01 ENDP
SVC_02 PROC NEAR  ; access_type
	pop		si
SVC_02_CHK_IFCLASS:
	cmp		al,01h ; IFCLASS = 1
	je		SVC_02_CHK_IFTYPE
	mov		dh,NO_CLASS
	jmp		SVC_02_BAD
SVC_02_CHK_IFTYPE:
	cmp		bx,0FFFFh ; IFTYPE = wildcard
	je		SVC_02_CHK_IFNUM
	mov		dh,NO_TYPE
	jmp		SVC_02_BAD
SVC_02_CHK_IFNUM:
	cmp		dl,00h ; IFNUM = 0, 1st interface
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
	mov		dh,BAD_HANDLE
	stc
	jmp		SVC_RET
SVC_03 ENDP
SVC_04 PROC NEAR
	pop		si
	mov		dh,CANT_SEND
	stc
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
	mov		dh,BAD_HANDLE
	stc
	jmp		SVC_RET
SVC_06 ENDP
SVC_07 PROC NEAR
	pop		si
	mov		dh,BAD_HANDLE
	stc
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

;; This procedure sets up the interrupt by hooking the vector
;	and pointing it at INT_PKT_DRVR
SETUP_INT PROC NEAR
	mov		ax,offset	INT_PKT_HANDLER ; get the offset of the packet driver interrupt handler
	mov		es:[int_packet_driver_offset],ax
	mov		ax,cs
	mov		es:[int_packet_driver_segment],ax
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
	UTIL_PRINT_STR	dbg_goodbye_msg
;; SETUP_CODE_HERE_DONE
EXITTSRDOS:
	mov		dx,(offset END_OF_PROGRAM - offset PROGRAM + 100h + 15) SHR 4	; end-begin + PSP + round up to next paragraph, convert
																			;to paragraph
	mov		ax,(svc_dos_keep_resident SHL 8) OR val_dos_terminate_0
	int		int_dos_21 ;; EXIT to DOS
MAIN ENDP
dbg_goodbye_msg db "INT_PKT_HANDLER installed. Adios Mundo!$"

;; Store caller's information
data_receiver_handle dw ?
data_receiver_segment dw ?
data_receiver_offset dw ?



END_OF_PROGRAM:

CODESEG ENDS
END PROGRAM
