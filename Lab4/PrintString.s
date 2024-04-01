.global _start
_start:
	
	
PrintString:
	subi	sp, sp, 12
	stw		r2, 8(sp)
	stw		r3, 4(sp)
	stw		ra, 0(sp)
	
	mov		r3, r2
ps_loop:
	ldbu	r2, 0(r3) 		#load byte at str_ptr address
ps_if:
	beq		r2, 0, ps_end_loop 	#exit loop if ch is zero
ps_end_if:
	call 	PrintChar 	#call PrintChar with ch in r2
	addi	r3, r3, 1	#increment str_ptr
	br		ps_loop		#unconditional branch to start of loop
ps_end_loop:
	ldw		r3, 0(sp)
	ldw		r2, 4(sp)
	ldw		ra, 8(sp)
	addi	sp, sp, 12
	ret