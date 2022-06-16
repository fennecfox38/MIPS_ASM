# include<stdio.h>
# void printList(int v[], int n){
#	 int i;
#	 printf("[ ");
#	 for(i=0;i<n;++i)
#		 printf("%h ",v[i]);
#	 puts("]");
# }
# int main(void){
#	 int len = 0x08;
#	 int list[] = {0x37, 0xF4x, 0x07, 0x4E, 0xC9, 0x0C, 0x6B, 0x2A};
#	 printList(list,n);
#	 sort(list,len);
#	 printList(list,n);
# }

.data
	len: .word 8
	list: .word 55, 244, 7, 78, 201, 12, 107, 42

.text
.globl main
main:
	la $t0, len				# load data address of len
	lw $s0, 0($t0)				# load data from len in data segment
	la $s1, list				# load data address of list

	add $a0, $s1, $zero			# 1st parameter of sort procedure: address of list
	add $a1, $s0, $zero			# 2nd parameter of sort proceduer: length of list
	jal printList				# Print List before sorting

	add $a0, $s1, $zero			# 1st parameter of sort procedure: address of list
	add $a1, $s0, $zero			# 2nd parameter of sort proceduer: length of list
	jal sort				# Call the procedure sort
	
	add $a0, $s1, $zero			# 1st parameter of sort procedure: address of list
	add $a1, $s0, $zero			# 2nd parameter of sort proceduer: length of list
	jal printList				# Print List after sorting

	
	addi $v0, $zero, 10			# Syscall Code for termination of execution
	syscall					# Terminate execution

printList:
	addi $sp, $sp, -12			# Backup the value of register on stack
	sw $ra, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)

	add $s0, $a0, $zero			# Assign address of list to $s0
	add $s1, $a1, $zero			# Assign length of list to $s1

	addi $v0, $zero, 11			# System Call Code for print character
	addi $a0, $zero, 0x5B			# character '['
	syscall					# Print character
	addi $a0, $zero, 0x20			# character ' '(space)
	syscall					# Print character

	add $t0, $zero, $zero			# Set index variable $t0 as 0
	Loop:
		slt $t1, $t0, $s1		# $t1 is 1 only if index $t0 is less than length of list
		beq $t1, $zero, Halt		# if index $t0 is not in valid range, goto Halt

		sll $t1, $t0, 2			# $t1 = $t0 * 4; (relative byte offset)
		add $t1, $s0, $t1		# get absolute address of target element
		lw $a0, 0($t1)			# get value of target element
		addi $v0, $zero, 1		# Syscall Code for print integer in decimal
		syscall				# Print target element

		addi $a0, $zero, 0x0020		# String " " (space)
		addi $v0, $zero, 11		# Syscall Code for print characters
		syscall				# Print " " (space)

		addi $t0, $t0, 1		# increase index $t0 by 1
		j Loop				# Iterate
	Halt:
	
	addi $v0, $zero, 11			# System Call Code for print character
	addi $a0, $zero, 0x5D			# chracter ']'
	syscall					# Print character
	addi $a0, $zero, 0x0A			# chracter '\n'
	syscall					# Print character

	lw $s0, 0($sp)				# restore the value of register from stack
	lw $s1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	jr $ra					# jump and return to caller, the origin
