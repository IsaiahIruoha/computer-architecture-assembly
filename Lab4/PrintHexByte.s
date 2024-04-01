.global _start
_start:
	
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