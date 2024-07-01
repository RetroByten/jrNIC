TITLE jrNIC TestINT60 Driver Program
PAGE 66,80 ; 66 lines per page, 80 characters/line

%OUT Processing EQUATES...
INCLUDE EQUATES.ASM

%OUT Processing CODE Segment
CODESEG SEGMENT
	assume CS:CODESEG, DS:CODESEG, SS:CODESEG
ORG 100h
PROGRAM: ; Needed for COM to later terminate the program
jmp		MAIN ; 3 bytes

MAIN PROC NEAR

;; Invoke int_packet_driver
int		int_packet_driver 

;; Exit
mov		ax,(svc_dos_terminate SHL 8) OR val_dos_terminate_0 
int		int_dos_21 ;; EXIT to DOS

MAIN ENDP

CODESEG ENDS
END PROGRAM
