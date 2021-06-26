.data
	string: .space 10
	Message1: .asciiz "Nhap xau:"
	Message2: .asciiz "Do dai la "
	TRUE: .asciiz "Ket qua la: TRUE"
	FALSE: .asciiz "Ket qua la: FALSE"

.text
#is_cyclone_phrase
#is_cyclone_phrase("adjourned") # => True
#is_cyclone_phrase("settled") # => False
main:
	get_string: 
		li $v0, 54
		la $a0, Message1
		la $a1, string
		la $a2, 100
		syscall
	
	jal get_length_of_string
	nop
	
	jal is_cyclone_phrase
	nop
	
	li $v0,10 			# exit
	syscall
end_main:

	# ham tim do dai cua xau nhap vao
	get_length_of_string:
	li $s1,10 			# ma ascii cua ki tu xuong dong 
		
	get_length:
		la $a0,string 		# a0 = Address(string[0])
		add $s5,$0,$a0
		xor $s0,$zero, $zero 	# s0 = length = 0
		xor $t0,$zero, $zero 	# t0 = i = 0
		
	check_char:
		add $t1,$a0, $t0 	# t1 = a0 + t0
		lb $t2, 0($t1) 		# t2 = string[i]
		beq $t2,$s1,end_of_str 
		addi $s0, $s0, 1 	# s0=s0+1->length=length+1
		addi $t0, $t0, 1 	# t0=t0+1->i = i + 1
		j check_char
		
	end_of_str:
	
	end_of_get_length:
	jr $ra


#thuc hien thuat toan
# y tuong: Xay dung mot day so gom cac chi so cyclone
# for(i=0;i<=n/2-1;i++) {luu 2 gia tri (i,(n-1)-i}
# neu n-1 chan thi them phan tu (n-1)/2 con khong thi thoi 
# VD length =9 thi day so la a=[0,8,1,7,2,6,3,5,4]
# Sau do se so sanh cac string[a[i]] va string[a[i+1]]
# string[a[i]]>string[a[i+1]] false else true


	is_cyclone_phrase:
		#init value
		
		div $t1,$s0,2
		add $t1,$t1,-1  		# n/2-1
		addi $s0,$s0,-1 		# length = length -1
		li $t0,0 			# i=0
		la $a0,0x1001005c 		# dia chi cua mang
		add $t2,$0,$a0 			# $t2 cung luu dia chi co so cua mang
		
		loop:
			bgt $t0,$t1,end_loop 	#if i>(n/2-1) re nhanh
			
			add $t3,$0,$t0
			sw $t3,4($t2)		# luu gia tri cua i
			  
			sub $t4,$s0,$t0  
			sw $t4,8($t2)		# luu gia tri cua (n-1)-i

			add $t0,$t0,1		# i++
			add $t2,$t2,8		# tang gia tri dia chi len 8
			
			j loop
		end_loop:
		
	li $t7,2
	div $s0,$t7  				# tinh div (length-1),2
	mfhi $t5				# lay so du
	
	beqz $t5,even  
	beq $t5,1,odd


	even:
		mflo $t6
		sw $t6,4($t2) 			# neu n=9 thi day so la 0,8,1,7,2,6,3,5,4

	odd:					#neu n=8 thi day so 0,7,1,6,2,5,3,4



	# $s5 luu dia chi co so cua string
	add $t2,$a0,4  				# dia chi mang chi so
	li $t0,0 				# i=0
	
	loop2:
	
		bge $t0,$s0,end_loop2
	
		lw $t1,0($t2)  			# lay chi so a[i]
		lw $t3,4($t2)  			# lay chi so a[i+1]
	
		add $t4,$s5,$t1
		lb $t4,0($t4) 			# string[a[i]]

		add $t5,$s5,$t3 
		lb $t5,0($t5) 			# string[a[i+1]]


		bgt $t4,$t5,false
	
		add $t0,$t0,1 			#i++
		add $t2,$t2,4 			#tang dia chi co so cua mang chi so

		j loop2
	
	end_loop2:

true:
	li $v0,55
	la $a0,TRUE
	li $a1,1
	syscall
	j exit

false:
	li $v0,55
	la $a0,FALSE
	li $a1,1
	syscall
	j exit

exit:
	jr $ra
