# void swap(int v[], int a, int b){
#	 int temp;
#	 temp=v[a];
#	 v[a]=v[b];
#	 v[b]=temp;
# }
# void sort(int v[], int n){
#	 int i,j;
#	 for(i=0;i<n;++i)
#		 for(j=i-1;j>=0&&v[j]>v[j+1];--j)
#			 swap(v,j, j+1);
# }
.globl sort
sort:
	addi $sp, $sp, -20			# Backup the value of register on stack
	sw $ra, 16($sp)
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	add $s0, $a0, $zero			# Assign address of list to $s0
	add $s1, $a1, $zero			# Assign length of list to $s1

	add $s2, $zero, $zero			# Set 1st index variable $s2 as 0
	Loop1:
		slt $t0, $s2, $s1		# $t0 is 1 only if index $s2 is less than length of list
		beq $t0, $zero, Exit1		# if index $s2 is not in valid range, goto Exit1

		addi $s3, $s2, -1		# Set 2nd index variable $s3 as ($s2 -1)
		Loop2:
			slt $t0, $s3, $zero	# $t0 is 1 only if index $s3 is less than 0
			bne $t0, $zero, Exit2	# if index $s3 is less than 0, goto Exit2
			sll $t0, $s3, 2		# $t0 = $s3 * 4; (relative byte offset)
			add $t0, $s0, $t0	# get absolute address of 1st target element
			lw $t1, 0($t0)		# get the value of 1st target element
			lw $t2, 4($t0)		# get the value of 2nd target element
			slt $t0, $t2, $t1	# compare 1st with 2nd
			beq $t0, $zero, Exit2	# if prior one is less than latter one, goto Exit2

			add $a0, $s0, $zero	# 1st parameter to swap: address of the list
			add $a1, $s3, $zero	# 2nd parameter to swap: the index of 1st target element
			addi $a2, $s3, 1	# 3rd parameter to swap: the index of 2nd target element
			jal swap		# Call the procedure swap

			addi $s3, $s3, -1	# Decrease the 2nd index by 1
			j Loop2			# Iterate 2nd Loop
		Exit2:				# Escape 2nd Loop

		addi $s2, $s2, 1		# Increase the 1st index by 1
		j Loop1				# Iterate 1st Loop
	Exit1:					# Escape 1st Loop

	lw $s0, 0($sp)				# restore the value of register from stack
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $ra, 16($sp)
	addi $sp, $sp, 20
	jr $ra					# jump and return to caller, the origin

swap:
	sll $t0, $a1, 2				# $t0 = $a1 * 4; (relative byte offset)
	sll $t1, $a2, 2				# $t1 = $a2 * 4; (relative byte offset)
	add $t0, $a0, $t0			# get absolute address of 1st element
	add $t1, $a0, $t1			# get absolute address of 2nd element
	lw $t2, 0($t0)				# get the value of 1st element
	lw $t3, 0($t1)				# get the value of 2nd element
	sw $t2, 0($t1)				# save the value on 1st element (swapped)
	sw $t3, 0($t0)				# save the value on 2nd element (swapped)
	jr $ra					# jump and return to caller, the origin
