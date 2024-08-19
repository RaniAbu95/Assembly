# copies elements from the a_source array to the a_dest array, skipping the elements that match the value in $s2, and then exits the program.

.data	0x10010000
	.word 3,0,2,5,24,432,74,73,78,12 # prapare a_source[] in memory
.data	0x10010030
	.space 40			# prapare place for a_dest[] in memory (40 bytes = 10 words)

.text
# This MIPS assembly code performs the following operations:
# 1. Copies elements from the `a_source` array to the `a_dest` array, while skipping any elements that match the value in `$s2`.
# 2. Initializes the base addresses for `a_source` and `a_dest`, and sets up an index for iterating through the arrays.
# 3. Loops through each element in `a_source`:
#    - If the current element matches the value in `$s2`, it is skipped.
#    - Otherwise, the element is copied to `a_dest` at the current position.
# 4. After processing all elements, the program exits.
#
# Specifically:
# - `a_source` array is initialized at address 0x1001 0000 with 10 integers.
# - `a_dest` array is allocated space at address 0x1001 0030 to store up to 10 integers.
# - The loop iterates through each element of `a_source`, comparing it with the value in `$s2`.
# - If the element does not match `$s2`, it is copied to `a_dest`.
# - The program exits using a syscall after the loop completes.


#void main(void)
# {
	# int[10] a_source = {3,0,2,5,24,432,74,73,78,12};
	# int[10] a_dest;
	lui	$s0, 0x1001		# $s0 points on a_source[0]
	ori	$s1, $s0, 0x0030	# $s1 points on a_dest[0]

	# int j=0
	addi	$t2, $zero, 0		# # int j=0 // $t2=j
	# for (i=0; i<10; i++)
	addi	$t0, $zero, 0		# $t0 = i
LOOP:	slti	$t1, $t0, 10		# if i<10 then $t1=1 else $t1=0
	beq	$t1, $zero, END_LOOP	# if $t1=0 end the loop
	 # {

	sll	$t1, $t0, 2		# $t1 = 4*i
	add	$t1, $t1, $s0		# $t1 = address of a_source[i]
	#if(a_dest[i]==num){continue}
IF:	lw	$t5, 0($t1)		# $t5 = a_source[i]
	move	$t6, $s2		# $t6 = num
	beq	$t5, $t6, CONTINUE		
	
	lw	$t3, 0($t1)		# $t3 = a_source[i]
	
	add	$t2, $t2, 1		# j++
	sll	$t4, $t2, 2		# $t4 = j * 4	
	add	$t4, $t4, $s1		# $t2 = address of a_dest[j]
	sw	$t3,0($t4)		# a_dest[j] = a_source[i];


CONTINUE:	add	$t0, $t0, 1	# i++
		j	LOOP
		
END_LOOP:
    # Exit program (MIPS syscall to exit)
    li   $v0, 10          # Load syscall code for exit
    syscall               # Make syscall
