# #define SIZE 4
# #include <stdio.h>
# void dgemm (int size, double **C, double **A, double **B);
# void printM (int size, double **matrix){
#	 double **p1, **p2;
#	 putchar('{');
#	 for(p1=matrix+(size*size);matrix<p1;){
#		 printf("\n\t{ ");
#		 for(p2=matrix+size;matrix<p2;++matrix)
#			 printf("%lf, ",*((double*)matrix));
#		 printf("\b\b },");
#	 }
#	 printf("\b \n}\n");
# }
# int main(void){
#	 double A[SIZE][SIZE]= { { 1.0, 2.0, 3.0, 4.0 },
#				 { 5.0, 6.0, 7.0, 8.0 },
#				 { 9.0, 10.0, 11.0, 12.0},
#				 { 13.0, 14.0, 15.0, 16.0} };
#	 double B[SIZE][SIZE]= { { -1.0, -2.0, -3.0, -4.0 },
#				 { -5.0, -6.0, -7.0, -8.0 },
#				 { -9.0, -10.0, -11.0, -12.0},
#				 { -13.0, -14.0, -15.0, -16.0} };
#	 double C[SIZE][SIZE]= { { 0.0, 0.0, 0.0, 0.0 },
#				 { 0.0, 0.0, 0.0, 0.0 },
#				 { 0.0, 0.0, 0.0, 0.0 },
#				 { 0.0, 0.0, 0.0, 0.0 } };
#	 printM(SIZE,(double**)A);
#	 printM(SIZE,(double**)B);
#	 degmm(SIZE, (double**)C, (double**)A, (double**)B);
#	 printM(SIZE,(double**)C);
#	 return 0;
# }

.data
	size: .word 4
	A: .double 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0
	B: .double -1.0, -2.0, -3.0, -4.0, -5.0, -6.0, -7.0, -8.0, -9.0, -10.0, -11.0, -12.0, -13.0, -14.0, -15.0, -16.0
	C: .double 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
	str1: .asciiz "\n\t{ "
	str2: .asciiz ", "
	str3: .asciiz "\b\b },"
	str4: .asciiz "\b \n}\n"
.text
.globl main

main:
	la $t0, size
	lw $s0, 0($t0)
	la $s1, A
	la $s2, B
	la $s3, C
	
	add $a0, $s0, $zero
	add $a1, $s1, $zero
	jal printM

	add $a0, $s0, $zero
	add $a1, $s2, $zero
	jal printM

	add $a0, $s0, $zero
	add $a1, $s3, $zero
	add $a2, $s1, $zero
	add $a3, $s2, $zero
	jal dgemm
	
	add $a0, $s0, $zero
	add $a1, $s3, $zero
	jal printM

	li $v0, 10
	syscall 
	
printM:
	addi $sp, $sp, -16	# Backup on stack
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)

	add $s0, $a0, $zero	# $s0=size
	add $s1, $a1, $zero	# $s1=matrix (will point target element)

	li $v0, 11
	li $a0, '{'
	syscall			# print '{'

	mul $s2, $s0, $s0 	# $s2 = size*size
	sll $s2, $s2, 3		# $s2 = (size*size)*8 (size of matrix)
	add $s2, $s1, $s2	# $s2 = p1 = matrix + size*size (address of end of matrix)
L1:	li $v0, 4
	la $a0, str1
	syscall			# print "\n\t{ "

	sll $s3, $s0, 3		# $s3 = size*8
	add $s3, $s1, $s3	# $s3 = p2 = matrix + size*8 (address of end of row)

L2:	l.d $f12, 0($s1)	# load C[i][j] (*((double**)matrix)) to $f12
	li $v0, 3
	syscall			# print C[i][j]

	li $v0, 4
	la $a0, str2
	syscall			# print ", "

	addiu $s1, $s1, 8	# Pointing next element (8byte for double precision)
	bne $s1, $s3, L2	# Iterate unless pointer points end of row

	li $v0, 4
	la $a0, str3
	syscall			# print "\b\b },"

	bne $s1, $s2, L1	# Iterate unless pointer points end of matrix 

	li $v0, 4
	la $a0, str4
	syscall			# print "\b \n}\n"
	
	lw $s3, 12($sp)		# Restore from stack
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 20
	jr $ra			# Return to callee, the origin