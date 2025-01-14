.equ PERIOD, 25000000
.equ TIMER, 0xFF202000

.text
.global _start
_start: li s0, 0xFF200050 # Address of keys
	li s1, 0xFF200000 # Address of LEDs
	li s2, 0xFF20005C # Address of the edge bits
	li s3, -1 		  # Counter on the LED
	
	li s9, TIMER
	li s5, PERIOD
	li s6, 0x0000FFFF # Masking bits
	srli s7, s6, 16   # srli by 16
	and s5, s5, s6    # least significant 16 digits
	
	li s10, 15 	      # Use 1111 to reset edge bits
	li s11, 6         # Use 0110 to set up timer
	
	sw s5, 8(s9)
	sw s7, 16(s9)
	
ADD1: addi s3, s3, 1
	j update_led

COUNTER: sw s11, 4(s9)
POLL: lw s8, 0(s9)    	# Poll timer TO status
	lw s4, 0(s2)		# Poll edge bits at the same time
	bnez s4, RESET
	andi s8, s8, 1
	beqz s8, POLL
	xori s8, s8, 1		# Reset TO whe timer finishes countdown
	sw s8, 0(s9)        # Save the reset TO back to timer
	j ADD1 		   		# Increment by 1

RESET: sw s10, 0(s2)
	j STOP

STOP: lw s4, 0(s2)	 # Polling at the same time
	bnez s4, CONT    # Continue the count once edge bits are no longer zero
	j STOP

CONT: sw s10, 0(s2)
	j ADD1	
	
update_led: sw s3, 0(s1)
	j COUNTER

END: j END

	
