TITLE jrNIC Test Packet Driver Program 2
PAGE 66,80 ; 66 lines per page, 80 characters/line

%OUT Processing EQUATES...
interrupt_vector_table_segment		EQU 0000h
int_dos_21					EQU	21h
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
;; INT_CODE_HERE_DONE
	pop		ax		; Restore registers
	pop		ds
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