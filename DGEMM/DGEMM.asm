# DGEMM: Double precision General Matrix Multiply
# void dgemm (int size, double **C, double **A, double **B){
#	 int i, j, k;
#	 for(i=0;i!=size;++i)
#	 for(j=0;j!=size;++j)
#	 for(k=0;k!=size;++k)
#		 C[i][j] += A[i][k] * B[k][j];
# }
.text
.globl dgemm
dgemm:
	addi $sp, $sp, -12	# Backup on stack
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)

	li $s0, 0		# $s0 = i = 0
L1:	li $s1, 0		# $s1 = j = 0
L2:	li $s2, 0		# $s2 = k = 0

	mul $t0, $s0, $a0	# $t0=i*n
	add $t0, $t0, $s1	# $t0=i*n+j : Byte Offset of [i][j]
	sll $t0, $t0, 3		# $t0=(i*n+j)*8 : Bit Offset (8byte for double precision)
	add $t0, $a1, $t0	# address of C[i][j]
	l.d $f0, 0($t0)		# load C[i][j] to $f0

L3:	mul $t1, $s0, $a0	# $t1=i*n
	add $t1, $t1, $s2	# $t1=i*n+k : Byte Offset of [i][k]
	sll $t1, $t1, 3		# $t1=(i*n+k)*8 : Bit Offset (8byte for double precision)
	add $t1, $a2, $t1	# address of A[i][k]
	l.d $f2, 0($t1)		# load A[i][k] to $f2

	mul $t2, $s2, $a0	# $t2=k*n
	add $t2, $t2, $s1	# $t2=k*n+j : Byte Offset of [k][j]
	sll $t2, $t2, 3		# $t2=(k*n+j)*8 : Bit Offset (8byte for double precision)
	add $t2, $a3, $t2	# address of B[k][j]
	l.d $f4, 0($t2)		# load B[k][j] to $f4
	
	mul.d $f6, $f2, $f4	# $f6 = A[i][k]*B[k][j]
	add.d $f0, $f0, $f6	# $f0 += A[i][k]*B[k][j]

	addiu $s2, $s2, 1
	bne $s2, $a0, L3	# Iterate
	s.d $f0, 0($t0)		# store to C[i][j]

	addiu $s1, $s1, 1
	bne $s1, $a0, L2	# Iterate

	addiu $s0, $s0, 1
	bne $s0, $a0, L1	# Iterate

	lw $s2, 8($sp)		# Restore from stack
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 12

	jr $ra			# Return to callee, the origin
