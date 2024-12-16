;; These rely on values not known until the (END)
;; After the first pass of the assembler

;; RAM usage equates during INIT and TSR phases

;; Note: PARA = Paragraph = 16 byte aligned
;; Note: TSR = Terminate and stay resident
;; Note: *_R = rounded up to nearest paragraph boundary

IF ROM
	; Cartridge ROM code is not in RAM, PARA ALIGNED
	INIT_CODE_SIZE EQU (MEMORYSHIMEND - BEGINOFPROG) - PSP_SIZE 
	RESIDENT_CODE_SIZE EQU INIT_CODE_SIZE
ELSE ; IF COM
	; COM code is in RAM, PARA ALIGNED
	INIT_CODE_SIZE EQU (ENDOFPROG - BEGINOFPROG) - PSP_SIZE
	RESIDENT_CODE_SIZE EQU (ENDOFTSR - BEGINOFPROG) - PSP_SIZE
ENDIF

;; MEMORY_BLOCK = memory used at INIT time
MEMORY_BLOCK_SIZE EQU PSP_SIZE + INIT_CODE_SIZE + STACK_SIZE

IF MEMORY_BLOCK_SIZE MOD 16
	; If not paragraph aligned, round up
	MEMORY_BLOCK_SIZE_R EQU MEMORY_BLOCK_SIZE + PARA_SIZE
ELSE ; IF paragraph aligned already
	; No rounding needed
	MEMORY_BLOCK_SIZE_R EQU MEMORY_BLOCK_SIZE
ENDIF

; Convert bytes to paragraphs
MEMORY_BLOCK_PARA EQU MEMORY_BLOCK_SIZE_R SHR 4

;; RESIDENT_BLOCK = memory used while TSR
RESIDENT_BLOCK_SIZE EQU PSP_SIZE + RESIDENT_CODE_SIZE + STACK_SIZE

IF RESIDENT_BLOCK_SIZE MOD 16
	; If not paragraph aligned, round up
	RESIDENT_BLOCK_SIZE_R EQU RESIDENT_BLOCK_SIZE + PARA_SIZE ; Rounded up
ELSE ; IF paragraph aligned already
	; No rounding needed
	RESIDENT_BLOCK_SIZE_R EQU RESIDENT_BLOCK_SIZE ; No rounding needed
ENDIF

; Convert bytes to paragraphs
RESIDENT_BLOCK_PARA EQU RESIDENT_BLOCK_SIZE_R SHR 4
