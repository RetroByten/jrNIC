TITLE RESET - Manually Reset card
PAGE 66,132 ; 66 lines per page, 132 characters/line

PAGE
%OUT Processing jrNIC Equates (Beginning)
INCLUDE JREQUB.ASM ; These are statically known up-front

PAGE
%OUT Processing jrNIC Macros
INCLUDE JRMACROS.ASM

PAGE
CODESEG SEGMENT
	assume CS:CODESEG, DS:CODESEG, SS:CODESEG
	BEGINOFPROG EQU $	; Mark 0000h for calculations
	ORG	100h
	PROGRAM:
	jmp			NEAR PTR MAIN				; DOS Command Entry Point

;DOS EQU 0 ; Use the BIOS versions of functions

MAC_ADDRESS_TABLE LABEL BYTE
	db 00h, 03h, 01h, 04h, 01h, 05h ; Default made up source MAC address
MAC_ADDRESS_TABLE_L EQU $-MAC_ADDRESS_TABLE

PAGE
%OUT Processing JRNICHAL
INCLUDE JRNICHAL.ASM

PAGE
%OUT Processing jrNIC Utils
INCLUDE JRUTIL.ASM

MAIN PROC FAR
	; Set DS
	mov		ax,cs
	mov		ds,ax
	
	MASK_IRQ4M ; Forcibly lock card
	
	;; Reset card
	call	HAL_RESET
	
	; EXIT
	mov		ax,(svc_dos_terminate_4C SHL 8) OR val_dos_terminate_00
	int		int_dos_21
MAIN ENDP

ENDOFPROG EQU $ ; Used for CARTSIZ calculation and TSR end of stack
CODESEG ENDS

PAGE
%OUT Processing jrNIC Equates (Ending)
INCLUDE JREQUE.ASM ; These are not known up-front, dynamically calculated

END PROGRAM
