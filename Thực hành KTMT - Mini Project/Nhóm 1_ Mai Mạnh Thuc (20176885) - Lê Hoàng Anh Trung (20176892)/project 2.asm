# $s0 = N, $s1 = M, $s2 = i, $s3 = j, $s4 = flag
.data
Num1: .asciiz "Enter lower bound of the interval: "
Num2: .asciiz "Enter upper bound of the interval: "
Message: .asciiz "Do you want to continue printing?"
GoAgain: .asciiz "Would you like to enter another ?"
a: .asciiz "\t"
b: .asciiz "\n"
error1: .asciiz "Enter the value greater than 0!"
error2: .asciiz "Enter upper bound greater than lower bound!"
error3: .asciiz "Enter the integer value greater than 0!"

.text
#----------------------------------------------------------------------------
# input1, input2: Nhap khoang kiem tra
# error_input: loi input nho hon 0
# error_input_2: loi upper be hon lower
# check_var_type:
# error1: Check input type
#----------------------------------------------------------------------------
main:
li $v0, 4				#	
la $a0, b				#
syscall					# Enter xuong dong

li $s7, 0				# count = 0

input1:
	la $a0, Num1  
    	li $v0, 51
    	syscall 			# get the user input.
    	jal check_var_type		# check type input
    	add $s0, $a0, $0		# Assign N
    	addi $t1, $0, 1			# var type check error
	slt $t0, $0, $s0		# neu gia tri nhap vao <= 0 => jump input1
	bne $t0, 1, error_input		

input2:	la $a0, Num2
    	li $v0, 51
    	syscall 			# get the user input.
    	jal check_var_type		# check type input
	add $s1, $a0, $0		# Assign M
	slt $t0, $0, $s1		# neu gia tri nhap vao < 0 => jump input2
	bne $t0, 1, error_input			
	slt $t0, $s0, $s1		# Check upper greater than lower?
	bne $t0, 1, error_input_2
	add $s2, $0, $s0		# i = N
	
	jal check_prime_number		# Nhay den ham kiem tra so nguyen to
	j end_program
error_input:
	li $v0, 55
	la $a0, error1
	syscall 			# In thong bao loi input <0
	beq $t1, 1, input2			
	j input1
error_input_2:
	li $v0, 55
	la $a0, error2
	syscall				# In thong bao loi upper be hon lower
	j input2

check_var_type:
	beq $a1, -1, error_1		#
	beq $a1, -2, end_program	#
	beq $a1, -3, error_1		#
	jr $ra				# Check loi input
	error_1:
		li $v0, 55
		li $a1, 0
		la $a0, error3
		syscall			# In thong bao
		beq $t1, 1, input2
		j input1
#----------------------------------------------------------------------------
# for_1, for_2: Dung vong lap duyet tung so tu N->M de tim so nguyen to
# for( i = N; i <= M; i++){
# 	if(i==1 || i==0) continue;
# 	flag = 1;
# 	for( j = 2; j < i/2; j++)
#		if(i%j == 0) {flag = 0; break;}  // Tìm uoc cua cac i
# 	if(flag ==1) print(i);		  // Neu khong co uoc, flag = 1 la so nguyen to, in ra i 
# }
#----------------------------------------------------------------------------

check_prime_number:
for_1:
	slt $t0, $s1, $s2		#
	bne $t0, $0, end_for_1		# Neu i > M ket thuc vong lap 1
	beq $s2, 1, end_for_2     	# Neu i = 1 thi tang i
	addi $s3, $0, 2			# j = 2
	addi $t9, $0, 2			# Bien tam k = 2
	div $s2, $t9			# 
	mflo $s5			# $s5 = i div 2
	addi $s4, $0, 1			# set flag = 1
	
	for_2:
		slt $t1, $s5, $s3	#
		bne $t1, 0, end_for_2	# Neu j > i/2 ket thuc vong lap 2, tang i
		div $s2, $s3		#
		mfhi $t2		# $t2 = i mod 3
		beq $t2, $0, push	# Neu $t2 = 0 -> i co thuong nen ko phai so nguyen to  
		addi $s3, $s3,1		# j++
		j for_2
	print:
		beq $s7, 51, continue_printing	# Kiem tra bien count, count > 50 dung in, thoat chuong trinh
		add $a0, $s2, $0	#
		li $v0, 1		# 
		syscall			# In so nguyen to
		li $v0, 4		#
		la $a0, a		#
		syscall			# Dau tab
		addi $s7, $s7, 1	# count ++
		
		addi $s2, $s2, 1	# i++
		j for_1
	push:	# gan flag = 0
		add $s4, $0, $0		# flag = 0
		addi $s2, $s2, 1	# i++
		j for_1
	end_for_2: #quay lai vong lap 1
		beq $s4, 1, print	# Neu flag = 1, in so nguyen to
		addi $s2, $s2, 1	# i++
		j for_1
end_for_1: #ket thuc chuong trinh
	la $a0, GoAgain
	li $v0, 50
	syscall				# In thong bao hoi co muon tiep tuc thuc hien lai chuong trinh
	beq $a0, 0, main		
	jr $ra

continue_printing:
	la $a0, Message
	li $v0, 50
	syscall				# In thong bao co tiep tuc in so nguyen to neu in qua 50
	beq $a0, 0, reset		# Kiem tra Yes/No/Cancel
	j end_for_1
reset:	
	add $s7 , $0, $0		# Reset bien count
	li $v0, 4			#	
	la $a0, b			#
	syscall				# Enter xuong dong
	j print
end_program:
	li $v0, 10
	syscall				# Ket thuc chuong trinh
