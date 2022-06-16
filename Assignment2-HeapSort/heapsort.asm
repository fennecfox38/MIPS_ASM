#############################################################
#   HW2: Heapsort to sort numbers in increasing order       #
#   File: heapsort.asm                                      #
#   이름: 강준구                                             #
#############################################################
#
#  Text segment
#
    .text
    .globl heapSort
#
# Build heap (프로그램 필요)
#
heapSort:                       # for loop_0 to build heap
    addi    $sp, $sp, -16           # BACKUP ON STACK
    sw      $ra, 12($sp)            # return address
    sw      $s2, 8($sp)             # callee saved register
    sw      $s1, 4($sp)             #
    sw      $s0, 0($sp)             #

    move    $s0, $a0                # int arr[];
    move    $s1, $a1                # int n;
    li      $t0, 1
    beq     $s1, $t0, return        # if(n==1) return;
    ########for(int i=n/2-1;i>=0;--i)########
    srl     $s2, $s1, 1             # int i=n/2; (it will be n/2-1 when loop starts)
loop1:
    addi    $s2, $s2, -1            # --i;
    
    move    $a0, $s0                # $a0=arr;
    move    $a1, $s1                # $a1=n;
    move    $a2, $s2                # $a2=i;
    jal     heapify                 # heapify(arr,n,i);

    bne     $s2, $zero, loop1       # iterate unless i==0
#
# One by one extraction from heap  (프로그램 필요)
#   ########for(int i=n-1;i>0;--i)########
    addi    $s2, $s1, -1            # i=n-1;
loop2:
    move    $a0, $s0                # $a0=$s0;          // $a0=arr;
    sll     $a1, $s2, 2             #
    add     $a1, $s0, $a1           # $a1=$s0+4*$s2;    // $a1=arr+i;
    jal     swap                    # swap(arr,arr+i);

    move    $a0, $s0                # $a0=arr;
    move    $a1, $s2                # $a1=i;
    move    $a2, $zero              # $a2=0;
    jal     heapify                 # heapify(arr,i,0);

    addi    $s2, $s2, -1            # --i;
    bne     $s2, $zero, loop2       # iterate unless i==0
return:
    lw      $s0, 0($sp)             # RESTORE FROM STACK
    lw      $s1, 4($sp)             # callee saved register
    lw      $s2, 8($sp)             #
    lw      $ra, 12($sp)            # return address
    addi    $sp, $sp, 16            # restore the stack pointer
    jr      $ra                     # return to caller

#
# Implement heapify  (프로그램 필요)
#
heapify:
    addi    $sp, $sp, -20           # BACKUP ON STACK
    sw      $ra, 16($sp)            # return address
    sw      $s3, 12($sp)            # callee saved registers
    sw      $s2, 8($sp)             #
    sw      $s1, 4($sp)             #
    sw      $s0, 0($sp)             #

    move    $s0, $a0                # int arr[];
    move    $s1, $a1                # int n;
    move    $s2, $a2                # int i;

    move    $s3, $s2                # $s3=$s2;          // int largest = i;
    sll     $t0, $s3, 1
    addi    $t0, $t0, 1             # $t0=2*($s2)+1;    // int l = 2*i+1;
    addi    $t1, $t0, 1             # $t1=2*($a2)+2;    // int r = 2*i+2;

    ########if(l<n && arr[l]>arr[largest])#########
    slt		$t2, $t0, $s1		    # $t2=($t0<$s1);    // $t2 = (l<n);
    beq     $t2, $zero, skip1       # goto skip1 if left child is out of range
    sll     $t2, $s3, 2
    add     $t2, $s0, $t2           # $t2=$s0+4*$s3;    // $t2 = arr+largest;
    lw      $t3, 0($t2)             # $t3=arr[largest];
    sll     $t2, $t0, 2
    add     $t2, $s0, $t2           # $t2=$s0+4*$t0;    // $t2 = arr+l;
    lw      $t4, 0($t2)             # $t4=arr[l];
    slt     $t2, $t3, $t4           # $t2=($t3<$t4);    // $t2 = (arr[largest]<arr[l]);
    beq     $t2, $zero, skip1       # goto skip1 if left child is not larger than largest

    move    $s3, $t0                # $s3=$t0;          // largest=l;
skip1:######if(r<n && arr[r]>arr[largest])#########
    slt		$t2, $t1, $s1		    # $t2=($t1<$s1);    // $t2 = (r<n);
    beq     $t2, $zero, skip2       # goto skip2 if right child is out of range
    sll     $t2, $s3, 2
    add     $t2, $s0, $t2           # $t2=$s0+4*$s3;    // $t2 = arr+largest;
    lw      $t3, 0($t2)             # $t3=arr[largest];
    sll     $t2, $t1, 2
    add     $t2, $s0, $t2           # $t2=$s0+4*$t1;    // $t2 = arr+r;
    lw      $t4, 0($t2)             # $t4=arr[r];
    slt     $t2, $t3, $t4           # $t2=($t3<$t4);    // $t2 = (arr[largest]<arr[r]);
    beq     $t2, $zero, skip2       # goto skip2 if right child is not larger than largest

    move    $s3, $t1                # $s3=$t1;          // largest=r;
skip2:######if(largest!=i)#########
    beq     $s3, $s2, skip3         # goto skip3 if largest is not changed

    sll     $a0, $s2, 2
    add     $a0, $s0, $a0           # $a0=$s0+4*$s2     // $a0=arr+i;
    sll     $a1, $s3, 2
    add     $a1, $s0, $a1           # $a1=$s0+4*$s3;    // $a1=arr+largest;
    jal     swap                    # swap(arr+i,arr+largest);

    move    $a0, $s0                # $a0=$s0;          // $a0=arr;
    move    $a1, $s1                # $a1=$ss;          // $a1=n;
    move    $a2, $s3                # $a2=$s3;          // $a2=largest;
    jal     heapify                 # heapify(arr,n,largest);

skip3:
    lw      $s0, 0($sp)             # RESTORE FROM STACK: 
    lw      $s1, 4($sp)             # callee saved registers
    lw      $s2, 8($sp)             #
    lw      $s3, 12($sp)            #
    lw      $ra, 16($sp)            # return address
    addi    $sp, $sp, 20            # restore stack pointer
    jr      $ra                     # return to caller

#
#  swap function  (프로그램 필요)
#
swap:
    lw      $t8, 0($a0)             # $t8 = *x;
    lw      $t9, 0($a1)             # $t9 = *y;
    sw      $t9, 0($a0)             # *x = $t9;
    sw      $t8, 0($a1)             # *y = $t8;
    jr      $ra                     # return to caller