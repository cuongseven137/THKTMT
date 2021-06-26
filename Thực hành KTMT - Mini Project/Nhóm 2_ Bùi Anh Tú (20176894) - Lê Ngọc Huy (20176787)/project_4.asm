.data
nhapn: .asciiz "Nhap n: "
nhapm: .asciiz "Nhap gioi han duoi m: "
nhapM: .asciiz "Nhap gioi han tren M: "
Open: .asciiz "[ "
Close: .asciiz " ] = "
Insert: .asciiz "\nNhap cac gia tri cua mang: "
output: .asciiz "\nMang da nhap: "
output2: .asciiz "\nMax="
output3: .asciiz "\nCount = "
array: .word 0:100 # int array[100]

.text
main:
# nhap n
	la 	$a0, nhapn
	addi 	$v0, $zero, 51
	syscall
	addi	$s0, $a0, 0		       	# $s0 = n
	ble	$s0, $zero, main 		# kiem tra mang co khac 0 hay khong	
main1:
	la	$a0, nhapm
	addi 	$v0, $0, 51
	syscall
	beq 	$a1, -1, main1			# $a1 status value (if input is invalid => Re-input)
	beq 	$a1, -3, main1			# $a1 status value (if input is invalid => Re-input)
	addi $s1, $a0, 0 			# $s1 = m
	
main2:	
	la 	$a0, nhapM
	addi 	$v0, $0, 51
	syscall
	addi 	$s2, $a0, 0 			# $s2 = M
	addi 	$t6,$zero,0			# khoi tao gia tri dem so luong phan tu nam trong khoang
	bge 	$s1, $s2, main2 		# kiem tra gioi han tren co lon hon gioi han duoi hay khong
	
	jal NhapMang
	jal XuatMang
	jal end_Max
	jal Count_Element
	addi $v0, $zero, 10
	syscall
end_main:
NhapMang:
# khoi tao
	li $t3,0 #max=0
	li $t1,0 # $t1 = 0
	la $a2, array # $a2 = &array
	NhapPhanTu:
		# kiem tra so lan lap
		slt $t2, $t1, $s0		# neu t1 < s0 thi t2 = 1 else t2 = 0
		beq $t2, $zero, KetThucNhap	# neu t2 =0 thi nhay den ham KetThucNhap
		addi $v0, $zero, 51	
		la $a0, Insert
		syscall
		beq 	$a1, -1, NhapPhanTu			# $a1 status value (if input is invalid => Re-input)
	        beq 	$a1, -3, NhapPhanTu			# $a1 status value (if input is invalid => Re-input)
		sw $a0, ($a2)					# luu gia tri vao trong dia chi hien tai cua thanh ghi a2
		add $s6,$a0,$zero	
		slt $t2,$s6,$t3 				# so sanh so nguyen vua nhap voi max
		beq $t2,$zero,changmax
		slt $t2,$s6,$s1 				# so sanh so nguyen vua nhap voi m
		beq $t2,$zero,Max1			  
		# tang chi so
		addi $t1, $t1, 1
		addi $a2, $a2, 4	

		j NhapPhanTu
		# thay doi max bang so nguyen vua nhao, neu nguyen vua nhap lon hon
		changmax:
		addi $t3,$s6,0
		slt $t2,$s6,$s1				      # so sanh so nguyen voi m
		beq $t2,$zero,Max1			  
		# tang chi so
		addi $t1, $t1, 1
		addi $a2, $a2, 4

		j NhapPhanTu

KetThucNhap:	jr $ra		#ket thuc ham nhap mang
Max1:
	slt $t2,$s6,$s2 	# so sanh so nguyen vua nhap voi M
	bne $t2,$zero,cou	# neu t2 khong bang 0 thi nhay den cou
	addi $t1, $t1, 1
	addi $a2, $a2, 4	
	j NhapPhanTu
	
cou: # tang so luong neu trong khoang (m,M)
	addi $t6,$t6,  1	
	addi $t1, $t1, 1
	addi $a2, $a2, 4
	j NhapPhanTu
# Xuat
XuatMang:
	la $a0, output
	addi $v0, $zero, 4
	syscall
	la $a2, array
	addi $t1, $zero, 0

XuatPhanTu:
	# kiem tra so lan lap
	slt $t2, $t1, $s0	#neu i=n thi ket thuc ham
	beq $t2, $zero, Exit

	# xuat phan tu array[i]
	lw $a0, ($a2)
	addi $v0, $zero, 1
	syscall

	# xuat khoang trang
	addi $a0, $0, 0x20
	addi $v0, $0, 11
	syscall

	# tang i
	addi $t1, $t1, 1
	addi $a2, $a2, 4

	j XuatPhanTu
Exit: jr $ra


#	in ra gia tri max
end_Max:		
		la $a0, output2
		addi $v0, $0, 4
		syscall
		addi $a0,$t3,0
		addi $v0, $zero, 1
	        syscall
		jr $ra
#	in ra tong so cac phan tu thuoc gioi han
Count_Element:
	la $a0, output3
	addi $v0, $0, 4
	syscall
	addi $a0,$t6,0
	addi $v0, $zero, 1
	syscall
        jr $ra
 end_Count:
	
