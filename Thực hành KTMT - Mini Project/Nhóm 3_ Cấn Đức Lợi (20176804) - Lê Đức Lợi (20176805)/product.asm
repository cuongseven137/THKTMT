.data
	A:  		.word 50 	
	Input_mess:	.space 1000	# Luu xau sau khi them so thu tu cua mang vao xau
	Input: 		.asciiz		"Nhap vao so phan tu cua mang: "
	Input_array:	.asciiz		"Nhap vao phan tu thu "
	Message1: 	.asciiz		"\nTich lon nhat cua hai phan tu "
	Message2: 	.asciiz		" va "
	Message3: 	.asciiz		" trong mang la: "
	Output:		.asciiz		"Cac phan tu trong mang la: "
	Colon:		.asciiz		" "
	Error1_1:	.asciiz 	"Tich cua hai so "
	Error1_2:	.asciiz		" qua lon."
	Error2:		.asciiz 	"So nhap vao qua lon."
	Error3:		.asciiz 	"So nhap vao sai dinh dang."
.text
	li $a2, 2147483647	# gioi han so lon nhat co the
main:	
	li $v0, 51		# Nhap so phan tu cua mang
	la $a0, Input
	syscall
	bne $a1, $zero, error4	# Neu so vua nhap vao sai dinh dang thi hien thi loi.
	add $t1, $zero, $a0	# luu so phan tu cua mang A vao $t1
	jal input		# Nhay den procedure nhap tung phan tu vao mang
	jal find		# Bat dau tim kiem

output:
	jal 	output		# In cac phan tu cua mang ra man hinh.	 
	li $v0, 4		# Hien thi ket qua tich lon nhat
	la $a0, Message1	
	syscall	
	li $v0, 1		# Hien thi phan tu thu nhat
	add $a0, $0, $s1	
	syscall
	li $v0, 4		
	la $a0, Message2	
	syscall
	li $v0, 1		# Hien thi phan tu thu hai
	add $a0, $0, $s2	
	syscall
	li $v0, 4		
	la $a0, Message3	
	syscall
	li $v0, 1		
	add $a0, $0, $v1	
	syscall
end_main:
	li $v0, 10		# Ket thuc chuong trinh
	syscall

#-----------------------------------------------------------------
# main
# @brief Tim gia tri lon nhat cua 2 phan tu ke nhau trong mang A.
# @param[in] a0 Luu dia chi co so cua mang A.
# @param[in] a1 Luu so phan tu cua mang A.
# @param[in] a2 Luu tich lon nhat co the.
# @param[out] v0 Luu gia tri tich lon nhat da tim duoc.
#-----------------------------------------------------------------
# Procedure input
# function: Nhap vao cac phan tu cua mang.
# Neu phan tu nhap vao qua lon hoac sai dinh dang se dua ra loi.
#-----------------------------------------------------------------
# Procedure find
# function: Tim gia tri lon nhat cua tich 2 phan tu ke nhau trong mang A
# voi dia chi co so cua mang A luu trong $a0, so phan tu cua mang A luu 
# trong $a1.
# Neu tich hai so vuot qua tich lon nhat thi in thong bao loi ra man hinh 
# va thoat chuong trinh. Neu khong, dua ra ket qua cuoi cung.

# Nhap vao cac phan tu cua mang
input: 
	add 	$t0, $zero, 0		# khoi tao $t0 luu gia tri bien chay i = 0.
input_loop:
	beq 	$t0, $t1, done_input	# Khi i = so phan tu cua mang A thi done
	j	copy_string
mess_appear:
	li 	$v0, 51
	la 	$a0, Input_mess+100
	syscall 
	bne	$a1, $zero, error3	# Neu so vua nhap vao sai dinh dang thi hien thi loi.
	la 	$a3, A			# Load dia chi co so cua mang A de luu gia tri nhap vao.
	sll 	$t2, $t0, 2 		# Luu 4i vao $t2.
	add 	$t3, $t2, $a3 		# Luu dia chi A[i] vao $t3.
	sw	$a0, 0($t3)		# Luu gia tri A[i] vao bo nho.
	addi	$t0, $t0, 1		# Tang bien nhay len 1.
	j 	input_loop
done_input:
	jr	$ra
copy_string:				# Copy so thu tu vao trong loi nhan.
	addi 	$t0, $t0, 1
	la 	$t7, Input_mess		# Load vi tri xau vao thanh ghi
	la 	$t8, Input_array
	addi 	$t9, $t0, 48		# Chuyen integer sang charcode	
copy_Input_arrray:
	add 	$s0,$zero,$zero 	# s0 = i=0
L1:
	add 	$t2,$s0,$t8 		# t2 = s0 + t8 = i + Input_array[0]
 					# = address of Input_array[i]
	lb 	$t3,0($t2) 		# t3 = value at t2 = Input_array[i]
	add 	$t4,$s0,$t7 		# t4 = s0 + t7 = i + Input_mess[0]
 					# = address of Input_mess[i]
	sb 	$t3, 100($t4) 		# Input_mess[i]= t3 = y[i]
	beq 	$t3,$zero,end_of_copy_Input_array 	# if Input_array[i]==0, exit
	nop
	addi 	$s0,$s0,1 		# s0=s0 + 1 <-> i=i+1
	j 	L1 			# next character
	nop
end_of_copy_Input_array:
copy_STT:	
	add 	$s1,$zero,$zero 	# s1 = j=0
L2:
	add 	$t5,$s1,$t0 		# t5 = s0 + t0 = charcode
 					# = address of charcode
	add 	$s3,$s0,$t7 		# s3 = s0 + t7 = i + Input_mess[0]
 					# = address of Input_mess[i]
	sb 	$t9,100($s3) 		# Input_array[i]= t9 = charcode
end_of_copy_STT:
	addi	$t0, $t0, -1
	j	mess_appear
# In cac phan tu cua mang ra man hinh
output:
	li 	$v0, 4		
	la 	$a0, Output	
	syscall	
	add 	$t0, $zero, 0		# khoi tao $t0 luu gia tri bien chay i = 0.
loop_output:
	beq 	$t0, $t1, done_output	# Khi i = so phan tu cua mang A thi done
	li 	$v0, 51
	la 	$a3, A			# Load dia chi co so cua mang A de luu gia tri nhap vao.
	sll 	$t2, $t0, 2 		# Luu 4i vao $t2.
	add 	$t3, $t2, $a3 		# Luu dia chi A[i] vao $t3.
	lw	$a0, 0($t3)		# Luu gia tri A[i] vao bo nho.
	li $v0, 1			
	syscall
	li $v0, 4
	la $a0, Colon
	syscall
	addi	$t0, $t0, 1		# Tang bien nhay len 1.
	j 	loop_output
done_output:
	jr	$ra
# Tim tich lon nhat
find: 
	addi 	$v1, $zero, -2147483647	# khoi tao gia tri tich lon nhat.
	addi 	$t0, $zero, 0		# khoi tao $t0 luu gia tri bien chay i = 0.
	subi	$t8, $t1, 1		# $t8 luu gia tri lon nhat cua bien nhay
	la 	$a0, A			# luu dia chi phan tu dau tien cua mang A vao $a0
loop: 		
	beq 	$t0, $t8, done_find	# Khi i = so phan tu cua mang A thi done
	sll 	$t2, $t0, 2 		# Luu 4i vao $t2.
	add 	$t3, $t2, $a0 		# Luu dia chi A[i] vao $t3.
	lw  	$t4, 0($t3)		# Luu gia tri A[i] vao $t4.	
	lw  	$t5, 4($t3)		# Luu gia tri A[i+1] vao $t5.
	mul	$t6, $t4, $t5		# Tinh A[i] * A[i+1]
	mfhi	$t9
	slt	$t7, $zero, $t9		# Xet xem thanh ghi $hi co luu gia tri hay khong
	bne	$t7, $zero, too_max	# Neu dung thi nhay den nhan too_max
	slt	$t7, $t6, $v1		# Neu $t6 < $v0 thi $t7 = 1 hay tic lon nhat tich luy van duoc bao toan
	beq	$t7, $zero, modify	# Neu $t9 = 0 thi $t8 > $v0 -> can cap nhat
	addi	$t0, $t0, 1		# Tang buoc nhay i len 1.
	j	loop
done_find:
	jr	$ra
modify:
	add 	$s1, $0, $t4		# Luu lai 2 phan tu co tich lon nhat
	add	$s2, $0, $t5
	add 	$v1, $zero, $t6		# $v0 = $t8.
	addi	$t0, $t0, 1		# Tang buoc nhay i len 1.
	j	loop
error2: 
	li 	$v0, 55			# Hien thi loi so nhap vao qua lon.
	la 	$a0, Error2	
	syscall
	j	input_loop		# Nhap lai.
error3:
	li 	$v0, 55			# Hien thi loi so nhap vao aai dinh dang.
	la 	$a0, Error3	
	syscall
	j	input_loop		# Nhap lai.
error4:
	li 	$v0, 55			# Hien thi loi so nhap vao aai dinh dang.
	la 	$a0, Error3	
	syscall
	j	main			# Nhap lai.
too_max:
	li 	$v0, 4			# Hien thi loi tich qua lon.
	la 	$a0, Error1_1	
	syscall
	li $v0, 1			# Hien thi phan tu thu nhat
	add $a0, $0, $t4	
	syscall
	li $v0, 4		
	la $a0, Message2	
	syscall
	li $v0, 1			# Hien thi phan tu thu hai
	add $a0, $0, $t5	
	syscall
	li $v0, 4		
	la $a0, Error1_2	
	syscall
