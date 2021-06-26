#Cyclone Word (challenge) 
.data
Array:	.word
Mess1:	.asciiz	"Nhap tu : "
Err:	.asciiz "Nhap sai loai "
Again:	.asciiz	"Chay lai "
Mess2: 	.asciiz "Cyclone Word"
Mess3:	.asciiz "Not Cyclone Word"
KetQua:	.asciiz	""
string:	.space	100
.text
main:
	jal Nhap
	nop
	
	jal Kiem_Tra
	nop
	
	j   end_main
#-------------------------------------------------
# Nhap : Nhap va kiem tra cac ky tu duoc nhap vao
#	 va cho chung vao mot mang
# $s0 luu tru dia chi chu duoc nhap vao
# $s7 luu tru dia chi mang cac tu
#--------------------------------------------------
Nhap:
	li $v0, 54
	la $a0, Mess1
	la $a1, string
	la $a2, 100
	syscall			# Nhap tu
	
	la $s0, string		# $s0 giu dia chi tu nhap vao
	la $s7, Array		# $s7 giu dia chi Array[0]	
Check:
	lb  $t1, 0($s0)		# $t1 = ma Ascii cua string[i]
	beq $t1, 10, end_Check	# neu la ky tu ket thuc thi dung
	li  $t0, 96		# ky hieu truoc 'a'
	li  $t2, 123		# ky hieu sau 'z'
	slt $t3, $t0, $t1	# 'a' <= string[i] ?
	slt $t4, $t1, $t2	#  string[i] <= 'z' ?
	and $t5, $t3, $t4	# ('a' <= string[i] && string[i] <= 'z') ??
	beq $t5, 1, ADD		# if(true) thi them vao mang
	j  err			# else bao loi	
ADD:
	sw  $t1,0($s7)		# Array[i] = string[i]
	add $s7, $s7, 4		# i++  
	add $s0, $s0, 1
	j   Check		# quay lai check
end_Check:
	sub $s7, $s7, 4
	jr  $ra
#-----------------------------------------------
# Kiem Tra : check xem tu nhap vao co phai Cyclone Word hay khong
#		Bang cach kiem tra dan theo thu tu trai phai
# $s6 chay tu A[0] -> A[k]
# $s7 chay tu A[n] -> A[k]
#---------------------------------------------------
Kiem_Tra:
	la  $s6, Array
	lw  $t0, 0($s6)		# $t0 = A[0]
	lw  $t1, 0($s7)		# $t1 = A[i]
	li  $s2, 1		# $s2 = 1 ( tiep theo se xet phan tu ben trai)
	j   Compare		# so sanh $t0, $t1
Compare:
	slt $t2, $t1, $t0	# $t1 < $t0 ?
	beq $t2, 1, Not		# if($t1 < $t0) thi khong phai Cyclone Word (challenge) 
	beq $s2, 1, Left	# $s2 = 1 (xet phan tu ben trai)
	j   Right		# $s2 = 0 (xet phan tu ben phai)
Left:
	add $t0, $t1, $0	# $t0 = $t1
	add $s6, $s6, 4		# j++  chay tu trai qua phai
	beq $s6, $s7, end	# if(j = i) ket thuc
	lw  $t1, 0($s6)		# $t1 = Array[j]
	li  $s2, 0		# ( tiep theo se xet phan tu ben phai)
	j   Compare
Right:
	add $t0, $t1, $0	# $t0 = $t1
	sub $s7,$s7,4		# i --
	beq $s6, $s7, end	# if(i = j) ket thuc
	lw  $t1, 0($s7)		# $t1 = Array[i]
	li  $s2, 1		# ( tiep theo se xet phan tu ben trai)
	j Compare
end:
	li $v0, 59
	la $a0, KetQua
	la $a1, Mess2
	syscall
	jr $ra
Not: 
	li $v0, 55
	la $a0, Mess3
	syscall
	jr $ra
err: 
	li $v0, 59
	la $a0, Err
	la $a1, Again
	syscall
end_main:
