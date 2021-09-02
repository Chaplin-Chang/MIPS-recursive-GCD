.data
	msg1: .asciiz "first integer: "
	msg2: .asciiz "second integer: "
	msg3: .asciiz "GCD: "
.text
.globl main

main:
    la $a0, msg1           # ��J�Ĥ@�ӼƦr
    li $v0, 4              # print_string
    syscall                # output
    li $v0, 5              # read_int
    syscall                # input 
    addi $a1, $v0, 0       # �Ʀr1�s��a1

    la $a0, msg2           # ��J�ĤG�ӼƦr
    li $v0, 4              # print_string
    syscall                # output
    li $v0, 5              # read_int
    syscall                # input integer n2 into $v0
    addi $a2, $v0, 0       # �Ʀr2�s��a2

    addi $sp, $sp, -8      # �վ�2�Ŷ�
    sw $a1, 0($sp)         # �s���Ʀr1
    sw $a2, 4($sp)         # �s���Ʀr2
    jal gcd                # ����GCD �����U��a�}
    lw $a1, 0($sp)         # load to a1
    lw $a2, 4($sp)         # load to a2
    addi $sp, $sp, 8       # �^�_sp����m
    move $s0, $v0          # result v0 �ǤJ$s0
   
    la $a0, msg3           #GCD���G
    li $v0, 4              # print_string
    syscall                # output
    li $v0, 1              # print_int
    add $a0, $s0, $zero    #��GCD�����G��X
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
    addi $sp, $sp, -8      # �վ�2�Ŷ�
    sw $ra, 4($sp)         # �s��return address
# Recursive
    div $a1, $a2           # ���k
    mfhi $s0               # ��Hi�l��
    sw $s0, 0($sp)         # �x�s�l��
    bne $s0, $zero, gcd2   #  $s0 != 0 ��gcd2

    add $v0, $a2, $zero   # a2�Oans�A�Ǩ�v0
    addi $sp, $sp, 8      # �^�_sp����m
    jr $ra                # return
gcd2:
    add $a1, $a2, $zero   # ��a1�ܦ�a2 �Agcd(n2, n1 % n2);
    lw $s0, 0($sp)        # load �l��
    add $a2, $s0, $zero   # ��a2�ܦ��l�ơAgcd(n2, n1 % n2);
    jal gcd               # �^gcd

    lw $ra, 4($sp)        # load return address
    addi $sp, $sp, 8      # �^�_sp����m
    jr $ra                # return
