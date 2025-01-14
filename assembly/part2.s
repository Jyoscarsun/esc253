.text
.global _start
_start: li s0, 0xFF200050 # Address of keys
	li s1, 0xFF200000 # Address of LEDs
	li s2, 0xFF20005C # Address of the edge bits
	li s3, -1 		  # Counter on the LED
	li s10, 15 	      # Use 1111 to reset edge bits

ADD1: addi s3, s3, 1
	j update_led

DELAY: li s11, 500000 # Change to 10,000,000 on the lab board
LOOP: addi s11, s11, -1 # Decrease the timer by 1
    lw s4, 0(s2)   # Polling at the same time
	bnez s4, RESET  # Stop the count once edge bits are no longer zero
	bnez s11, LOOP # Loop when the timer is not zero yet
	j ADD1 		   # Increment by 1

RESET: sw s10, 0(s2)
	j STOP

STOP: lw s4, 0(s2)	 # Polling at the same time
	bnez s4, CONT    # Continue the count once edge bits are no longer zero
	j STOP

CONT: sw s10, 0(s2)
	j ADD1	
	
update_led: sw s3, 0(s1)
	j DELAY

END: j END

	