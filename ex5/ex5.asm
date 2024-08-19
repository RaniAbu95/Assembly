# This MIPS assembly code performs the following operations:
# 1. Multiplies corresponding elements from two floating-point arrays, `A_FLOATS` and `B_FLOATS`.
# 2. Stores the results of these multiplications in two separate arrays, `MULT_POSITIVES` and `MULT_NEGATIVES`.
# 3. Results are stored in `MULT_POSITIVES` if they are positive or zero, and in `MULT_NEGATIVES` if they are negative.
#
# Specifically:
# - `A_FLOATS` is an array of 10 32-bit floating-point numbers, initialized at address 0x1001 0000.
# - `B_FLOATS` is another array of 10 32-bit floating-point numbers, initialized at address 0x1001 0040.
# - `MULT_POSITIVES` is reserved space for storing the positive or zero results of the multiplications.
# - `MULT_NEGATIVES` is reserved space for storing the negative results of the multiplications.
#
# The code executes the following steps:
# 1. Loads the base addresses of the arrays.
# 2. Initializes loop index and floating-point registers.
# 3. Loops through each element of `A_FLOATS` and `B_FLOATS`, performing the following:
#    - Multiplies the corresponding elements.
#    - Checks if the result is negative or not.
#    - Stores the result in the appropriate array (`MULT_POSITIVES` or `MULT_NEGATIVES`).
# 4. Exits the program using a syscall.
#
# The floating-point comparison is done using the `c.lt.s` instruction to check if the result is less than zero.
# The program uses `swc1` to store floating-point results into memory and manages loop indices and addresses using integer registers.


.data
# Define the base addresses for the arrays
A_FLOATS: 
    .word 0x3FC00000   # 1.5
    .word 0xC0000000   # -2.0
    .word 0x3F000000   # 0.5
    .word 0x40400000   # 3.0
    .word 0xBF800000   # -1.0
    .word 0x3F000000   # 0.5
    .word 0x40400000   # 2.5
    .word 0xC0800000   # -4.0
    .word 0x3F800000   # 1.0
    .word 0xBF000000   # -0.5

    .space 24         # Reserve space between A_Floats and B_Floats

B_FLOATS: 
    .word 0x40000000   # 2.0
    .word 0xBF000000   # -0.5
    .word 0x40800000   # 4.0
    .word 0xBF800000   # -1.5
    .word 0x40000000   # 2.0
    .word 0x3F800000   # 1.0
    .word 0xC0400000   # -2.5
    .word 0x40400000   # 3.0
    .word 0x3F000000   # 0.5
    .word 0xBF800000   # -1.0

    .space 24          # Reserve space for Mult_Positives

MULT_POSITIVES: 
    .space 64          # Reserve space for 10 floats (4 bytes each)

MULT_NEGATIVES: 
    .space 40          # Reserve space for 10 floats (4 bytes each)


.text
.globl main

main:
    # Initialize base addresses
    la $t0, A_FLOATS      # Load base address of A_Floats into $t0
    la $t1, B_FLOATS      # Load base address of B_Floats into $t1
    la $t2, MULT_POSITIVES# Load base address of Mult_Positives into $t2
    la $t3, MULT_NEGATIVES# Load base address of Mult_Negatives into $t3

    li $t4, 0             # Loop index i = 0

    # Initialize $f4 to 0.0
    li $t5, 0x00000000   # Load integer representation of 0.0 into $t5
    mtc1 $t5, $f4        # Move integer value into floating-point register $f4
    nop                  # Delay slot

loop:
    bge $t4, 10, end      # If i >= 10, exit loop

    # Load floating-point values
    lwc1 $f0, 0($t0)      # Load A_Floats[i] into $f0
    lwc1 $f1, 0($t1)      # Load B_Floats[i] into $f1

    # Perform the multiplication
    mul.s $f2, $f0, $f1  # $f2 = A_Floats[i] * B_Floats[i]

    # Check the sign of the result
    c.lt.s $f2, $f4      # Compare $f2 < $f4 (result < 0)
    bc1t store_negative   # If $f2 < $f4, branch to store_negative

    # If positive or zero
    swc1 $f2, 0($t2)      # Store result in Mult_Positives[i]
    j increment_index    # Jump to increment index

store_negative:
    # If negative
    swc1 $f2, 0($t3)      # Store result in Mult_Negatives[i]

increment_index:
    addi $t4, $t4, 1     # Increment index i
    addi $t0, $t0, 4     # Move to next element in A_Floats
    addi $t1, $t1, 4     # Move to next element in B_Floats
    addi $t2, $t2, 4     # Move to next element in Mult_Positives
    addi $t3, $t3, 4     # Move to next element in Mult_Negatives
    j loop               # Repeat the loop

end:
    # Exit the program
    li $v0, 10           # Load the exit system call code
    syscall              # Make the system call to exit
