.data
	prompt: 	.asciiz "Enter an integer: "
	quotient:	.asciiz "Quotient: "
	remainder:	.asciiz "Remainder: "
	line:		.asciiz "\n"
	
.text
	.globl main
	
	
main:
	li $v0, 4
	la $a0, prompt
	syscall
	
	li $v0, 5
	syscall
	add $s0, $v0, $zero
	beq $s0, $zero, exit
	
	li $v0, 4
	la $a0, prompt
	syscall
	
	li $v0, 5
	syscall
	add $s1, $v0, $zero
	beq $s1, $zero, exit
	
	add $a0, $s0, $zero
	add $a1, $s1, $zero
	jal divide
	
	add $s0, $v0, $zero
	add $s1, $v1, $zero
	
	li $v0, 4
	la $a0, quotient
	syscall
	
	li $v0, 1
	add $a0, $s0, $zero
	syscall
	
	li $v0, 4
	la $a0, line
	syscall
	
	li $v0, 4
	la $a0, remainder
	syscall
	
	li $v0, 1
	add $a0, $s1, $zero
	syscall
	
	li $v0, 4
	la $a0, line
	syscall
	
	j main
	
exit:
	li $v0, 10
	syscall
	
divide:
	addi $sp, $sp, -12
	sw $ra, 8($sp)
	sw $s0, 4($sp)
	sw $s1, 0($sp)
	
	add $s0, $a0, $zero
	add $s1, $a1, $zero
	
	blt $s0, $s1, baseCase
	
	sub $a0, $s0, $s1
	add $a1, $s1, $zero
	jal divide
	
	addi $v0, $v0, 1
	j restore
	
baseCase:
	add $v0, $zero, $zero
	add $v1, $s0, $zero
	
restore:
	lw $s1, 0($sp)
	lw $s0, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	jr $ra
	