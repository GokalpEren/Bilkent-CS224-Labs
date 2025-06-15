.data
    prompt: .asciiz "Enter an integer: "
    original: .asciiz "Original value (hex): "
    reversed: .asciiz "Reversed value (hex): "
    Continue: .asciiz "Continue? (1/0): "
    line: .asciiz "\n"

.text
    .globl main

main:
    jal GetInput
    add $a0, $zero, $v0
    add $s0, $zero, $v0
    jal ReverseBits
    add $s1, $zero, $v1

    li $v0, 4
    la $a0, original
    syscall

    li $v0, 34
    add $a0, $zero, $s0
    syscall

    li $v0, 4
    la $a0, line
    syscall

    li $v0, 4
    la $a0, reversed
    syscall

    li $v0, 34
    add $a0, $zero, $s1
    syscall

    li $v0, 4
    la $a0, line
    syscall

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

GetInput:
    addi $sp, $sp, -8
    sw $s0, 0($sp)
    sw $s1, 4($sp)

    li $v0, 4
    la $a0, prompt
    syscall

    li $v0, 5
    syscall
    move $s0, $v0

    move $v0, $s0

    lw $s0, 0($sp)
    lw $s1, 4($sp)
    addi $sp, $sp, 8
    jr $ra

ReverseBits:
    addi $sp, $sp, -20
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)

    add $s0, $zero, $a0
    li $s1, 0
    li $s2, 32

RevLoop:
    beq $s2, $zero, done
    sll $s1, $s1, 1
    andi $s3, $s0, 1
    or $s1, $s1, $s3
    srl $s0, $s0, 1
    subi $s2, $s2, 1
    j RevLoop

done:
    add $v0, $zero, $s0
    add $v1, $zero, $s1

    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    addi $sp, $sp, 20
    jr $ra


