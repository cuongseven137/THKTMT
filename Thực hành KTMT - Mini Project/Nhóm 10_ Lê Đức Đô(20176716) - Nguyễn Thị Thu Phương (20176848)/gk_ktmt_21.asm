#
.data
	string: 	.space 10			# chuoi de nhap 
	Message1:       .asciiz "Nhap so:" 		# chuoi yeu cau nhap xau vao
	Message2:	.asciiz "DigitDgree = "		# chuoi dua ra ket qua
	Error:		.asciiz "Ban dang khong nhap so. "	# dua ra loi
	Again:		.asciiz "Hay nhap lai."		# dua ra loi muoi nhap lai
	
.text

main:
	li $s0, 0	# sum = 0
	li $t1, 0	# i = 0
	li $s1, 47	# ma ASSCI truoc '0'
	li $s2, 58	# ma ASSCI sau '9'
	li $s3, 0	# kiem tra so co phai so am
	
	jal NHAP	# goi ham con nhap
	nop
	jal CheckType	# jump to checktype
	nop
	jal digitDgree	# goi ham con digitDgree
	nop
	jal in 		# goi ham con in ra
	nop
NHAP:
	li $v0, 54
	la $a0, Message1
	la $a1, string
	li $a2, 10
	syscall 
	
	la $a0, string	# Address string[0]
	
	jr $ra
	
	
CheckType:	# kiem tra xem kieu nhap vao co dung la cac chu so khong
	add $t2, $a0, $t1	# Address string[i]
	lb $t3, 0($t2)		# gia tri string[i]
	
	beq $t3, 10, end_check	# string[i] = '\n' ? true thi jump
	beq $t3, 0, error
	beq $t3, 45, So_Am	# jump toi chuyen so am
	
	slt $t4, $s1, $t3	# string[i] >= '0' ? $t4 = 1 : 0
	slt $t5, $t3, $s2	# string[i] <= '9' ? $t5 = 1 : 0
	
	and $t6, $t4, $t5	# if '0' <= string[i] <=  '9' ? $t6 = 1 : 0
	
	addi $t1, $t1, 1	# i = i+1
	
	bne $t6, $zero, toNumber	# if $t6 = 1 jump toNumber
	beq $t6, $zero, error		# if string[i] <= '0' || string[i] >= '9' thi bi loi
	
	end_check:
		beq $s3, $zero, return
		sub $s0, $zero, $s0
	return:
		jr $ra
	
	toNumber:
		sub $t3, $t3, 1		# tru gia tri $t2 di 1 de duoc gia tri dung
		sub $t7, $t3, $s1	# tru de lay gia tri so cua ki tu
	
		mul $s0, $s0, 10	# nhan tong len
	
		add $s0, $s0, $t7	# tong ra so
	
		j CheckType		# jump to CheckType	
	
	So_Am:
		bne $t0, $zero, error	# if ki tu '-' la ki tu o vi tri != 0 thi bao loi
		li $s3, 1		# else gan lai co = 1
		add $t1, $t1, 1		# tang vi tri
		j CheckType		# jump lai ve Check
	
#--------------------------------------------------------------------
#int digitDgree(int n){
#	int count = 0;
#	while(n/10 > 0){
#	     n = sumA(n);
#	     count++;
#   }
#   return count;
# }
#----------------------------------------------------------------------
	
digitDgree:
	xor $v0, $zero, $zero	# tong so count
	li $s4, 10	# gia tri 10
	while_digit:
		slt $s5, $s0, $zero
		bne $s5, $zero, in 
		div $s0, $s4	# n / 10
		mflo $t0	# thuong cua n/10
	
		beq $t0, $zero, end_while_digit	# if thuong = 0 thi jump to end_while_digit
		j sumA		# if thuong != 0 thi jump to sumA
	buoc_2:		#tiep tuc vong lap
		addi $v0, $v0, 1	# tang gia tri truong hop len
		j while_digit
	
	end_while_digit:
		jr $ra 	# jump to in

#--------------------------------------------------------------------
# int sumA(int n){
#	int sum = 0;
#	while(n != 0){
#	    int mod = n % 10;
#	    sum += mod;
#	    n = n/10;
#   }
#   return sum;
# }
#----------------------------------------------------------------------

	sumA:
		xor $s5, $zero, $zero	# gan $s5 = 0 tuyet doi
		add $t1, $s0, $zero	# gan $t1 = $s0 
	while_sum:
		div $t1, $s4
		mfhi $s6
		add $s5, $s5, $s6
		mflo $t1
		beq $t1, $zero, end_while_sum
		j while_sum
	end_while_sum:
		add $s0, $s5, $zero
		j buoc_2

error:		# bao loi nhap sai
	li $v0, 59
	la $a0, Error
	la $a1, Again
	syscall 
	
	j NHAP	# quay lai de nhap dung
		
in:				# in ket qua ra
	la $a0, Message2
    	add $a1, $zero, $v0
    	li $v0, 56

    	syscall
  
exit:
	li $v0, 10
	syscall 
	
