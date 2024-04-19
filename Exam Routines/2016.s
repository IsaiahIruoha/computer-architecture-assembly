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
	
	movi r3, 'a'
	movi r4, 'z'
	mov r5, r0
loop:
	call GetChar
	blt r2, r3, loop
	bgt r2, r4, loop
	call PrintChar
	movia r3, TEST_STR
loop2:
	ldb r4, 0(r3) 
	bne r2, r4, else
	beq r4, r0, endloop
then:
	addi r5, r5, 1
else: 
	addi r3, r3, 1
	br loop2
endloop: 
	stw r5, COUNT(r0) 
	break
	
PrintChar:
	subi sp, sp, 8
	stw r3, 4(sp)
	stw r4, 0(sp)
	
	movia r3, JTAG_UART_BASE
	
pc_loop:
	ldwio r4, 4(r3)
	andhi r4, r4, 0xFFFF
	beq r4, r0, pc_loop
	
	stwio r2, 0(r3) 
	ldw r4, 0(sp)
	ldw r3, 4(sp)
	addi sp, sp, 8
	ret
	
GetChar:
	subi sp, sp, 8
	stw r3, 4(sp)
	stw r4, 0(sp)
	
	movia r3, JTAG_UART_BASE

gc_loop:
	ldwio r2, 0(r3)
	andi r4, r2, 0x8000
	beq r4, r0, gc_loop
gc_then: 
	andi r2, r2, 0xFF
	ldw r4, 0(sp)
	ldw r3, 4(sp)
	addi sp, sp, 8
	ret

PrintString:
	subi sp, sp, 12
	stw ra, 8(sp)
	stw r2, 4(sp)
	stw r3, 0(sp)
	
	mov r3, r2
ps_loop:
	ldb r2, 0(r3) 
	beq r2, r0, ps_end
	call PrintChar
	addi r3, r3, 1
	br ps_loop
ps_end:
	ldw r3, 0(sp)
	ldw r2, 4(sp)
	ldw ra, 8(sp)
	addi sp, sp, 12
	ret

.org 0x1000
TEST_STR: .ascii "a test string of characters" 
TEXT: .ascii "Type a lowercase character a-z:\n"
COUNT: .skip 4
.end