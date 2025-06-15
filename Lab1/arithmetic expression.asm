.data
	input: .asciiz "Enter an int: "
	.align 4
	values: .space 12
	
.text
	.globl main
	
main:
	la $t0, values # the inputs
	li $t1, 3 # no of inputs
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
	lw $t1, 0($t0)
	lw $t2, 4($t0)
	lw $t3, 8($t0)
	
	li $t4, 0 # quotient
	move $t5, $t1
	
BdivC: 
	blt $t5, $t2, endBdivC
	sub $t5, $t5, $t2 # t5 -= t2
	addi $t4, $t4, 1
	j BdivC
	
endBdivC:
	move $t6, $t1

DmodB:
	blt $t6, $t1, endDmodB
	sub $t6, $t6, $t1
	j DmodB
	
endDmodB:
	sub $t7, $t4, $t2
	add $t7, $t7, $t6 # t7 is (B / C + D % B - C)
	
	li $t4, 0 # quotient for second division
	move $t5, $t7
	
resdivB:
	blt $t5, $t1, end
	sub $t5, $t5, $t1
	addi $t4, $t4, 1
	j resdivB
	
end:
	li $v0, 1
	move $a0, $t4
	syscall
	
	li $v0, 10
	syscall
	
