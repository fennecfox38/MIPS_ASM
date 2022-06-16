# void strcpy(char dst[], char src[]){
#	 int i=0;
#	 while((dst[i]=src[i])!='\0')
#		 i += 1;
# }

.globl strcpy
strcpy:
	addi $sp, $sp, -4			# move stack pointer downward by one word
	sw $s0, 0($sp)				# save data of $s0 in stack temporarily
	
	add $s0, $zero, $zero			# set register $s0 as 0 (index)
	
	Loop:					# Loop
		add $t0, $a0, $s0		# address of the destination
		add $t1, $a1, $s0		# address of the source
		lbu $t2, 0($t1)			# value of the source
		sb $t2, 0($t0)			# storing the value of source to destination
		
		beq $t2, $zero, Exit		# Exit if value is zero (iterate if nonzero)
		addi $s0, $s0, 1		# Increase the index $s0 by increment 1
		j Loop				# Iterate
	
	Exit:
		lw $s0, 0($sp)			# restore data for $s0 from stack
		addi $sp, $sp, 4		# restore stack pointer (move sp upward by one word)
		jr $ra				# return to caller
