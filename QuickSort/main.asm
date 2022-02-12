# #include<stdio.h>
# void printList(int v[], int n){
#	 int i;
#	 printf("[ ");
#	 for(i=0;i<n;++i)
#		 printf("%d ",v[i]);
#	 puts("]");
# }
# int main(void){
#	 int siz = 16;
#	 int list[] = {55, 244, 7, 78, 201, 12, 107, 42, 255, 54, 102, 63, 1, 5, 34, 21};
#	 printList(list,siz);
#	 quickSort(list, list+siz-1);
#	 printList(list,siz);
#	 return 0;
# }

.data
	siz: .word 16
	list: .word 55, 244, 7, 78, 201, 12, 107, 42, 255, 54, 102, 63, 1, 5, 34, 21

.text
.globl main
main:
	la $t0, siz				# $t0 = &siz
	lw $s0, 0($t0)				# $s0 = *($t0) (size of list)
	la $s1, list				# $s1 = list (address of list)

	add $a0, $s1, $zero			# 1st parameter: $s1, address of list
	add $a1, $s0, $zero			# 2nd parameter: $s0, size of list
	jal Print				# Print list before sorting

	add $a0, $s1, $zero			# 1st parameter: $s1, address of list
	sll $t0, $s0, 2				# $t0 = $s0 * 4: size of list in byte
	add $t0, $s1, $t0			# $s1 + $t0 :	 address of end of list
	addi $a1, $t0, -4			# 2nd parameter: address of last element
	jal Sort				# Call procedure sort (global)

	add $a0, $s1, $zero			# 1st parameter: $s1, address of list
	add $a1, $s0, $zero			# 2nd parameter: $s0, size of list
	jal Print				# Print list before sorting

	addi $v0, $zero, 10			# Syscall Code for Termination of execution
	syscall					# Terminate execution

Print:
	add $t0, $a0, $zero			# $t0 = $a0		: indexing pointer
	sll $t1, $a1, 2				# $t1 = $a1 * 4		: array size in byte
	add $t1, $t0, $t1			# $t1 = $t0 + $t1	: pointing end of array

	addi $v0, $zero, 11			# System Call Code for print character
	addi $a0, $zero, 0x5B			# '['
	syscall					# Print
	addi $a0, $zero, 0x20			# ' '(space)
	syscall					# Print

Loop:
	slt $t2, $t0, $t1			# $t2 = ($t0 < $t1)
	beq $t2, $zero, Escape			# if($t0>=$t1) goto Escape

	addi $v0, $zero, 1			# Syscall Code for print integer
	lw $a0, 0($t0)				# $a0 = *($t0)
	syscall					# Print *($t0)
	addi $v0, $zero, 11			# Syscall Code for print character
	addi $a0, $zero, 0x20			# ' '(space)
	syscall					# Print
	
	addi $t0, $t0, 4			# $t0 += 4
	j Loop					# goto Loop (Iterate)

Escape:
	addi $v0, $zero, 11			# Syscall Code for print character
	addi $a0, $zero, 0x5D			# ']'
	syscall					# Print
	addi $a0, $zero, 0x0A			# '\n'
	syscall					# Print
	jr $ra					# return to caller, the origin
