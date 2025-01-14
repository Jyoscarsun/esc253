.global _start
.text
_start:
	la s2, LIST #Load address of LIST into s2
	addi s10, zero, 0 #s10 = 0 Keep track of number
	addi s11, zero, 0 #s11 = 0 Keep track of sum
	lw s3, 0(s2) # The value 
	li t0, -1
LOOP: beq s3, t0, END
	addi s11, s11, 1
	add s10, s10, s3
	addi s2, s2, 4
	lw s3, 0(s2)
	j LOOP
END: j END
.global LIST
.data

LIST:
.word 1, 2, 3, 5, 0xA, -1