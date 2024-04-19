.equ JTAG_UART_BASE, 0x10001000
.equ DATA_OFFSET, 0
.equ STATUS_OFFSET, 4
.text
.global _start
.org 0x0000

_start:
	movia sp, 0x7FFFC
main:
	movia r2, TEXT
	call PrintString
	
	movia r3, BUFFER
	movi r4, 'A'
	movi r5, 'Z'
	movi r7, '\n'
	mov r8, r0 
	movia r2, BUFFER
	call GetString
loop: 
	ldb r6, 0(r3) 
	addi r3, r3, 1
	bgt r6, r5, loop
	blt r6, r4, loop
	addi r8, r8, 1
	beq r6, r7, endif
endif: 
	stw r8, COUNT(r0) 
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
	beq r2, r0, ps_endif
	call PrintChar
	addi r3, r3, 1
	br ps_loop
ps_endif:
	ldw ra, 0(sp)
	ldw r2, 4(sp)
	ldw r3, 8(sp)
	addi sp, sp, 12
	ret

GetString:
	subi sp, sp, 16
	stw r4, 12(sp)
	stw r3, 8(sp)
	stw r2, 4(sp)
	stw ra, 0(sp)
	
	movi r3, '\n' 
	mov r4, r2
	
gs_loop:
	call GetChar
	call PrintChar
	addi r4, r4, 1
	beq r2, r3, gs_endif
	stb r2, 0(r4)
	br gs_loop
gs_endif:
	stb r0, 0(r4) 
	ldw ra, 0(sp)
	ldw r2, 4(sp)
	ldw r3, 8(sp)
	ldw r4, 12(sp)
	addi sp, sp, 12
	ret
	
.org 0x1000
TEXT: .ascii "Type 80 chars. or less and press Enter\n"
COUNT: .skip 4
BUFFER: .skip 81 
.end 