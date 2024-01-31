.text
.global _start
.org 0x0000
_start:
	ldw r2, A(r0)
	ldw r3, J(r0)
	ldw r4, H(r0)
    add r3, r3, r2
	div r4, r3, r4 
	stw r4, B(r0) 
	ldw r3, F(r0)
	ldw r5, K(r0) 
	sub r4, r3, r4
	add r4, r4, r5
	stw r4, W(r0)
	mul r2, r2, r3
	stw r2, X(r0) 
_end:
	break
.org 0x1000
A: .word 2
H: .word 3
J: .word 4
K: .word 5
F: .word 6
B: .skip 4
W: .skip 4
X: .skip 4
	.end 
	
	
	
	