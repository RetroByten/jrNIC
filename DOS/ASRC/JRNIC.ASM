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
DEBUG_TEST1 EQU 0
DEBUG_TEST2 EQU 0
DEBUG_TEST3 EQU 0
DEBUG_TEST4 EQU 0
DEBUG_TEST5 EQU 0
DEBUG_TEST6 EQU 0
DEBUG_TEST7 EQU 0
DEBUG_TEST8 EQU 1 ; READ/WRITE MAC/MII, READ/WRITE PHY Register

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

PAGE
MEMORYSHIMBEGIN: ; For ROM, will be copied into RAM at end of PSP
	jmp		NEAR PTR SHIM_INT_ENTRY ; Near ptr for alignment and PKT DRVR SPEC
	PKT_DRIVER_SIGNATURE_MACRO
	PROGRAM_SIGNATURE_MACRO
	SHIM_INT_ENTRY:
	sti ; Re-enable interrupts
	push	bp
	mov		bp,cs ; Pass resident PSP/Mem to function
	SHIM_INT_CALL: ; For fixing the absolute call
	call	FAR PTR PLACEHOLDER_JMP ; dummy, replaced at runtime with CS:PKT_DRV_CORE, sets/clears carry
	SHIM_INT_COMPLETE:
	mov		bp,sp ; Get current stack pointer, should have nothing but BP + OFFSET + SEG + FLAGS
				  ;                                                    0    2        4     6
	jc		SHORT RET_BAD
RET_GOOD: ; Clear carry flag on stack
	and		BYTE PTR [bp+6],0FEh ; SS:
	jmp		SHORT RET_DONE
RET_BAD: ; Set carry flag on stack
	or		BYTE PTR [bp+6],01h ; SS:
RET_DONE:
	pop		bp
	iret
MEMORY_DATA_OFFSET:
	orig_int_offset 			dw 0FEC0h ; Dummy
	orig_int_segment 			dw 0EFBEh ; Dummy
	orig_recv_offset 			dw 0DDDDh ; Dummy
	orig_recv_segment 			dw 0CCCCh ; Dummy
	caller_stack_offset 		dw 0BBBBh ; Dummy
	caller_stack_segment 		dw 0AAAAh ; Dummy
	int_pkt_driver				db int_default_pkt_driver ; Dummy
	IF ROM
		allow_unload_env		db 0h ; Can't unload ROM env
	ELSE
		allow_unload_env		db 1h
	ENDIF
	PARA_ALIGN_MACRO ;; Necessary for both paragraph reservation and MOVSW
MEMORYSHIMEND:

PAGE
%OUT Processing JRNICHAL
INCLUDE JRNICHAL.ASM

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

PKT_DRVR_CORE PROC FAR
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
	jb		PKT_DRVR_CORE_EXECUTE ; if yes, execute
	xor		si,si ; if no, force invalid command entry
PKT_DRVR_CORE_EXECUTE: ;; CAN'T BE A CALL BECAUSE OF SI RECOVERY
	jmp		WORD PTR CS:[SI + OFFSET INT_SVC_TABLE] ; will return on it's own, must pop SI
	DEBUG_PARA_ALIGN_MACRO
PKT_DRVR_CORE ENDP

PKT_DRIVER_RECV_DEFAULT PROC FAR
	; TODO - clear received packets
	iret
PKT_DRIVER_RECV_DEFAULT ENDP

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
	;; TODO - ensure interrupt is disabled, reset the card
	call	TXRX_SOFT_RESET ; Reset the card
;	UTILM_DELAY_ITER 20h
	;; Clear internal card Memory
	call	TXRX_CLEAR_MEMORY

	ret ; Far Return
	DEBUG_PARA_ALIGN_MACRO
INIT ENDP
INITDOS PROC FAR
	push	cs ; setup far return
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
	; Need to search PSP:80-FFH looking for first two ASCII characters representing hex digits
	xor		al,al
	mov		[int_pkt_driver],al ; Zero pkt driver int
	
	mov		dl,02h ; Need to find 2 valid chars, not worried about sequential
	
	mov		si,val_dos_args_80h
	mov		cl,[si] ; Get number of chars
	inc		si	
SET_DESIRED_INT_LOOP:  ; TODO: is this off by 1?
	cmp		cl,00h
	je		SET_DESIRED_INT_CONT
	mov		al,[si]
	inc		si
	dec		cl
	call	UTIL_ASCII_NUM_TO_HEX
	jc		SET_DESIRED_INT_LOOP
	dec		dl
	call	SAVE_INT_NIBBLE
	cmp		dl,00h
	je		SET_DESIRED_INT_FOUND
SET_DESIRED_INT_NOT_FOUND:
	jmp		SHORT SET_DESIRED_INT_LOOP
SET_DESIRED_INT_CONT:
	stc
	ret
SET_DESIRED_INT_FOUND:
	; Check if between 60 and 80h
	mov		al,[int_pkt_driver]
	cmp		al,60h
	jb		SET_DESIRED_INT_CONT
	cmp		al,80h
	ja		SET_DESIRED_INT_CONT
	clc
	ret
SET_DESIRED_INT ENDP
PAGE

LOAD_RESIDENT_TSR PROC NEAR
	UTILM_PRINT_STR debug_str_loading
IF ROM ; If RAM, not necessary as we will use the existing resident block
	; Copy CS:MEMORYSHIMBEGIN block to DS:RAM
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
	; Fix PSP:call	FAR PTR PLACEHOLDER_JMP to CS:PKT_DRVR_CORE
	mov		ax,offset PKT_DRVR_CORE
	mov		WORD PTR [SHIM_INT_CALL+1],ax ; call <offset>
	mov		ax,cs
	mov		WORD PTR [SHIM_INT_CALL+3],ax ; call <offset> <seg>
	
	;; TODO - Check args for INT
	call	SET_DESIRED_INT
	jnc		LOAD_CONT ;; If failed to set INT, bail
	;; Print error
	mov		ah,[int_pkt_driver]
	UTILM_PRINT_BREG str_invalid_int, ax
	;; exit clean
	jmp		NEAR PTR EXITCLEAN
	
	
	;;		Range check desired int
	;;
LOAD_CONT:
	mov		ah,[int_pkt_driver]
	UTILM_PRINT_BREG debug_str_int,ax
	UTILM_PRINT_NEWLINE
	
	; Retrieve old int + store in DS
	mov		ah,svc_dos_get_interrupt_35
	mov		al,[int_pkt_driver]
	int		int_dos_21 ; ES:BX has original values
	mov		[orig_int_offset],bx
	mov		bx,es
	mov		[orig_int_segment],bx
		
	; Set new int to PSP:MEMORYSHIMBEGIN
	; ds already = PSP
	mov		dx,offset MEMORYSHIMBEGIN
	mov		ah,svc_dos_set_interrupt_25
	mov		al,[int_pkt_driver]
	int		int_dos_21
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


DEBUG_HAL PROC NEAR
	;call	DEBUG_HAL_BANK
	
	
	ret
DEBUG_HAL ENDP

DEBUG_HAL_BANK PROC NEAR
	call	GET_CONTROLLER_BANK
	mov		ah,al
	UTILM_PRINT_BREG debug_txrx_bank,ax
	UTILM_PRINT_NEWLINE
	
	mov		ah,BANK2
	call	SET_CONTROLLER_BANK
	
	call	GET_CONTROLLER_BANK
	mov		ah,al
	UTILM_PRINT_BREG debug_txrx_bank,ax
	UTILM_PRINT_NEWLINE
	ret
DEBUG_HAL_BANK ENDP

INIT_ADAPTER PROC NEAR
	;call	HAL_INIT
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
DEBUG_PARA_ALIGN_MACRO
MAIN PROC FAR
	UTILM_PRINT_SEGS		;; Debug print
;;;
;; Step 0.) Move the stack pointer in to top of needed memory
;; SS is already set to PSP by default - DOS Technical Reference (pg. 6-8)
;;;
MOVESTACK: ; Moves stack, can't be function
	mov		sp,MEMORY_BLOCK_SIZE	; Set SP to end of memory block
	xor		ax,ax					; Push 0's on the new stack,
	push	ax  					; DOS Technical Reference (pg. 6-8)

;;;
;; Step 1.) SET BLOCK to free unnecessary memory
;;;
SETBLOCKSTART:
	call	SET_BLOCK
	call	DEBUG_PRINT_PROC

;;;
;; Step 2.) Check if COM or ROM are already TSR from
;; a previous session
;; 2a.) If not already loaded, we need to load and TSR
;; 2b.) If already loaded, we need to unload and exit
;;;
CHECK_IF_ALREADY_LOADED: 
	call	CHECKLOADED ; SCAN 60h-80h for signature
	jc		UNLOAD ; Was loaded, need to unload
LOAD: ; 2a.)  Need to load ourselves and then TSR
	call	LOAD_RESIDENT_TSR
	call	DEBUG_HAL ;; Now that it's loaded, test it
	call	INIT_ADAPTER
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
debug_txrx_reset db "Resetting jrNIC...$"
debug_txrx_bank db "Bank$"
debug_txrx_test db "Test$"
debug_txrx_erdpt db "ERDPT$"
debug_txrx_ewrpt db "EWRPT$"
debug_txrx_memory db "MEMORY$"
;;;;;
;; TEST CART - used to debug the HAL
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
TEST1_T: ;; 20241215 - GOOD
	;; Tests CORE COMMANDS: RESET, READ_ETH, WRITE_REG
	mov	ah,1
	UTILM_PRINT_BREG debug_txrx_test,ax
	UTILM_PRINT_NEWLINE
	; a.) Reset Card
	UTILM_PRINT_STRN debug_txrx_reset
	call	TXRX_SOFT_RESET
	; b.) Read Register, should be 00 (default)
	mov		ah,ECON1_REGISTER
	call	READ_ETH_REGISTER ; al = bank value
	and		al,BANK_MASK
	mov		ah,al
	UTILM_PRINT_BREG debug_txrx_bank,ax
	UTILM_PRINT_NEWLINE
	; c.) Write Register (write bank 3)
	mov		ah,ECON1_REGISTER
	mov		al,BANK3
	call	WRITE_REGISTER
	; d.) Read Register (should be 03)
	mov		ah,ECON1_REGISTER
	call	READ_ETH_REGISTER ; al = bank value
	and		al,BANK_MASK
	mov		ah,al
	UTILM_PRINT_BREG debug_txrx_bank,ax
	UTILM_PRINT_NEWLINE
	; e.) Reset Card
	UTILM_PRINT_STRN debug_txrx_reset
	call	TXRX_SOFT_RESET
	; f.) Read Register, should be 00 (default)
	mov		ah,ECON1_REGISTER
	call	READ_ETH_REGISTER ; al = bank value
	and		al,BANK_MASK
	mov		ah,al
	UTILM_PRINT_BREG debug_txrx_bank,ax
	UTILM_PRINT_NEWLINE
	UTILM_PRINT_NEWLINE
ENDIF
IF DEBUG_TEST2
TEST2_T:  ;; 20241215 - GOOD
	;; Tests CORE COMMANDS: BIT_FIELD_SET, BIT_FIELD_CLEAR
	mov	ah,2
	UTILM_PRINT_BREG debug_txrx_test,ax
	UTILM_PRINT_NEWLINE
	; a.) Reset Card
	UTILM_PRINT_STRN debug_txrx_reset
	call	TXRX_SOFT_RESET
	; b.) Read Register (should be 00)
	mov		ah,ECON1_REGISTER
	call	READ_ETH_REGISTER ; al = bank value
	and		al,BANK_MASK
	mov		ah,al
	UTILM_PRINT_BREG debug_txrx_bank,ax
	UTILM_PRINT_NEWLINE
	; c.) Set Bit Field to BANK1
	mov		ah,ECON1_REGISTER
	mov		al,01h ; bit field set
	call	BIT_FIELD_SET
	; d.) Read Register (should be 01)
	mov		ah,ECON1_REGISTER
	call	READ_ETH_REGISTER ; al = bank value
	and		al,BANK_MASK
	mov		ah,al
	UTILM_PRINT_BREG debug_txrx_bank,ax
	UTILM_PRINT_NEWLINE
	; e.) Clear bit Field
	mov		ah,ECON1_REGISTER
	mov		al,01h ; bit field set
	call	BIT_FIELD_CLEAR
	; f.) Read Register
	mov		ah,ECON1_REGISTER
	call	READ_ETH_REGISTER ; al = bank value
	and		al,BANK_MASK
	mov		ah,al
	UTILM_PRINT_BREG debug_txrx_bank,ax
	UTILM_PRINT_NEWLINE
	UTILM_PRINT_NEWLINE
ENDIF
IF DEBUG_TEST3
TEST3_T: ;; 20241215 - GOOD
	;; Tests Support Commands: SET_CONTROLLER_BANK, GET_CONTROLLER_BANK
	mov	ah,3
	UTILM_PRINT_BREG debug_txrx_test,ax
	UTILM_PRINT_NEWLINE
	; a.) Reset Card
	UTILM_PRINT_STRN debug_txrx_reset
	call	TXRX_SOFT_RESET
	; b.) Read current bank, should be 00 (default)
	call	GET_CONTROLLER_BANK
	mov		ah,al ; move to AH
	UTILM_PRINT_BREG debug_txrx_bank,ax
	UTILM_PRINT_NEWLINE
	; c.) Set Bank to 2
	mov		ah,2
	call	SET_CONTROLLER_BANK
	; d.) Read current bank, should be 02
	call	GET_CONTROLLER_BANK
	mov		ah,al ; move to AH
	UTILM_PRINT_BREG debug_txrx_bank,ax
	UTILM_PRINT_NEWLINE
	UTILM_PRINT_NEWLINE
ENDIF
IF DEBUG_TEST4
TEST4_T: ;; 20241215 - GOOD
	;; Tests Compound Command:
	;WRITE_REGISTER_LOW_HIGH
	;READ_ETH_REGISTER_LOW_HIGH
	
	mov	ah,4
	UTILM_PRINT_BREG debug_txrx_test,ax
	UTILM_PRINT_NEWLINE
	; a.) Reset Card
	UTILM_PRINT_STRN debug_txrx_reset
	call	TXRX_SOFT_RESET
	;; Set BANK0
	mov		ah,BANK0
	call	SET_CONTROLLER_BANK
	;b. ) Read low, high ERDPTH
	mov		ax,(ERDPTH_REGISTER SHL 8) OR ERDPTL_REGISTER
	call	READ_ETH_REGISTER_LOW_HIGH
	UTILM_PRINT_WREG debug_txrx_erdpt,ax
	UTILM_PRINT_NEWLINE
	;c.) Write low-high ERDPT
	mov		ax,(ERDPTH_REGISTER SHL 8) OR ERDPTL_REGISTER
	mov		bx,0123h
	call	WRITE_REGISTER_LOW_HIGH ; BANK0
	;d. ) Read low, high ERDPTH
	mov		ax,(ERDPTH_REGISTER SHL 8) OR ERDPTL_REGISTER
	call	READ_ETH_REGISTER_LOW_HIGH
	UTILM_PRINT_WREG debug_txrx_erdpt,ax
	UTILM_PRINT_NEWLINE
	UTILM_PRINT_NEWLINE
ENDIF
IF DEBUG_TEST5
TEST5_T: ;; 20241215 - GOOD
	;; Tests Support Commands: 
	; SET_ERDPT, SET_EWRPT
	mov	ah,5
	UTILM_PRINT_BREG debug_txrx_test,ax
	UTILM_PRINT_NEWLINE
	; a.) Reset Card
	UTILM_PRINT_STRN debug_txrx_reset
	call	TXRX_SOFT_RESET
	;; Set BANK0
	mov		ah,BANK0
	call	SET_CONTROLLER_BANK
	; b.) Read ERDPT
	mov		ax,(ERDPTH_REGISTER SHL 8) OR ERDPTL_REGISTER
	call	READ_ETH_REGISTER_LOW_HIGH
	UTILM_PRINT_WREG debug_txrx_erdpt,ax
	UTILM_PRINT_NEWLINE
	; c.) Write ERDPT
	mov		ax,1023h
	call	SET_ERDPT
	; d.) Read ERDPT
	mov		ax,(ERDPTH_REGISTER SHL 8) OR ERDPTL_REGISTER
	call	READ_ETH_REGISTER_LOW_HIGH
	UTILM_PRINT_WREG debug_txrx_erdpt,ax
	UTILM_PRINT_NEWLINE
	; e.) Read EWRPT
	mov		ax,(EWRPTH_REGISTER SHL 8) OR EWRPTL_REGISTER
	call	READ_ETH_REGISTER_LOW_HIGH
	UTILM_PRINT_WREG debug_txrx_ewrpt,ax
	UTILM_PRINT_NEWLINE
	; f.) Write EWRPT
	mov		ax,1134h
	call	SET_EWRPT
	; g.) Read EWRPT
	mov		ax,(EWRPTH_REGISTER SHL 8) OR EWRPTL_REGISTER
	call	READ_ETH_REGISTER_LOW_HIGH
	UTILM_PRINT_WREG debug_txrx_ewrpt,ax
	UTILM_PRINT_NEWLINE
	UTILM_PRINT_NEWLINE
ENDIF
IF DEBUG_TEST6
TEST6_T: ;; 202412156 - GOOD
	;; Tests CORE COMMANDS: 
	;READ/WRITE BUFFER MEMORY BYTE
	;READ/WRITE BUFFER MEMORY WORD
	mov	ah,6
	UTILM_PRINT_BREG debug_txrx_test,ax
	UTILM_PRINT_NEWLINE
	; a.) Reset Card
	UTILM_PRINT_STRN debug_txrx_reset
	call	TXRX_SOFT_RESET
	; b1.) Set ERDPT
	mov		ax,1000h
	call	SET_ERDPT
	; b2.) Read buffer memory BYTE
	call	READ_BUFFER_MEMORY_BYTE
	mov		ah,al
	UTILM_PRINT_BREG debug_txrx_memory,ax
	UTILM_PRINT_NEWLINE
	
	; c1.) Set EWRPT
	mov		ax,1000h
	call	SET_EWRPT
	; c2.) Write buffer memory
	mov		al,55h
	call	WRITE_BUFFER_MEMORY_BYTE
	
	; d1.) Set ERDPT
	mov		ax,1000h
	call	SET_ERDPT
	; d2.) Read buffer memory
	call	READ_BUFFER_MEMORY_BYTE
	mov		ah,al
	UTILM_PRINT_BREG debug_txrx_memory,ax
	UTILM_PRINT_NEWLINE
	; e.) Reset Card
	UTILM_PRINT_STRN debug_txrx_reset
	call	TXRX_SOFT_RESET
	
	; f1.) Set ERDPT
	mov		ax,1010h
	call	SET_ERDPT
	; f2.) Read buffer memory WORD
	call	READ_BUFFER_MEMORY_WORD
	UTILM_PRINT_WREG debug_txrx_memory,ax
	UTILM_PRINT_NEWLINE
	
	; g1.) Set EWRPT
	mov		ax,1010h
	call	SET_EWRPT
	; g2.) Write buffer memory WORD
	mov		ax,0aacch
	call	WRITE_BUFFER_MEMORY_WORD
	; f1.) Set ERDPT
	mov		ax,1010h
	call	SET_ERDPT
	; f2.) Read buffer memory WORD
	call	READ_BUFFER_MEMORY_WORD
	UTILM_PRINT_WREG debug_txrx_memory,ax
	UTILM_PRINT_NEWLINE
	UTILM_PRINT_NEWLINE
ENDIF
IF DEBUG_TEST7
TEST7_T:
	;; Tests CORE COMMANDS: READ/WRITE BUFFER MEMORY (ARRAY)
	;; For memory, read from ds:orig_int_offset
	mov	ah,7
	UTILM_PRINT_BREG debug_txrx_test,ax
	UTILM_PRINT_NEWLINE
	; a.) Reset Card
	UTILM_PRINT_STRN debug_txrx_reset
	call	TXRX_SOFT_RESET
	UTILM_PRINT_STR debug_txrx_memory
	UTILM_PRINT_COLON
	;; Test util read memory ; needs DS:SI, CX
	push	ds
	mov		ax,cs
	mov		ds,ax ; DS = CS
	mov		si,offset orig_int_offset
	mov		cx,0008 ; 8 bytes
	call	UTIL_PRINT_MEM
	pop		ds
	UTILM_PRINT_NEWLINE
	UTILM_PRINT_NEWLINE
	
	; b.) READ BUFFER 8 bytes -> to DS+PSP_SIZE, print
	; b1.) Read buffer (ERDPT + ES:DI + CX)
	mov		ax,1010h
	call	SET_ERDPT
	push	es
	mov		ax,ds
	mov		es,ax ; ES set
	mov		di,PSP_SIZE; DS+PSP_SIZE
	mov		cx,8h
	call	READ_BUFFER_MEMORY ; Copy memory
	pop		es
	; b2.) print read buffer (DS:SI + CX
	; DS is already set
	mov		si,PSP_SIZE
	mov		cx,8h
	call	UTIL_PRINT_MEM
	UTILM_PRINT_NEWLINE
	
	; c.) WRITE BUFFER 8 bytes <- from CS+offset orig_int_offset
	; c1.) Write buffer (EWRPT + DS:SI + CX)
	mov		ax,1010h
	call	SET_EWRPT
	push	ds
	mov		ax,cs
	mov		ds,ax ; DS = CS
	mov		si,offset orig_int_offset
	mov		cx,8h
	call	WRITE_BUFFER_MEMORY
	pop		ds
	
	; d.) READ BUFFER 8-bytes -> to DS:PSP_SIZE, print
	; d1.) Read buffer (ERDPT + ES:DI + CX)
	mov		ax,1010h
	call	SET_ERDPT
	push	es
	mov		ax,ds
	mov		es,ax ; ES set
	mov		di,PSP_SIZE; DS+PSP_SIZE
	mov		cx,8h
	call	READ_BUFFER_MEMORY ; Copy memory
	pop		es
	; d2.) print read buffer (DS:SI + CX
	; DS is already set
	mov		si,PSP_SIZE
	mov		cx,8h
	call	UTIL_PRINT_MEM
	UTILM_PRINT_NEWLINE
ENDIF
IF DEBUG_TEST8
TEST8_T:
	mov	ah,8
	UTILM_PRINT_BREG debug_txrx_test,ax
	UTILM_PRINT_NEWLINE
	; a.) Reset Card
	UTILM_PRINT_STRN debug_txrx_reset
	call	TXRX_SOFT_RESET
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