TITLE jrNIC Test Packet Driver Program 4
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
	mov		dx,offset str
	mov		ah,svc_dos_print_str
	int		int_dos_21 ; Print the welcome message
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

SVC_01 PROC NEAR
	mov		dh,BAD_HANDLE
	stc
	ret
SVC_01 ENDP
SVC_02 PROC NEAR
	mov		dh,NO_CLASS
	stc
	ret
SVC_02 ENDP
SVC_03 PROC NEAR
	mov		dh,BAD_HANDLE
	stc
	ret
SVC_03 ENDP
SVC_04 PROC NEAR
	mov		dh,CANT_SEND
	stc
	ret
SVC_04 ENDP
SVC_05 PROC NEAR
	mov		dh,BAD_HANDLE
	stc
	ret
SVC_05 ENDP
SVC_06 PROC NEAR
	mov		dh,BAD_HANDLE
	stc
	ret
SVC_06 ENDP
SVC_07 PROC NEAR
	mov		dh,BAD_HANDLE
	stc
	ret
SVC_07 ENDP

INT_SVC_TABLE LABEL WORD
	dw		OFFSET SVC_01
	dw		OFFSET SVC_02
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
	push	ds		; Save registers
	push	ax
	mov		ax,cs
	mov		ds,ax ; set DS so we can use DOS functions
;; INT_CODE_HERE_START
	UTIL_PRINT_STR dbg_welcome_msg ; Print welcome
	UTIL_PRINT_CHAR ':' ; Print a ascii colon 
	pop		ax		; Restore AH
	UTIL_PRINT_HEX 2 ; Print 2 hex nibbles of AH
	UTIL_PRINT_NEWLINE ; Print a newline to clean it up
	push	ax		; Save AL
	mov		al,ah	; move SVC to AL
	xor		ah,ah	; set AH to 0
	dec		al		; SVC is 1 based, offsets are 0 based
	sal		ax,1	; svc * 2 = INT_SVC_TABLE entry
	mov		si,ax	; SI = INT_SVC_TABLE entry
	pop		ax		; Restore AL
	cmp		si,INT_SVC_TABLE_L ; ensure entry is valid
	jb		INT_GOOD ; 	
	mov		dh,BAD_COMMAND ; Else this command is out of band, later possibly do other checks
	stc		; Set ERROR carry
	jmp		INT_EXIT
INT_GOOD:
	call	WORD PTR CS:[SI + OFFSET INT_SVC_TABLE]
	pop		ds ; Restore registers
	;; Stack is currently only holding FLAGS, SEGMENT, OFFSET
	push	bp ; we need to use the BP, so add that to the Stack
	mov		bp, sp ; get bp
	jc		RET_BAD ; if carry was set by the function, we need to set the true carry
RET_GOOD:				; else we need to clear the carry flag
	and		word ptr ss:[bp+6],0FFFEh
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
	UTIL_PRINT_STR	dbg_goodbye_msg
;; SETUP_CODE_HERE_DONE
EXITTSRDOS:
	mov		dx,(offset END_OF_PROGRAM - offset PROGRAM + 100h + 15) SHR 4	; end-begin + PSP + round up to next paragraph, convert
																			;to paragraph
	mov		ax,(svc_dos_keep_resident SHL 8) OR val_dos_terminate_0
	int		int_dos_21 ;; EXIT to DOS
MAIN ENDP
dbg_goodbye_msg db "INT_PKT_HANDLER installed. Adios Mundo!$"
END_OF_PROGRAM:

CODESEG ENDS
END PROGRAM
