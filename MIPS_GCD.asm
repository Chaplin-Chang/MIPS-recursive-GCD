.data
	msg1: .asciiz "first integer: "
	msg2: .asciiz "second integer: "
	msg3: .asciiz "GCD: "
.text
.globl main

main:
    la $a0, msg1           # 輸入第一個數字
    li $v0, 4              # print_string
    syscall                # output
    li $v0, 5              # read_int
    syscall                # input 
    addi $a1, $v0, 0       # 數字1存到a1

    la $a0, msg2           # 輸入第二個數字
    li $v0, 4              # print_string
    syscall                # output
    li $v0, 5              # read_int
    syscall                # input integer n2 into $v0
    addi $a2, $v0, 0       # 數字2存到a2

    addi $sp, $sp, -8      # 調整2空間
    sw $a1, 0($sp)         # 存取數字1
    sw $a2, 4($sp)         # 存取數字2
    jal gcd                # 跳至GCD 紀錄下行地址
    lw $a1, 0($sp)         # load to a1
    lw $a2, 4($sp)         # load to a2
    addi $sp, $sp, 8       # 回復sp的位置
    move $s0, $v0          # result v0 傳入$s0
   
    la $a0, msg3           #GCD結果
    li $v0, 4              # print_string
    syscall                # output
    li $v0, 1              # print_int
    add $a0, $s0, $zero    #把GCD的結果輸出
    syscall                # output
    li $v0, 10             # Terminating program
    syscall                
# ---------------------------------------------------------
#int GCD(int a, int b) {
#        int r = a % b;
#        if (r == 0) {
#            return b;
#        } else {
#            return GCD(b, r);
#        }
#    }
# ---------------------------------------------------------
gcd:
    addi $sp, $sp, -8      # 調整2空間
    sw $ra, 4($sp)         # 存取return address
# Recursive
    div $a1, $a2           # 除法
    mfhi $s0               # 取Hi餘數
    sw $s0, 0($sp)         # 儲存餘數
    bne $s0, $zero, gcd2   #  $s0 != 0 跳gcd2

    add $v0, $a2, $zero   # a2是ans，傳到v0
    addi $sp, $sp, 8      # 回復sp的位置
    jr $ra                # return
gcd2:
    add $a1, $a2, $zero   # 讓a1變成a2 ，gcd(n2, n1 % n2);
    lw $s0, 0($sp)        # load 餘數
    add $a2, $s0, $zero   # 讓a2變成餘數，gcd(n2, n1 % n2);
    jal gcd               # 回gcd

    lw $ra, 4($sp)        # load return address
    addi $sp, $sp, 8      # 回復sp的位置
    jr $ra                # return
