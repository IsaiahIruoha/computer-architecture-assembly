.equ JTAG_UART_BASE, 0x10001000
.equ DATA_OFFSET, 0
.equ STATUS_OFFSET, 4
.text
.global _start
.org 0x0000

_start: 
	movia sp, 0x7FFFFC
main: 
	movia r2, TEXT
	call PrintString

	movi r3, 8
	mov r4, r0
	
loopy:
	call GetDecDigit
	muli r4, r4, 10
	add r4, r4, r2
	subi r3, r3, 1
	bgt r3, r0, loopy
	stw r4, VALUE(r0) 
	break
	
GetDecDigit: 
	subi sp, sp, 12
	stw r3, 8(sp)
	stw ra, 0(sp)
	stw r4, 4(sp)
	
	movi r3, '0'
	movi r4, '9'
	
gdd_loop:
	call GetChar
	blt r2, r3, gdd_loop
	bgt r2, r4, gdd_loop

	call PrintChar
	subi r2, r2, '0'
	
	ldw r3, 8(sp)
	ldw r4, 4(sp)
	ldw ra, 0(sp)
	addi sp, sp, 12
	ret
	
PrintChar: 
	subi sp, sp, 8
	stw r3, 4(sp)
	stw r4, 0(sp)
	
	movia r3, JTAG_UART_BASE
	
pc_loop:
	ldwio r4, STATUS_OFFSET(r3) 
	andhi r4, r4, 0xFFFF
	beq r4, r0, pc_loop
	stwio r2, DATA_OFFSET(r3) 
	
	ldw r4, 0(sp)
	ldw r3, 4(sp)
	addi sp, sp, 8
	ret
	
GetChar:
	subi sp, sp, 8
	stw r3, 0(sp)
	stw r4, 4(sp) 
	
	movia r3, JTAG_UART_BASE
gc_loop: 
	ldwio r2, DATA_OFFSET(r3) 
	andi r4, r2, 0x8000
	beq r4, r0, gc_loop
	andi r2, r2, 0xFF
	
	ldw r4, 4(sp)
	ldw r3, 0(sp)
	addi sp, sp, 8
	ret

PrintString: 
	subi sp, sp, 12
	stw r3, 8(sp)
	stw r2, 4(sp)
	stw ra, 0(sp)
	
	mov r3, r2
	
ps_loop: 
	ldb r2, 0(r3) 
	beq r2, r0, endloop
	call PrintChar
	addi r3, r3, 1
	br ps_loop
endloop: 
	ldw ra, 0(sp)
	ldw r2, 4(sp)
	ldw r3, 8(sp)
	addi sp, sp, 12
	ret
	
.org 0x1000
VALUE: .skip 4
TEXT: .asciz "Enter exactly 8 decimal digits\n" 
.end