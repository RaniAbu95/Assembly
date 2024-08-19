.data	0x10010000
	.word -85, 36, -94, 45, 29, 85, -12, 89, -20, 4					# prapare A[] in memory
.data	0x10010040
	.word 4, -819, 134, 27, -9							# prapare B[] in memory
.data	0x10010060
	.word 1, 21, 49, 68, 95, 134, 225, 492, 697, 767, 812, 957, 1050, 13		# prapare C[] in memory
	
.text
#void main(void)
	# int[10] A = {-85, 36, -94, 45, 29, 85, -12, 89, -20, 4};
	# int[5] B = {4, -819, 134, 27, -9};= {0x00000004,0xfffffccd,0x00000086,0x0000001b,0xfffffff7}
	# int[14] C = {1, 21, 49, 68, 95, 134, 225, 492, 697, 767, 812, 957, 1050, 13};
	lui	$s0, 0x1001		# $s0 points on A[0]
	ori	$s1, $s0, 0x0040	# $s1 points on B[0]
	ori	$s2, $s0, 0x0060	# $s2 points on C[0]
	
	#int length_A = sizeof(A)/sizeof(A[0]);
	addi	$s3, $zero, 10 	#$s3 = length_A
	#int length_B = sizeof(B)/sizeof(B[0]);
	addi 	$s4, $zero, 5	#$s4 = length_B
	#int length_C = sizeof(C)/sizeof(C[0]);
	addi 	$s5, $zero, 14	#$s5 = length_C

	#Sort array A
	move	$a0, $s0		# $a0 = array_A_start_address
	move	$a1, $s3		# $a1 = number_of_elements_in_A
	addi 	$sp, $sp, -4  		# push $ra
	sw 	$ra, 0($sp)     	 
	jal	FUNC3
	
	#Sort array B
	move	$a0, $s1		# $a0 = array_B_start_address
	move	$a1, $s4		# $a1 = number_of_elements_in_B
	addi 	$sp, $sp, -4  		# push $ra
	sw 	$ra, 0($sp)     	
	jal	FUNC3
	
	#Sort array C
	move	$a0, $s2		# $a0 = array_B_start_address
	move	$a1, $s5		# $a1 = number_of_elements_in_B
	addi 	$sp, $sp, -4  		# push $ra
	sw 	$ra, 0($sp)     	
	jal	FUNC3
	
	# Exit the program
    	li $v0, 10  # Load the syscall code for exit into $v0
    	syscall     # Make the syscall to terminate the program
	
FUNC3: 
# unsigned void BUBBLE_SORT(unsigned int array_start_address, unsigned int number_of_elements)
#{
# for (i=0; i<number_of_elements; i++)
	#addi 	$t3,$a0,0
	#addi	$t4,$a1,0
	
	addi	$t0, $zero, 0		# $t0 = i
	addi 	$sp, $sp, -4  		# push $ra
	sw 	$ra, 0($sp)     	
	lw	$s7, 0($sp)
	jal	FUNC2
	#addi	$t1,$v0,0		# $t1 = SWAP_ALL(array_start_address, number_of_elements)
	# while(SWAP_ALL(array_start_address, number_of_elements)==1)
WHILE:	bne	$v0,1,END_WHILE		
	#{
		# $t1 = SWAP_ALL(array_start_address, number_of_elements)
	jal	FUNC2
	addi	$t1,$v0, 0
	j	WHILE
	#}
	
FUNC2: 
# unsigned int SWAP_ALL(unsigned int array_start_address, unsigned int number_of_elements)	
# {
# for (i=0; i<number_of_elements-1; i++)
#{
	addi 	$sp, $sp, -4  		# push $ra
	sw 	$ra, 0($sp)     	
	addi	$t1,$a1,-1		# $t1 =  number_of_elements - 1
	sub	$t1,$t1,$t0		# $t1 =  number_of_elements -1 - i
	addi	$v0, $zero, -1		# $v0 = -1 (return value if no swap happens)
LOOP:	slt	$t2, $zero,$t1		# if $t1 > 0 then $t2=1 else $t2=0
	beq	$t2, $zero, END_LOOP	# if $t2=0 end the loop
	# {
	#if (A[i]>A[i+1])
	sll	$t1, $t0, 2		# $t1 = 4*i
	add	$t1, $t1, $a0		# $t1 = address of array[i]
	lw	$t2,0($t1)		# $t2 = array[i]
	lw	$t3,4($t1)		# $t3 = array[i+1]
	slt 	$t4, $t3,$t2     	# Set $t4 to 1 if $t2 < $t3, otherwise set $t4 to 0
	beq	$t4, $zero, CONTINUE	# if $t2=0 execute ELSE statement
	#{
		#SWAP(A[i],A[i+1])
	addi	$v0, $zero, 1		# $v0 = 1 (return value 1 if at least one swap happened)
	addi	$sp, $sp, -4	
	sw	$t0, 0($sp)		# PUSH i
	addi	$sp, $sp, -4
	sw	$a0, 0($sp)		# PUSH $a0
	addi	$a0, $t1,0		# $a0 = address of array[i]
	jal 	FUNC1    		# Jump and link to FUNC1
	lw	$a0, 0($sp)		#POP $a0
	addi	$sp, $sp, 4		
	lw	$t0, 0($sp)		#POP i
	addi	$sp, $sp, 4	
	addi	$t1,$a1,-1		# $t1 =  number_of_elements - 1
	sub	$t1,$t1,$t0		# $t1 =  number_of_elements -1 - i
	j	LOOP
	#}
	#else
CONTINUE:
	#{
		#continue;
	addi	$t0, $t0, 1		# i++
	addi	$t1,$a1,-1		# $t1 =  number_of_elements - 1
	sub	$t1,$t1,$t0		# $t1 =  number_of_elements -1 - i
	j 	LOOP
	#}
#}
# This MIPS assembly code performs the following operations:
# 1. Initializes and sorts three integer arrays, `A`, `B`, and `C`, using the Bubble Sort algorithm.
#
# Specifically:
# - `A` is an array of 10 integers, initialized at address 0x1001 0000.
# - `B` is an array of 5 integers, initialized at address 0x1001 0040.
# - `C` is an array of 14 integers, initialized at address 0x1001 0060.
#
# The code executes the following steps:
# 1. Calls the `FUNC3` subroutine to sort array `A`.
# 2. Calls the `FUNC3` subroutine to sort array `B`.
# 3. Calls the `FUNC3` subroutine to sort array `C`.
# 4. Exits the program using a syscall.
#
# The `FUNC3` subroutine performs Bubble Sort on the given array:
# - It repeatedly calls `FUNC2` to perform swaps until no more swaps are needed.
#
# The `FUNC2` subroutine performs the actual swapping of elements in the array:
# - It compares adjacent elements and swaps them if they are in the wrong order.
#
# The `FUNC1` subroutine performs a swap between two adjacent elements in the array.
# - It uses arithmetic operations to swap the values without using a temporary variable.
#
# The program uses syscalls for exiting and relies on the stack to manage return addresses.

FUNC1:
# unsigned void SWAP_ONE(unsigned int array_start_address)
	
#{
        #int start = 0;             // Start of the array
	addi 	$s6, $a0,0	# $s6 point to the address of array[0]
	#int end = array.length - 1;  // End of the array
	addi 	$s7, $a0, 4	# $s7 point to the address of array[1]
	 
        #int temp = array[start]; 
	lw 	$t0, 0($s6)		# $t0 = array[0]
	lw 	$t1, 0($s7)		# $t1 = array[1]
	add 	$t0, $t0, $t1		# $t0 = array[0] + array[1]
	sub 	$t1, $t0, $t1		# $t1 = array[0] + array[1] - array[1] = array[0]
	sub 	$t0, $t0, $t1		# $t0 = array[0] + array[1] - array[0] = array[1]
	#array[start] = array[s1];
	sw 	$t0, 0($s6)		# $s6 = array[1] 
	#array[end] = temp;
	sw 	$t1, 0($s7)		# $s6 = array[0] 	
	jr 	$ra
#}
	
END_LOOP:
	xor	$t0,$t0,$t0	#i=0
	lw 	$ra, 0($sp)     # POP $ra
	addi 	$sp, $sp, 4   	
	jr	$ra
	
END_WHILE:
	lw 	$ra, 0($sp)     # pop $ra
	addi 	$sp, $sp, 4   	
	jr	$ra

	
	
	
