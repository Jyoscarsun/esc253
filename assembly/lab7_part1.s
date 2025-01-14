.global _start
_start:
	la a1, LIST    # Load the memory address of LIST into a1
	lw a0, 0(a1)   # Load the value at address a1 into a0
	li s3, -1
	li s10, -1     # s4 stores the maximum number of 1's 
LOOP: beq a0, s3, END # Exit loop after reaching -1
	jal ONES       # Call the subroutine
	bge a0, s10, UPDATE
CONT:	
	addi a1, a1, 4 # Update memory pointer address
	lw a0, 0(a1)   # Update word stored in a1
	j LOOP
UPDATE:
	mv s10, a0
	j CONT
END: j END

ONES: 
    addi t0, a0, 0 #copy input to s0
    addi t1, zero, 0 #set counter to 0 
    addi a0, zero, 0 #set result to 0 
LOOP1:
    beqz t0, RETURN1 # Loop until data contains no more 1’s
    srli t2, t0, 1 # Perform SHIFT, followed by AND
    and t0, t0, t2
    addi t1, t1, 1 # Count the string lengths so far
	mv a0, t1      # Move the count to a0
    j LOOP1
RETURN1:
	jr ra
	
.global LIST
.data
LIST:
.word 0x103fe00f, 0x00000000, 0x11111111, 0xffffffff
	
