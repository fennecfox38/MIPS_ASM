#############################################################
#   HW2: Heapsort to sort numbers in increasing order       #
#   File: main.asm                                          #
#   이름: 강준구                                             #
#############################################################
#
#  Data segment
#
    .data
    count:      .word 0         # number of elements in integer array
    array:      .word 0:40      # data buffer for integer array
    input:      .space 64       # buffer for input string
    message1:   .asciiz "Enter numbers to be sorted: "  # output message 1
    message2:   .asciiz "Sorted output: "               # output message 2

#
#  Text segment
#
    .text
    .globl main
main:
    jal     data_input          # call data_input to accept input data

    la      $a0, array          # load address of array
    lw      $a1, count          # load integer from count
    jal     heapSort            # heapSort(array,count);

    jal     data_output         # call data_output to print output data
    li      $v0, 10
    syscall                     # system call to terminate the program

#
#  Accept input data
#
data_input:
    la      $a0,message1            # print 
    li      $v0,4                   # "Enter numbers to be sorted: "
    syscall
    la      $a0,input               # load input buffer from keyboard
    li      $a1,64                  # max string length = 64  
    li      $v0,8                   # read string
    syscall

#  String to Integer Array
    la      $t0, input              # load address of input buffer to $t0
    la      $t1, array              # load address of integer array to $t1
    move    $t2, $t1                # load address of integer array to $t2 (will be seeking pointer)
    move    $t4, $zero              # set $t4 as 0 (for accumulation)
    move    $t5, $zero              # sign flag (0 for positive, 1 for negative)
    li      $t6, 10                 # reserve $t6 for 10 (the base of decimal number and also '\n', end of string)
    li      $t7, 0x20               # reserve $t7 for ' '
    li      $t8, 0x2D               # reserve $t8 for '-'
stoi:
    lb      $t3, 0($t0)             # load byte from input buffer to $t3
    slti    $t9, $t3, 48            # 
    bne     $t9, $zero, nondigit    # Determine if $t3 is digit or not
    slti    $t9, $t3, 58            # 48<=$t3<58 : digit (continue)
    beq     $t9, $zero, nondigit    # otherwise  : non-digit (jump to nondigit)

    mulo    $t4, $t4, $t6           # multiply by base 10 (shift 1 digit left)
    addi    $t3, $t3, -48           # get integer value from ASCII digit
    add     $t4, $t4, $t3           # apply to least significant digit 

    addi    $t0, $t0, 1             # $t0 points next character in input buffer
    j       stoi                    # iterate the loop: get the next character
        
nondigit:                           # IN CASE FOR NON-DIGIT (assume as delimiter)
    bne     $t3, $t8, negate        # Check if it is '-' (go to negate if not)
    li      $t5, 1                  # Set the negative flag as true (1)
    addi    $t0, $t0, 1             # $t0 indicates next element of the input buffer
    j       stoi                    # iterate the loop: get the next character
negate:                             
    beq     $t5, $zero, save        # if the negative sign flag is zero, skip negate.
    move    $t5, $zero              # initialize sign flag as zero, for next number
    nor     $t4, $t4, $zero         # invert $t4 (for 2's complement negation)
    addi    $t4, $t4, 1             # $t4 has been negated, in 2's complement format.
save:
    sw      $t4, 0($t2)             # Save accumulated number to integer array
    move    $t4, $zero              # initialize $t4 as 0 for next number
    addi    $t2, $t2, 4             # $t2 points next element of integer array
    addi    $t0, $t0, 1             # $t0 points next character in input buffer

    beq     $t3, $t7, formatcheck   # if it is ' ', check format validity then bypass
    beq     $t3, $t6, eos           # go to eos if it is end of string '\n'
    tne     $t3, $zero              # '\0' is also can be end of string. make a trap if not equal
eos:# end of string: '\n'
    sub     $t9, $t2, $t1           # get the byte size of integer array ($t2-$t1)
    srl     $t9, $t9, 2             # count = ($t2-$t1)/4; (word size of integer array)
    sw      $t9, count              # save to count (in data segment)
    jr      $ra                     # return back to main procedure where $ra points

formatcheck:                        # checking consecutive space character which is invalid
    lb      $t3, -2($t0)            # load previous character from buffer
    bne     $t3, $t7, stoi          # continue the loop if prev char is not ' ' (not consecutive)
    teq     $zero, $zero            # (trap if equal) make trap because it is consecutive

#
#   Print the sorted data
#
data_output:
    la      $a0, message2           # print 
    li      $v0, 4                  # "Sorted output: "
    syscall

    la      $t0, array              # $t0 points to 1st element of integer array
    lw      $t1, count              # $t1=count (word size of array)
    sll     $t1, $t1, 2             # $t1=count*4 (byte size of array)
    add     $t1, $t0, $t1           # $t1 points the boundary: one word after the end of array.

loop_output:
    lw      $a0, 0($t0)             # load integer value from $t0 (pointing current element of array)
    li      $v0, 1                  # print the loaded integer
    syscall

    li      $a0, 0x20               # print ' '
    li      $v0, 11                 # print character
    syscall

    addi    $t0, $t0, 4             # $t0 points next element of array
    bne     $t0, $t1, loop_output   # iterate unless pointer $t0 reach to the boundary $t1
    jr      $ra                     # return back to main procedure where $ra points

#
#   Exception Handler on text segment reserved for kernel
#
    .ktext 0x80000180
    mfc0    $k0, $13                # load the code for cause of exception from coprocessor $13
    li      $k1, 36	
    beq     $k0, $k1, code36        # Exception occurred from instruction 'multo'
    li      $k1, 52	
    beq     $k0, $k1, code52        # Exception occurred by trap from instruction 'tne'

    la      $a0, Unknown            # load message for unknown code.
print:
    li      $v0, 4                  # system call to print string 
    syscall                         # print message
    mfc0    $a0, $14                # print the address where the exception occured
    li      $v0, 34                 # syscall code to print integer in hexadecimal
    syscall

    li      $v0, 10                 # system call for exit       
    syscall                         # EXIT!

code36:
    la      $a0, Overflow           # load message for overflow exception
    j       print                   # jump to print

code52:
    la      $a0, Invalid            # load message for invalid character exception
    j       print                   # jump to print

   .kdata
Unknown:    .asciiz "Unknown exception occurred at "
Overflow:   .asciiz "Integer overflow exception occurred at "
Invalid:    .asciiz "Invalid input exception occurred at "