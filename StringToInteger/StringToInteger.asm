.text
.globl StringToInteger

StringToInteger:
	add $v0, $zero, $zero		# $v0 will be accumulated and store converted Integer.
	add $t0, $a0, $zero		# $t0 is pointer pointing target byte element.
	
Loop:	lb $t1, 0($t0)			# load value from pointer
	beq $t1, $zero, Return		# goto Return if NULL-Terminated.
	slti $t2, $t1, 48 
	bne $t2, $zero, Illegal		# Validity test: Allowed value (48~57)
	slti $t2, $t1, 58		# goto Illegal if it is not allowed.
	beq $t2, $zero, Illegal

	mul $v0, $v0, 10		# multiply 'accumulated $v0' by 10 (ready to add next digit)
	addi $t1, $t1, -48		# Correction (ASCII Code to Integer Value)
	add $v0, $v0, $t1		# add new digit on Least Significant Digit

	addi $t0, $t0, 1		# Pointing next byte
	j Loop				# Iterate

Illegal:li $v0, -1			# Illegal String return -1
Return:	jr $ra				# Return to caller, the origin
