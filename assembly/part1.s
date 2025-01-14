.global _start
_start:
	.equ LEDs, 0xFF200000
	.equ TIMER, 0xFF202000
	.equ PUSH_BUTTON, 0xFF200050
	.equ TOP_COUNT, 25000000
		#Set up the stack pointer
		li sp, 0x20000
		
		jal CONFIG_TIMER #configure the Timer
		jal CONFIG_KEYS #configure the KEYs port
		
		/* Enable Interrupts in NIOS V processor, and set up the address
		handling location to be the interrupt_handler subroutine */
		
		# Your code goes below here:
		# Your code should:
		# Turn off interrupts in case an interrupt is called before correct set up
		
		# Activate interrupts from IRQ18 (Pushbuttons) and IRQ16 (Timer)
		# set IRQ on
		# set the mtvec register to be the interrupt_handler location
		# Turn the interrupts back on
		la s0, LEDs
		la s1, COUNT
		# disable interrupt 
		csrw mstatus, zero # Turn off the interrupt while doing the rest of the setup
		li s2, 0x50000 		# Turn on IRQ16 and IRQ18 at the same time 
		csrw mie, s2
		la s3, interrupt_handler 
		csrw mtvec, s3		# Set the mtvec register to be interrupt_handler
		li s4, 0b1000
		csrw mstatus, s4 	# Enable interrupt
		
	LOOP:
		lw s2, 0(s1) # get current count
		sw s2, 0(s0) # store count in LEDs
		j LOOP
		
interrupt_handler:
	addi sp, sp, -16
	sw s0, 0(sp)
	sw s1, 4(sp)
	sw s2, 8(sp)
	sw s3, 12(sp)
	
	csrr s0, mcause 	# to see which device caused the interrupt
	li s1, 0x80000010	# Value for the timer 
	bne s0, s1, KEY_SUB # The interrupt is not due to timer 
	jal Timer_ISR
	j CONT
KEY_SUB: jal KEYs_ISR
CONT:
	lw s0, 0(sp)
	lw s1, 4(sp)
	lw s2, 8(sp)
	lw s3, 12(sp)
	addi sp, sp, 16
mret

Timer_ISR: 
	addi sp, sp, -28 # Allocate space on the stack 
	sw s0, 0(sp) # Save a registers on the stack 
	sw s1, 4(sp)
	sw s2, 8(sp)
	sw s3, 12(sp)
	sw s4, 16(sp)
	sw s5, 20(sp)
	sw s6, 24(sp)
	
	li s0, TIMER
	lw s1, 0(s0)
	la s2, COUNT # Load address of COUNT 
	lw s3, 0(s2) # Load the value COUNT onto s3 
	li s4, 255
	bge s3, s4, RESET # if COUNT >= 255 reset the value of COUNT
	la s5, RUN # if < then we add the value of RUN onto COUNT and then save it back to COUNT
	lw s6, 0(s5) # Load value of RUN onto s6
	add s3, s3, s6 # update the value of COUNT = COUNT + RUN
	sw s3, 0(s2)
	j DEAL # no need to reset just deallocate and exit subroutine 
	
RESET: 
	sw zero, 0(s2) # Reset COUNT
	
DEAL: 
	li s1, 0 
	sw s1, 0(s0) # Reset TIMER to 0 
	
	lw s0, 0(sp) # load values back onto the register and deallocate space 
	lw s1, 4(sp)
	lw s2, 8(sp)
	lw s3, 12(sp)
	lw s4, 16(sp)
	lw s5, 20(sp)
	lw s6, 24(sp)

	addi sp, sp, 28
	
	jr ra 
	
KEYs_ISR:
	addi sp, sp, -16 # Allocate space on the stack 
	sw s0, 0(sp) # Save a registers on the stack 
	sw s1, 4(sp)
	sw s2, 8(sp) 
	sw s3, 12(sp) 
	
	la s0, RUN
	lw s1, 0(s0)
	xori s1, s1, 1 # xori switches the value of RUN (xori 1 is switching / xori 0 is keeping same)
	sw s1, 0(s0) # save the value back onto the address of RUN 
	
	li s2, PUSH_BUTTON
	lw s3, 12(s2)
	sw s3, 12(s2) # Reset the edge capture bits 
	
	lw s0, 0(sp) # load values back onto the register and deallocate space 
	lw s1, 4(sp)
	lw s2, 8(sp) 
	lw s3, 12(sp)
	
	addi sp, sp, 16
	
	jr ra 
	
CONFIG_TIMER:
	# configure timer period 
	li t1, TIMER
	li t0, 0b0111 # start, cont, interrupt 
	
	li t2, TOP_COUNT
	li t3, 0x0000FFFF
	srli t4, t2, 16 # t4 stores most significant 16 digits
	and t2, t2, t3 	# t2 stores least significant 16 digits 
	
	sw t2, 8(t1)
	sw t4, 12(t1)
	
	sw t0, 4(t1) # start timer 
	jr ra
ret

CONFIG_KEYS:
	li t0, 0b1111 # want to configure all 4 keys to interrupt
	li t1, PUSH_BUTTON
	sw t0, 8(t1) # set up interrupt bits for all keys 
	sw t0, 12(t1) # write 1 to edge capture to clear each bit
	jr ra
ret

.data
.global COUNT
	COUNT: .word 0x0 # used by timer
.global RUN # used by pushbutton KEYs
	RUN: .word 0x1 # initial value to increment COUNT
.end