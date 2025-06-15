.data
	addCountText:	.asciiz "Number of add instructions: "
	addiCountText:	.asciiz "Number of addi instructions: "
	line:		.asciiz "\n"
	
.text
	.globl main

main:

firstInstruction:
	
	la $a0, firstInstruction
	la $a1, lastInstruction
	jal countInstructions
	
	add $s0, $v0, $zero
	add $s1, $v1, $zero
	
	li $v0, 4
	la $a0, addCountText
	syscall
	
	li $v0, 1
	add $a0, $s0, $zero
	syscall
	
	li $v0, 4
	la $a0, line
	syscall
	
	li $v0, 4
	la $a0, addiCountText
	syscall
	
	li $v0, 1
	add $a0, $s1, $zero
	syscall
	
	li $v0, 10
	syscall
	
countInstructions:
	addi $sp, $sp, -32
	sw $s7, 28($sp)
	sw $s6, 24($sp)
	sw $s5, 20($sp)
	sw $s4, 16($sp)
	sw $s0, 12($sp)
	sw $s1, 8($sp)
	sw $s2, 4($sp)
	sw $s3, 0($sp)
	
	add $s0, $a0, $zero # first instruction
	add $s1, $a1, $zero # last instruction
	li $s2, 0 # add count
	li $s3, 0 # addi count
	
countLoop:
	bgt $s0, $s1, countDone
	
	lw $s4, 0($s0)
	
	andi $s5, $s4, 0x3F
	li $s6, 0x20
	bne $s5, $s6, addiCheck
	
	srl $s5, $s4, 26
	bne $s5, $zero, addiCheck
	
	addi $s2, $s2, 1
	j next
	
addiCheck:
	andi $s5, $s4, 0xFC000000
	li $s6, 0x20000000
	bne $s5, $s6, next
	
	addi $s3, $s3, 1
	
next:
	addi $s0, $s0, 4
	j countLoop
	
countDone:
	add $v0, $s2, $zero
	add $v1, $s3, $zero
	
	lw $s7, 28($sp)
	lw $s6, 24($sp)
	lw $s5, 20($sp)
	lw $s4, 16($sp)
	lw $s0, 12($sp)
	lw $s1, 8($sp)
	lw $s2, 4($sp)
	lw $s3, 0($sp)
	addi $sp, $sp, 32
	
	jr $ra
	
lastInstruction:
	
	
