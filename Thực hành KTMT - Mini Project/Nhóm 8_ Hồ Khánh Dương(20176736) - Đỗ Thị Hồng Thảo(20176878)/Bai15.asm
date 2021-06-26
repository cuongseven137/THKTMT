# You are given an array of integers. On each move you are allowed to increase exactly one of its elements by one. 
# Find the minimal number of moves required to obtain a strictly increasing sequence from the input.  
.data
Array:	.word	
Mess1:	.asciiz "Nhap so phan tu"
Mess2: 	.asciiz "Nhap cac phan tu phan cach nhau bang dau , "
KetQua: .asciiz "Ket Qua : "
Err:	.asciiz "Loi tai vi tri : "
Again:	.asciiz "Chay lai"
string:	.space 100
DauPhay: .asciiz ",  "

.text
main:	
	la $s2, Array		# gan dia chi mang cho s2
	jal Nhap
	nop
	
	
	li $s5, 0
	sub $s0, $s0, 4
	jal Tinh
	nop
	
	j end_main
#------------------------------------------------------------
# Nhap : de nhap day so duoc ngan cach bang dau ',' , kiem tra va cho vao mang Array
# $a1 luu tru chuoi nhap vao
# $s0 luu tru dia chi A[i]
#-------------------------------------------------------------
Nhap:
	li  $v0, 54
	la  $a0, Mess2
	la  $a1, string
	la  $a2, 100
	syscall
	
	la $a1, string
	
	la $s0, Array		# gan dia chi mang cho s0
	
	li  $t0, 0		# i = 0  : con tro trong chuoi nhap vao
	
	li  $s7, 1		# co the la so am
Check:
	add $t1, $t0, $a1	# t1 tro toi vi tri String[i]
	lb  $t3, 0($t1)		# t3 = String[i]
	li  $t2, 47		# t2 = ':'
	li  $t4, 58		# t4 = '/'
	
	beq $t3, 10, end_check	# if(String[i] == '\n') end check
	beq $t3, 44, KTSA	# if(String[i] == ',') next
	beq $t3, 32, Next	# if(String[i] == ' ') next
	beq $t3, 45, So_Am	# Kiem tra so am
	
	slt $t5, $t2, $t3	# String[i] <= 9 ?
	slt $t6, $t3, $t4	# String[i] >= 0 ?
	and $t7, $t5, $t6	# 0 <= String[i] <= 9 ?
	bne $t7, 0, ADD1	# if(true) qua ADD1
	beq $t7, 0, err		# else error
ADD1:
	li  $s7, 0		# Khong the la so am
	li  $s6, 1		# Co so
	sub $t3, $t3, 1		# string[i] --
	sub $t7, $t3, $t2	# $t7 = string[i] - 47
	mul $s3, $s3, 10	# A[j] = A[j]*10
	add $s3, $s3, $t7	# A[j] += $t7
	j   Next
KTSA:
	beq $s5, 0, ADD2	# Neu khong phai so am thi them vao mang
	sub $s3, $0, $s3	# Neu la so am thi A[j] = 0-A[j]
	li  $s5, 0		# Tat co so am
ADD2:
	beq $s6, 0, err		# Neu khong co so
	sw  $s3, 0($s0)		# them A[j] vao mang
	add $s0, $s0, 4		# j++
	li  $s6, 0		# Khong co so
	li  $s7, 1		# Co the tiep theo la so am
	li  $s3, 0		# reset so nhap vao
	j   Next
So_Am:
	beq $s7, 0, err		# Neu khong the la so am thi bao loi
	li $s5, 1		# Bat co so am
	j  Next
Next:
	add $t0, $t0, 1		# i++
	j   Check
Chuyen:
	sub $s3, $0, $s3
	li  $s5, 0
end_check:
	beq $s6, 0, err		# Neu khong co so
	beq $s5, 1, Chuyen
	sw  $s3, 0($s0)		# them A[j] vao mang
	add $s0, $s0, 4		# j++
	jr  $ra			# Quay lai main

#---------------------------------------------------------
# Tinh : de tinh xem can bao nhieu lan tang 1 don vi de dat duoc mang tang tuyet doi
# 	Bang cach xet tu A[0] den A[n] va tang tung phan tu neu can thiet
#---------------------------------------------------------
Tinh: 
	slt $t0, $s2 , $s0 	# Dia chi A[j+1] > A[i] ?
	beq $t0, 0, end   	# if(false) thi ket thuc
	add $t1, $0, $0   	# reset count = 0
	lw  $t2, 0($s2)   	# $t5 = A[i]
	lw  $t3, 4($s2)		# $t6 = A[i+1]
	
	slt $t4, $t2, $t3	# A[i] < A[i+1] ? 
	beq $t4, $0, Tang 	# if(false) Tang
	add $s2, $s2, 4
	j   Tinh
Tang:
	sub $t1, $t2, $t3	# count = A[i] - A[i+1]
	add $t1, $t1, 1		# count ++
	add $t3, $t3, $t1	# A[i+1] += count
	sw  $t3, 4($s2)		# load lai A[i+1] vao mang
	add $s5, $s5, $t1	# sum += count
	add $s2, $s2, 4		# j++
	j   Tinh
end:
	li $v0, 56
	la $a0, KetQua
	add $a1, $s5, 0
	syscall
	jr  $ra
err:
	sub $s1, $s0, $s2	# s1 = A[i] - A[0]
	li  $t0, 4		
	div $s1, $t0		
	mflo $t4		# t4 = s1 / 4 : vi tri nhap sai
	add $t4, $t4, 1
	
	li $v0, 56
	la $a0, Err
	add $a1, $t4, $0 
	syscall
	j  end_main
end_main:
