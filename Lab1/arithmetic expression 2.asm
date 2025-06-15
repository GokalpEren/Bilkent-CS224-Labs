.data
	input: .asciiz "Enter an int: "
	.align 4
	values: .space 8
	
.text
	.globl main

main: 
	la $t0, values # the inputs
	li $t1, 2 # no of inputs
	li $t8, 0 # counter
	
get_inputs:
	bge $t8, $t1, continue
	
	li $v0, 4
	la $a0, input
	syscall
	
	li $v0, 5
	syscall
	sw $v0, 0($t0)
	
	addi $t8, $t8, 1
	addi $t0, $t0, 4
	j get_inputs
	
continue:
	la $t0, values
	lw $t1, 0($t0) # A
	lw $t2, 4($t0) # B
	
	add $t3, $t1, $t2 # A + B
	sub $t4, $t2, $t1 # B - A
	
	mul $t3, $t3, $t4 # (A + B)(B - A)
	
	div $t3, $t2
	mfhi $t5
	
	li $v0, 1
	move $a0, $t5
	syscall
	
	li $v0, 10
	syscall






