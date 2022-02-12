# int factorial(int n){
#	 if(n<1) return 1;
#	 return n*factorial(n-1);
# }

.globl factorial
factorial:			# Procedure named Factorial
	slti $t0, $a0, 1	# $t0 is 1 if $a0<1 or 0 otherwise.
	beq $t0, $zero, L1	# goto L1 if $t0=0 (if $a0>=1)
	
	addi $v0, $zero, 1	# (for cae $a0<1) set as $v0=1
	jr $ra			# return to caller

	L1:			# (for case $a0>=1)
	addi $sp, $sp, -8	# Move stack pointer downward by 2 word
	sw $ra, 4($sp)		# backup the value of $ra, (push into stack)
	sw $a0, 0($sp)		# backup the value of $a0, (push into stack)

	addi $a0, $a0, -1	# Subtract $a0 by 1 (for recursive call)
	jal factorial		# jump to factorial and link (recursive call)

	lw $a0, 0($sp)		# restore the value of $a0, (pop from stack)
	lw $ra, 4($sp)		# restore the value of $ra, (pop from stack)
	addi $sp, $sp, 8	# Move stack pointer upward by 2 word

	mul $v0, $a0, $v0	# Multiply $a0 by $v0, result will be ($a0)!
	jr $ra			# jump and return to $ra, which is origin, caller.
