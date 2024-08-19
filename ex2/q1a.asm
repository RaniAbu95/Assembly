# This MIPS assembly code performs the following operations:
# 1. Initializes values for variables `a`, `b`, `c`, and `i`, and sets the base address of the array.
# 2. Computes a new value based on the formula `a + a - b - 1 + array[2]`.
# 3. Stores the computed value into `array[c + 1]`.
# 
# Specifically:
# - `a` is set to 75.
# - `b` is set to 5.
# - `c` is set to 4.
# - `i` is set to 2.
# - The address of `array` is set to 0x1001 0000.
# - The formula computes `a + a` (which is 150), subtracts `b + 1` (which is 6), adds `array[2]`, and stores the result in `array[c + 1]`.

.data	#0x1001 0000
	.word 75, -8, 125, 35, 49, 1025, -457, -76, 654, -548


.text
	addi	$s0, $zero, 75 	# a = 75
	addi	$s1, $zero, 5	# b = 5
	addi	$s2, $zero, 4	# c = 4
	addi	$s3, $zero, 2	# i = 2
	lui	$s4, 0x1001	# $s4 = address of array[0]

# array[c+1] = = a + a - b – 1 + array[2]) :
	sll	$t0, $s0, 1	# $t0 = a + a
	add	$t1, $s1, 1	# $t1 = b + 1
	sll	$t2, $s3,2	# $t2 = 4*(2)
	add	$t2, $t2, $s4	# $t2 = address of array[2]
	lw	$t2, 0($t2)	# $t2 = array[2]
	sub	$t1, $t0, $t1	# $t1 = a + a - b - 1
	add	$t1, $t1, $t2	# $t1 = a + a - b – 1 + array[2]
	add	$t4, $s2, 1	# $t4 = c + 1
	sll	$t4, $t4, 2	# $t4 = (c + 1) * 4
	add	$t4, $t4, $s4	# $t4 = address of array[c+1]
	add	$t5, $t5, $t1	# $t5 = $t5 + $t1 // $t5 = a + a - b – 1 + array[2]
	sw	$t5, 0($t4)	# Store $t5 into array[c + 1]
