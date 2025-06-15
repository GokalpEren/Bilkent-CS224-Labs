.data
    .align 4
array:      .space 80

size:    .asciiz "Enter number of elements (20 max): "
input:   .asciiz "Enter an integer: "

.text
    .globl main

main:
    li $v0, 4
    la $a0, size
    syscall # print size string

    li $v0, 5
    syscall # read integer
    move $t3, $v0 # t3 is size

    li $t4, 20
    bgt $t3, $t4, limit # limits size to 20

    j continue_input

limit:
    li $t3, 20

continue_input:
    li $t0, 0
    la $t2, array # t2 is the array base address

read_loop:
    bge $t0, $t3, display_array # counts up to t3, then proceeds to display array

    li $v0, 4
    la $a0, input
    syscall # prints "Enter an integer: " at  each iteration

    li $v0, 5
    syscall # read integer

    sw $v0, 0($t2)

    addi $t2, $t2, 4 # "pointer" moves to next address
    addi $t0, $t0, 1 # i++

    j read_loop

display_array:
    li $t0, 0
    la $t2, array # points back to starting position

print_loop:
    bge $t0, $t3, reverse_array # loops until size

    lw $a0, 0($t2)
    li $v0, 1
    syscall # loads word into a0 then prints the integer

    li $v0, 11
    li $a0, 32
    syscall # print a space

    addi $t2, $t2, 4
    addi $t0, $t0, 1 # increment pointer and index

    j print_loop

reverse_array:
    la $t2, array # back to start
    mul $t4, $t3, 4 # t4 points to last element
    add $t4, $t4, $t2
    addi $t4, $t4, -4  

swap_loop:
    bge $t2, $t4, print_reversed # loops until size

    lw $t5, 0($t2)  
    lw $t6, 0($t4)  

    sw $t6, 0($t2)  
    sw $t5, 0($t4) # swapping elements

    addi $t2, $t2, 4
    addi $t4, $t4, -4 # two pointer indices get changed

    j swap_loop

print_reversed:
    li $t0, 0
    la $t2, array

print_loop_reversed:
    bge $t0, $t3, end # same print logic

    lw $a0, 0($t2)
    li $v0, 1
    syscall

    li $v0, 11
    li $a0, 32
    syscall

    addi $t2, $t2, 4
    addi $t0, $t0, 1

    j print_loop_reversed

end:
    li $v0, 10
    syscall
