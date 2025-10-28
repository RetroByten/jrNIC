;; These rely on values not known until the (END)
;; After the first pass of the assembler

;; RAM usage equates during INIT and TSR phases

;; Note: PARA = Paragraph = 16 byte aligned
;; Note: TSR = Terminate and stay resident
;; Note: *_R = rounded up to nearest paragraph boundary

;; Number of bytes main program is
CODE_SIZE EQU (ENDOFPROG - BEGINOFPROG) - PSP_SIZE

;; Number of bytes in the memory shim
MEMORYSHIM_SIZE EQU MEMORYSHIMEND-MEMORYSHIMBEGIN

;; Number of bytes full program is
;RESIDENT_SIZE EQU PSP_SIZE + CODE_SIZE + STACK_SIZE

IF ROM
RESIDENT_SIZE EQU PSP_SIZE + MEMORYSHIM_SIZE + RECV_BUFFER_SIZE + STACK_SIZE
RECV_BUFFER_OFFSET EQU PSP_SIZE + MEMORYSHIM_SIZE; End of PSP+Code, Beginning of Receive Buffer
STACK_OFFSET EQU PSP_SIZE + MEMORYSHIM_SIZE + RECV_BUFFER_SIZE + STACK_SIZE ; Top of Memory
ELSE ; COM
RESIDENT_SIZE EQU PSP_SIZE + CODE_SIZE + RECV_BUFFER_SIZE + STACK_SIZE
RECV_BUFFER_OFFSET EQU PSP_SIZE + CODE_SIZE ; End of PSP+Code, Beginning of Receive Buffer
STACK_OFFSET EQU PSP_SIZE + CODE_SIZE + RECV_BUFFER_SIZE + STACK_SIZE ; Top of Memory
ENDIF

;; How many paragraphs of RAM we retain, rounded up
RESIDENT_PARA EQU (RESIDENT_SIZE SHR 4) + 1
