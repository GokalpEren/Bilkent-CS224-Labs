# column major

        .data
sizePrompt: .asciiz "Enter matrix dimension N: "
colMsg:     .asciiz "Col‑major sum = "
newline:    .asciiz "\n"

        .text
        .globl main
main:
    # prompt + read N
    li   $v0, 4
    la   $a0, sizePrompt
    syscall
    li   $v0, 5
    syscall
    move $s0, $v0         # s0 = N

    # allocate N*N*4 bytes
    mul  $t0, $s0, $s0
    li   $t1, 4
    mul  $t0, $t0, $t1
    move $a0, $t0
    li   $v0, 9
    syscall
    move $s1, $v0         # s1 = base address

    # compute column‑major sum
    li   $s3, 0           # sumCol in s3
    li   $t3, 1           # j = 1
col_j:
    bgt  $t3, $s0, col_done
    li   $t2, 1           # i = 1
col_i:
    bgt  $t2, $s0, next_col
    addi $t4, $t2, -1     # t4 = i-1
    mul  $t4, $t4, $s0    # t4 = (i-1)*N
    addi $t5, $t3, -1     # t5 = j-1
    add  $t4, $t4, $t5    # t4 = (i-1)*N + (j-1)
    li   $t5, 4
    mul  $t4, $t4, $t5    # t4 = offset*4
    add  $t4, $s1, $t4    # t4 = address of A[i][j]
    lw   $t6, 0($t4)      # load A[i][j]  ← counts in cache sim
    add  $s3, $s3, $t6    # sumCol += A[i][j]
    addi $t2, $t2, 1
    j    col_i
next_col:
    addi $t3, $t3, 1
    j    col_j
col_done:
    # print the sum (just to verify)
    li   $v0, 4
    la   $a0, colMsg
    syscall
    li   $v0, 1
    move $a0, $s3
    syscall
    li   $v0, 4
    la   $a0, newline
    syscall

    li   $v0, 10          # exit
    syscall

# row major

        .data
sizePrompt: .asciiz "Enter matrix dimension N: "
rowMsg:     .asciiz "Row‑major sum = "
newline:    .asciiz "\n"

        .text
        .globl main
main:
    # prompt + read N
    li   $v0, 4
    la   $a0, sizePrompt
    syscall
    li   $v0, 5
    syscall
    move $s0, $v0         # s0 = N

    # allocate N*N*4 bytes
    mul  $t0, $s0, $s0    # t0 = N*N
    li   $t1, 4           # 4 bytes/word
    mul  $t0, $t0, $t1    # t0 = N*N*4
    move $a0, $t0
    li   $v0, 9           # sbrk
    syscall
    move $s1, $v0         # s1 = base address

    # compute row‑major sum
    li   $s2, 0           # sumRow in s2
    li   $t2, 1           # i = 1
row_i:
    bgt  $t2, $s0, row_done
    li   $t3, 1           # j = 1
row_j:
    bgt  $t3, $s0, next_row
    addi $t4, $t2, -1     # t4 = i-1
    mul  $t4, $t4, $s0    # t4 = (i-1)*N
    addi $t5, $t3, -1     # t5 = j-1
    add  $t4, $t4, $t5    # t4 = (i-1)*N + (j-1)
    li   $t5, 4
    mul  $t4, $t4, $t5    # t4 = ((i-1)*N+(j-1))*4
    add  $t4, $s1, $t4    # t4 = address of A[i][j]
    lw   $t6, 0($t4)      # load A[i][j]  ← counts in cache sim
    add  $s2, $s2, $t6    # sumRow += A[i][j]
    addi $t3, $t3, 1
    j    row_j
next_row:
    addi $t2, $t2, 1
    j    row_i
row_done:
    # print the sum (just to verify)
    li   $v0, 4
    la   $a0, rowMsg
    syscall
    li   $v0, 1
    move $a0, $s2
    syscall
    li   $v0, 4
    la   $a0, newline
    syscall

    li   $v0, 10          # exit
    syscall
