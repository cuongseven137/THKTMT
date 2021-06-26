.data
	Ten: .byte 0x0A 			# Ten =10
.text
main:
	li $s5,0  				# result
	lb $t0,Ten				# $t0 =10 
	
	input:	
		li $v0,5
		syscall
		add $s0,$0,$v0  		# $s0 luu gia tri nhap vao

	jal digitDegree
	nop

end_main:

digitDegree:
	#ham check dung de xem number <10 hay chua
	check:
		blt $s0,10,print_result
		add $s5,$s5,1
		j sum_of_digit

	#ham print_result de in ra ket qua
	print_result:
		li $v0,1
		add $a0,$s5,$0
		syscall
		
		done:
			li $v0,10
			syscall
	
	#ham sum_of_digit dung de tinh tong cac chu so 
	sum_of_digit:
	li $s1,0	# khoi tao sum=0
	add $t2,$s0,$0
		while:
			div $t2,$t0
			mfhi $t1 	#du
			mflo $t2 	#thuong
			add $s1,$s1,$t1
			beqz $t2,end_sum_of_digit
			j while

	end_sum_of_digit:
	
	add $s0,$s1,$0 			#cap nhat lai number = tong cac chu so cua no
	j check

	exit:
	jr $ra
