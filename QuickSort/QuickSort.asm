# void quickSort(int* left, int* right){
#     int *i=left, *j=right, temp;
#     int pivot=*(left+(right-left)/2);
#     while(i<=j){
#         while(*i<pivot) ++i;
#         while(*j>pivot) --j;
#         if(i<=j){
#             temp=*i;
#             *i=*j;
#             *j=temp;
#             ++i; --j;
#         }
#     }
#     if(left<j) quickSort(left,j);
#     if(i<right) quickSort(i,right);
# }

.globl Sort
Sort:
	addi $sp, $sp, -20		# Backup the value of register on stack
	sw $ra, 16($sp)
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)

	add $s0, $a0, $zero		# $s0 = *left
	add $s1, $a1, $zero		# $s1 = *right
	add $s2, $s0, $zero		# $s2 = *i = *left
	add $s3, $s1, $zero		# $s3 = *j = *right
	sub $t1, $s1, $s0		# $t1 = right-left
	srl $t1, $t1, 3			# $t1 = (right-left)/8
	sll $t1, $t1, 2			# $t1 = ((right-left)/8)*4 (align by 4bit)
	add $t1, $s0, $t1		# $t1 = &pivot = left + ((right-left)/8)*4
	lw $t0, 0($t1)			# $t0 = pivot = list[mid]

Loop1:					# Outer Loop
	slt $t1, $s3, $s2		# while (i<j)
	bne $t1, $zero, Exit1		# while ($s2<$s3)

Loop2:					# inner loop for i : find the lowest index of element larget than pivot $t0
	lw $t1, 0($s2)			# $t1 = *($s2) = *i
	slt $t2, $t1, $t0		# while( $t1 < $t0 )
	beq $t2, $zero, Loop3		# while( *i < pivot)
	addi $s2, $s2, 4		# 	++i;	point next element
	j Loop2				# iterate

Loop3:					# inner loop for j : find the largetst index of element smaller than pivot $t0
	lw $t1, 0($s3)			# $t1 = *($3) = *i
	slt $t2, $t0, $t1		# while( $t0 < $t1 )
	beq $t2, $zero, Exit3		# while(pivot < *j )
	addi $s3, $s3, -4		# 	--j;	point previous element
	j Loop3				# iterate

Exit3:					# continue in outer loop
	slt $t1, $s3, $s2		# if($s2<=$s2) (skip if $s2>$s3) 
	bne $t1, $zero, Exit1		# if(i<=j) (skip if i>j)
	lw $t1, 0($s2)			# 
	lw $t2, 0($s3)			# 
	sw $t1, 0($s3)			# swap the value between i and j
	sw $t2, 0($s2)			#
	addi $s2, $s2, 4		# ++i;	pointing next element
	addi $s3, $s3, -4		# --j;	pointing prev element
	j Loop1

Exit1:
	slt $t1, $s0, $s3		# if($s0<$s3) (skip if $s0>=$s3)
	beq $t1, $zero, Skip1		# if(left<j) (skip if left>=j)
	add $a0, $s0, $zero		# 1st parameter : $s0, left
	add $a1, $s3, $zero		# 2nd parameter : $s3, j
	jal Sort			# Call procedure Sort(left, j)
Skip1:	slt $t1, $s2, $s1		# if($s2<$s1) (skip if $s2>=$s1)
	beq $t1, $zero, Skip2		# if(i<right) (skip if right>=i)
	add $a0, $s2, $zero		# 1st parameter : $s2, i
	add $a1, $s1, $zero		# 2nd parameter : $s1, right
	jal Sort			# Call procedure Sort(i, right)

Skip2:	lw $s0, 0($sp)			# Restore the value of register on stack
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $ra, 16($sp)
	addi $sp, $sp, 20
	jr $ra				# return to caller, the origin