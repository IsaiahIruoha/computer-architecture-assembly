.equ JTAG_UART_BASE, 0x10001000
.equ DATA_OFFSET, 0
.equ STATUS_OFFSET, 4
.text
.global _start
.org 0x0000

_start:
	movia sp, 0x7FFFFC
main:
	movi r3, 15
	movia r2, TEXT
	call PrintString
	mov r4,r0
	movia r5, LIST
	movi r6, ' '
loop:
	call GetChar
	call PrintChar
	stb r2, 0(r5)
	bne r2, r6, endif
	addi r4, r4, 1
endif:
	subi r3, r3, 1
	addi r5, r5, 1
	bgt r3, r0, loop
endloop:
	movi r2, '\n'
	call PrintChar
	movia r2, TEXT2
	call PrintString
	mov r2, r4
	call PrintHexDigit
	break
	
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
	stw r3, 4(sp)
	stw r4, 0(sp)
	movia r3, JTAG_UART_BASE

gc_loop:
	ldwio r2, DATA_OFFSET(r3)
	andi r4, r2, 0x8000
	beq r4, r0, gc_loop
	andi r2, r2, 0xFF
	ldw r4, 0(sp)
	ldw r3, 4(sp)
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
	beq r2, r0, ps_end
	call PrintChar
	addi r3, r3, 1
	br ps_loop
	
ps_end:
	ldw ra, 0(sp)
	ldw r2, 4(sp)
	ldw r3, 8(sp)
	addi sp, sp, 12
	ret

PrintHexDigit:
	subi sp, sp, 12
	stw r3, 8(sp)
	stw r2, 4(sp)
	stw ra, 0(sp)
	movi r3, 9
phd_if:
	bgt r2, r3, phd_else
phd_then:
	addi r2, r2, '0'
	br phd_end
phd_else:
	subi r2, r2, 10
	addi r2, r2, 'A'
phd_end:
	call PrintChar
	ldw ra, 0(sp)
	ldw r2, 4(sp)
	ldw r3, 8(sp)
	addi sp, sp, 12
	ret	
	
.org 0x1000
TEXT: .asciz "Enter 15 characters:\n"
TEXT2: .asciz "# of space chars ="
LIST: .skip 15
.end