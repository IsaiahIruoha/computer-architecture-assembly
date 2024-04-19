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
	
	movia r4, LIST
	movi r3, 0x1
	mov r5, r0 
	ldw r6, LENGTH(r0) 
	
loopy: 
	mov r2, r3
	call PrintHexDigit
	movi r2, ':'
	call PrintChar
	ldw r2, 0(r4)
	bge r2, r0, else
then:
	movi r2, 'N'
	call PrintChar
	addi r5, r5, 1
	br endif
else:
	movi r2, '.'
	call PrintChar
endif: 
	movi r2, '\n'
	call PrintChar
	addi r3, r3, 0x1
	subi r6, r6, 1
	addi r4, r4, 4
	bgt	 r6, r0, loopy
	
	stw r5, NEG_COUNT(r0) 
	break
	
PrintChar:
	subi sp, sp, 8 
	stw r4, 0(sp)
	stw r3, 4(sp)
	movia r4, JTAG_UART_BASE
	
pc_loop:	
	ldwio r3, 4(r4) 
	andhi r3, r3, 0xFFFF
	beq r3, r0, pc_loop
	stwio r2, 0(r4) 
	
	ldw r3, 4(sp)
	ldw r4, 0(sp) 
	addi sp, sp, 8
	ret
	
PrintString:
	subi sp, sp, 12
	stw r3, 8(sp)
	stw r2, 4(sp)
	stw ra, 0(sp)
	mov r3, r2
	
ps_loop:
	ldbu r2, 0(r3)
	beq r2, r0, ps_endloop
ps_endif:
	call PrintChar
	addi r3, r3, 1
	br ps_loop
ps_endloop: 

	ldw r3, 8(sp)
	ldw r2, 4(sp)
	ldw ra, 0(sp) 
	addi sp, sp, 12
	ret 
	
PrintHexDigit: 
	subi sp, sp, 12
	stw r3, 8(sp)
	stw r2, 4(sp)
	stw ra, 0(sp)
	
	movi r3, 9 
	bgt r2, r3, phd_else
	addi r2, r2, '0'
	br phd_endif
phd_else:
	subi r2, r2, 10
	addi r2, r2, 'A'
phd_endif: 
	call PrintChar
	ldw r3, 8(sp)
	ldw r2, 4(sp)
	ldw ra, 0(sp) 
	addi sp, sp, 12
	ret 
	
	.org 0x1000
LENGTH: .word 5
LIST: .word 0xAA, -33, 0, -11, 0xFFFFFFFF
TEXT: .ascii "Summary of element values\n"
NEG_COUNT: .skip 4
	.end
	