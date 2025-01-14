.text
.global _start
_start: li s0, 0xFF200050 # Address of keys
	li s1, 0xFF200000 # Address of LEDs
	li s11, 15        # Save 15 to register s11 for comparison
	li s10, 1		  # Save 1 to register s10 for comparison
	li s9, 0          # Boolean checker for whether key 3 is pressed in prev cycle
	
POLL: lw s2, 0(s0)    # Poll for key press
	beqz s2, POLL     # Continue polling if s2 equals to 0
WAIT: lw s3, 0(s0)
	bnez s3, WAIT	  # Wait for key release, s3 goes back to 0
	beq s9, s10, LOAD1 # If s9 (key 3 pressed previously) is true
	li s3, 1          # Check for key 0, and with 0001
	andi s5, s2, 0x1
	bne s5, s3, CHECK_1
	li s4, 1		  # Key 0 is pressed, show 0x1
	j update_led

CHECK_1: li s3, 2	  # Check for key 1
	and s5, s2, s3
	bne s5, s3, CHECK_2
	blt s4, s11, ADD1
CONT1: j update_led
	
ADD1: addi s4, s4, 1
	j CONT1

CHECK_2: li s3, 4     # Check for key 2
	and s5, s3, s2
	bne s5, s3, CHECK_3
	blt s10, s4, SUB1
CONT2:	j update_led

SUB1: addi s4, s4, -1
	j CONT2
	
CHECK_3: li s4, 0     # Key 3
	li s9, 1
	j update_led

LOAD1: li s4, 1
	li s9, 0
	j update_led

update_led: sw s4, 0(s1)
	j POLL
 
END: j END