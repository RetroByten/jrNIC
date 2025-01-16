;; These equates are all known before hand
interrupt_vector_table_segment		EQU 0000h
int_bios_video_10					EQU 10h
	svc_bios_video_setmode_00			EQU	00h
	svc_bios_video_tty_0E				EQU 0Eh
	svc_bios_video_getmode_0F			EQU 0Fh
		val_bios_video_col_white_0F			EQU 0Fh
int_dos_21							EQU	21h
    svc_dos_print_char_02				EQU 02h
	svc_dos_print_str_09				EQU 09h
	svc_dos_set_interrupt_25			EQU 25h
	svc_dos_keep_resident_31			EQU 31h
	svc_dos_get_interrupt_35			EQU 35h
	svc_dos_free_memory_49				EQU 49h
	svc_dos_setblock_4A					EQU	4Ah
	svc_dos_terminate_4C				EQU 4Ch
		val_dos_terminate_00				EQU 00h
		val_dos_terminate_01				EQU 01h ; error
int_default_pkt_driver				EQU 60h
int_modem					EQU 0Ch ; Interrupt for the modem port, IRQ 4
	int_modem_offset			EQU int_modem * 4
	int_modem_segment			EQU int_modem_offset + 2

;; PORTS
	port_pic_cmd				EQU 20h ; 8259A PIC Command port
		val_pic_eoi					EQU 20h ; 8259A PIC "End of Interrupt" value
	port_pic_data				EQU 21h ; 8259A PIC data port
		mask_modem_bit				EQU 00010000B ; (to enable, invert + AND -> 1110 1111)
port_nmi_mask_reg			EQU 0A0h ; 
	nmi_enable				EQU 10000000B ; Bit 7 = NMI
	nmi_disable				EQU 00000000B ; Bit 7 = NMI
; PSP Offsets
		val_dos_env_offset_2C				EQU 2Ch
		val_dos_args_80h					EQU 80h
		
;; Packet Driver Error Codes
BAD_HANDLE		EQU 1	;1	BAD_HANDLE	Invalid handle number,
NO_CLASS		EQU 2	;2	NO_CLASS	No interfaces of specified class found,
NO_TYPE			EQU 3	;3	NO_TYPE		No interfaces of specified type found,
NO_NUMBER		EQU 4	;4	NO_NUMBER	No interfaces of specified number found,
BAD_TYPE		EQU 5	;5	BAD_TYPE	Bad packet type specified,
NO_MULTICAST	EQU 6	;6	NO_MULTICAST	This interface does not support multicast,
CANT_TERMINATE	EQU 7	;7	CANT_TERMINATE	This packet driver cannot terminate,
BAD_MODE		EQU 8	;8	BAD_MODE	An invalid receiver mode was specified,
NO_SPACE		EQU 9	;9	NO_SPACE	Operation failed because of insufficient space,
TYPE_INUSE		EQU 10	;10	TYPE_INUSE	The type had previously been accessed,
						;			and not released,
BAD_COMMAND		EQU 11	;11	BAD_COMMAND	The command was out of range, or not implemented,
CANT_SEND		EQU 12	;12	CANT_SEND	The packet couldn't be sent (usually hardware error),
CANT_SET		EQU 13	;13	CANT_SET	Hardware address couldn't be changed
						;			(more than 1 handle open),
BAD_ADDRESS		EQU 14	;14	BAD_ADDRESS	Hardware address has bad length or format,
CANT_RESET		EQU 15	;15	CANT_RESET	Couldn't reset interface (more than 1 handle open).

;; NUMBER OF SUPPORTED HANDLES
HANDLE_COUNT EQU 10 ; Per Packet Driver Spec

;; RAM Usage
PSP_SIZE EQU 100h ; DOS 2.1 Technical Reference (p.6-5), PARA ALIGNED
STACK_DOS_SIZE EQU 80h ; DOS 2.1 Technical Reference (p.5-14), PARA ALIGNED
STACK_USER_SIZE EQU 80h 
STACK_SIZE EQU STACK_DOS_SIZE + STACK_USER_SIZE ; 100h
PARA_SIZE EQU 0Fh
