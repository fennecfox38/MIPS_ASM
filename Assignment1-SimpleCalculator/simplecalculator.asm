###################################
#  HW1: Simple string calculator  #
###################################
#
#  Data segment
#
		.data
input:		.asciiz  "Enter input (e.g. 1+2): "	# accept input expression
error:		.asciiz  "Input error!"
sol:    	.asciiz  "Answer = "	# label for "Answer = " 
plus: 		.asciiz  "+"		# label for "+"
minus:		.asciiz  "-"		# label for "-"
times:		.asciiz  "*"		# label for "*"########################################implementation for 1st condition
divide:		.asciiz  "/"		# label for "/"########################################implementation for 1st condition
exp:		.word 	 0:15   	# define buffer for input string
size: 		.word  	 15			# size of buffer

#
#  Text segment
#
		.text
main:	la 	$a0,input  		# print 
		li 	$v0,4			# "Enter input (e.g. 1+2):"
		syscall
		la 	$a0,exp			# load Buffer for input string         
		la  $a1,size		# load size to $a1  
		li  $v0,8 	    	# read string
		syscall
		
		jal load_input		# load operand1, 2, operator
		jal	operator		# decide operation
		jal	print			# print result
		
_end:	li 	$v0,10      	# system call for exit       
        syscall   			# EXIT!
		
#
#  Subroutine to load operands & operator, and to print the result 
#

#begin of implementation for 2nd condition#############################################################################
load_input:	li      $t4, 10					# reserve $t4=10 (constant for decimal evaluation)

			addi	$sp, $sp, -4
			sw		$ra, 0($sp)				# backup $ra on stack (address to go back to main)

			addu	$v0, $zero, $zero		# initialize $v0 (to be accumulated)
			jal		load_oprnd				# jump to load_oprnd to get operand 1
			addu	$s0, $v0, $zero			# save operand 1 from $v0 to $s0

			add		$t1, $t2, $zero			# load operator to $t1 ($t1 is reserved for saving operator)
			addi	$a0, $a0, 1				# move to next character in buffer.

			addu	$v0, $zero, $zero		# initialize $v0 (to be accumulated)
			jal		load_oprnd				# jump to load_oprnd to get operand 2
			addu	$s1, $v0, $zero			# save operand 2 from $v0 to $s1

			lw		$ra, 0($sp)
			addi	$sp, $sp, 4				# resotre $ra from stack

			jr		$ra						# return to main
			
loop_oprnd: mulo	$v0, $v0, $t4			# multiply by 10 (shift 1 digit left in decimal)
			addi	$t2, $t2, -48			# subtract 48 (ASCII Digit Offset)
			add 	$v0, $v0, $t2			# accumulate the digit verified.

			addi	$a0, $a0, 1				# move to next character in buffer.
load_oprnd: lb		$t2, 0($a0)				# load byte from buffer to $t2 ($t2 is reserved for input from buffer)

											#########Illegal character detection#########
			slti	$t3, $t2, 58			# All expected operator & operand is <58
			beq		$t3, $zero, exception	# Therefore go to exception if it is <58

											#########Classify operand and operator#########
			slti	$t3, $t2, 48			# operator<48 while operand>=48
			beq		$t3, $zero, loop_oprnd	# go back to loop if it is >=48
            
			jr		$ra						# jump to $ra
################################################################################end of implementation for 2nd condition
		 		         
operator:	lb 		$t5,plus		# load "+" to $t5
			lb		$t6,minus		# load "-" to $t6
			lb		$t7,times		# load "*" to $t7#####################################implemented for 1st condition
			lb		$t8,divide		# load "/" to $t8#####################################implemented for 1st condition
			beq 	$t1,$t5,add_op	# goto add operation  
			beq 	$t1,$t6,sub_op	# goto sub operation
			beq 	$t1,$t7,mul_op	# goto mult operation#################################implemented for 1st condition
			beq 	$t1,$t8,div_op	# goto div operation##################################implemented for 1st condition
exception:	la 		$a0,error    	# load input error message#################exception handling - print "Input error"
			li 		$v0,4			# "Input error"
			syscall
			b		_end

add_op:   	add 	$s2,$s0,$s1		# operand1 + operand2
        	jr 		$ra				# return from subroutine 
        	
sub_op:  	sub 	$s2,$s0,$s1		# operand1 - operand2
			jr 		$ra				# return from subroutine 

#begin of implementation for 1st condition#############################################################################
mul_op:   	mulo 	$s2,$s0, $s1	# operand1 * operand2
        	jr 		$ra				# return from subroutine
			
div_op:		teq		$s1, $zero		# if divisor is 0, then make ZeroDivision Exception
			div 	$s0, $s1		# operand1 / operand2
			mflo	$s2				# load result to $s2
			jr 		$ra				# return from subroutine
################################################################################end of implementation for 1st condition

print: 		la 		$a0,sol    		# load "Answer = " to $a0
			li 		$v0,4			# print "Answer = "
			syscall
			la 		$a0,0($s2)  	# load result to $a0
			li 		$v0,1       	# print result		
			syscall
			jr 		$ra				# return from subroutine 

#begin ofmplementation for exception handling##########################################################################
   .ktext 0x80000180
		mfc0 $k0, $13				# load the code for cause of exception from coprocessor $13
		li	$k1, 36	
		beq	$k0, $k1, code36		# Exception occurred from instruction 'multo'
		li	$k1, 48
		beq	$k0, $k1, code48		# Exception occurred from instruction 'add' or 'sub'
		li	$k1, 52
		beq	$k0, $k1, code52		# Exception made by checking zero divisor.

		la	$a0, Unknown			# load message for unknown code.
		li 	$v0, 10      			# system call for exit       
       	syscall   					# EXIT!

code36:	
code48:	la	$a0, Overflow			# load message for overflow exception
		li  $v0, 4					# system call to print string 
		syscall						# print message
		j	retback					# return back to where the exception occurred.

code52: la	$a0, ZeroDivision		# load message for overflow exception
		li  $v0, 4					# system call to print string 
		syscall						# print message and then may fall through label retback 
		
retback:mfc0 $k0,$14				# Coprocessor0 reg $14 has address where the exception occurred.
		addi $k0,$k0,4				# Add 4 to point to next instruction.
		mtc0 $k0,$14				# Store updated address back into $14.
		eret						# Error return; jump to the address stored in $14

   .kdata
Unknown:		.asciiz "Unknown Exception Occurred: "
Overflow:		.asciiz "Integer Overflow Exception Occurred: the result may not be correct.\n"
ZeroDivision:	.asciiz "Zero Division Exception Occurred: dividing by 0 is not defined.\n"
############################################################################end of implementaion for exception handling