.global _start
_start:
	la s0, LIST  # Pointer to element accessed in the list
	lw s1, 0(s0)
	la s1, LIST 
	addi s1, s1, 4 # Permanently store the address of memory location, update s0 later
	lw s2, 0(s0) # Access the number of element in the list
	addi s0, s0, 4 # Move to pointer to actual number
	addi s2, s2, -1
WHILE1: beqz s2, END # No more swaps needed
	li s3, 0 # Counter for number of swaps
WHILE2: beq s3, s2, CONT
	addi a0, s0, 0 # Input
	jal SWAP
	addi s0, s0, 4
	addi s3, s3, 1
	j WHILE2
CONT:
	addi s0, s1, 0 # Move the pointer back to first element
	addi s2, s2, -1
	j WHILE1
END: j END
	
SWAP: 
	# Take an argument a0, address of list element. Compare with the next element
	# if a swap is performed, 1 is returned. 0 is returned otherwise
	lw t0, 0(a0) # a0 - address, t0 - value
	addi a1, a0, 4 # a1 - address, t1 - value
	lw t1, 0(a1)
	
	blt t0, t1, NO_SWAP # Comparison
	sw t1, 0(a0)
	sw t0, 0(a1) # Swap
	li a0, 1 # Return
	jr ra
NO_SWAP:
	li a0, 0 # No swap performed, return
	jr ra		
	
.global LIST
.data
LIST:
.word 10, 1400, 45, 23, 5, 3, 8, 17, 4, 20, 33