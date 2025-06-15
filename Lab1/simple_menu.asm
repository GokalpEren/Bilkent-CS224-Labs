.data
	.align 4
	
array:	.space 400
prompt1: .asciiz "Enter number of elements (100 max): "
prompt2: .asciiz "Enter an integer: "
menu: 	.asciiz "\nMenu: \n1. Find max \n2. Occurrences of max \n3. Find average\n4. Number of elements smaller and larger than average \n5. Quit\nChoose an option: "
line:	.asciiz "\n"

.text
	.globl main

main: 
	li $v0, 4
	la $a0, prompt1
	syscall
	
	li $v0, 5
	syscall
	move $t0, $v0 # t0 is number of elements
	
	li $t1, 100
	bgt $t0, $t1, limit # limit to 100 if greater than 100
	
	li $t2, 0 # index
	la $t3, array # t3 holds base address of the array
	
	j getElements
	
limit:
	li $t0, 100
	
getElements:
	bge $t2, $t0, menuLoop
	
	li $v0, 4
	la $a0, prompt2
	syscall
	
	li $v0, 5
	syscall
	
	sw $v0, 0($t3)
	
	addi $t2, $t2, 1
	addi $t3, $t3, 4
	j getElements
	
menuLoop:
	li $v0, 4
	la $a0, menu
	syscall
	
	li $v0, 5
	syscall
	move $t4, $v0
	
	beq $t4, 1, max
	beq $t4, 2, count_max
	beq $t4, 3, average
	beq $t4, 4, countElements
	beq $t4, 5, end
	
	j menuLoop
	
max: 
	li $t5, 0
	li $t1, 0
	la $t3, array
	
max_loop:
	bge $t1, $t0, printMax
	lw $t6, 0($t3)
	bgt $t6, $t5, newMax
	j next
	
newMax:
	move $t5, $t6
	
next:
	addi $t1, $t1, 1
	addi $t3, $t3, 4
	j max_loop
	
printMax:
	li $v0, 1
	move $a0, $t5
	syscall
	
	j menuLoop
	
count_max: # option 2
	li $t1, 0
	li $t7, 0
	la $t3, array
	
	li $t5, 0
	
findMax:
	bge $t1, $t0, maxFound
	lw $t6, 0($t3)
	
	bge $t6, $t5, updateMax
	j findMaxNext
	
updateMax:
	move $t5, $t6
	
findMaxNext:
	addi $t1, $t1, 1
	addi $t3, $t3, 4
	j findMax
	
maxFound:
	li $t1, 0
	la $t3, array
	
countMaxLoop:
	bge $t1, $t0, printCount
	lw $t6, 0($t3)
	
	bge $t6, $t5, incrementCount
	j nextCount
	
incrementCount:
	addi $t7, $t7, 1
	
nextCount:
	addi $t1, $t1, 1
	addi $t3, $t3, 4
	j countMaxLoop
	
printCount:
	li $v0, 1
	move $a0, $t7
	syscall
	
	j menuLoop
	
average:
	li $t7, 0 # sum
	li $t1, 0
	la $t3, array
	
sumLoop:
	bge $t1, $t0, calcAvg
	lw $t6, 0($t3)
	add $t7, $t7, $t6
	
	addi $t1, $t1, 1
	addi $t3, $t3, 4
	j sumLoop

calcAvg:
	div $t7, $t0
	mflo $t9
	
	li $v0, 1
	move $a0, $t9
	syscall
	
	j menuLoop
	
countElements:
	li $t1, 0
	li $t7, 0 # smaller
	li $t8, 0 # greater
	la $t3, array

countLoop:
	bge $t1, $t0, printCounts
	lw $t6, 0($t3)
	
	blt $t6, $t9, incLesser
	bgt $t6, $t9, incGreater
	
	j nextLessGreat
	
incLesser:
	addi $t7, $t7, 1
	j nextLessGreat

incGreater:
	addi $t8, $t8, 1
	j nextLessGreat
	
nextLessGreat:
	addi $t1, $t1, 1
	addi $t3, $t3, 4
	j countLoop
	
printCounts:
	li $v0, 1
	move $a0, $t7
	syscall
	
	li $v0, 4
	la $a0, line
	syscall
	
	li $v0, 1
	move $a0, $t8
	syscall	
	
	j menuLoop
	
end:
	li $v0, 10
	syscall
	
	
	
	
