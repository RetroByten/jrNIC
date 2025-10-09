TITLE jrNIC - Packet Driver
PAGE 66,132 ; 66 lines per page, 99 characters/line

PAGE
%OUT Processing jrNIC Build Flags
INCLUDE JRBLDFLG.ASM

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

;; Ensure RAM segment has stack

;driver_in_use	dw 0000h
receive_offset	dw 0000h
receive_segment	dw 0000h
packet_size		dw 0000h

MAC_ADDRESS_TABLE LABEL BYTE
	db 00h, 03h, 01h, 04h, 01h, 05h ; Default made up source MAC address
MAC_ADDRESS_TABLE_L EQU $-MAC_ADDRESS_TABLE

PROGRAM_SIGNATURE:
	drv_signature:
	drv_vendor		db "RETROBYTEN"
	drv_card		db "JRNIC$" ; Used to detect if already running
	drv_signature_end:

DRIVER_INFO: 
	DRV_PKT_VERSION dw VER ; VERSION, BX (defined in JRBLDFLG.ASM)
	DRV_IFCLASS db 1 ; CLASS, CH
	DRV_IFTYPE dw 0FFFFh ; TYPE, DX
	DRV_IFNUM db 0 ; NUMBER, CL
	DRV_NAME db "jrNIC$",0 ; NAME, DS:SI
	DRV_FUNC db 1 ; FUNCTIONALITY, AL

PAGE
%OUT Processing JRNICHAL
INCLUDE JRNICHAL.ASM

PAGE
%OUT Processing jrNIC Utils
INCLUDE JRUTIL.ASM

;; Assumes Carry set/cleared as intended
;; Assumes all regs restored except bp
;; Need to set IRET carry and then IRET
INT_PKT_SVC_CLEANUPM MACRO
	local	INT_PKT_SVC_IRET_GOOD
	local	INT_PKT_SVC_IRET_BAD
	mov		bp,sp ; Get current stack pointer, should have nothing but BP + OFFSET + SEG + FLAGS
				  ;    													6      4      2      0 
	jc		SHORT INT_PKT_SVC_IRET_BAD
INT_PKT_SVC_IRET_GOOD: ; Clear carry flag on stack
	and		BYTE PTR [bp+6],0FEh ; SS:
	pop		bp
	iret
INT_PKT_SVC_IRET_BAD: ; Set carry flag on stack
	or		BYTE PTR [bp+6],01h ; SS:
	pop		bp ; Restore caller's BP
	iret
ENDM

;; ALL services must POP bx immediately
;; Caller BP was pushed
;; BP = current RESIDENT MEM DS
;; ALL services must invoke INT_PKT_SVC_CLEANUPM macro to restore BP before IRET
debug_INT_PKT_SVC_00 db "Service 00, ERROR$"
INT_PKT_SVC_00 PROC FAR ;; driver_error()
	pop		bx ; Restore caller's BX
				;; Point all invalid services here
				;; Return Carry + set return reason to BAD_COMMAND
	mov		dh,LOW BAD_COMMAND
	stc		; Indicate error condition
INT_PKT_SVC_00_CLEANUP:
	INT_PKT_SVC_CLEANUPM
INT_PKT_SVC_00 ENDP
debug_INT_PKT_SVC_01 db "Service 01, Handle$"
INT_PKT_SVC_01 PROC FAR ;; 6.3 driver_info()
	pop		bx ; Restore caller's BX
	
	;push	ds
	;mov	ds,bp ; Intentionally not setting DS = MEM because we need to return DS with other data
	push	ax
	mov		ax,cs
	mov		ds,ax ; Set DS:SI to driver data stored on CART/main RAM
	mov		si,offset DRV_NAME ; Point DS:SI to the driver name
	mov		bx,DRV_PKT_VERSION
	mov		ch,DRV_IFCLASS
	mov		dx,DRV_IFTYPE
	mov		cl,DRV_IFNUM
	;pop		ds ; Intentionally not restoring DS because we need to return it
	pop		ax ; restore AH
	mov		al,DRV_FUNC
	clc
INT_PKT_SVC_01_CLEANUP:
	INT_PKT_SVC_CLEANUPM
INT_PKT_SVC_01 ENDP

debug_INT_PKT_SVC_02 db "Service 02, Typelen$"
INT_PKT_SVC_02 PROC FAR ;; 6.4 access_type() 
	pop		bx ; Restore caller's BX

	;; NOTE - ASSUMES THIS WON'T BE CALLED FROM AN INT
	;; NOTE - Currently only supports 1 user handle
	;; NOTE - Unconditionally sets, does not check if already owned
	
	push	ds
	push	ax
	push	dx ; Save registers
	
	mov		ds,bp ; Set DS = MEM
	
	MASK_IRQ4M ;; Uses AX, Flags, Assumes this won't be called from a timer int
	
	;; Disable reception
	call HAL_DISABLE_RX ; AX/DX/FLAGS
	
	; Setup receiver ES:DI seg:off
	mov		ax,es
	mov		[receive_segment],ax
	mov		[receive_offset],di
	
	;; Enable reception (clear out any pending packet pointers)
	call HAL_ENABLE_RX ; AX/DX/FLAGS
	
	;; Release call
	UNMASK_IRQ4M ; Uses AX, Flags
	
	pop		dx ; Restore registers
	pop		ax
	pop		ds
	mov		ax,1 ; Handle
	clc		; Mark as successful
INT_PKT_SVC_02_CLEANUP:
	INT_PKT_SVC_CLEANUPM ;; -- Exits
INT_PKT_SVC_02 ENDP

;; release type needs to mask driver
debug_INT_PKT_SVC_03 db "Service 03, Handle$"
INT_PKT_SVC_03 PROC FAR ;; 6.5 release_type()
	pop		bx ; Restore caller's BX

	push	ds
	push	ax
	push	dx ; Save registers

	mov		ds,bp ; Set DS = MEM

	MASK_IRQ4M ;; Uses AX, Flags Assumes this won't be called from a timer int, uses AX

	;; Disable reception
	call HAL_DISABLE_RX ; AX/DX/FLAGS

	; Setup dummy receiver seg:off
	mov		ax,cs
	mov		[receive_segment],ax 
	mov		[receive_offset],offset RCV_DUMMY_RET

;; 20251009 - Only enabling when an app is actively receiving
	;; Enable reception (clear out any pending packet pointers)
;	call HAL_ENABLE_RX ; AX/DX/FLAGS
	
	;; Release call
;	UNMASK_IRQ4M ; Uses AX, flags
;; 20251009 - End
	pop		dx ; Restore registers
	pop		ax
	pop		ds

	clc		; Mark as successful
INT_PKT_SVC_03_CLEANUP:
	INT_PKT_SVC_CLEANUPM	
INT_PKT_SVC_03 ENDP

;;;;;;;;;;;;;
;; INT_PKT_SVC_04 IMPLEMENTED in the core INT_PKT_ENTER default path
;;;;;;;;;;;;;

INT_PKT_SVC_05 PROC FAR ;; terminate()
	pop		bx ; Restore caller's BX

	mov		dh,CANT_TERMINATE
	stc
	INT_PKT_SVC_CLEANUPM
INT_PKT_SVC_05 ENDP

INT_PKT_SVC_06 PROC FAR ;; get_address()
	pop		bx ; Restore caller's BX

	push	ax
	push	ds
	mov		ds,bp ; Set DS = MEM
INT_PKT_SVC_06_CHK_SIZE:
	cmp		cx,MAC_ADDRESS_TABLE_L ; Compare available buffer space to table Length
	jae		INT_PKT_SVC_06_CONT
	mov		dh,NO_SPACE
	stc		; Indicate error
	jmp		INT_PKT_SVC_06_CLEANUP
INT_PKT_SVC_06_CONT:
	; Set DS:SI to MAC address table
		; DS already set to MEM
	push	si
	push	di
	mov		si,offset MAC_ADDRESS_TABLE
	mov		cx,MAC_ADDRESS_TABLE_L ; set count to MAC_ADDRESS_TABLE_L
	;; ES:DI = receive buffer
	cld
	rep		movsb ; Copy MAC address, modifies SI, DI, and CX
	pop		di
	pop		si
	mov		cx,MAC_ADDRESS_TABLE_L
	clc
INT_PKT_SVC_06_CLEANUP:
	pop		ds
	pop		ax
	INT_PKT_SVC_CLEANUPM
INT_PKT_SVC_06 ENDP

INT_PKT_SVC_07 PROC FAR ;; reset_interface()
	pop		bx ; Restore caller's BX
	
	mov		dh,CANT_RESET
	stc		; Indicate error condition
	INT_PKT_SVC_CLEANUPM
INT_PKT_SVC_07 ENDP

;; Returns ES:DI = receiver function
;; Returns AX = in use/handle
INT_PKT_SVC_08_DEBUG PROC FAR
	pop		bx ; Restore caller's BX
	push	ds
	mov		ds,bp ; Set DS
	mov		di,[receive_segment]		
	mov		es,di
	mov		di,[receive_offset]
	mov		ax,1 ; Handle
	pop		ds
	clc
	INT_PKT_SVC_CLEANUPM
INT_PKT_SVC_08_DEBUG ENDP


;; API
;; INT CALLED / IRQ TRIGGERED
;; INT/IRQ ENTER (in MEMORY):
;; jmp NEAR INT/IRQ CONTINUE:
;; - <sig>
;; - <prog>
;; - <driver>
;; INT/IRQ CONTINUE:
;; push bp/push ax ; push caller's bp or ax
;; mov bp/ax, cs ; MEMORY SEG FOR DS
;; jmp FAR INT/IRQ ACTUAL (in ROM)
;; - <do stuff>
;; - <carry fiddling for ret if necessary>
;; pop bp/ax ; restore caller's bp
;; iret

INT_PKT_SVC_TABLE LABEL WORD
	dw		OFFSET INT_PKT_SVC_00 ; driver_error()
	dw		OFFSET INT_PKT_SVC_01 ; driver_info()
	dw		OFFSET INT_PKT_SVC_02 ; access_type()
	dw		OFFSET INT_PKT_SVC_03 ; release_type()
	dw		OFFSET INT_PKT_SVC_04 ; send_pkt() ; Is implemented directly, not accessed via SVC table
	dw		OFFSET INT_PKT_SVC_05 ; terminate()
	dw		OFFSET INT_PKT_SVC_06 ; get_address()
	dw		OFFSET INT_PKT_SVC_07 ; reset_interface()
	dw		OFFSET INT_PKT_SVC_08_DEBUG ; debug_get_receiver()
INT_PKT_SVC_TABLE_L EQU $-INT_PKT_SVC_TABLE ; Length of table

INT_PKT_HANDLE_OTHER PROC NEAR ;; Handle all INT_PKT services except 04h
	;; Handle other services except 04 (send)
	push	bx		; Save caller's BX, used for temporary offset
	xor		bh,bh	; Zero out upper address, valid BX values are 0-(14-1) decimal
					; so this is safe
	mov		bl,ah	; AH was SVC, move to bl
	sal		bl,1	; SVC * 2 = INT_PKT_SVC_TABLE entry
	cmp		bl,INT_PKT_SVC_TABLE_L ; check if command is valid
	jb		INT_PKT_SVC_EXEC ; if yes, continue
	xor		bl,bl	; if no, force driver_error() handler
INT_PKT_SVC_EXEC: ;; Jump to service handler
	;; Requirements
	;; 0.) SVC entry: caller BX, caller BP on the stack (needed for exit)
	;; 1.) SVC should pop BX immediately
	;; 2.) If using card, check (needs AX) FORCE_MASK_IRQ_CHECKM
	;;		a.) If card available	: DISABLE_RX (needs AX, DX)
	;;								: DO STUFF
	;;								: ENABLE_RX (needs AX,DX)
	;;								: UNMASK_IRQ4M (needs AX)
	;;								: Clear Carry
	;;		b.) If card unavailable : Set DH, Set Carry
	;; 3.) Set/clear IRET stack carry (+6), pop BP, iret
	jmp		WORD PTR CS:[BX + OFFSET INT_PKT_SVC_TABLE] ; BX contains service handler offset
INT_PKT_HANDLE_OTHER ENDP

INT_PKT_ENTER PROC FAR
	jmp		NEAR PTR INT_PKT_ENTER_CONT ; jmp over signature to continue
	drvr_signature	db "PKT DRVR",00h ; Required Packet Driver signature
INT_PKT_ENTER_CONT:
	push	bp		; Preserve caller's BP on caller's stack
					; Uses BP because that is not a parameter used in the PKT DRV spec
	mov		bp,cs	; Give real PKT_INT the MEMORYSHIMBEGIN segment in BP
					; CS:INT_PKT_ENTER must clean up stack
	;jmp		NEAR PTR INT_PKT_ACTUAL ; TODO --- , replace with jmp FAR PTR, need to edit destination with init code
INT_PKT_ACTUAL:
	sti			; Re-enable Interrupts
	cmp		ah,04h ;; Priority path is AH=04h[send_packet()], make that the default / no jump
	jnz		INT_PKT_HANDLE_OTHER ;; All other functions can jump elsewhere to be handled slower
INT_PKT_SVC_04: ; Else this is service 04h, handle here
	; pop		bx ; Restore caller's BX, no longer necessary since this path doesn't use BX for a table lookup
	;; This could be called from a timer int, so need to
	;; conditionally reserve card
	push	ax
	;; Ensure we're not interrupting another send or receive process
	FORCE_MASK_IRQ_CHECKM ; Uses AX, flags
	jnz		INT_PKT_SVC_04_CANT_SND_PKT ; If in use, need to bail out
INT_PKT_SVC_04_SND_PKT: ; Else, we've now reserved it so carry on
	push	dx
	call	HAL_SEND_PKT; Sets carry for fail, clears for success
	pop		dx
	pushf	; Save flag
	UNMASK_IRQ4M ; Uses AX,flags Release card
	popf	; Restore flag
	jc		INT_PKT_SVC_04_CANT_SND_PKT
INT_PKT_SVC_04_CLEANUP:
	pop		ax
	INT_PKT_SVC_CLEANUPM
INT_PKT_SVC_04_CANT_SND_PKT: ; Signal error
	mov		dh,CANT_SEND
	stc
	jmp		INT_PKT_SVC_04_CLEANUP
; INT_PKT_SVC_04 END
INT_PKT_ENTER ENDP

;; Dummy receive handler, returns buffer size 0 aka error
RCV_DUMMY_RET PROC FAR
	xor		di,di
	mov		es,di ;; Always reply no buffer available
	ret
RCV_DUMMY_RET ENDP


;; IRQ
; Needs to unmask interrupts
; Needs to acknowledge PIC IRQ
IRQ_RCV_ENTER PROC FAR
	; - Level 1 - Start
	push	ax ; Save Interuptee's AX on Interuptee's stack
	mov		ax,cs ; Pass in Resident MEM/DS
IRQ_RCV_ACTUAL:
	; -- Level 2 - Start
		push	ds
		push	dx
		push	bp  ; Save Interuptee's DS, DX, BP on Interuptee's stack
		
		mov		ds,ax ; DS = Resident MEM/DS, ax is now free
		MASK_IRQ4M	; Uses AX, Mask interrupts Unconditionally
					; since we got here via interrupt and haven't (yet)
					; re-enabled them, nothing else can be using the card
					; TECHNICALLY a bad NMI could've re-enabled interrupts
					; but also then they would run their code and return
					; before we continue
					; And also a bad NMI wouldn't re-enable the mask?...
					; Card not in use and is now marked for use
		sti
		call	HAL_DISABLE_RX ; Disable further reception (uses AX/DX/FLAGS)

		;; Check that packet size is > 0
		call	HAL_GET_PACKET_SIZE ; get packet size into AX, uses AX/DX/FLAGS	
		cmp		ax,0h ; just in case packet is somehow zero?
		je		IRQ_RCV_RANGE_JMP_DONE ; Shouldn't be possible, but whatever...
		mov		[packet_size],ax ; Save packet size

		;;; Setup Internal Stack
		mov		dx,ss ; Save interuptee's ss:sp in registers
		mov		bp,sp
		
		mov		ax,ds ; Intentional due to it being the RAM segment
		mov		ss,ax ; Temporarily disables interrupts
		mov		sp,RESIDENT_SIZE
		
		; Push EVERYTHING
		;push ax ; already preserved
		push bx
		push cx
		push dx ; interuptee's stack segment
		push bp ; interuptee's stack pointer
		push si
		push di
		;push ds ; already preserved
		push es
		
			;;; SAFETY ZONE
			;; Ask receiver if it can take the packet
			xor		ax,ax ; first call flag is 0
			mov		bx,1 ; Handle
			mov		cx,[packet_size] ; CX = packet size in bytes
			call	DWORD PTR [receive_offset] ; returns ES:DI buffer, 0:0 if can't hold the packet
		
			; Check if caller gave us a good buffer back. ES:DI == 0:0 if buffer bad, else good
			mov		ax,es
			or		ax,di
			jz		IRQ_RCV_NOTIFY_DONE ; if both were zero, bail out
IRQ_RCV_NOTIFY_COPY: ; Ok go-ahead and copy
			;; ES:DI is the destination
			push	di
			mov		cx,[packet_size]
			call	HAL_RX ; copy packet to buffer
			pop		si
			push	es ; Pushed Buffer Segment
			mov		ax,ds
			mov		es,ax ; ES = MEMORY SHIM
			pop		ds ; DS:SI = buffer
			mov		ax,1 ; second call flag
			mov		bx,1 ; handle
			mov		cx,[packet_size]
			call	DWORD PTR ES:[receive_offset] 
IRQ_RCV_NOTIFY_DONE:		
		;;; END ZONE
		
		;; Pop EVERYTHING
		pop es
		;pop ds ; already preserved
		pop di
		pop si
		pop bp ; interuptee's stack pointer
		pop dx ; interuptee's stack segment
		pop cx
		pop bx
		;pop ax ; already preserved
		
		;;; Restore Interuptee Stack
		mov ss,dx ; Temporarily disables interrupts
		mov sp,bp

IRQ_RCV_RANGE_JMP_DONE:
		call	HAL_ENABLE_RX ; Conditionally Re-enable reception
		UNMASK_IRQ4M ; Uses AX, Mask interrupts Unconditionally
		
		pop		bp   ; Restore Interuptee's DS, DX, BP from Interuptee's stack
		pop		dx
		pop		ds
		
	; -- Level 2 - End
	ACK_IRQM ; Requires AX, ACK PIC IRQ
	pop		ax ; Restore Interuptee's AX from Interuptee's stack
	; - Level 1 - End
	iret
IRQ_RCV_ENTER ENDP



;; Test driver will only load at 0x60
;; Test driver will not check if previously loaded
;; Test driver will not unload (reboot required)
;; Test driver only RAM loadable
;; Test driver will load entirely into RAM
MAIN PROC FAR
	; Set DS
	mov		ax,cs
	mov		ds,ax

	; Move Stack to within TSR space
	mov		ax,cs
	mov		ss,ax ; set sack segment, disables interrupts for one instruction
	mov		sp,RESIDENT_SIZE	; End of program memory, re-enables interrupts
	
	; Re-add default 0 to stack
	xor		ax,ax
	push	ax ; Should not be popped
	
	; Ensure RCV HW IRQ is masked when driver is loaded
	MASK_IRQ4M ; Uses AX, Flags

	; Setup Default Receive handler
	mov		ax,cs
	mov		[receive_segment],ax
	mov		[receive_offset],offset RCV_DUMMY_RET

	; Setup Interrupt INT_PKT_ENTER (sender API)
	mov		dx,offset INT_PKT_ENTER ; DS:DX = segment/offset
	mov		ah,svc_dos_set_interrupt_25
	mov		al,int_default_pkt_driver
	int		int_dos_21
	
	; Setup Interrupt IRQ_RCV_ENTER (receive HW IRQ)
	mov		dx,offset IRQ_RCV_ENTER ; DS:DX = segment/offset
	mov		ah,svc_dos_set_interrupt_25
	mov		al,int_modem
	int		int_dos_21
	
	; Reset, initialize, and enable card
	call	HAL_RESET
	call	HAL_INIT
;; 20251009 - Only enabling when an app is actively receiving
;	call	HAL_ENABLE_RX
	
	; Umask RCV HW IRQ
;	UNMASK_IRQ4M ; Uses AX, Flags
;; 20251009 - END
	
	
	; TSR
	mov		dx,RESIDENT_PARA  ; DS:DX = Resident Location + Paras to retain
	mov		ax,(svc_dos_keep_resident_31 SHL 8) OR val_dos_terminate_00
	int		int_dos_21 ; DOS Interrupt
MAIN ENDP

ENDOFPROG EQU $ ; Used for CARTSIZ calculation and TSR end of stack
CODESEG ENDS

PAGE
%OUT Processing jrNIC Equates (Ending)
INCLUDE JREQUE.ASM ; These are not known up-front, dynamically calculated

END PROGRAM
