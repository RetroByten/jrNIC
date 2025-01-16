TITLE jrNIC Driver
PAGE 66,132 ; 66 lines per page, 99 characters/line
 
; NOTE1: CRC needs to be calculated externally

;; High level jrNIC packet driver

;;; Knock-down list
; 1.) Cleanup LOAD and UNLOAD functions
;    1a.) Comment / clean up logic
;    1b.) create sub functions
; 2.) Integrate HAL backend


%OUT Processing jrNIC Build Options
ROM EQU 1 ; Set to 0 if COM, Set to 1 if ROM
;; Debugging options - only work in ROM
DEBUG EQU 1 ; Set to 0 if not debugging
DEBUG_TEST1 EQU 0 ; CORE COMMANDS: 
					; HW_RESET
					; HW_READ_ETH_REGISTER
					; HW_WRITE_REGISTER
DEBUG_TEST2 EQU 0 ; CORE COMMANDS: 
					; HW_BIT_FIELD_SET
					; HW_BIT_FIELD_CLEAR
DEBUG_TEST3 EQU 0 ; SUPPORT COMMANDS: 
					; HW_GET_CONTROLLER_BANK
					; HW_SET_CONTROLLER_BANK
DEBUG_TEST4 EQU 0 ; COMPOUND COMMANDS: 
					; HW_WRITE_REGISTER_LOW_HIGH
					; HW_READ_ETH_REGISTER_LOW_HIGH
DEBUG_TEST5 EQU 0	; SUPPORT COMMANDS: HW_SET_ERDPT, HW_SET_EWRPT
DEBUG_TEST6 EQU 0 ; CORE COMMANDS: 
					; READ/WRITE BUFFER MEMORY BYTE
					; READ/WRITE BUFFER MEMORY WORD
DEBUG_TEST7 EQU 0 ; CORE COMMANDS: READ/WRITE BUFFER MEMORY (ARRAY)
DEBUG_TEST8 EQU 0 ; CORE COMMANDS: 
					; READ/WRITE MAC/MII
					; READ/WRITE PHY Register

DEBUG_VERIFY_BUFFER EQU 0 ; Verify Controller buffers					
DEBUG_VERIFY_FILTER EQU 0 ; Verify Controller filters
DEBUG_VERIFY_MODE EQU 0 ; Verify Controller Mode
DEBUG_VERIFY_PHY EQU 0 ; Verify Controller Physical Interface
;;;;;; TODO - fix debug function

IF ROM
	%OUT ROM building
ELSE
	%OUT COM building
ENDIF

PAGE
%OUT Processing jrNIC Equates (Beginning)
INCLUDE JREQUB.ASM ; These are statically known up-front

PAGE
%OUT Processing jrNIC Macros
INCLUDE JRMACROS.ASM

; Input: None
; Output: 
;	jz, zero flag set (1) if interrupt was unmasked (Active,0)
;	jnz, zero flag clear (0) if interrupt was masked (card in use,1)
; Destroys AH, Flags
FORCE_MASK_IRQ_CHECKM MACRO
	in		al,port_pic_data	; Read current IRQ masks
	mov		ah,al				; Save current IRQ masks
	or		al,mask_modem_bit	; Unconditionally mask (if it's already masked its no loss)
	test	ah,mask_modem_bit	; Check if saved IRQ masks has modem masked
ENDM

MASK_IRQ4M MACRO
	in		al,port_pic_data
	or		al,mask_modem_bit ; 0001 0000 mask IRQ off
	out		port_pic_data,al
ENDM

UNMASK_IRQ4M MACRO
	in		al,port_pic_data
	and		al,NOT mask_modem_bit ; 1110 1111 clear/activate IRQ
	out		port_pic_data,al ; write interrupt controller mask reg to unmask modem
ENDM

ACK_IRQM MACRO
	mov		al,val_pic_eoi		; Unconditionally ACK hardware Interrupt
	out		port_pic_cmd,al
ENDM

PAGE
SHIMSEG SEGMENT AT 0h ; Memory resident at end of PSP
	assume CS:SHIMSEG
	ORG 100h
	jmp		NEAR PTR PLACEHOLDER_JMP ; Placeholder
	PLACEHOLDER_JMP:
SHIMSEG ENDS

PAGE
CODESEG SEGMENT
	assume CS:CODESEG, DS:CODESEG, SS:CODESEG
	BEGINOFPROG EQU $	; Mark 0000h for calculations
IF ROM 	;; Cartridge Header
	ORG 0
	PROGRAM:
	CARTSIG		dw 0AA55h						; Cartridge Signature
	CARTSIZ		db (ENDOFPROG - BEGINOFPROG) / 512	; Cartride size in 512 byte chunks
	jmp			NEAR PTR INIT					;; Cartridge BIOS Init Entry Point
	DOSCMD1L	db DOSCMD1E - DOSCMD1S			; Length of DOS Command1 name
	DOSCMD1S	db "CJRNIC"						; DOS Command1 name string
	DOSCMD1E:									; End of Command1 name string
	jmp			NEAR PTR MAIN					;; DOS Command1 Entry Point
	DOSCMD2L	db DOSCMD2E - DOSCMD2S			; Length of DOS Command2 name
	DOSCMD2S	db "CCARTINI"						; DOS Command2 name string
	DOSCMD2E:									; End of Command2 name string
	jmp			NEAR PTR INITDOS				;; DOS Command2 Entry Point
IF DEBUG ;; DEBUGGING TEST FUNCTION
	DOSCMD3L	db DOSCMD3E - DOSCMD3S			; Length of DOS Command3 name
	DOSCMD3S	db "CJRNICT"					; DOS Command3 name string
	DOSCMD3E:									; End of Command3 name string
	jmp			NEAR PTR TESTCART				;; DOS Command3 Entry Point
	DOSCMD4L	db DOSCMD4E - DOSCMD4S			; Length of DOS Command4 name
	DOSCMD4S	db "CDEBUG"						; DOS Command4 name string
	DOSCMD4E:									; End of Command4 name string
	jmp			NEAR PTR CDEBUG					;; DOS Command4 Entry Point
ENDIF
	CARTEOH		db 00h							; End of cartridge header
	;; TODO - Currently wasted space :(
	ORG	100h
	jmp			NEAR PTR PROGRAM				; Placeholder for segment alignment
ELSE 	;; DOS COM Entry
	ORG	100h
	PROGRAM:
	jmp			NEAR PTR MAIN				; DOS Command Entry Point
ENDIF

PAGE ;; Memory SHIM
MEMORYSHIMBEGIN: ; For ROM runs, this will be copied into RAM at end of PSP
;;; - PKT INT API ENTRY
PKT_INT_SHIM_ENTRY:
	jmp		NEAR PTR PKT_INT_SHIM_CONT ; Near ptr for alignment and PKT DRVR SPEC
	PKT_DRIVER_SIGNATURE_MACRO
	PROGRAM_SIGNATURE_MACRO
PKT_INT_SHIM_CONT:
	sti ; Re-enable interrupts
	push	bp	; Use BP to pass PSP/MEM because we won't use caller's BP but need
				; Most of the rest of the caller's args
	mov		bp,cs ; Pass resident PSP/Mem to function
	PKT_INT_SHIM_CALL: ; For fixing the absolute call
	call	FAR PTR PLACEHOLDER_JMP ; dummy, replaced at runtime with CS:PKT_DRV_CORE, sets/clears carry
	PKT_INT_SHIM_COMPLETE:
	mov		bp,sp ; Get current stack pointer, should have nothing but BP + OFFSET + SEG + FLAGS
				  ;                                                    0    2        4     6
	jc		SHORT PKT_INT_SHIM_RET_GOOD
PKT_INT_SHIM_RET_GOOD: ; Clear carry flag on stack
	and		BYTE PTR [bp+6],0FEh ; SS:
	pop		bp
	iret
	;jmp		SHORT RET_DONE
PKT_INT_SHIM_BAD: ; Set carry flag on stack
	or		BYTE PTR [bp+6],01h ; SS:
	pop		bp
	iret
;;; - PKT RCV IRQ ENTRY
RCV_INT_SHIM_ENTRY:  ;; Can't call any cartridge fuctions directly because they'd be 
						; near cartridge calls and we're far away in RAM
	;; Preserve ALL registers except flags because we are an IRQ!
	;; Do as little as possible here because we're possibly in slow RAM
	;; Save actual work for 
	push	ax				; 1.) Preserve interuptee's AX on interuptee's stack
	mov		ax,cs			; 2.) Give real IRQ the MEMORYSHIMBEGIN segment
	RCV_INT_SHIM_CALL: 
	jmp		FAR PTR PLACEHOLDER_JMP ; dummy placeholder, replaced at runtime with CS:RCV_INT_MAIN
									; - Must pop AX and iret when complete
									; - Must ACK PIC IRQ (unconditionally)
									; - Must check if card is in use (for sanity)
									; - Must clear jrNIC interrupt line (if not in use)
;	call	FAR PTR PLACEHOLDER_JMP ; dummy	; Replaced at runtime with CS:RCV_INT_MAIN
											; at runtime
											; Must check if card is in use
											; Must clear jrNIC interrupt line (if owns card)
											; and ACK PIC IRQ (unconditionally)
;	pop		ax ; Restore interuptee's AX from interuptee's stack
;	iret
MEMORY_DATA_OFFSET:
	orig_int_offset 			dw 0FEC0h ; Dummy
	orig_int_segment 			dw 0EFBEh ; Dummy
	orig_recv_offset 			dw 0DDDDh ; Dummy
	orig_recv_segment 			dw 0CCCCh ; Dummy
MEMORY_DATA_RECEIVERS:
	receiver_call_ptrs			dd HANDLE_COUNT dup(0FFFFFFFFh); 4 bytes per entry
	packet_size					dw 0000h ; Dummy
	int_pkt_driver				db int_default_pkt_driver ; Dummy
	;PACKET_BUFFER_SIZE EQU TX_ADDRESS_END - TX_ADDRESS_START + 1
	PACKET_BUFFER_SIZE			EQU 5ffh
	pkt_mem_buffer				db PACKET_BUFFER_SIZE dup(00h)
MAC_ADDRESS_TABLE LABEL BYTE
	db 00h, 03h, 01h, 04h, 01h, 05h ; Default made up source MAC address
MAC_ADDRESS_TABLE_L EQU $-MAC_ADDRESS_TABLE
	IF ROM
		allow_unload_env		db 0h ; Can't unload ROM env
	ELSE
		allow_unload_env		db 1h
	ENDIF
	PARA_ALIGN_MACRO ;; Necessary for both paragraph reservation and MOVSW
MEMORYSHIMEND: 	
;;; TODO - move pkt_ram_buffer out of the SHIM definition since they can be done by malloc

PAGE
%OUT Processing JRNICHAL
INCLUDE JRNICHAL.ASM

PAGE
debug_recv_seg db "Receive Segment$"
debug_recv_off db "Receive Offset$"
debug_str_mask db "Mask$"
CDEBUG PROC FAR
	mov		ax,cs
	mov		ds,ax
	;; Print Receive IRQ
	mov		ah,svc_dos_get_interrupt_35
	mov		al,int_modem
	int		int_dos_21					; Set MODEM (RECV) Interrupt
	;; sets ES:BX
	UTILM_PRINT_WREG debug_recv_seg,es
	UTILM_PRINT_COLON
	UTILM_PRINT_WREG debug_recv_off,bx
	UTILM_PRINT_NEWLINE
	
	;; Print Mask
	in		al,port_pic_data
	mov		ah,al
	UTILM_PRINT_BREG debug_str_mask,ax
	UTILM_PRINT_NEWLINE

	EXITCLEAND:
	mov		ax,(svc_dos_terminate_4C SHL 8) OR val_dos_terminate_00
	int		int_dos_21
	DEBUG_PARA_ALIGN_MACRO
CDEBUG ENDP

PAGE
SVC_00 PROC FAR ;; driver_error
	pop		si
	mov		dh,LOW BAD_COMMAND
	stc
	ret ; Far Return
SVC_00 ENDP
SVC_01 PROC FAR ;; driver_info
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
	
	clc
	ret ; Far Return
SVC_01 ENDP
SVC_02 PROC FAR ;; access_type
	pop		si
	;;;
	mov		ax,0001h; always return handle 1
	clc
	ret ; Far Return
SVC_02 ENDP

PAGE
DEBUG_PARA_ALIGN_MACRO
INT_SVC_TABLE LABEL WORD
	dw		OFFSET SVC_00 ; driver_error
	dw		OFFSET SVC_01 ; driver_info
	dw		OFFSET SVC_02 ; access_type
INT_SVC_TABLE_L EQU $-INT_SVC_TABLE ; Length of table

PKT_INT_MAIN PROC FAR
	;; BP = RESIDENT MEMORY SEGMENT IF NEEDED TO STORE / SWAP STACK FRAME
	;; CAN'T CHANGE STACK UNLESS YOU CHECK IF RECV INTERRUPT IS UNMASKED
	;; TO ENSURE ONLY 1 COPY OF THIS IS RUNNING!!!
	
	;; Calculate command offset
	push	si ; Save SI, used for temporary offset
	push	ax
	mov		al,ah ; al=SVC
	xor		ah,ah ; ah=0
	sal		ax,1 ; SVC*2 = INT_SVC_TABLE entry
	mov		si,ax ; SI = INT_SVC_TABLE entry
	pop		ax
	cmp		si,INT_SVC_TABLE_L ; Check if command is valid
	jb		PKT_INT_MAIN_SVC_EXE ; if yes, execute
	xor		si,si ; if no, force invalid command entry
PKT_INT_MAIN_SVC_EXE: ;; CAN'T BE A CALL BECAUSE OF SI RECOVERY
	jmp		WORD PTR CS:[SI + OFFSET INT_SVC_TABLE] ; will return on it's own, must pop SI
	DEBUG_PARA_ALIGN_MACRO
PKT_INT_MAIN ENDP

debug_str_int_called db "Interrupt!$"
debug_str_int_nmi db "NMI Mask$"
debug_str_int_reject db "Rejected!$"
RCV_INT_RANGE_JMP_END:
	jmp		NEAR PTR RCV_INT_MAIN_END
RCV_INT_RANGE_JMP_DONE:
	jmp		NEAR PTR RCV_INT_MAIN_DONE
RCV_INT_MAIN PROC FAR ; SHIM needs to point here for RX
	; AX contains MEMOERYSHIM SEGMENT, MUST PRESERVE ALL REGISTERS EXCEPT FLAGS
	; - Must pop AX and iret when complete (unconditionally)
	; - Must ACK PIC IRQ (unconditionally)
	; - Must check if card is in use (for sanity)
	; - Must clear jrNIC interrupt line (if not in use)
	sti						; Re-enable interrupts
	push	ds				; Preserve caller's DS
	push	dx				; Preserve DX
	push	bp				; Preserve BP
	mov		ds,ax			; Set DS to MEMORYSHIMBEGIN segment
	FORCE_MASK_IRQ_CHECKM 	; Mask IRQ4/Check if already masked
									; Yes this is here...
									; Technically it shouldn't be needed
									; because if something was using
									; the card it would mask IRQ preventing
									; out entry, but for everyone's sanity
									; we'll keep this check here
	jnz		RCV_INT_RANGE_JMP_END	; Card is in use, bail, should NOT be possible
	
	;; Card not in use and is now marked for use

;	DO THINGS, preserve all registers used
	call	HAL_DISABLE_RX ; Disable further reception, uses AX/DX/FLAGS
	UTILM_PRINT_STRN debug_str_int_called
	
	;; Read Packet Size, check for weird error, and save
	call	HAL_GET_PACKET_SIZE ; get packet size into AX, uses AX/DX/FLAGS
	cmp		ax,0h ; just in case packet is somehow zero?
	je		RCV_INT_RANGE_JMP_DONE ; Shouldn't be possible, but whatever...
	mov		[packet_size],ax ; Save packet size
	
	;; Swap STACK from interuptee to internal
	mov		dx,ss 		; Save interuptee's stack SS:SP in registers
	mov		bp,sp
	
	; Disable NMI (to protect Stack swap)
	mov		al,nmi_disable
	out		port_nmi_mask_reg,al

	; Setup internal stack
	mov		ax,ds
	cli			; Disable interrupts
	mov		ss,ax
	mov		sp,offset RESIDENT_BLOCK_SIZE_R
	sti 	; Enable interrupts
		
	; Enable NMI
	mov		al,nmi_enable
	out		port_nmi_mask_reg,al
	in		al,port_nmi_mask_reg ; Clear NMI latch
	
	;; Push EVERYTHING, receiver only saves DS, SS, SP, and FLAGS
	;push	ax ; already preserved
	push	bx
	push	cx
	push	dx ; interuptee's stack segment
	push	bp ; interuptee's stack pointer
	push	si
	push	di
	;push	ds ; already preserved
	push	es
	
	;;;;;; SAFETY ZONE
	;; Copy packet to internal buffer
	mov		ax,ds
	mov		es,ax ; Set ES to SHIM
	mov		di,offset pkt_mem_buffer ; DI = offset
	mov		cx,[packet_size] ; CX = packet size in bytes
	call	HAL_RX
	
	;; LOOP FOR each registered caller, notify them about the packet 
	xor		bx,bx ; Start at handle 0
RCV_INT_NOTIFY_LOOP: 
	xor		ax,ax ; First call, flag is 0
	mov		cx,[packet_size] ; CX = packet size in bytes
	push	bx ; Save BX
	call	DWORD PTR [receiver_call_ptrs + bx] ; destroys everything except DS, SS, SP, and FLAGS
	pop		bx ; Restore BX
		; Check if caller gave us a good buffer back. ES:DI == 0:0 if buffer bad, else good
	cmp		di,0h
	jne		RCV_INT_NOTIFY_LOOP_COPY ; if DI != 0, we know we got a good buffer!
	mov		ax,es
	cmp		ax,0h ; if DI was 0, it may still be valid unless ES is also 0
	je		RCV_INT_NOTIFY_LOOP_UPDATE ; If 0:0, this caller doesn't want it, update loop
RCV_INT_NOTIFY_LOOP_COPY: ;; Caller does want it, ES:DI has buffer
	; DS is still set to SHIM
	push	di ; Save DI, contains recv buffer offset
	mov		si,offset pkt_mem_buffer ; internal buffer offset
	mov		cx,[packet_size]
	cld		; Forward direction
	rep		movsb
	pop		si ; pop DI into SI, contains recv buffer OFFSET
	
	push	ds ; Save DS SHIM
	mov		ax,ds
	mov		es,ax ; now DS = BUFFER
	mov		ax,1h ; Second call flag
	mov		cx,es:[packet_size] ; CX = packet size in bytes
	push	bx ; Save receiver offset
	call	DWORD  PTR es:[receiver_call_ptrs + bx] ; destroys everything except DS, SS, SP, and FLAGS
	pop		bx ; Restore receiver offset
	pop		ds ; put back DS=SHIM
RCV_INT_NOTIFY_LOOP_UPDATE:
	add		bx,4h
	cmp		bx,SIZE receiver_call_ptrs
	jb		RCV_INT_NOTIFY_LOOP
	;;;;;; END SAFETY ZONE

	;; Pop EVERYTHING
	pop		es
	;pop	ds ; already preserved
	pop		di
	pop		si
	pop		bp ; interuptee's stack pointer
	pop		dx ; interuptee's stack segment
	pop		cx
	pop		bx
	;pop	ax ; already preserved
	;; Restore interuptee's STACK
	
	; Disable NMI (to protect Stack swap)
	mov		al,nmi_disable
	out		port_nmi_mask_reg,al
	
		; Return to old stack
	cli 			; Disable interrupts
	mov		ss,dx
	mov		sp,bp
	sti 			; Enable interrupts

	; Enable NMI
	mov		al,nmi_enable
	out		port_nmi_mask_reg,al
	in		al,port_nmi_mask_reg ; Clear NMI latch

RCV_INT_MAIN_DONE:	
	call	HAL_ENABLE_RX ; Conditionally Re-enable reception
	UNMASK_IRQ4M ; Conditionally Unmask (activate) IRQ4
RCV_INT_MAIN_END: ;; Restore bp/dx/ds, ACK the PIC interrupt that got us here, restore AX
	pop		bp					
	pop		dx
	pop		ds 		; Restore BP/DX/DS off of interuptee's stack (was pushed in SHIM)
	ACK_IRQM		; ACK PIC IRQ
	pop		ax 		; Restore AX off of interuptee's stack (was pushed in SHIM)
	iret			; Return control to interuptee
RCV_INT_MAIN ENDP

;; Dummy receive handler, returns buffer size 0 aka error
; BX = handle
; CX = packet size
debug_str_handle db "Handle$"
debug_str_size db "Size$"
debug_str_call db "Call$"
RCV_DUMMY_RET PROC FAR
	UTILM_PRINT_WREG debug_str_handle,bx
	UTILM_PRINT_NEWLINE
	UTILM_PRINT_WREG debug_str_call,ax
	UTILM_PRINT_NEWLINE
	UTILM_PRINT_WREG debug_str_size,cx
	UTILM_PRINT_NEWLINE
	xor		di,di
	mov		es,di
	ret
RCV_DUMMY_RET ENDP

IFE ROM ; COM Align end of TSR
	PARA_ALIGN_MACRO
	db "ENDOFTSRCODEBLCK"; Debug
ENDIF
ENDOFTSR: ;; Marks the end of the TSR section if we implement TSR ability

PAGE
DRIVER_INFO_MACRO ; DRIVER INFO for init

PAGE
IF ROM
INIT PROC FAR 	; BIOS enters, TODO
IF DEBUG
	UTILM_PRINT_STRN debug_txrx_reset
ENDIF
	MASK_IRQ4M
	;call	MASK_IRQ4 ; ensure no gibberish receives can occur
	call	HAL_RESET ; Reset the card
	; Intentionally leaves card masked, driver will properly initialize later
	ret ; Far Return
	DEBUG_PARA_ALIGN_MACRO
INIT ENDP
INITDOS PROC FAR
	push	cs ; setup segment for correct far return from near call
	call	NEAR PTR INIT
	mov		ax,(svc_dos_terminate_4C SHL 8) OR val_dos_terminate_00
	int		int_dos_21
INITDOS ENDP
ENDIF

; INPUT: CL = int to check
; OUTPUT: 
CHECKINT PROC NEAR
	push	cx

	;; Get interrupt value
	mov		ah,svc_dos_get_interrupt_35
	mov		al,cl
	int		int_dos_21 ; ES:BX has original values
	add		bx,3 ; Skip over jmp
	mov		di,bx ; set ES:DI to offset + 3
	
	;; Set DS:SI
	mov		ax,cs
	mov		ds,ax
	mov		si,offset drvr_signature
	
	; Set Count & Direction
	mov		cx,offset drv_signature_end - offset drvr_signature
	cld
	; Do the compare
	repe	cmpsb
	je		CHECKINTMATCH
CHECKINTNOMATCH:
	clc
	jmp		SHORT CHECKINTDONE
CHECKINTMATCH:
	stc
CHECKINTDONE:
	pop		cx
	ret
	DEBUG_PARA_ALIGN_MACRO
CHECKINT ENDP

; Return: 
; INT FOUND: Carry Set, CL = int #
; INT NOT found: Carry clear
CHECKLOADED PROC NEAR
	push	es
	push	ds
	;; Need to loop 60h to 80h
	mov		cx,60h
CHECKLOADEDLOOP:
	call	CHECKINT
	jc		CHECKLOADEDDONE
	inc		cl
	cmp		cl,80h
	ja		CHECKLOADEDDONE
	jmp		CHECKLOADEDLOOP
CHECKLOADEDDONE:
	pop		ds
	pop		es
	ret ; Carry was set or not set by CHECKINT
	DEBUG_PARA_ALIGN_MACRO
CHECKLOADED ENDP

; DL has Count, 1 or 0
; AL has byte
SAVE_INT_NIBBLE PROC NEAR
	push	dx
	mov		dh,[int_pkt_driver] ; get current packet driver
	or		dh,al
	cmp		dl,0h
	jz		SAVE_INT_NIBBLE_END
	shl		dh,1 ; Else this is the high nibble
	shl		dh,1
	shl		dh,1
	shl		dh,1
SAVE_INT_NIBBLE_END:
	mov		[int_pkt_driver],dh
	pop		dx
	ret
SAVE_INT_NIBBLE ENDP

PAGE
SET_DESIRED_INT PROC NEAR
	; Need to search PSP:80-FFH (DOS args)
	; looking for first two ASCII characters representing hex digits
	
	; 0.) Set current int_pkt_driver to 0 by default
	xor		al,al
	mov		[int_pkt_driver],al ; Zero pkt driver int
	
	; 1.) Looking for any two valid ASCII numbers
	mov		dl,02h ; Need to find 2 valid chars, not worried about sequential
	
	; 2.) Get length of DOS command line args
	mov		si,val_dos_args_80h
	mov		cl,[si] ; Get number of chars
	inc		si
	
	; 3.) Loop over DOS command line arg characters
SET_DESIRED_INT_LOOP:  ; TODO: is this off by 1
	; Need to check CL because CL may have been zero to start
	cmp		cl,00h					; If we ran out of characters without finding 2
	je		SET_DESIRED_INT_NOTFOUND	; Desired Int Not Found
	mov		al,[si]					; Get next character
	inc		si						; Inc index
	dec		cl						; Dec number of characters left
	call	UTIL_ASCII_NUM_TO_HEX	; Check if current character is ASCII num
	jc		SET_DESIRED_INT_LOOP	; If not, loop to check next number
	dec		dl						; If it was, decrement found character count
	call	SAVE_INT_NIBBLE			; Save character to [int_pkt_driver]
	cmp		dl,00h					; Check if we've found 2
	je		SET_DESIRED_INT_FOUND	; If so, we're done
	jmp		SHORT SET_DESIRED_INT_LOOP	; Else check next character
SET_DESIRED_INT_FOUND:		; We found our number
	; Check if between 60 and 80h
	mov		al,[int_pkt_driver]
	cmp		al,60h						; check if less than 60h
	jb		SET_DESIRED_INT_NOTFOUND
	cmp		al,80h						; check if greater than 80h
	ja		SET_DESIRED_INT_NOTFOUND
	clc									; Valid INT found!
	ret
SET_DESIRED_INT_NOTFOUND:
	stc
	ret
SET_DESIRED_INT ENDP
PAGE


RESET_RECV_CALLEE PROC NEAR
	
	xor		bx,bx
	mov		ax,cs
RESET_RECV_CALLEE_LOOP:
	mov		word ptr [receiver_call_ptrs+bx],offset RCV_DUMMY_RET 
	add		bx,2
	mov		word ptr [receiver_call_ptrs+bx],ax ; Segment
	add		bx,2
	cmp		bx,SIZE receiver_call_ptrs ; number of bytes
	jb		RESET_RECV_CALLEE_LOOP
	ret
RESET_RECV_CALLEE ENDP

LOAD_RESIDENT_TSR PROC NEAR
	UTILM_PRINT_STR debug_str_loading
IF ROM ; If RAM, not necessary as we will use the existing resident block
	; 0.) Copy CS:MEMORYSHIMBEGIN block to DS:RAM
	push	ds ; save DS=PSP
		; Set ES:DI to destination (PSP:MEMORYSHIMBEGIN)
	mov		ax,ds
	mov		es,ax ; ES=PSP
	mov		di,offset MEMORYSHIMBEGIN ; Has matching offset in ROM
		; Set DS:SI to source (CS:MEMORYSHIMBEGIN)
	mov		ax,cs
	mov		ds,ax ; DS=CODE
	mov		si,offset MEMORYSHIMBEGIN
		; Set word count and direction
	mov		cx,(offset MEMORYSHIMEND - offset MEMORYSHIMBEGIN)/2 ; words
	cld
		; Move!
	rep		movsw
	pop		ds ; restore DS=PSP
ENDIF
	; 1.) Fix PSP:call	FAR PTR PLACEHOLDER_JMP to CS:PKT_INT_MAIN
	mov		ax,offset PKT_INT_MAIN
	mov		WORD PTR [PKT_INT_SHIM_CALL+1],ax ; call <offset>
	mov		ax,cs
	mov		WORD PTR [PKT_INT_SHIM_CALL+3],ax ; call <offset> <seg>
	
	; 2.) Fix PSP:call	FAR PTR PLACEHOLDER_JMP to CS:RCV_INT_MAIN
	mov		ax,offset RCV_INT_MAIN
	mov		WORD PTR [RCV_INT_SHIM_CALL+1],ax ; call <offset>
	mov		ax,cs
	mov		WORD PTR [RCV_INT_SHIM_CALL+3],ax ; call <offset> <seg>
	
	; 3.) Figure out what INT user wants to use
	call	SET_DESIRED_INT 
	jnc		SET_DEFAULT_RECV_CALLEE 	; If success, continue
	;; Print error		; Else
	mov		ah,[int_pkt_driver]
	UTILM_PRINT_BREG str_invalid_int, ax
	stc ; indicate error
	ret ; exit
	
	
	; 4.) Receive interrupt tries to pass packets to a registered callee
	;	Set the default registered callee to a dummy pointer
SET_DEFAULT_RECV_CALLEE:	
	call	RESET_RECV_CALLEE
	
	; 5.) Load PKT Driver INT API
LOAD_TSR_INT:
	mov		ah,[int_pkt_driver]
	UTILM_PRINT_BREG debug_str_int,ax
	UTILM_PRINT_NEWLINE
	
	; 5a.) Retrieve old int + store in DS:[orig_int_offset]
	mov		ah,svc_dos_get_interrupt_35
	mov		al,[int_pkt_driver]
	int		int_dos_21					; Get Old interrupt
;	 ES:BX has original values	
	mov		[orig_int_offset],bx
	mov		bx,es
	mov		[orig_int_segment],bx
		
	; 5b.) Set new int to PSP:MEMORYSHIMBEGIN
	; ds already = PSP
	mov		dx,offset MEMORYSHIMBEGIN
	mov		ah,svc_dos_set_interrupt_25
	mov		al,[int_pkt_driver]
	int		int_dos_21					; Set PKT Driver Interrupt
	
	; 6.) Load IRQ RECV INT
LOAD_RECV_INT:
	; ds already = PSP
	mov		dx,offset RCV_INT_SHIM_ENTRY
	mov		ah,svc_dos_set_interrupt_25
	mov		al,int_modem
	int		int_dos_21					; Set MODEM (RECV) Interrupt
	
	clc ; Successfully loaded
	ret
LOAD_RESIDENT_TSR ENDP
PAGE
UNLOAD_RESIDENT_TSR PROC NEAR
	UTILM_PRINT_STR debug_str_unloading
	push	cx
	mov		ch,cl
	UTILM_PRINT_BREG debug_str_int,cx
	UTILM_PRINT_NEWLINE
	pop		cx
	
	; TODO; Disable/Mask Receive interrupt!
	; TODO; Also reset Receive HW interrupt

	
	; Step 1; Retrieve vector
	mov		ah,svc_dos_get_interrupt_35
	mov		al,cl
	;push	cx
	int		int_dos_21 ; ES:BX has original values
	;pop	cx
	
	push	es ; Store the resident PSP segment
	push	ds
	
	;; Step 2; Reset vector (Need to set DS:DX)
	mov		dx,es:[orig_int_segment]
	mov		ds,dx
	mov		dx,es:[orig_int_offset]
	mov		ah,svc_dos_set_interrupt_25
	mov		al,cl
	int		int_dos_21	

	pop		ds
	pop		es ; Get back resident PSP
	; Step 3 - Free memory
	
	;debug_str_allow_env_unload
	;; Check if legal to free ENV - only legal for resident COM
	; See: https://www.brutman.com/forums/viewtopic.php?p=9806#p9806
	mov		al,es:[allow_unload_env]
	cmp		al,00h
	jz		FREE_TSR
FREE_ENV:
	UTILM_PRINT_STRN debug_str_allow_env_unload
	; Step 3a - Free TSR's environment (ES:2ch)
	push	es ; Save ES
	mov		ax,es:[val_dos_env_offset_2C]
	mov		es,ax
	UTILM_PRINT_WREG debug_str_2ct,ax ;; DEBUG
	UTILM_PRINT_NEWLINE ;; DEBUG
	mov		ah,svc_dos_free_memory_49
	int		int_dos_21
	pop		es ; Restore ES
FREE_TSR:
	; Step 3b - Free TSR itself
	mov		ah,svc_dos_free_memory_49
	int		int_dos_21
	ret
UNLOAD_RESIDENT_TSR ENDP

SET_BLOCK PROC NEAR
	mov		ax,ds
	mov		es,ax ; Set ES to PSP
	mov		bx,MEMORY_BLOCK_PARA
	mov		ah,svc_dos_setblock_4A
	int		int_dos_21
	ret
SET_BLOCK ENDP

DEBUG_PRINT_PROC PROC NEAR
	DEBUG_PRINT:
	UTILM_PRINT_SEGS
	; get PSP:2C
	mov		ax,ds:[val_dos_env_offset_2C]
	UTILM_PRINT_WREG debug_str_2c,ax
	UTILM_PRINT_NEWLINE
	ret
DEBUG_PRINT_PROC ENDP

debug_str_init_adapter db "Initializing Adapter...$"
debug_str_enable_rx db "Enabling RX...$"
INIT_ADAPTER PROC NEAR
	; Call HAL_INIT to initalize card
	; then setup PCjr default HW RX interrupt
	; then enable PCjr HW RX interrupt
	; then enable HAL_ENABLE_RX
	UTILM_PRINT_STRN debug_str_init_adapter
	call	HAL_INIT ; Initialize the card
	UTILM_PRINT_STRN debug_str_enable_rx
	call	HAL_ENABLE_RX
	ret
INIT_ADAPTER ENDP

;;;;;;;;;;;;;;;;;;;;
;; MAIN
;;;;;;;;;;;;;;;;;;;;
DEBUG_PARA_ALIGN_MACRO
debug_str_loading db "Loading...$"
debug_str_unloading db "Unloading...$"
debug_str_allow_env_unload db "Free ENV$"
debug_str_int db "Int$"
debug_str_2c db "Environment (PSP:2Ch)$"
debug_str_2ct db "TSR Environment (PSP:2Ch)$"
str_cs db "CS$"
str_ds db "DS$"
str_es db "ES$"
str_ss db "SS$"
str_sp db "SP$"
str_invalid_int db "Arg1 must be between 60 and 80 hex"
db 0dh,0ah
db "Interupt requested$"
debug_str_masking db "Masking...$"
debug_str_unmasking db "Unmasking...$"
debug_str_resetting_adap db "Resetting adapter...$"
debug_str_checkmask db "Check masking...$"
DEBUG_PARA_ALIGN_MACRO
MAIN PROC FAR
	UTILM_PRINT_SEGS		;; Debug print
;; Step 0.) Move the stack pointer in to top of needed memory
;; SS is already set to PSP by default - DOS Technical Reference (pg. 6-8)
MOVESTACK: ; Moves stack, can't be function
	mov		sp,MEMORY_BLOCK_SIZE	; Set SP to end of memory block
	xor		ax,ax					; Push 0's on the new stack,
	push	ax  					; DOS Technical Reference (pg. 6-8)

;; Step 1.) SET BLOCK to free unnecessary memory
SETBLOCKSTART:
	call	SET_BLOCK
	call	DEBUG_PRINT_PROC

;; Step 2.) Prepare jrNIC HW
;; 2a.) Mask IRQ to prevent firing
;; 2b.) Reset HW adapter
RESETADAPTER:
	;call	MASK_IRQ4
	MASK_IRQ4M
	UTILM_PRINT_STRN debug_str_resetting_adap
	call	HAL_RESET

;; Step 3.) Check if COM or ROM are already TSR from
;; a previous session
;; 3a.) If not already loaded, we need to load and TSR
;; 3b.) If already loaded, we need to unload and exit
CHECK_IF_ALREADY_LOADED: 
	call	CHECKLOADED ; SCAN 60h-80h for signature
	jc		UNLOAD ; Was loaded, need to unload
LOAD: ; 2a.)  Need to load ourselves and then TSR + RECV
	call	LOAD_RESIDENT_TSR
	jc		EXITCLEAN ; If we failed, exit
	call	INIT_ADAPTER
	;call	UNMASK_IRQ4
	UNMASK_IRQ4M
EXITTSR: ; Terminate, free up additional memory
	; DS is already PSP
	mov		dx,RESIDENT_BLOCK_PARA
	mov		ax,(svc_dos_keep_resident_31 SHL 8) OR val_dos_terminate_00
	int		int_dos_21 ; DOS Interrupt
UNLOAD: ; 2b.) Unload the currently loaded one and exit cleanly
	call	UNLOAD_RESIDENT_TSR
EXITCLEAN:
	mov		ax,(svc_dos_terminate_4C SHL 8) OR val_dos_terminate_00
	int		int_dos_21
	DEBUG_PARA_ALIGN_MACRO
MAIN ENDP

PAGE
IF DEBUG
;debug_txrx_todo db "TODO...add expected/actual/labels$"
debug_txrx_reset db "Resetting jrNIC...$"
debug_txrx_expected db "Expected$"
debug_txrx_actual db "Actual$"
debug_txrx_test db "Test$"
debug_txrx_complete db "Complete$"
;;;;;
;; TEST CART - used to debug the low level functions
;; - Technically violates the HAL by directly accessing HW
;; - TODO - have PD provide HAL with a debug print FUNCTION
;; - Then reimplement DEBUG as HAL_DEBUG
;;;;;
DEBUG_PARA_ALIGN_MACRO
TESTCART PROC NEAR
MOVESTACK_T: ; Moves stack, can't be function
	mov		sp,MEMORY_BLOCK_SIZE	; Set SP to end of memory block
	xor		ax,ax					; Push 0's on the new stack,
	push	ax  					; DOS Technical Reference (pg. 6-8)
SETBLOCKSTART_T:
	call	SET_BLOCK
	call	DEBUG_PRINT_PROC
IF DEBUG_TEST1
	jmp		TEST1_T
	debug_txrx_test1_name db "CORE COMMANDS: RESET, READ_ETH, WRITE_REG$"
	debug_txrx_test1_read_econ1 db "Read ECON1_REGISTER$"
	debug_txrx_test1_write_econ1 db "Write ECON1_REGISTER$"
TEST1_T: ;; 20241215 - GOOD
	; a.) CORE COMMANDS: RESET, READ_ETH, WRITE_REG
	mov	ah,1
	UTILM_PRINT_BREG debug_txrx_test,ax
	UTILM_PRINT_NEWLINE
	UTILM_PRINT_STRN debug_txrx_test1_name
	
	; b.) Reset Card
	UTILM_PRINT_STRN debug_txrx_reset
	call	HW_SOFT_RESET
	
	; c.) Read ECON1_REGISTER (ANY BANK), value on reset: 00
	UTILM_PRINT_STRN debug_txrx_test1_read_econ1
	mov		ah,00
	UTILM_PRINT_BREG debug_txrx_expected,ax
	UTILM_PRINT_NEWLINE
	
	mov		ah,ECON1_REGISTER
	call	HW_READ_ETH_REGISTER ; al = bank value
	mov		ah,al
	UTILM_PRINT_BREG debug_txrx_actual,ax
	UTILM_PRINT_NEWLINE
	
	; c.) Write ECON1_REGISTER (ANY BANK)
	UTILM_PRINT_STRN debug_txrx_test1_write_econ1
	mov		ah,ECON1_REGISTER
	mov		al,BANK3 ; Set to bank 3
	call	HW_WRITE_REGISTER

	; d.) Read ECON1_REGISTER (ANY BANK)
	UTILM_PRINT_STRN debug_txrx_test1_read_econ1
	mov		ah,BANK3
	UTILM_PRINT_BREG debug_txrx_expected,ax
	UTILM_PRINT_NEWLINE

	mov		ah,ECON1_REGISTER
	call	HW_READ_ETH_REGISTER ; al = bank value
	mov		ah,al
	UTILM_PRINT_BREG debug_txrx_actual,ax
	UTILM_PRINT_NEWLINE
	
	; e.) Complete
	UTILM_PRINT_STRN debug_txrx_complete
	UTILM_PRINT_NEWLINE
ENDIF
IF DEBUG_TEST2
	jmp		TEST2_T
	debug_txrx_test2_name db "CORE COMMANDS: HW_BIT_FIELD_SET, HW_BIT_FIELD_CLEAR$"
	debug_txrx_test2_read_econ1 db "Read ECON1_REGISTER$"
	debug_txrx_test2_bfs_econ1 db "Bit Field Set ECON1_REGISTER$"
	debug_txrx_test2_bfc_econ1 db "Bit Field Clear ECON1_REGISTER$"
TEST2_T:  ;; 20241215 - GOOD
	; a.) CORE COMMANDS: HW_BIT_FIELD_SET, HW_BIT_FIELD_CLEAR
	mov	ah,2
	UTILM_PRINT_BREG debug_txrx_test,ax
	UTILM_PRINT_NEWLINE
	UTILM_PRINT_STRN debug_txrx_test2_name
	
	; b.) Reset Card
	UTILM_PRINT_STRN debug_txrx_reset
	call	HW_SOFT_RESET
	
	; c.) Read ECON1_REGISTER (ANY BANK), value on reset: 00
	UTILM_PRINT_STRN debug_txrx_test2_read_econ1
	mov		ah,00
	UTILM_PRINT_BREG debug_txrx_expected,ax
	UTILM_PRINT_NEWLINE
	
	mov		ah,ECON1_REGISTER
	call	HW_READ_ETH_REGISTER ; al = bank value
	mov		ah,al
	UTILM_PRINT_BREG debug_txrx_actual,ax
	UTILM_PRINT_NEWLINE
	
	; d.) Bit Field Set ECON1_REGISTER (ANY BANK)
	UTILM_PRINT_STRN debug_txrx_test2_bfs_econ1
	mov		ah,ECON1_REGISTER
	mov		al,01h ; bit field set
	call	HW_BIT_FIELD_SET
	
	; e.) Read Register ECON1_REGISTER (ANY BANK), should be 01
	UTILM_PRINT_STRN debug_txrx_test2_read_econ1
	mov		ah,01
	UTILM_PRINT_BREG debug_txrx_expected,ax
	UTILM_PRINT_NEWLINE
	
	mov		ah,ECON1_REGISTER
	call	HW_READ_ETH_REGISTER ; al = bank value
	mov		ah,al
	UTILM_PRINT_BREG debug_txrx_actual,ax
	UTILM_PRINT_NEWLINE
	
	; f.) Bit Field Clear ECON1_REGISTER (ANY BANK)
	UTILM_PRINT_STRN debug_txrx_test2_bfc_econ1
	mov		ah,ECON1_REGISTER
	mov		al,01h ; bit field clear
	call	HW_BIT_FIELD_CLEAR
	
	; g.) Read Register ECON1_REGISTER (ANY BANK), should be 00
	UTILM_PRINT_STRN debug_txrx_test2_read_econ1
	mov		ah,00
	UTILM_PRINT_BREG debug_txrx_expected,ax
	UTILM_PRINT_NEWLINE
	
	mov		ah,ECON1_REGISTER
	call	HW_READ_ETH_REGISTER ; al = bank value
	mov		ah,al
	UTILM_PRINT_BREG debug_txrx_actual,ax
	UTILM_PRINT_NEWLINE

	; h.) Complete
	UTILM_PRINT_STRN debug_txrx_complete
	UTILM_PRINT_NEWLINE
ENDIF
IF DEBUG_TEST3
	jmp		TEST3_T
	debug_txrx_test3_name db "SUPPORT COMMANDS: HW_SET_CONTROLLER_BANK, HW_GET_CONTROLLER_BANK$"
	debug_txrx_test3_get_bank db "HW_GET_CONTROLLER_BANK$"
	debug_txrx_test3_set_bank db "HW_SET_CONTROLLER_BANK$"	
TEST3_T: ;; 20241215 - GOOD
	; a.) SUPPORT COMMANDS: HW_SET_CONTROLLER_BANK, HW_GET_CONTROLLER_BANK
	mov	ah,3
	UTILM_PRINT_BREG debug_txrx_test,ax
	UTILM_PRINT_NEWLINE
	UTILM_PRINT_STRN debug_txrx_test3_name
	
	; b.) Reset Card
	UTILM_PRINT_STRN debug_txrx_reset
	call	HW_SOFT_RESET
	
	; c.) Call HW_GET_CONTROLLER_BANK, should be 00 (default)
	UTILM_PRINT_STRN debug_txrx_test3_get_bank
	mov		ah,00
	UTILM_PRINT_BREG debug_txrx_expected,ax
	UTILM_PRINT_NEWLINE
	call	HW_GET_CONTROLLER_BANK
	mov		ah,al ; move to AH
	UTILM_PRINT_BREG debug_txrx_actual,ax
	UTILM_PRINT_NEWLINE
	
	; d.) Call HW_SET_CONTROLLER_BANK
	UTILM_PRINT_STRN debug_txrx_test3_set_bank
	mov		ah,BANK2
	call	HW_SET_CONTROLLER_BANK
	
	; e.) Call HW_GET_CONTROLLER_BANK, should be 02
	UTILM_PRINT_STRN debug_txrx_test3_get_bank
	mov		ah,02
	UTILM_PRINT_BREG debug_txrx_expected,ax
	UTILM_PRINT_NEWLINE
	call	HW_GET_CONTROLLER_BANK
	mov		ah,al ; move to AH
	UTILM_PRINT_BREG debug_txrx_actual,ax
	UTILM_PRINT_NEWLINE

	; f.) Complete
	UTILM_PRINT_STRN debug_txrx_complete
	UTILM_PRINT_NEWLINE
ENDIF
IF DEBUG_TEST4
	jmp		TEST4_T
	debug_txrx_test4_name db "COMPOUND COMMANDS:"
		db "HW_WRITE_REGISTER_LOW_HIGH, "
		db "HW_READ_ETH_REGISTER_LOW_HIGH$"
	debug_txrx_test4_read_ERDPT  db "Read ERDPT$"
	debug_txrx_test4_write_ERDPT db "Write ERDPT$"	
TEST4_T: ;; 20241215 - GOOD
	; a.) COMPOUND COMMANDS: HW_WRITE_REGISTER_LOW_HIGH,
	; 						HW_READ_ETH_REGISTER_LOW_HIGH
	mov	ah,4
	UTILM_PRINT_BREG debug_txrx_test,ax
	UTILM_PRINT_NEWLINE
	UTILM_PRINT_STRN debug_txrx_test4_name
	
	; b.) Reset Card
	UTILM_PRINT_STRN debug_txrx_reset
	call	HW_SOFT_RESET
	
	; c.) Read 16-bit ERDPT_REGISTER (BANK0) Low, High
	UTILM_PRINT_STRN debug_txrx_test4_read_ERDPT
	mov		al,0FAh ; 1111 1010 
	mov		ah,05h ; ---0 0101
	UTILM_PRINT_WREG debug_txrx_expected,ax
	UTILM_PRINT_NEWLINE
		; Set BANK0
	mov		ah,BANK0
	call	HW_SET_CONTROLLER_BANK
		; Read ERDPT_REGISTER
	mov		ax,(ERDPTH_REGISTER SHL 8) OR ERDPTL_REGISTER
	call	HW_READ_ETH_REGISTER_LOW_HIGH
	UTILM_PRINT_WREG debug_txrx_actual,ax
	UTILM_PRINT_NEWLINE
	
	; d.) Write 16-bit ERDPT_REGISTER (BANK0) Low, High
	UTILM_PRINT_STRN debug_txrx_test4_write_ERDPT
		; Set BANK0
	mov		ah,BANK0
	call	HW_SET_CONTROLLER_BANK
		; Write ERDPT_REGISTER
	mov		ax,(ERDPTH_REGISTER SHL 8) OR ERDPTL_REGISTER
	mov		bx,0123h
	call	HW_WRITE_REGISTER_LOW_HIGH ; BANK0
	
	; e.) Read 16-bit ERDPT_REGISTER (BANK0) Low, High
	UTILM_PRINT_STRN debug_txrx_test4_read_ERDPT
	mov		al,23h 
	mov		ah,01h
	UTILM_PRINT_WREG debug_txrx_expected,ax
	UTILM_PRINT_NEWLINE
		; Set BANK0
	mov		ah,BANK0
	call	HW_SET_CONTROLLER_BANK
		; Read ERDPT_REGISTER
	mov		ax,(ERDPTH_REGISTER SHL 8) OR ERDPTL_REGISTER
	call	HW_READ_ETH_REGISTER_LOW_HIGH
	UTILM_PRINT_WREG debug_txrx_actual,ax
	UTILM_PRINT_NEWLINE
	
	; f.) Complete
	UTILM_PRINT_STRN debug_txrx_complete
	UTILM_PRINT_NEWLINE
ENDIF
IF DEBUG_TEST5
	jmp		TEST5_T
	debug_txrx_test5_name db "SUPPORT COMMANDS: HW_SET_ERDPT, HW_SET_EWRPT$"
	debug_txrx_test5_read_ERDPT  db "Read ERDPT$"
	debug_txrx_test5_set_ERDPT db "HW_SET_ERDPT$"
	debug_txrx_test5_read_EWRPT  db "Read EWRPT$"
	debug_txrx_test5_set_EWRPT db "HW_SET_EWRPT$"	
TEST5_T: ;; 20241215 - GOOD
	; a.) SUPPORT COMMANDS: HW_SET_ERDPT, HW_SET_EWRPT
	mov	ah,5
	UTILM_PRINT_BREG debug_txrx_test,ax
	UTILM_PRINT_NEWLINE
	UTILM_PRINT_STRN debug_txrx_test5_name
	
	; b.) Reset Card
	UTILM_PRINT_STRN debug_txrx_reset
	call	HW_SOFT_RESET

	; c.) Read 16-bit ERDPT_REGISTER (BANK0) Low, High
	UTILM_PRINT_STRN debug_txrx_test5_read_ERDPT
	mov		al,0FAh ; 1111 1010 
	mov		ah,05h ; ---0 0101
	UTILM_PRINT_WREG debug_txrx_expected,ax
	UTILM_PRINT_NEWLINE
		; Set BANK0
	mov		ah,BANK0
	call	HW_SET_CONTROLLER_BANK
		; Read ERDPT_REGISTER
	mov		ax,(ERDPTH_REGISTER SHL 8) OR ERDPTL_REGISTER
	call	HW_READ_ETH_REGISTER_LOW_HIGH
	UTILM_PRINT_WREG debug_txrx_actual,ax
	UTILM_PRINT_NEWLINE

	; d.) Call HW_SET_ERDPT
	UTILM_PRINT_STRN debug_txrx_test5_set_ERDPT
	mov		ax,1025h
	call	HW_SET_ERDPT
	
	; e.) Read 16-bit ERDPT_REGISTER (BANK0) Low, High
	UTILM_PRINT_STRN debug_txrx_test5_read_ERDPT
	mov		al,25h
	mov		ah,10h
	UTILM_PRINT_WREG debug_txrx_expected,ax
	UTILM_PRINT_NEWLINE
		; Set BANK0
	mov		ah,BANK0
	call	HW_SET_CONTROLLER_BANK
		; Read ERDPT_REGISTER
	mov		ax,(ERDPTH_REGISTER SHL 8) OR ERDPTL_REGISTER
	call	HW_READ_ETH_REGISTER_LOW_HIGH
	UTILM_PRINT_WREG debug_txrx_actual,ax
	UTILM_PRINT_NEWLINE
	
	; f.) Read 16-bit EWRPT_REGISTER (BANK0) Low, High
	UTILM_PRINT_STRN debug_txrx_test5_read_EWRPT
	mov		ax,0000h
	UTILM_PRINT_WREG debug_txrx_expected,ax
	UTILM_PRINT_NEWLINE
		; Set BANK0
	mov		ah,BANK0
	call	HW_SET_CONTROLLER_BANK
		; Read EWRPT_REGISTER
	mov		ax,(EWRPTH_REGISTER SHL 8) OR EWRPTL_REGISTER
	call	HW_READ_ETH_REGISTER_LOW_HIGH
	UTILM_PRINT_WREG debug_txrx_actual,ax
	UTILM_PRINT_NEWLINE
	
	; g.) Call HW_SET_EWRPT
	UTILM_PRINT_STRN debug_txrx_test5_set_EWRPT
	mov		ax,1134h
	call	HW_SET_EWRPT
	
	; h.) Read 16-bit EWRPT_REGISTER (BANK0) Low, High
	UTILM_PRINT_STRN debug_txrx_test5_read_EWRPT
	mov		ax,1134h
	UTILM_PRINT_WREG debug_txrx_expected,ax
	UTILM_PRINT_NEWLINE
		; Set BANK0
	mov		ah,BANK0
	call	HW_SET_CONTROLLER_BANK
		; Read EWRPT_REGISTER
	mov		ax,(EWRPTH_REGISTER SHL 8) OR EWRPTL_REGISTER
	call	HW_READ_ETH_REGISTER_LOW_HIGH
	UTILM_PRINT_WREG debug_txrx_actual,ax
	UTILM_PRINT_NEWLINE
	
	; i.) Complete
	UTILM_PRINT_STRN debug_txrx_complete
	UTILM_PRINT_NEWLINE
ENDIF
IF DEBUG_TEST6
	jmp		TEST6_T
	debug_txrx_test6_name db "CORE COMMANDS: "
	db "READ/WRITE BUFFER MEMORY BYTE, "
	db "READ/WRITE BUFFER MEMORY WORD$"
	debug_txrx_test6_unk			   db "Expected (unknown)$"
	debug_txrx_test6_read_memory_byte  db "Read memory byte$"
	debug_txrx_test6_write_memory_byte db "Write memory byte$"
	debug_txrx_test6_read_memory_word  db "Read memory word$"
	debug_txrx_test6_write_memory_word db "Write memory word$"
TEST6_T: ;; 202412156 - GOOD
	; a.) CORE COMMANDS: 
	; READ/WRITE BUFFER MEMORY BYTE
	; READ/WRITE BUFFER MEMORY WORD
	mov	ah,6
	UTILM_PRINT_BREG debug_txrx_test,ax
	UTILM_PRINT_NEWLINE
	UTILM_PRINT_STRN debug_txrx_test6_name
	
	; b.) Reset Card
	UTILM_PRINT_STRN debug_txrx_reset
	call	HW_SOFT_RESET
	
	; c.) Call HW_SET_ERDPT
	mov		ax,1000h
	call	HW_SET_ERDPT
	
	; d.) Read single buffer memory byte (default state unknown)
	UTILM_PRINT_STRN debug_txrx_test6_read_memory_byte
	UTILM_PRINT_STRN debug_txrx_test6_unk
	call	HW_READ_BUFFER_MEMORY_BYTE
	mov		ah,al ; move byte to print
	UTILM_PRINT_BREG debug_txrx_actual,ax
	UTILM_PRINT_NEWLINE
	
	; e.) Call Set EWRPT
	mov		ax,1000h
	call	HW_SET_EWRPT
	
	; f.) Write single buffer memory byte
	UTILM_PRINT_STRN debug_txrx_test6_write_memory_byte
	mov		al,55h
	call	HW_WRITE_BUFFER_MEMORY_BYTE

	; g.) Call HW_SET_ERDPT
	mov		ax,1000h
	call	HW_SET_ERDPT

	; h.) Read single buffer memory byte
	UTILM_PRINT_STRN debug_txrx_test6_read_memory_byte
	mov		ah,55h
	UTILM_PRINT_BREG debug_txrx_expected, ax
	UTILM_PRINT_NEWLINE
	call	HW_READ_BUFFER_MEMORY_BYTE
	mov		ah,al ; move byte to print
	UTILM_PRINT_BREG debug_txrx_actual,ax
	UTILM_PRINT_NEWLINE
	
	; i.) Call HW_SET_ERDPT
	mov		ax,1010h
	call	HW_SET_ERDPT
	
	; j.) Read single buffer memory word (default state unknown)
	UTILM_PRINT_STRN debug_txrx_test6_read_memory_word
	UTILM_PRINT_STRN debug_txrx_test6_unk
	call	HW_READ_BUFFER_MEMORY_WORD
	UTILM_PRINT_WREG debug_txrx_actual,ax
	UTILM_PRINT_NEWLINE
	
	; k.) Call HW_SET_EWRPT
	mov		ax,1010h
	call	HW_SET_EWRPT
	
	; l.) Write single buffer word
	UTILM_PRINT_STRN debug_txrx_test6_write_memory_word
	mov		ax,0aacch
	call	HW_WRITE_BUFFER_MEMORY_WORD
	
	; m.) Call HW_SET_ERDPT
	mov		ax,1010h
	call	HW_SET_ERDPT
	
	; n.) Read single buffer memory word (default state unknown)
	UTILM_PRINT_STRN debug_txrx_test6_read_memory_word
	mov		ax,0aacch
	UTILM_PRINT_WREG debug_txrx_expected, ax
	UTILM_PRINT_NEWLINE
	call	HW_READ_BUFFER_MEMORY_WORD
	UTILM_PRINT_WREG debug_txrx_actual,ax
	UTILM_PRINT_NEWLINE

	; o.) Complete
	UTILM_PRINT_STRN debug_txrx_complete
	UTILM_PRINT_NEWLINE
ENDIF
IF DEBUG_TEST7
	jmp		TEST7_T
	debug_txrx_test7_name db "CORE COMMANDS: "
	db "READ/WRITE BUFFER MEMORY (ARRAY)$"
	debug_txrx_test7_memory				db "PCjr Memory contents$"
	debug_txrx_test7_read_mem_array  db "Read memory array$"
	debug_txrx_test7_write_mem_array  db "Write memory array$"
TEST7_T:
	; a.) CORE COMMANDS: READ/WRITE BUFFER MEMORY (ARRAY)
	;; For memory, read from ds:orig_int_offset
	mov	ah,7
	UTILM_PRINT_BREG debug_txrx_test,ax
	UTILM_PRINT_NEWLINE
	UTILM_PRINT_STRN debug_txrx_test7_name
	
	; b.) Reset Card
	UTILM_PRINT_STRN debug_txrx_reset
	call	HW_SOFT_RESET
		
	;; c.) Read PCjr memory: read memory ; needs DS:SI, CX
	UTILM_PRINT_STR debug_txrx_test7_memory
	UTILM_PRINT_COLON
	push	ds
	mov		ax,cs
	mov		ds,ax ; DS = CS
	mov		si,offset orig_int_offset
	mov		cx,0008 ; 8 bytes
	call	UTIL_PRINT_MEM
	pop		ds
	UTILM_PRINT_NEWLINE

	; d.) Call HW_SET_ERDPT
	mov		ax,1010h
	call	HW_SET_ERDPT

	; e.) Read BUFFER MEMORY (ARRAY)
	UTILM_PRINT_STRN debug_txrx_test7_read_mem_array
	; READ BUFFER 8-bytes -> to DS:PSP_SIZE, print
	; Read buffer (ERDPT + ES:DI + CX)
	UTILM_PRINT_STR debug_txrx_actual
	UTILM_PRINT_COLON
	push	es
	mov		ax,ds
	mov		es,ax ; ES set
	mov		di,PSP_SIZE; DS+PSP_SIZE
	mov		cx,8h
	call	HW_READ_BUFFER_MEMORY ; Copy memory
	pop		es
	; e2.) print read buffer (DS:SI + CX
	; DS is already set
	mov		si,PSP_SIZE
	mov		cx,8h
	call	UTIL_PRINT_MEM
	UTILM_PRINT_NEWLINE
	
	; f.) Call HW_SET_EWRPT
	mov		ax,1010h
	call	HW_SET_EWRPT
	
	; g.) Write BUFFER MEMORY (ARRAY)
	UTILM_PRINT_STRN debug_txrx_test7_write_mem_array
	; WRITE BUFFER 8 bytes <- from CS+offset orig_int_offset
	; Write buffer (EWRPT + DS:SI + CX)
	push	ds
	mov		ax,cs
	mov		ds,ax ; DS = CS
	mov		si,offset orig_int_offset
	mov		cx,8h
	call	HW_WRITE_BUFFER_MEMORY
	pop		ds

	; h.) Call HW_SET_ERDPT 
	mov		ax,1010h
	call	HW_SET_ERDPT

	; i.) Read BUFFER MEMORY (ARRAY)
	UTILM_PRINT_STRN debug_txrx_test7_read_mem_array
	; READ BUFFER 8-bytes -> to DS:PSP_SIZE, print
	; Read buffer (ERDPT + ES:DI + CX)
	UTILM_PRINT_STR debug_txrx_actual
	UTILM_PRINT_COLON
	push	es
	mov		ax,ds
	mov		es,ax ; ES set
	mov		di,PSP_SIZE; DS+PSP_SIZE
	mov		cx,8h
	call	HW_READ_BUFFER_MEMORY ; Copy memory
	pop		es
	; i2.) print read buffer (DS:SI + CX
	; DS is already set
	mov		si,PSP_SIZE
	mov		cx,8h
	call	UTIL_PRINT_MEM
	UTILM_PRINT_NEWLINE

	; j.) Complete
	UTILM_PRINT_STRN debug_txrx_complete
	UTILM_PRINT_NEWLINE
ENDIF
IF DEBUG_TEST8
	jmp		TEST8_T
	debug_txrx_test8_name db "COMPOUND COMMANDS: "
	db "READ/WRITE MAC/MII"
	db "READ/WRITE PHY$"
	
	debug_txrx_test8_read_maddr5		db "Read MAADR5_REGISTER$"
	debug_txrx_test8_write_maddr5		db "Write MAADR5_REGISTER$"
	debug_txrx_test8_read_phcon2		db "Read PHCON2_REGISTER$"
	debug_txrx_test8_write_phcon2		db "Write PHCON2_REGISTER$"
TEST8_T:
	; a.) COMPOUND COMMANDS: READ/WRITE MAC/MII, READ/WRITE PHY
	mov	ah,8
	UTILM_PRINT_BREG debug_txrx_test,ax
	UTILM_PRINT_NEWLINE
	UTILM_PRINT_STRN debug_txrx_test8_name
	
	; b.) Reset Card
	UTILM_PRINT_STRN debug_txrx_reset
	call	HW_SOFT_RESET
	
	;; c.) Read MAC MAADR5_REGISTER (BANK3), default 00h
	UTILM_PRINT_STRN debug_txrx_test8_read_maddr5
	mov		ah,00h
	UTILM_PRINT_BREG debug_txrx_expected,ax
	UTILM_PRINT_NEWLINE
	mov		ah,BANK3
	call	HW_SET_CONTROLLER_BANK
	mov		ah,MAADR5_REGISTER
	call	HW_READ_MAC_MII_REGISTER ; al
	mov		ah,al
	UTILM_PRINT_BREG debug_txrx_actual,ax
	UTILM_PRINT_NEWLINE
	
	;; d.) Write MAC MAADR5_REGISTER (BANK3) 
	UTILM_PRINT_STRN debug_txrx_test8_write_maddr5
	mov		ah,BANK3
	call	HW_SET_CONTROLLER_BANK
	mov		ah,MAADR5_REGISTER
	mov		al,05h
	call	HW_WRITE_REGISTER
	
	; e.) Read MAC MAADR5_REGISTER (BANK3)
	UTILM_PRINT_STRN debug_txrx_test8_read_maddr5
	mov		ah,05h
	UTILM_PRINT_BREG debug_txrx_expected,ax
	UTILM_PRINT_NEWLINE
	mov		ah,BANK3
	call	HW_SET_CONTROLLER_BANK
	mov		ah,MAADR5_REGISTER
	call	HW_READ_MAC_MII_REGISTER ; al
	mov		ah,al
	UTILM_PRINT_BREG debug_txrx_actual,ax
	UTILM_PRINT_NEWLINE

	; f.) Read PHCON2_REGISTER, default 0000h
	UTILM_PRINT_STRN debug_txrx_test8_read_phcon2
	mov		ax,0000h
	UTILM_PRINT_WREG debug_txrx_expected,ax
	UTILM_PRINT_NEWLINE
	mov		ah,PHCON2_REGISTER
	call	HW_READ_PHY_REGISTER
	UTILM_PRINT_WREG debug_txrx_actual,ax
	UTILM_PRINT_NEWLINE
		
	; g.) Write PHCON2_REGISTER
	UTILM_PRINT_STRN debug_txrx_test8_write_phcon2
	mov		ah,PHCON2_REGISTER
	mov		bx,PHCON2_HDLDIS_BIT
	call	HW_WRITE_PHY_REGISTER
	
	; h.) Read PHCON2_REGISTER
	UTILM_PRINT_STRN debug_txrx_test8_read_phcon2
	mov		ax,PHCON2_HDLDIS_BIT
	UTILM_PRINT_WREG debug_txrx_expected,ax
	UTILM_PRINT_NEWLINE
	mov		ah,PHCON2_REGISTER
	call	HW_READ_PHY_REGISTER
	UTILM_PRINT_WREG debug_txrx_actual,ax
	UTILM_PRINT_NEWLINE
			
	; i.) Complete
	UTILM_PRINT_STRN debug_txrx_complete
	UTILM_PRINT_NEWLINE
ENDIF

EXITCLEAN_T:
	mov		ax,(svc_dos_terminate_4C SHL 8) OR val_dos_terminate_00
	int		int_dos_21
	DEBUG_PARA_ALIGN_MACRO
TESTCART ENDP
ENDIF


PAGE
%OUT Processing jrNIC Utils
INCLUDE JRUTIL.ASM
PAGE

IF ROM 	; Align CARTCRC to end of a 512 byte boundary
	IF ($-BEGINOFPROG+2) MOD 512 ; If end of next word (+2) is not on a 512 byte boundary
		ORG ($-BEGINOFPROG+2)+512-(($-BEGINOFPROG+2) MOD 512) - 2 ; Round up, minus 2
	ENDIF
	;CARTCRC dw 0FEC0h ; Placeholder for cartridge CRC
	CARTCRC dw 0000h ; Placeholder for cartridge CRC
	%OUT NOTE: Need to calculate CRC externally!
ELSE ; COM Align end of Program
	PARA_ALIGN_MACRO
ENDIF
ENDOFPROG EQU $ ; Used for CARTSIZ calculation and TSR end of stack
CODESEG ENDS

PAGE
%OUT Processing jrNIC Equates (Ending)
INCLUDE JREQUE.ASM ; These are not known up-front, dynamically calculated

END PROGRAM
