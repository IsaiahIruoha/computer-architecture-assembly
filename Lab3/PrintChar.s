.text
.global _start
.org 0
_start:
	
	.equ	JTAG_UART_BASE,		0x10001000
	.equ	DATA_OFFSET,		0
	.equ	STATUS_OFFSET,		4
	.equ 	WSPACE_MASK,		0xFFFF
	
	movia	sp, 0x7FFFFC
	movia	r2, c
	
	call PrintChar
	
PrintChar:
	subi	sp, sp, 8
	stw		r3, 4(sp)
	stw		r4, 0(sp)
	
	movia	r3, JTAG_UART_BASE

pc_loop:
	ldwio	r4, STATUS_OFFSET(r3)
	andhi	r4, r4, WSPACE_MASK
	beq 	r4, r0, pc_loop
	stwio	r2, DATA_OFFSET(r3)
	ldw		r3, 4(sp)
	ldw		r4, 0(sp)
	addi	sp, sp, 8
	ret
	
	.org 0x1000

c:  .word 4