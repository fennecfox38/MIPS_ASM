.data
	str1: .asciiz "1023859674"	# Sample String 1: StringToInteger will return 1023859674.
	str2: .asciiz "105a74"		# Sample String 2: StringToInteger will return -1

.text
.globl main
main:
	la $s0, str1			# address of "1023859674"
	add $a0, $s0, $zero
	li $v0, 4			# Syscall Code for print_string
	syscall

	li $a0, 58			# ASCII Code for ':'
	li $v0, 11			# Syscall Code for print_character
	syscall

	add $a0, $s0, $zero		# 1st Parameter : address of string
	jal StringToInteger		# Call the procedure StringToInteger

	add $a0, $v0, $zero		# Ready to print result from 'StringToInteger'
	li $v0, 1			# Syscall Code for print_int
	syscall
	
	li $a0, 10			# ASCII Code for '\n'
	li $v0, 11			# Syscall Code for print_character
	syscall
	
	la $s0, str2			# address of "105a74"
	add $a0, $s0, $zero
	li $v0, 4
	syscall

	li $a0, 58
	li $v0, 11
	syscall

	add $a0, $s0, $zero
	jal StringToInteger

	add $a0, $v0, $zero
	li $v0, 1
	syscall

	li $v0, 10			# Syscall Code for termination of execution
	syscall
