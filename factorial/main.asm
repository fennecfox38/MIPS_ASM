# #include<stdio.h>
# int main(void){
#	 int n, result;
#	 print("Enter a number:");
#	 scanf("%d",&n);
#	 result=factorial(n);
#	 printf("%d! = %d\n",result);
#	 return 0;
# }

.data
	query:	.asciiz "Enter a number: "
	show:	.asciiz "! = "

.text

.globl main
main:
	addi $v0, $zero, 4	# System Call Code for print_string
	la $a0, query		# Load address of 'query'
	syscall			# Print 'query'

	addi $v0, $zero, 5	# System Call Code for read_int
	syscall			# Read integer
	add $s0, $v0, $zero	# Assign input on $s0

	add $a0, $s0, $zero	# Set reg $a0 (parameter) from the value read
	jal factorial		# Call procedure factorial (will return factorial)
	add $s1, $v0,$zero	# Assgin result to $s1

	addi $v0, $zero, 1	# System Call Code for print_int
	add $a0, $s0, $zero	# Set reg $a0 as value of $s0 to print
	syscall			# Print integer

	addi $v0, $zero, 4	# System Call Code for print_string
	la $a0, show		# Load address of 'show'
	syscall			# Print 'show'

	addi $v0, $zero, 1	# System Call Code for print_int
	add $a0, $s1, $zero	# Set reg $a0 as value of $s1 to print
	syscall			# Print integer
	
	addi $v0, $zero, 10	# Syscall Code for termination of execution
	syscall			# Terminate execution