        .data
sizePrompt: .asciiz "Enter matrix dimension N: "
promptRow:  .asciiz "Enter row to display: "
promptCol:  .asciiz "Enter column to display: "
rowSum:     .asciiz "Row major summation: "
colSum:     .asciiz "Column major summation: "
elementMsg: .asciiz "Element at (i,j): "
newline:    .asciiz "\n"

        .text
        .globl main
main:
    li   $v0, 4
    la   $a0, sizePrompt
    syscall

    li   $v0, 5
    syscall
    move $s0, $v0       # s0 = N

    # allocating space
    mul  $t1, $s0, $s0  # t1 = N*N
    li   $t2, 4
    mul  $t3, $t1, $t2
    move $a0, $t3
    li   $v0, 9
    syscall
    move $s1, $v0       # s1 = base address


    li   $t5, 1         # value = 1
    li   $t6, 1         # j = 1
initCol:
    bgt  $t6, $s0, done
    li   $t7, 1         # i = 1
initRow:
    bgt  $t7, $s0, nextCol
    # offset = ((j-1)*N + (i-1)) * 4
    addi $t8, $t6, -1  
    mul  $t8, $t8, $s0  
    addi $t9, $t7, -1  
    add  $t8, $t8, $t9 
    li   $t9, 4        
    mul  $t8, $t8, $t9 
    add  $t8, $s1, $t8 
    sw   $t5, 0($t8)
    addi $t5, $t5, 1    # value++
    addi $t7, $t7, 1
    j    initRow
nextCol:
    addi $t6, $t6, 1
    j    initCol
done:
    li   $s2, 0         # sumRow = 0
    li   $t6, 1         # i = 1
rowi:
    bgt  $t6, $s0, rowDone
    li   $t7, 1         # j = 1
rowj:
    bgt  $t7, $s0, nextRowi
    addi $t8, $t7, -1
    mul  $t8, $t8, $s0
    addi $t9, $t6, -1
    add  $t8, $t8, $t9
    li   $t9, 4
    mul  $t8, $t8, $t9
    add  $t8, $s1, $t8
    lw   $t9, 0($t8)
    add  $s2, $s2, $t9
    addi $t7, $t7, 1
    j    rowj
nextRowi:
    addi $t6, $t6, 1
    j    rowi
rowDone:
	#print
    li   $v0, 4
    la   $a0, rowSum
    syscall
    li   $v0, 1
    move $a0, $s2
    syscall
    li   $v0, 4
    la   $a0, newline
    syscall

    li   $s3, 0         # sumCol = 0
    li   $t7, 1         # j = 1
colj:
    bgt  $t7, $s0, colDone
    li   $t6, 1         # i = 1
coli:
    bgt  $t6, $s0, nextColj
    addi $t8, $t7, -1
    mul  $t8, $t8, $s0
    addi $t9, $t6, -1
    add  $t8, $t8, $t9
    li   $t9, 4
    mul  $t8, $t8, $t9
    add  $t8, $s1, $t8
    lw   $t9, 0($t8)
    add  $s3, $s3, $t9
    addi $t6, $t6, 1
    j    coli
nextColj:
    addi $t7, $t7, 1
    j    colj
colDone:

	#print
    li   $v0, 4
    la   $a0, colSum
    syscall
    li   $v0, 1
    move $a0, $s3
    syscall
    li   $v0, 4
    la   $a0, newline
    syscall

    li   $v0, 4
    la   $a0, promptRow
    syscall
    li   $v0, 5
    syscall
    move $t6, $v0

    li   $v0, 4
    la   $a0, promptCol
    syscall
    li   $v0, 5
    syscall
    move $t7, $v0

	#compute address
    addi $t8, $t7, -1
    mul  $t8, $t8, $s0
    addi $t9, $t6, -1
    add  $t8, $t8, $t9
    li   $t9, 4
    mul  $t8, $t8, $t9
    add  $t8, $s1, $t8
    lw   $t9, 0($t8)

    # print element
    li   $v0, 4
    la   $a0, elementMsg
    syscall
    li   $v0, 1
    move $a0, $t9
    syscall
    li   $v0, 4
    la   $a0, newline
    syscall

    # ——— exit —————————————————————————————————————————————————————
    li   $v0, 10
    syscall
