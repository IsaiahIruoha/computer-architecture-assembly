.global _start
_start:
	
	.equ	JTAG_UART_BASE,		0x10001000
	.equ	DATA_OFFSET,		0
	.equ	STATUS_OFFSET,		4
	.equ 	WSPACE_MASK,		0xFFFF
	
GetChar:
	subi	sp, sp, 8
	stw		r3, 4(sp)
	stw		r4, 0(sp)
	
	movia	r3, JTAG_UART_BASE

gc_loop:
	ldwio	r4, DATA_OFFSET(r3)
	andi	r3, r4, 0x8000
	beq		r3, r0, gc_loop
	andi	r2, r4, 0xFF
	
	ldw		r4, 0(sp)
	ldw		r3, 4(sp)
	addi	sp, sp, 8
	ret
	