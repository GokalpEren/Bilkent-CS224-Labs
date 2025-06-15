.data
	line: 				.asciiz "\n--------------------------------------"
	nodeNumberLabel: 		.asciiz "\nNode: "
	addressOfCurrentNodeLabel: 	.asciiz "\nAddress of Current Node: "
	addressOfNextNodeLabel: 	.asciiz "\nAddress of Next Node: "
	keyOfCurrentNode: 		.asciiz "\nKey: "
	dataValueOfCurrentNode: 	.asciiz "\nData: "
	oddListLabel: 			.asciiz "\nOdd List:"
	evenListLabel: 			.asciiz "\nEven List:"

.text
	.globl main

main:
    li $a0, 8
    jal createLinkedList
    add $s0, $v0, $zero  # Store head pointer of the original list

    add $a0, $s0, $zero
    jal printLinkedListRecursive

    add $a0, $s0, $zero
    jal generateOddEvenLinkedLists
    add $s1, $v0, $zero  # odd list head
    add $s2, $v1, $zero  # even list head

    # Print odd
    la $a0, line
    li $v0, 4
    syscall

    li $v0, 4
    la $a0, oddListLabel
    syscall

    add $a0, $s1, $zero
    jal printLinkedListRecursive

    # Print even
    la $a0, line
    li $v0, 4
    syscall

    li $v0, 4
    la $a0, evenListLabel
    syscall

    add $a0, $s2, $zero
    jal printLinkedListRecursive

    li $v0, 10
    syscall

createLinkedList:
	addi	$sp, $sp, -28
	sw	$s0, 24($sp)
	sw	$s1, 20($sp)
	sw	$s2, 16($sp)
	sw	$s3, 12($sp)
	sw	$s4, 8($sp)
	sw	$s5, 4($sp)
	sw	$ra, 0($sp)

	add	$s0, $a0, $zero  # Number of nodes
	li	$s1, 1           # Key value
	li	$s5, 0           # Counter for every 3rd node

	# Allocate memory for head node
	li	$a0, 12
	li	$v0, 9
	syscall

	add	$s2, $v0, $zero  # Head node pointer
	add	$s3, $v0, $zero  # Start of linked list

storeNode:
	sw	$s1, 0($s2)   # Store key
	mul	$s4, $s1, 2  # Compute data

	# Increment data by 1 for every 3rd node
	addi	$s5, $s5, 1
	bne	$s5, 3, skipInc
	addi	$s4, $s4, 1
	li	$s5, 0  # Reset third node counter

skipInc:
	sw	$s4, 4($s2)   # Store data value

	# Check stop condition
	beq	$s1, $s0, finishList
	addi	$s1, $s1, 1

	# Allocate memory for next node
	li	$a0, 12
	li	$v0, 9
	syscall

	sw	$v0, 8($s2)  # Link to next node
	add	$s2, $v0, $zero
	j	storeNode

finishList:
	sw	$zero, 8($s2)  # Set last node's next to NULL
	add	$v0, $s3, $zero  # Return head pointer

	# Restore stack and return
	lw	$ra, 0($sp)
	lw	$s5, 4($sp)
	lw	$s4, 8($sp)
	lw	$s3, 12($sp)
	lw	$s2, 16($sp)
	lw	$s1, 20($sp)
	lw	$s0, 24($sp)
	addi	$sp, $sp, 28
	jr	$ra


printLinkedListRecursive:
    # Base case: if node is NULL, return
    beq    $a0, $zero, endPrint

    # Save registers to stack
    addi    $sp, $sp, -20
    sw      $s7, 16($sp)
    sw      $a0, 12($sp)
    sw      $ra, 8($sp)
    sw      $s0, 4($sp)
    sw      $s1, 0($sp)

    lw      $s0, 0($a0)  # Key
    lw      $s1, 4($a0)  # Data
    lw      $s7, 8($a0)  # Link to next node

    # Recursive call to print the next node first (this reverses the order)
    add    $a0, $s7, $zero
    jal    printLinkedListRecursive

    # Print after returning from recursion (reverse order)
    la      $a0, line
    li      $v0, 4
    syscall

    la      $a0, nodeNumberLabel
    li      $v0, 4
    syscall

    add     $a0, $s0, $zero  # Key
    li      $v0, 1
    syscall

    la      $a0, addressOfCurrentNodeLabel
    li      $v0, 4
    syscall

    lw      $a0, 12($sp)  # Load back current node address
    li      $v0, 34
    syscall

    la      $a0, addressOfNextNodeLabel
    li      $v0, 4
    syscall

    add     $a0, $s7, $zero  # Next node address
    li      $v0, 34
    syscall

    la      $a0, keyOfCurrentNode
    li      $v0, 4
    syscall

    add     $a0, $s0, $zero  # Key
    li      $v0, 1
    syscall

    la      $a0, dataValueOfCurrentNode
    li      $v0, 4
    syscall

    add     $a0, $s1, $zero  # Data
    li      $v0, 1
    syscall

    li      $a0, 10
    li      $v0, 11
    syscall

    # Restore registers and return
    lw      $s1, 0($sp)
    lw      $s0, 4($sp)
    lw      $ra, 8($sp)
    lw      $a0, 12($sp)
    lw      $s7, 16($sp)
    addi    $sp, $sp, 20
    jr      $ra

endPrint:
    jr      $ra


generateOddEvenLinkedLists:
    addi    $sp, $sp, -28
    sw      $s0, 24($sp)  # Original list
    sw      $s1, 20($sp)  # Current
    sw      $s2, 16($sp)  # Data
    sw      $s3, 12($sp)  # Odd list head
    sw      $s4, 8($sp)   # Even list head
    sw      $s5, 4($sp)   # Last odd node
    sw      $s6, 0($sp)   # Last even node

    add    $s0, $a0, $zero      # Head of original list
    li      $s3, 0        # Odd list head
    li      $s4, 0        # Even list head
    li      $s5, 0        # Last odd node
    li      $s6, 0        # Last even node

processNodes:
    beq     $s0, $zero, finished  # Stop if 0

    lw      $s1, 0($s0)
    lw      $s2, 4($s0)

    # Allocate memory for new node
    li      $a0, 12
    li      $v0, 9
    syscall

    sw      $s1, 0($v0)   # Store key in new node
    sw      $s2, 4($v0)   # Store data in new node
    sw      $zero, 8($v0) # Initialize next pointer to 0

    andi    $s7, $s2, 1
    beq    $s7, $zero, addToEven  # If data is even, go to even

addToOdd:
    beq     $s3, $zero, firstOdd
    sw      $v0, 8($s5)   # Link last odd node to new node
    j       storeOddTail

firstOdd:
    add    $s3, $v0, $zero  # Set head of odd list

storeOddTail:
    add    $s5, $v0, $zero  # Update last odd node
    j       nextNode

addToEven:
    beq    $s4, $zero, firstEven
    sw      $v0, 8($s6)   # Link last even node to new node
    j       storeEvenTail

firstEven:
    add    $s4, $v0, $zero  # Set head of even list

storeEvenTail:
    add    $s6, $v0, $zero  # Update last even node

nextNode:
    lw      $s0, 8($s0)   # Move to next node
    j       processNodes

finished:
    add    $v0, $s3, $zero  # Return odd list head
    add    $v1, $s4, $zero  # Return even list head

    # Restore registers and return
    lw      $s6, 0($sp)
    lw      $s5, 4($sp)
    lw      $s4, 8($sp)
    lw      $s3, 12($sp)
    lw      $s2, 16($sp)
    lw      $s1, 20($sp)
    lw      $s0, 24($sp)
    addi    $sp, $sp, 28
    jr      $ra

errorExitGen:
    li      $v0, 10  # Exit program if memory allocation fails
    syscall
