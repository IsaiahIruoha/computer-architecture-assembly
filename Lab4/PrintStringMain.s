.equ	JTAG_UART_BASE,		0x10001000	#adress of first JTAG UART register
.equ	DATA_OFFSET,		0			#offset of JTAG UART data register
.equ	STATUS_OFFSET,		4			#offset of JTAG UART status register
.equ	WSPACE_MASK,		0xFFFF		#used in AND operation to check status

	.text
	.global _start
	.org	0
	
_start:
	movia	sp, 0x7FFFFC	#initialize stack pointer

main:
	movi	r2, s
	call	PrintString
	break
	
	
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
	
PrintString:
	subi	sp, sp, 12
	stw		r2, 8(sp)
	stw		r3, 4(sp)
	stw		ra, 0(sp)
	
	mov		r3, r2
ps_loop:
	ldbu	r2, 0(r3) 		#load byte at str_ptr address
ps_if:
	beq		r2, r0, ps_end_loop 	#exit loop if ch is zero
ps_end_if:
	call 	PrintChar 	#call PrintChar with ch in r2
	addi	r3, r3, 1	#increment str_ptr
	br		ps_loop		#unconditional branch to start of loop
ps_end_loop:
	ldw		ra, 0(sp)
	ldw		r3, 4(sp)
	ldw		r2, 8(sp)
	addi	sp, sp, 12
	ret
	
.org 	0x1000
s:
    .ascii "hello\0"  # Define the string "hello" terminated by '\0'

	