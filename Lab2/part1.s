.text
.global _start
.org 0x0000

_start:
	movia 	 sp, 0x7FFFFC
	movia	 r2, x
	movia 	 r3, y
	movia	 r4, N
	 ldw     r4, 0(r4)
	 movi	 r5, 5
	 movi    r6, 2
	 call    ListCalc
	 stw     r2, RESULT(r0)
_end:
	 break
	 
	 ListCalc:
	 		subi sp, sp, 28
			stw  r3, 0(sp)
			stw  r4, 4(sp)
			stw  r5, 8(sp)
			stw  r6, 12(sp)
			stw  r7, 16(sp)
			stw  r8, 20(sp)
			stw  r9, 24(sp)
			mov  r9, r0
		LOOP: 
		    ldw  r7, 0(r2)
			ldw  r8, 0(r3)
		m_If:
		    bgt  r7, r5, m_Else
		m_Then:
		    mul  r8, r6, r7
			subi r8, r8, 4
			stw  r8, 0(r3)
			br   m_EndIf
		m_Else:
		    mov  r8, r0
			mov  r7, r5
			stw  r7, 0(r2)
			stw  r8, 0(r3)
			addi r9, r9, 1
		m_EndIf:
		    addi r2, r2, 4
			addi r3, r3, 4
			subi r4, r4, 1
			bgt  r4, r0, LOOP
			mov  r2, r9
			ldw  r3, 0(sp)
			ldw  r4, 4(sp)
			ldw  r5, 8(sp)
		    ldw  r6, 12(sp)
			ldw  r7, 16(sp)
			ldw  r8, 20(sp)
			ldw  r9, 24(sp)
			addi sp, sp, 28
			ret
			
.org 0x1000
N:  .word  3
x:  .word  1, 3, 5
y:  .word  -1, -1, -1
RESULT: .skip 4

			
						

	  
	  
	