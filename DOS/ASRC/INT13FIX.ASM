TITLE INT13FIX

; If the system has an int13h override that is disabling interrupts,
;	this TSR will ensure they are re-enabled prior to returning
 
PAGE 66,132 ; 66 lines per page, 99 characters/line

PAGE
CODESEG SEGMENT
	assume CS:CODESEG, DS:CODESEG, SS:CODESEG
	BEGINOFPROG EQU $	; Mark 0000h for calculations
	ORG	100h
	PROGRAM:
	jmp			NEAR PTR MAIN				; DOS Command Entry Point

original_int13_offset dw ?
original_int13_segment dw ?

INT13H_SHIM PROC FAR
	pushf		; Push current flags, ints disabled by CPU INT call
	call	DWORD PTR CS:[original_int13_offset]	; Far call instead of INT, returns carry flag clear/set
	sti			; Re-enable interrupts in returned flags
	ret		2	; Discard stack flags and return to the caller with the current flags + interrupts force-enabled
INT13H_SHIM ENDP

ENDOFTSR EQU $

;; TSR to shim INT13
MAIN PROC FAR
	mov		ax,cs
	mov		ds,ax ; Set DS
	
	; Get Original Int 13h vector
	mov		ax,(35h SHL 8) OR 13h ; DOS service 35h, asking for INT 13H Vector
	int		21h ; DOS INT, returns ES:BX = INT 13H Vector
	
	; Store Original Int 13h Vector
	mov		[original_int13_offset],bx
	mov		ax,es
	mov		[original_int13_segment],ax

	; Set Int 13h vector to our SHIM
	; DS already set
	mov		dx,offset INT13H_SHIM
	mov		ax,(25h SHL 8) OR 13h ; DOS service 25h, setting INT 13H Vector
	int		21h ; DOS INT, expects DS:DX set to desired INT vector value

	; TSR
	mov		dx,RESIDENT_PARA  ; DS:DX = Resident Location + Paras to retain
	mov		ax,(31h SHL 8) OR 0h ; DOS service 31h, return code 0h
	int		21h ; DOS INT, TSR
MAIN ENDP

ENDOFPROG EQU $ ; Used for CARTSIZ calculation and TSR end of stack
CODESEG ENDS

PSP_SIZE EQU 100h
CODE_SIZE EQU (ENDOFTSR - BEGINOFPROG) - PSP_SIZE
RESIDENT_SIZE EQU PSP_SIZE + CODE_SIZE
RESIDENT_PARA EQU (RESIDENT_SIZE SHR 4) + 1 ; TODO - calculate exact number of PARAS needed

END PROGRAM
