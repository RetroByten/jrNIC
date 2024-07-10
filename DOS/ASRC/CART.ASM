TITLE jrNIC Test Packet Driver Program 3
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

%OUT Processing CODE Segment
CODESEG SEGMENT
	assume CS:CODESEG, DS:CODESEG, SS:CODESEG
ORG 100h
PROGRAM: ; Needed for COM to later terminate the program
jmp		MAIN
dbg_welcome_msg db "Hola Mundo! Packet Driver Invoked!$"

;; This a printable message to denote when the the packet driver handler was called
UTIL_PRINT_STR MACRO str
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
;; INT_CODE_HERE_DONE
	pop		ds ; Restore registers
	iret
INT_PKT_HANDLER ENDP

MAIN PROC NEAR
	mov		ax,cs
	mov		ds,ax ; set DS to ourselves
	mov		ax,interrupt_vector_table_segment
	mov		es,ax ; set ES to the interrupt vector table
;; SETUP_CODE_HERE_START
	mov		ax,offset INT_PKT_HANDLER
	mov		es:[int_packet_driver_offset],ax
	mov		ax,cs
	mov		es:[int_packet_driver_segment],ax
;; SETUP_CODE_HERE_DONE
EXITTOBIOS:
	ret
MAIN ENDP
dbg_goodbye_msg db "INT_PKT_HANDLER installed. Adios Mundo!$"

ORG 1000h
END_OF_PROGRAM:

CODESEG ENDS
END PROGRAM
