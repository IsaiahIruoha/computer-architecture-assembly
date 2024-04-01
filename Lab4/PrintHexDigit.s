.global _start
_start:
	
PrintHexDigit:
	subi	sp, sp, 12
	stw		r2, 8(sp)
	stw		r3, 4(sp)
	stw		ra, 0(sp)
	
	mov		r3, r2
phd_if:
	mov		r2, 9
	ble		r3, r2, phd_else
phd_then:
	subi	r2, r3, 10
	addi	r2, r2, 'A'
	br		phd_end_if
phd_else:
	addi	r2, r3, 0
phd_end_if:
	call 	PrintChar
	
	ldw		r2, 8(sp)
	ldw		r3, 4(sp)
	ldw		ra, 0(sp)
	addi	sp, sp, 12
	ret