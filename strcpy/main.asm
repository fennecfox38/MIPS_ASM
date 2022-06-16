# include<stdio.h>
# int main(void){
#	 char str1[16]="Hello World!";
#	 char str2[16]="";
#	 strcpy(str2,str1);
#	 puts(str2);
#	 return 0;
# }

.data
	str1:	.asciiz "Hello, World!"
	str2:	.asciiz "Before Copy\n"

.text
.globl main
main:
	la $a0, str2				# Load address of str2 : destination
	la $a1, str1				# Load address of str1 : source

	addi $v0, $zero, 4			# System Call Code for print_string
	syscall					# Print 'query' ($a0 is already set.)

	jal strcpy				# Call procedure strcpy

	addi $v0, $zero, 4			# System Call Code for print_string
	syscall					# Print 'query' ($a0 is already set.)
	
	addi $v0, $zero, 10			# Syscall Code for termination of execution
	syscall					# Terminate execution
