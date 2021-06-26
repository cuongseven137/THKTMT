.data
TRUE: .asciiz "Ket qua la: TRUE"
FALSE: .asciiz "Ket qua la: FALSE"
slpt: .asciiz "So luong phan tu cua mang:"
element: .asciiz "Nhap phan tu:"
err: .asciiz "Chuong trinh bi loi nhap lieu"
#$s5 luu ket qua cua bai toan . Quy uoc true =1, false =0
# [1, 3, 2, 1] returns 0
# [1, 3, 2] returns 1
# [1, 2, 1, 2] returns 0
# [1, 4, 10, 4, 2] returns 0
# [10, 1, 2, 3, 4, 5] returns 1
# $s7 luu dia chi cua mang
#$s0 luu so phan tu cua mang
#$s1 luu gia tri cua bien count
#$t0 luu gia tri bien chay i
#$t2 luu dia chi cua A[i]
#$t3 luu gia tri cua A[i]
#$t4 luu dia chi, gia tri cua A[i+1]
#$t5 luu dia chi,gia tri cua A[i-1]
#$t6 luu gia tri cua n-2
#$t7 luu gia tri cua A[i+2]
.text
main:
	la $s7,0x10010060		# dia chi co so cua mang
	li $v0,51
	la $a0,slpt
	syscall
	add $s0,$0,$a0			# so luong phan tu
	li $t0,0
	
	input:
	beq $t0,$s0,end_input
	sll $t2,$t0,2
	add $t1,$s7,$t2  		# chua dia chi cua a[i]
	
	li $v0,51
	la $a0,element
	syscall
	
	bnez $a1,error 			# neu $a1 !=0 error
	
	sw $a0,0($t1) 			# luu gia tri cua a[i]
	
	add $t0,$t0,1 			# i++
	
	j input
	end_input:

#init value
la $a0,0($s7)
li $s1,0  		# count = 0
li $t0,0 		# i=0
addi $s0,$s0,-1 	# n-1

jal almostIncreasingSequence
nop

li $v0,10 		# exit
syscall

	almostIncreasingSequence:
	loop:
	beq $t0,$s0,done 			#i=n-1 thi re nhanh
		if:
		# load a[i]
		add $t2,$t0,$t0
		add $t2,$t2,$t2 		# $t2 = 4*i
		add $t2,$t2,$a0 
		lw $t3,0($t2)    		# a[i]
		#load a[i+1]
		add $t4,$t2,4 			# $t4= $t2+4
		lw $t4,0($t4)  			# a[i+1]
		
		blt $t3,$t4,end_if  		# a[i]<a[i+1] end_if 
		
		add $s1,$s1,1 			# count++
		
		blt $t0,1,end_if 		# i<1 end_if
		
		#load a[i-1]
		add $t5,$t2,-4 			# chua dia chi cua a[i-1]
		lw $t5,0($t5) 			# a[i-1]
		
		blt $t5,$t4,end_if  		#a[i-1]<a[i+1]
		
		add $t6,$s0,-1 			# n-2
		ble $t6,$t0,end_if 		# n-2<=i thi end_if
		
		#load a[i+2]
		add $t7,$t2,8 			# chua dia chi cua a[i+2]
		lw $t7,0($t7) 			# a[i+2]
		
		blt $t3,$t7,end_if 		# a[i]<a[i+2] thi end_if
		j false
		
		end_if:
		
	add $t0,$t0,1  				#i=i+1
	j loop
	end_loop:  
	done: 
		bgt $s1,1,false			#if count>1 return false

	true:  
		la $a0,TRUE
		li $v0,55
		li $a1,1			# information message
		syscall
		j exit

	false:
		la $a0,FALSE
		li $v0,55
		li $a1,1			# information message
		syscall
		j exit

	exit:
		jr $ra

error:
	la $a0,err
	li $v0,55
	li $a1,0	#error message
	syscall
	
	li $v0,10 	#exit
	syscall
