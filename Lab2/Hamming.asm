.data
    prompt: .asciiz "Enter an integer: "
    result: .asciiz "Hamming distance: "
    Continue: .asciiz "Continue? (1/0): "
    line: .asciiz "\n"

.text
    .globl main

main:
    jal GetInputs
    add $a0, $zero, $v0
    add $a1, $zero, $v1
    jal CalcHamming

    li $v0, 4
    la $a0, result
    syscall

    li $v0, 1
    add $a0, $zero, $v1
    syscall

    li $v0, 4
    la $a0, line
    syscall

    # Continue?
    li $v0, 4
    la $a0, Continue
    syscall

    li $v0, 5
    syscall

    beq $v0, $zero, exit
    j main

exit:
    li $v0, 10
    syscall

CalcHamming:
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    
    add $s0, $a0, $zero
    add $s1, $a1, $zero
    
    li $v0, 34
    add $a0, $s0, $zero
    syscall
    
    li $v0, 4
    la $a0, line
    syscall
    
    li $v0, 34
    add $a0, $s1, $zero
    syscall
    
    li $v0, 4
    la $a0, line
    syscall

    xor $s0, $s0, $s1
    li $v1, 0

CountBits:
    beqz $s0, CalcEnd
    andi $t0, $s0, 1
    add $v1, $v1, $t0
    srl $s0, $s0, 1
    j CountBits

CalcEnd:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra

GetInputs:
    addi $sp, $sp, -8
    sw $s0, 0($sp)
    sw $s1, 4($sp)

    li $v0, 4
    la $a0, prompt
    syscall

    li $v0, 5
    syscall
    add $s0, $zero, $v0

    li $v0, 4
    la $a0, prompt
    syscall

    li $v0, 5
    syscall
    add $s1, $zero, $v0

    # Return values
    add $v0, $zero, $s0
    add $v1, $zero, $s1

    lw $s0, 0($sp)
    lw $s1, 4($sp)
    addi $sp, $sp, 8
    jr $ra
