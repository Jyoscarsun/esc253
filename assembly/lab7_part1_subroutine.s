.global _start
.text

_start:
	la a0, LIST # Load the memory address into a0
	lw a1, 0(a0) 
	jal ONES
END: j END
	
ONES: addi s1, zero, 0 # Register s2 hold the count
LOOP: beqz a1,ENDLOOP
	srli a0, a1, 1 # Perform SHIFT, followed by AND
	and a1, a1, a0
	addi s1, s1, 1 # Count the string length
	j LOOP
ENDLOOP: addi a0, s1, 0 # Return value goes in a0
	jr ra
	
.global LIST
.data
LIST:
.word 0x103fe00f
	
