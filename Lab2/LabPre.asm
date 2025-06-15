.data
	prompt1: 	.asciiz "Enter the size of the array: "
	prompt2:		.asciiz "Enter an integer: "
	line:		.asciiz "\n"
	space:		.asciiz " "
	FreqTable:	.word	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

.text
	.globl main

main:
	jal CreateArray
	
	add $a0, $v0, $zero
	add $a1, $v1, $zero
	
	jal PrintArray
	
	add $a0, $s0, $zero
	add $a1, $s1, $zero
	la $a2, FreqTable
	
	jal FindFreq
	
	la $a0, FreqTable
	
	jal PrintFreq
	
	li $v0, 10
	syscall
	
PrintFreq:
	addi $sp, $sp, -8
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	add $s0, $a0, $zero
	li $s1, 11
	
PrintFreqLoop:
	beq $s1, $zero, PrintFreqEnd
	
	li $v0, 1
	lw $a0, 0($s0)
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	addi $s0, $s0, 4
	addi $s1, $s1, -1
	
	j PrintFreqLoop
	
PrintFreqEnd:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	
	jr $ra
	
PrintArray:
	addi $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $ra, 8($sp)
	
	add $s0, $a0, $zero
	add $s1, $a1, $zero
	
PrintLoop:
	beq $s0, $zero, PrintEnd
	
	lw $a0, 0($s1)
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	addi $s1, $s1, 4
	addi $s0, $s0, -1
	j PrintLoop
	
PrintEnd:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	
	li $v0, 4
	la $a0, line
	syscall
	
	jr $ra
	
CreateArray:
	li $v0, 4
	la $a0, prompt1
	syscall
	
	li $v0, 5
	syscall
	add $s0, $v0, $zero
	
	sll $a0, $s0, 2 # multiply by 4
	li $v0, 9
	syscall
	add $s1, $zero, $v0
	
	addi $sp, $sp, -12
	sw $ra, 8($sp) # store return address
	sw $s0, 4($sp)
	sw $s1, 0($sp) # store size and base address
	
	jal InitializeArray
	
	lw $s1, 0($sp)
	lw $s0, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	
	add $v0, $s0, $zero
	add $v1, $s1, $zero
	
	jr $ra
	
InitializeArray:
	beq $s0, $zero, InitEnd
	
	li $v0, 4
	la $a0, prompt2
	syscall
	
	li $v0, 5
	syscall
	
	sw $v0, 0($s1)
	
	addi $s1, $s1, 4
	addi $s0, $s0, -1
	
	j InitializeArray
	
InitEnd:
	jr $ra
	
FindFreq:
	addi $sp, $sp, -24
	sw $s5, 20($sp)
	sw $s4, 16($sp)
	sw $s3, 12($sp)
	sw $s0, 8($sp)
	sw $s1, 4($sp)
	sw $s2, 0($sp)
	
	add $s0, $a0, $zero
    	add $s1, $a1, $zero
    	add $s2, $a2, $zero
    	
LoopFreq:
	beq $s0, $zero, EndFreq
	
	lw $s3, 0($s1)
	bgt $s3, 9, IncEleven
	blt $s3, 0, IncEleven
	
	sll $s4, $s3, 2
	add $s4, $s4, $s2
	
	lw $s5, 0($s4)
	addi $s5, $s5, 1
	sw $s5, 0($s4)

	j NextFreq
	
IncEleven:
	addi $s4, $s2, 40
	lw $s5, 0($s4)
	addi $s5, $s5, 1
	sw $s5, 0($s4)
	
NextFreq:
	addi $s1, $s1, 4
	addi $s0, $s0, -1
	j LoopFreq
	
EndFreq:
	lw $s2, 0($sp)
	lw $s1, 4($sp)
	lw $s0, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	addi $sp, $sp, 24
	
	jr $ra
	
	
	
	
	
	
	
