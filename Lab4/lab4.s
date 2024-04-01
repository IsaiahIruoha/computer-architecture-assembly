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

	ldw		r8, n(r0)
	movia	r2, byte
	mov		r4, r2
	
loop:
	ldbu	r2, 0(r4)
	call	PrintHexByte
	movi	r2, '?'
	call 	PrintChar
	movi	r2, ' '
	call 	PrintChar
	call	GetChar
if:
	movi	r6,'Z'
	bne		r2, r6, end_if:
then:
	stb 	r0, 0(r4)
end_if:
	addi	r4, r4, 1
	call	PrintChar
	movi	r2, '\n'
	call	PrintChar
	subi	r8, r8, 1
	bne		r8, r0, loop
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

PrintHexDigit:
	subi	sp, sp, 12
	stw		r2, 8(sp)
	stw		r3, 4(sp)
	stw		ra, 0(sp)
	
	mov		r3, r2
phd_if:
	movi	r2, 9
	ble		r3, r2, phd_else
phd_then:
	subi	r2, r3, 10
	addi	r2, r2, 'A'
	br		phd_end_if
phd_else:
	addi	r2, r3, '0'
phd_end_if:
	call 	PrintChar
	
	ldw		r2, 8(sp)
	ldw		r3, 4(sp)
	ldw		ra, 0(sp)
	addi	sp, sp, 12
	ret
	
PrintHexByte:
	subi	sp, sp, 12
	stw		r2, 8(sp)
	stw		r3, 4(sp)
	stw		ra, 0(sp)
	
	mov		r3, r2		#move argument n to r3
	srli	r2, r3, 4		#shift n right by 4 bits, store in r2
	call 	PrintHexDigit		#call PrintHexDigit with digit in r2
	andi	r2, r3, 0xF		#andi n with 0xF, result in r2
	call	PrintHexDigit		#call PrintHexDigit again for other digit
	
	ldw		ra, 0(sp)
	ldw		r3, 4(sp)
	ldw		r2, 8(sp)
	addi	sp, sp, 12
	ret

ShowByteList:
	subi	sp, sp, 16
	stw		r2, 12(sp)
	stw		r3, 8(sp)
	stw		r4, 4(sp)
	stw		ra, 0(sp)
	
	mov		r4, r2
sbl_loop:
	movi	r2, '('
	call 	PrintChar
	ldbu	r2, 0(r4)
	call	PrintHexByte
	addi	r4, r4, 1
	subi	r3, r3, 1
	movi	r2, ')'
	call 	PrintChar
	movi	r2, ' '
	call	PrintChar
	
	bgt		r3, r0, sbl_loop
sbl_end_loop:
	movi	r2, '\n'
	call	PrintChar
	ldw		ra, 0(sp)
	ldw		r4, 4(sp)
	ldw		r3, 8(sp)
	ldw		r2, 12(sp)
	addi	sp, sp, 16
	ret
	
GetChar:
	subi	sp, sp, 8
	stw		r3, 4(sp)
	stw		r4, 0(sp)
	
	movia	r3, JTAG_UART_BASE

gc_loop:
	ldwio	r4, DATA_OFFSET(r3)
	andi	r2, r4, 0x8000
	beq		r2, r0, gc_loop
	andi	r2, r4, 0xFF
	
	ldw		r4, 0(sp)
	ldw		r3, 4(sp)
	addi	sp, sp, 8
	ret
	
.org 	0x1000

n:	.word 4
byte: .byte 0x88, 0xA3, 0xF2, 0x1C
s:
    .ascii "lab 4\n"
	

	
	
	