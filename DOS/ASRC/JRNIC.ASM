TITLE jrNIC - Packet Driver
PAGE 66,132 ; 66 lines per page, 99 characters/line

; Starting from dev_packet_driver_development (works *iff* using int13fix)
;	1.) Adding entry shim for IRQ_RECV

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
PLACEHOLDER SEGMENT AT 0h ; Placeholder segment to allow assembly of placeholder FAR jumps
	assume CS:PLACEHOLDER, DS:PLACEHOLDER
	ORG 0h
	PLACEHOLDER_JMP:
PLACEHOLDER ENDS

PAGE
CODESEG SEGMENT
	assume CS:CODESEG, DS:CODESEG, SS:CODESEG

BEGINOFPROG EQU $	; Mark 0000h for calculations
	ORG	100h
PROGRAM:
	jmp			NEAR PTR MAIN				; DOS Command Entry Point
IRQ_RECV_SHIM PROC FAR
	push	ax			; Store interuptee's AX
	mov		ax,cs		; Store MEMORYSEGMENT in AX
IRQ_RECV_SHIM_JMP:
	jmp		FAR PTR		PLACEHOLDER_JMP ; Placeholder, will be replaced at runtime with jump to IRQ_RECV
IRQ_RECV_SHIM ENDP


PROGRAM_SIGNATURE:
	drv_signature:
	drv_vendor		db "RETROBYTEN"
	drv_card		db "JRNIC$" ; Used to detect if already running
	drv_signature_end:

DRIVER_INFO: 
	DRV_PKT_VERSION dw VER ; VERSION, BX (driver version, defined in JRBLDFLG.ASM)
	DRV_IFCLASS db 1 ; CLASS, CH ("Bluebook" Ethernet class)
	DRV_IFTYPE dw 0FFFFh ; TYPE, DX (Generic/Unspecified Mfr/Card type)
	DRV_IFNUM db 0 ; NUMBER, CL (First (0th) interface card for 1(Bluebook)/FFFF(Generic))
	DRV_NAME db "jrNIC$",0 ; NAME, DS:SI (Plain-text Name of the card)
	DRV_FUNC db 1 ; FUNCTIONALITY, AL (Implements basic functions only)

MAC_ADDRESS_TABLE LABEL BYTE
	db 00h, 03h, 01h, 04h, 01h, 05h ; Default made up source MAC address
MAC_ADDRESS_TABLE_L EQU $-MAC_ADDRESS_TABLE

;; Vars
;driver_in_use	dw 0000h
receive_offset	dw 0000h
receive_segment	dw 0000h
packet_size		dw 0000h
interuptee_stack_seg	dw 0000h
interuptee_stack_ptr	dw 0000h


PAGE
%OUT Processing JRNICHAL
INCLUDE JRNICHAL.ASM

PAGE
%OUT Processing jrNIC Utils
INCLUDE JRUTIL.ASM

;; Dummy receive handler, returns buffer size 0 aka error
RCV_DUMMY_RET PROC FAR
	xor		di,di
	mov		es,di ;; Always reply no buffer available
	ret
RCV_DUMMY_RET ENDP

;; Assumes Carry set/cleared as intended
;; Assumes all regs restored
;; Need to set IRET carry and then IRET
INT_PKT_SVC_CLEANUPM MACRO
	local	INT_PKT_SVC_IRET_GOOD
	local	INT_PKT_SVC_IRET_BAD
	push	bp	; Save caller BP
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

;; Input: NA
;; Output ERROR:
;;		Set Carry flag
;;		DH = BAD_COMMAND
;; Output SUCCESS: NA (this is the error service)
INT_PKT_SVC_00 PROC FAR ;; driver_error()
	pop		bx ; Restore caller's BX
				;; Point all invalid services here
				;; Return Carry + set return reason to BAD_COMMAND
	mov		dh,LOW BAD_COMMAND
	stc		; Indicate error condition
INT_PKT_SVC_00_CLEANUP:
	INT_PKT_SVC_CLEANUPM
INT_PKT_SVC_00 ENDP

;; Input: BX (Handle, Optional)
;; Output ERROR:
;;		Set Carry flag
;;		DH = Error Code (BAD_HANDLE)
;; Output SUCCESS:
;;		Clear Carry flag
;;		BX = Driver Version
;;		CH = Driver Interface Class (1h, Bluebook Ethernet class)
;;		DX = Driver Interface Type (0FFFFh, "Generic/Unspecified")
;;		CL = Driver Interface Number (0h, "attached card #1" of Bluebook Ethernet class/Generic type)
;;		DS:SI = Driver Interface Name (plain-text "jrNIC$")
;;		AL = Driver Supported Functions (1 - Basic)
;; Good
INT_PKT_SVC_01 PROC FAR ;; 6.3 driver_info()
	pop		bx ; Restore caller's BX


	push	ax ; Temporarily push AX to preserve AH
	mov		ax,cs
	mov		ds,ax ; DS used for variables

	;; Setup returns
	clc							; Return success
	mov		bx,[DRV_PKT_VERSION]
	mov		ch,[DRV_IFCLASS]
	mov		dx,[DRV_IFTYPE]
	mov		cl,[DRV_IFNUM]
	;mov		ax,cs
	;mov		ds,ax				; DS:SI = NAME, DS already set
	mov		si,offset DRV_NAME
	pop		ax					; restore AH
	mov		al,[DRV_FUNC]
INT_PKT_SVC_01_CLEANUP:
	INT_PKT_SVC_CLEANUPM
INT_PKT_SVC_01 ENDP

;;;;;;
; Notes
;	1.) Currently only supports 1 user handle
;	2.) Unconditionally sets, does not check if already owned
;; Good
INT_PKT_SVC_02 PROC FAR ;; 6.4 access_type() 
	pop		bx	; Restore caller's BX
				; All registers are currently caller's

	; 1.) Need to fully lock down INTS/NMI/IRQ
	;		to prevent accidental IRQ while changing RCV handle
	;		and protect card access
	; 2.) Ask card to disable RX (for safety)
	; 3.) Set up receiver segment/offset
	; 4.) Enable RX
	; 5.) Restore IRQ (ensure IRQ4 is unmasked)

	push	bp			; Use for scratch
	mov		bp,ax		; Store caller's AX in BP, AX is now free
	
	; Read current IRQ masks and push
	in		al,port_pic_data	; Read current IRQ mask register
	mov		ah,al				; Store current IRQ mask in AH
		; Ex: If interrupted here, they will return here before letting us continue so card would be used and returned
	; Externally Mask IRQs
	mov		al,0FFh				; Set IRQ mask to *ALL* masked
	out		port_pic_data,al	; IRQs masked, now disable NMI
		; At this point, even if an NMI fires and re-enables INTs, all IRQs are masked so none can fire
	
	; Externally Mask NMI
	mov		al,nmi_disable		; NMI disable bit
	out		port_nmi_mask_reg,al; NMI masked
		; At this point IRQs are masked and NMI is now masked, so it can no longer re-enable INTs
	
	; Disable Interrupts
	cli							; Disable INTs
		; At this point, IRQs masked, NMI masked, INTs disabled
	
	;; AH contains current IRQ Masks, BP contains user's AX

	;; For now, not validating what they gave us
	
	push	ax
	push	dx
	push	ds
	
	;; Disable reception
	call HAL_DISABLE_RX ; AX/DX/FLAGS

	mov		ax,cs
	mov		ds,ax ; Setup DATASEG=CS

	;; Grab ES:SI (receiver handle) and store
	mov		ax,es
	mov		[receive_segment],ax
	mov		[receive_offset],di
	
	;; Enable Reception (currently still card masked)
	call HAL_ENABLE_RX ; AX/DX/FLAGS

	pop		ds
	pop		dx
	pop		ax	; AH has current IRQ Masks, BP (on stack) still has user's AX
	
	; Enable interrupts
	sti 
	
	; Enable NMI
	mov		al,nmi_enable
	out		port_nmi_mask_reg,al	; Restore NMI
	in		al,port_nmi_mask_reg	; Read Port to clear latch,
									; For case a key was pressed
									; while NMI was masked
	
	; Externally Restore IRQs (and unmask IRQ4)
	mov		al,ah ; AL has old mask, need to unmask IRQ4
	and		al,NOT mask_modem_bit ; 1110 1111 clear/activate IRQ 
	out		port_pic_data,al
	
	pop		bp ; get back caller's original BP, discard AX since we don't need it
	
	;; Card is unmasked now and user's regs restored, set returns
	clc
	mov		ax,1 ; Set return handle to 1
INT_PKT_SVC_02_CLEANUP:
	INT_PKT_SVC_CLEANUPM ;; -- Exits
INT_PKT_SVC_02 ENDP

;; release type needs to mask driver
;; Good
INT_PKT_SVC_03 PROC FAR ;; 6.5 release_type()
	pop		bx ; Restore caller's BX

	; 1.) Need to fully lock down INTS/NMI/IRQ
	;		to prevent accidental IRQ while changing RCV handle
	;		and protect card access
	; 2.) Ask card to disable RX
	; 3.) Set receiver segment/offset to dummy
	; 4.) Restore IRQ (mask IRQ4)


	push	bp		; Push caller's BP
	mov		bp,ax	; Save caller's AX in BP

	; Read current IRQ masks and push
	in		al,port_pic_data	; Read current IRQ mask register
	mov		ah,al				; Store current IRQ mask in AH
		; Ex: If interrupted here, they will return here before letting us continue so card would be used and returned
	; Externally Mask IRQs
	mov		al,0FFh				; Set IRQ mask to *ALL* masked
	out		port_pic_data,al	; IRQs masked, now disable NMI
		; At this point, even if an NMI fires and re-enables INTs, all IRQs are masked so none can fire
	
	; Externally Mask NMI
	mov		al,nmi_disable		; NMI disable bit
	out		port_nmi_mask_reg,al; NMI masked
		; At this point IRQs are masked and NMI is now masked, so it can no longer re-enable INTs
	
	; Disable Interrupts
	cli							; Disable INTs
		; At this point, IRQs masked, NMI masked, INTs disabled
	
	;; AH contains current IRQ Masks, BP contains user's AX

	;; For now, not validating what they gave us
	push	ax
	push	dx
	push	ds
	
	;; Disable reception
	call HAL_DISABLE_RX ; AX/DX/FLAGS

	mov		ax,cs
	mov		ds,ax ; Setup DATASEG=CS

	;; Set receive to <cs>:<RCV_DUMMY_RET>
	mov		ax,cs
	mov		ds,ax
	mov		[receive_segment],ax ; 
	mov		[receive_offset],offset	RCV_DUMMY_RET
	
	pop		ds
	pop		dx
	pop		ax	; AH has current IRQ Masks, BP (on stack) still has user's AX
	
	; Enable interrupts
	sti 
	
	; Enable NMI
	mov		al,nmi_enable
	out		port_nmi_mask_reg,al	; Restore NMI
	in		al,port_nmi_mask_reg	; Read Port to clear latch,
									; For case a key was pressed
									; while NMI was masked
	
	; Externally Restore IRQs (and mask IRQ4)
	mov		al,ah ; AL has old mask, need to mask IRQ4
	or		al,mask_modem_bit ; 0001 0000 set/disable IRQ 
	out		port_pic_data,al
	
	mov		ax,bp ; Restore caller's AX
	pop		bp ; get back caller's original BP
	
	;; Card is masked now and user's regs restored, set return
	clc
INT_PKT_SVC_03_CLEANUP:
	INT_PKT_SVC_CLEANUPM	
INT_PKT_SVC_03 ENDP

INT_PKT_SVC_04 PROC FAR  ;; 6.6 send_pkt()
	pop		bx	; Restore caller's BX
	
	push	ax	; Push caller's AX (used for scratch)
	; Mask All Interupts Dance
	; 1.) Save initial IRQ masks
	in		al,port_pic_data		; Get current IRQ masks
	mov		ah,al					; Hold current IRQ masks in AH
	; 2.) Mask IRQs
	mov		al,0FFh					; Mask all IRQs
	out		port_pic_data,al		; IRQs masked
	; 3.) Mask NMI
	mov		al,nmi_disable			; Bit 7 = 0
	out		port_nmi_mask_reg,al	; Mask NMI
	; 4.) Mark IRQs as disabled with CPU flag
	cli								;post NMI disable
	; 5.) Unmask IRQs now that they're disabled
	mov		al,ah					; Recover IRQ mask
	out		port_pic_data,al		; Un-mask IRQs (still blocked by CLI)
	
	;; SAFE TO GO NOW
	
	; Access card
	push	dx	; Push caller's DX (used during card send)
	call	HAL_SEND_PKT ; uses AX, DX
	pop		dx
	; Unmask NMI
	mov		al,nmi_enable
	out		port_nmi_mask_reg,al	; Restore NMI
	
	; IRQ's re-enabled when exiting
	pop		ax ; Recover caller's AX
	clc			; Return good always (if it fails, they can always resend)
	INT_PKT_SVC_CLEANUPM ;; ----- EXIT INT_PKT_SVC_04, interrupts will be restored
INT_PKT_SVC_04 ENDP	

;; Good
; Doesn't access the card
; TODO - implement
INT_PKT_SVC_05 PROC FAR ;; terminate()
	pop		bx ; Restore caller's BX

	mov		dh,CANT_TERMINATE
	stc
	INT_PKT_SVC_CLEANUPM
INT_PKT_SVC_05 ENDP

; Doesn't access card
INT_PKT_SVC_06 PROC FAR ;; get_address()
	pop		bx ; Restore caller's BX

	push	ax
	push	ds

	mov		ax,cs
	mov		ds,ax ; Set DS
	
	;; Check if client has enough space for buffer
	cmp		cx,MAC_ADDRESS_TABLE_L ; Compare available buffer space to table Length
	jb		INT_PKT_SVC_06_FAIL ; If they don't have the space, bail
	
	;; Else, copy the MAC into their ES:DI buffer
	mov		cx,MAC_ADDRESS_TABLE_L ; Set count to MAC_ADDRESS_TABLE_L
	push	si
	push	di
	mov		si,offset MAC_ADDRESS_TABLE

	;; ES:DI = receive buffer already
	cld
	rep		movsb ; Copy MAC address, modifies SI, DI, and CX

	pop		di
	pop		si
; Setup returns
	mov		cx,MAC_ADDRESS_TABLE_L ; Set count to MAC_ADDRESS_TABLE_L
	clc
INT_PKT_SVC_06_CLEANUP:
	pop		ds
	pop		ax
	INT_PKT_SVC_CLEANUPM
INT_PKT_SVC_06_FAIL: ; Client didn't have the space, bail out
; Setup returns
	stc
	mov		dh,NO_SPACE
	jmp		INT_PKT_SVC_06_CLEANUP
INT_PKT_SVC_06 ENDP

;; Good
; Doesn't (currently) access the card
; TODO - implement
INT_PKT_SVC_07 PROC FAR ;; reset_interface()
	pop		bx ; Restore caller's BX
	
	mov		dh,CANT_RESET
	stc		; Indicate error condition
	INT_PKT_SVC_CLEANUPM
INT_PKT_SVC_07 ENDP

; Called services must:
; 1.) Immediately pop BX to retrieve caller's BX
; 2.) Must ensure proper carry is returned
INT_PKT_SVC_TABLE LABEL WORD
	dw		OFFSET INT_PKT_SVC_00 ; driver_error()
	dw		OFFSET INT_PKT_SVC_01 ; driver_info()
	dw		OFFSET INT_PKT_SVC_02 ; access_type()
	dw		OFFSET INT_PKT_SVC_03 ; release_type()
	dw		OFFSET INT_PKT_SVC_04 ; send_pkt() ; Is implemented directly, not accessed via SVC table
	dw		OFFSET INT_PKT_SVC_05 ; terminate()
	dw		OFFSET INT_PKT_SVC_06 ; get_address()
	dw		OFFSET INT_PKT_SVC_07 ; reset_interface()
INT_PKT_SVC_TABLE_L EQU $-INT_PKT_SVC_TABLE ; Length of table
INT_PKT PROC FAR
	jmp		NEAR PTR INT_PKT_START ; jmp over signature to continue
	pkt_drvr_signature	db "PKT DRVR",00h ; Required Packet Driver spec signature
	prog_signature		dw	offset PROGRAM_SIGNATURE ; Pointer to Program signature
INT_PKT_START:
	sti				; It'll take us a while to actually stop them anyway...
	push	bx		; Save caller BX, frees BX for scratch
	mov		bl,ah	; Move caller's AH (SVC#) to bl
	
	;; Setup offset calculation into packet service table, BL contains caller's AH (SVC#)
	sal		bl,1	; SVC * 2 = INT_PKT_SVC_TABLE entry offset
	cmp		bl,INT_PKT_SVC_TABLE_L ; Check if command is valid
	jae		INT_PKT_BAD_SVC ; If bad command go deal with that
INT_PKT_SVC_EXEC: ;; Else if good, jump to service handler
	xor		bh,bh	; Zero out upper address, valid BX values are 0-(14-1) decimal
					; So this is safe
	jmp		WORD PTR CS:[BX + OFFSET INT_PKT_SVC_TABLE] ; BX contains service handler offset
INT_PKT_BAD_SVC: ; If a bad command...
	xor		bl,bl	; if bad svc requested, force driver_error() handler
	jmp		SHORT INT_PKT_SVC_EXEC ; now go execute it	
INT_PKT ENDP




IRQ_RECV PROC FAR
	; CPUs disabled, PIC not ACK'd, interuptee's AX on the stack, AX==MEMORYSHIM
IRQ_RECV_MAIN:
	push	ds		; Push interuptee's DS on the stack
	mov		ds,ax	; Set DS to MEMORYSHIM
	
	mov		ax,ss
	mov		[interuptee_stack_seg],ax	
	mov		[interuptee_stack_ptr],sp	; Save interuptee's SS/SP

	; Mask All Interupts Dance
	; 1.) Save initial IRQ masks
	in		al,port_pic_data		; Get current IRQ masks
	mov		ah,al					; Hold current IRQ masks in AH
	; 2.) Mask IRQs
	mov		al,0FFh					; Mask all IRQs
	out		port_pic_data,al		; IRQs masked
	; 3.) Mask NMI
	mov		al,nmi_disable			; Bit 7 = 0
	out		port_nmi_mask_reg,al	; Mask NMI
	; 4.) Mark IRQs as disabled with CPU flag
	cli								;post NMI disable
	; 5.) Unmask IRQs now that they're disabled
	mov		al,ah					; Recover IRQ mask
	out		port_pic_data,al		; Un-mask IRQs (still blocked by CLI)
	
	;; Swap to internal stack
	mov		ax,ds ; Our memory shim
	mov		ss,ax
	;mov		sp,offset STACK_RECV_OFFSET
	mov		sp,offset STACK_OFFSET
	
	;; SAFE TO GO NOW
		
	; Push anything we need
;	push	ax ; Not needed
	push	bx
	push	cx
	push	dx
	push	bp
	push	si
	push	di
;	push	ds ; Not needed
	push	es
	
	;; --- Begin card accesses
	call	HAL_GET_PACKET_SIZE ; get packet size into AX (uses AX/DX/FLAGS), sets READ_PTR
	;; Ideally would check for zero
	sub		ax,4 ; Subtract Frame Check Sequence from length (Per Packet Spec)
	mov		[packet_size],ax	; Save packet size
	
	;; Copy packet to internal buffer so we can release the card
	mov		cx,ax
	mov		ax,cs
	mov		es,ax	; Setup ES
	mov		di,offset	RECV_BUFFER_OFFSET
	HAL_RXP ; Macro, uses AX/DX - Input: ES:DI, CX
	; Re-enable reception
	call	HAL_ENABLE_RX ; Re-enable/reset reception (uses AX/DX/flags)
	;; --- Card accesses complete
		
	;; Re-enable other interrupts (we haven't yet acknowledged IRQ4 so it shouldn't fire again)
		; Unmask NMI
	mov		al,nmi_enable
	out		port_nmi_mask_reg,al	; Restore NMI
		; Re-enable interrupts now that card accesses are complete
	sti							; Interrupts re-enabled
	
	;; Ok, now tell receiver (call 1) we have a packet, ask if they have room for it
	sub		ax,ax	; First call flag (0)
	mov		bx,1	; handle
	mov		cx,[packet_size]
	call	DWORD PTR [receive_offset] ; returns ES:DI buffer, 0:0 if no room
	
	;; Check ES:DI for zero:zero (would mean client can't take the packet)
	mov		ax,es
	or		ax,di
	jz		IRQ_RECV_END_PROCESSING ; They can't take the packet, bail
	
	;; Else, copy to receivers buffer (ES:DI is set, DS is set, need to set SI and CX)
	mov		si,offset	RECV_BUFFER_OFFSET
	mov		cx,[packet_size]
	; store important data for next call
	push	cx
	push	di
	push	es
	push	ds 
	cld
	rep		movsb	; Move DS:[SI] to ES:[DI], inc SI, inc DI, dec CX
	
	;; Ok, now tell receiver (call 2) the packet is there
	pop		es ; Our old DS
	pop		ds ; Their old ES
	pop		si ; Their old DI
	pop		cx ; Packet size
	push	es ; Our "ds", Packet driver isn't obligated to save this
	call	DWORD PTR es:[receive_offset]
	pop		ds ; put back in DS
IRQ_RECV_END_PROCESSING:	
		;; Restore regs
	pop		es
;	pop		ds
	pop		di
	pop		si
	pop		bp
	pop		dx
	pop		cx
	pop		bx
;	pop		ax	; No need to restore AX	
	
	; Swap back to old stack
	mov		ax,[interuptee_stack_seg]
	mov		ss,ax
	mov		sp,[interuptee_stack_ptr]	; Restore interuptee's SS/SP

	pop		ds							; Restore interuptee's DS
	ACK_IRQM ; Requires AX, ACK PIC IRQ
	pop		ax
	iret
IRQ_RECV ENDP



;; Test driver will only load at 0x60
;; Test driver will not check if previously loaded
;; Test driver will not unload (reboot required)
;; Test driver only RAM loadable
;; Test driver will load entirely into RAM
MAIN PROC FAR
	; Leave DS as is
	
	;1.) TODO - copy memoryshim to memory for cartridge

	;2.) Update DS:IRQ_RECV_SHIM_JMP to point at CS:IRQ_RECV
	mov		WORD PTR [IRQ_RECV_SHIM_JMP+1],offset IRQ_RECV
	mov		ax,cs
	mov		WORD PTR [IRQ_RECV_SHIM_JMP+3],ax ; Set segment

	; Ensure RCV HW IRQ is masked when driver is loaded
	MASK_IRQ4M ; Uses AX, Flags

	; Setup Default Receive handler
	mov		ax,cs
	mov		[receive_segment],ax
	mov		[receive_offset],offset RCV_DUMMY_RET

	; Setup Interrupt INT_PKT (sender API)
	mov		dx,offset INT_PKT ; DS:DX = segment/offset
	mov		ah,svc_dos_set_interrupt_25
	mov		al,int_default_pkt_driver
	int		int_dos_21
	
	; Setup Interrupt IRQ_RECV (receive HW IRQ)
	;mov		dx,offset IRQ_RECV ; DS:DX = segment/offset
	mov		dx,offset IRQ_RECV_SHIM
	mov		ah,svc_dos_set_interrupt_25
	mov		al,int_modem
	int		int_dos_21
	
	; Initialize, ENABLE_RX and UNMASK will be done upon access_type() (SVC_02) call
	call	HAL_INIT

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