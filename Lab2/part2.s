.equ  JTAG_UART_BASE, 	0x10001000
.equ  DATA_OFFSET,      0
.equ  STATUS_OFFSET,    4
.equ  WSPACE_MASK,      0xFFFF
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
	 call    SumList
	 
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
		LOOPL: 
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
			bgt  r4, r0, LOOPL
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
		
	SumList: 
	     subi sp, sp, 8
		 stw  r4, 4(sp)
		 stw  r5, 0(sp)
		LOOP:
		   ldw r5, 0(r2)
		 v_If: 
		   bgt r5, r0, else_If
		 v_IfL:
		   blt r5, r0, else_IfL
		 v_then: 
		   subi sp, sp, 8
		   stw  ra, 0(sp)
		   stw  r2, 4(sp)
		   movi r2, '0'
		   call PrintChar
		   movi r2, '\n'
		   call PrintChar
		   ldw  ra, 0(sp)
		   ldw  r2, 4(sp)
		   addi sp, sp, 8
		   br endIf
		 else_If: 
		   subi sp, sp, 8
		   stw  ra, 0(sp)
		   stw  r2, 4(sp)
		   movi r2, '+'
		   call PrintChar
		   movi r2, '\n'
		   call PrintChar
		   ldw  ra, 0(sp)
		   ldw  r2, 4(sp)
		   addi sp, sp, 8
		   br endIf
		 else_IfL: 
		   subi sp, sp, 8
		   stw  ra, 0(sp)
		   stw  r2, 4(sp)
		   movi r2, '-'
		   call PrintChar
		   movi r2, '\n'
		   call PrintChar
		   ldw  ra, 0(sp)
		   ldw  r2, 4(sp)
		   addi sp, sp, 8
		   br endIf
		  endIf: 
		   addi r2, r2, 4
		   subi r4, r4, 1
	
		   bgt  r4, r0, LOOP
		   ldw  r3, 4(sp)
		   ldw  r5, 0(sp)
		   ret   
		   
	PrintChar: 
	      subi		sp, sp, 8		#adjust stack pointer down to reserve space
		  stw		r3, 4(sp)		# save value of register r3 so it can be a temp
		  stw		r4, 0(sp)		# save value of register r4 so it can be a temp
		  movia     r3, JTAG_UART_BASE    # point to first memory-mapped I/0 register
	pc_loop:
		  ldwio		r4, STATUS_OFFSET(r3)  # read bits from status register
		  andhi     r4, r4, WSPACE_MASK    # mask off lower bits to isolate upper bits
		  beq       r4, r0, pc_loop        # if upper bits are zero, loop again
		  stwio     r2, DATA_OFFSET(r3)   # otherwise, write character to data register
		  ldw		r3, 4(sp)   # restore value of r3 from stack
		  ldw		r4, 0(sp)   # restore value of r3 from stack
		  addi		sp, sp, 8   # return to calling routine
		  ret
			
.org 0x1000
N:  .word  3
x:  .word  1, 3, 5
y:  .word  -1, -1, -1
RESULT: .skip 4

.end
