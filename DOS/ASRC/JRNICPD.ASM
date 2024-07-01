TITLE jrNIC Packet Driver Program
PAGE 66,80 ; 66 lines per page, 80 characters/line

%OUT Processing EQUATES...
DOS_RAM EQU 1 ; TRUE IF PROGRAM LOADED IN RAM VIA DOS
INCLUDE EQUATES.ASM

%OUT Processing CODE Segment
CODESEG SEGMENT
	assume CS:CODESEG, DS:CODESEG, SS:CODESEG
ORG 100h
PROGRAM: ; Needed for COM to later terminate the program
jmp		MAIN ; 3 bytes
label_str db "PKT DRVR",0h ; Packet driver spec requires 
db '$' ; convienance for printing
label_fingerprint db "RETROBYTEN jrNIC PacketDriver$"
;; TODO - store these on ethernet controller
old_int_pkt_offset dw ?
old_int_pkt_segment dw ?
;old_int0c_offset dw ?
;old_int0c_segment dw ?

label_int db "DUMMY_INT_PKT_DRIVER",0Dh,0Ah,"$"
INT_PKT_DRIVER PROC FAR
	sti ; enable interrupts to not block the timer
	push	ax
	push	dx
	push	ds
	
	mov		ax,cs
	mov		ds,ax ; setup DS
	mov		dx,offset label_int
	mov		ah,svc_dos_print_str
	int		int_dos_21 ; Needs DS, DX, AH
	
	pop		ds
	pop		dx
	pop		ax
	iret
INT_PKT_DRIVER ENDP


label_end_of_tsr db "END_OF_TSR$"
ENDOFTSR:
label_main db "MAIN_PROC_FAR$"
label_loaded db "Loaded TSR",0Dh,0Ah,"$"
MAIN PROC FAR
	mov		ax,cs
	mov		ds,ax ; Setup DS

	;; Setup ES to interrupt vector Segment
	mov		ax,interrupt_vector_table_segment
	mov		es,ax

	;; First check if already LOADED: compare offset, if offset doesn't match we aren't already be LOADED
	mov		ax,es:[int_packet_driver_offset]
	mov		[old_int_pkt_offset],ax ; Save in case we do end up loading
	;mov	bx,offset INT_PKT_DRIVER ; if offset doesn't match, obviously we aren't already be LOADED
	cmp		ax,offset INT_PKT_DRIVER 
	jne		LOAD_PKT_DRIVER

	; Second check if already LOADED: compare finger_print
	mov		ax,es:[int_packet_driver_segment]

LOAD_PKT_DRIVER:
	; Save old int
	mov		ax,es:[int_packet_driver_offset]
	mov		[old_int_pkt_offset],ax
	mov		ax,es:[int_packet_driver_segment]
	mov		[old_int_pkt_segment],ax
	
	; Check if old one matches
	; if so, unload and exit
	
	; Set new int one
	mov		ax,offset INT_PKT_DRIVER
	mov		es:[int_packet_driver_offset],ax
	mov		ax,cs
	mov		es:[int_packet_driver_segment],ax
	
	; Print success
	mov		dx,offset label_loaded
	mov		ah,svc_dos_print_str
	int		int_dos_21 ; Needs DS, DX, AH
	jmp		EXIT_TSR
	
EXIT_TSR:
IF DOS_RAM
	; TSR
	mov		dx,(offset ENDOFTSR - offset PROGRAM + 100h + 15) SHR 4 ; end-begin + PSP + round up to next paragraph, convert to paragraph
	mov		ax,(svc_dos_keep_resident SHL 8) OR val_dos_terminate_0
	int		int_dos_21 ; EXIT to DOS
ELSE ; ROM programs don't need to TSR because they are already resident
	ret
ENDIF

MAIN ENDP

CODESEG ENDS
END PROGRAM
