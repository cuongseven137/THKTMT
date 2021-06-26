.data 
Message: .asciiz "Nhap vao gia tri"
string: .space 50
true:	.asciiz "variableName(name)= true"
false:	.asciiz "variableName(name)= false"
out: .asciiz "Out of range"	

 .text  
MAIN:	
	li	$v0, 54
	la	$a0, Message
	la	$a1, string
	la	$a2,50
	syscall 
	la	 $a0,string			# a0 = Address(string[0])    
	addi	$s5,$s5,0	
	jal	CHECK_FIRST_NUMBER
	jal 	COMPARE
	j	EXIT
	

#--------------------------------------------------------
#Procedure CHECK_FIRST_NUMBER: Kiem tra ky tu dau co phai la so hay khong
#@Param[in]	$a0	thanh ghi chua gia tri loadbyte vao cua chuoi
#@return	TRUE neu khong phai la so , nguoc lai return FALSE
#--------------------------------------------------------
CHECK_FIRST_NUMBER:
	lb	$t2,0($a0) 	#load byte ki tu dau tien cua xau vua nhap 
	li 	$s1,'0'		# gan gia tri cua $s1 == 0
	addi 	$s1,$s1,-1	# do lenh sle la so sanh less or equal nen can phai tru di 1 o thanh ghi $s1
	li	$s2,'9'		# gan gia tri cua $s2 == 9 	
	sle	$t3,$t2,$s2	# neu nhu ky tu nam trong khoang be hon 9 thi $t3==1	
	add	$s5,$s5,$t3	# Dua cac gia tri cua $t3 va luu trong $s5
	sgt	$t3,$t2,$s1	#Neu ky tu nam trong khoang lon hon 0 thi $t3==1
	add	$s5,$s5,$t3	
	beq 	$s5,2,FALSE	# so sanh voi 2 neu nhu $s5 == 2 thi co nghia la ky tu dau tien la so
	
	jr	$ra
#-------------------------------------------------------------------------------------------------------------
#Procedure COMPARE: Kiem tra ky tu dau co phai la so hay khong
#@Param[in]	$a0	thanh ghi chua gia tri loadbyte vao cua chuoi 
#@return	TRUE neu la gia tri chu , so, dau gach duoi, nguoc lai return FALSE
#-------------------------------------------------------------------------------------------------------------
COMPARE:
	li	$t2,'\n'		# khoi tao cho dau ngat dong '\n' o thanh ghi $t2
	li 	$t3,'a'			#Khoi tao cho 'a' o $t3
	addi	$t3,$t3,-1		
	li	$t4,'z'			# Khoi tao cho 'z' o $t4
	li	$t5,'A'			#khoi tao cho 'A' o $t5
	addi	$t5,$t5,-1	
	li 	$t6,'Z'			#Khoi tao cho 'Z' o vi thanh ghi $t6
	li	$t7,'_'			#Khoi tao cho '_' o vi thanh ghi $t7
	li	$t8,'0'			#Khoi tao cho '0' o vi thanh ghi $t8
	addi	$t8,$t8,-1	
	li	$t9,'9'			#khoi tao cho '9' o vi thanh ghi $t9
#-------------------------------------------------------------------------------------------------------------
	addi 	$s5,$zero,0		# khoi tao gia tri dem $s5==0
	add 	$t1,$t1,$a0		# Gán cho thanh ghi $t1 vi trí cua Massage
	addi	$t1,$t1,0		# Khoi tao vi tri ban dau xet lay gia tri cua chuoi = 0
	
loop:
	lb 	$t0,0($t1)		# doc gia tri vao thanh ghi $t0
	addi	$t1,$t1,1	
	beq	$t0,$t2,TRUE		#ket thuc vong lap neu ma da xet het cac ky tu  
#-------------------------------------------------------------------------------------------------------------
	addi 	$s5,$zero,0		# khoi tao bien dem de luu cac gia tri tra ve cua cac lenh sle va sgt
	sle 	$s1,$t0,$t4		# Kiem tra xem co thuoc khoang < 'z' hay khong luu gia tri tra ve vao $s1
	add 	$s5,$s5,$s1		# neu dung trong khoang nay thi luu gia tri tra ve cua $s1 vao $s5
	sgt 	$s1,$t0,$t3		# Kiem tra xem co thuoc khoang > 'a' hay khong luu gia tri tra ve vao $s1
	add 	$s5,$s5,$s1		# Neu dung thi tiep tuc tang $s0 len 1
	beq 	$s5,2,loop		# Neu $s5 == 2 chuyen sang xet ky tu tieps theo

	addi 	$s5,$zero,0		# Lam moi gia tri so sanh
		
	sle 	$s1,$t0,$t6		#  Kiem tra xem co thuoc khoang < 'Z' hay khong luu gia tri tra ve vao $s1
	add 	$s5,$s5,$s1		# neu dung trong khoang nay thi luu gia tri tra ve cua $s1 vao $s5
	sgt 	$s1,$t0,$t5		# Kiem tra xem co thuoc khoang > 'A' hay khong luu gia tri tra ve vao $s1
	add 	$s5,$s5,$s1		# neu dung trong khoang nay thi luu gia tri tra ve cua $s1 vao $s5
	beq 	$s5,2,loop		# Neu $s5== 2 chuyen sang xet ky tu tieps theo
			
	addi 	$s5,$zero,0		# Lam moi gia tri so sanh
		
	beq 	$t0,$t7,loop 		#kiem tra xem trong chuoi co ky tu nao la '_' hay khong
					# Neu dung la dau '_' thi chuyen sang xet ky tu tiep theo
		
	sle 	$s1,$t0,$t9		#neu nhu ky tu nam trong khoang be hon 9 thi $s1 == 1
	add 	$s5,$s5,$s1		# neu dung trong khoang nay thi luu gia tri tra ve cua $s1 vao $s5
	sgt 	$s1,$t0,$t8		# neu nhu ky tu nam trong khoang lon hon 0 thi $s1 == 1
	add 	$s5,$s5,$s1		# neu dung trong khoang nay thi luu gia tri tra ve cua $s1 vao $s5
	beq 	$s5,2,loop		# Neu $s5 == 2 chuyen sang xet ky tu tieps theo neu khong thi in ra False
	j 	FALSE	
	jr  	$ra			
	
#-------------------------------------------------------------------------------------------------------------
	
TRUE:
	la	$a0,true 		# Gan cho thong bao True de in ra man hinh;
	la	$a1,1	
	j	END			# Nhay den ket thuc luon
	
FALSE:
	la	$a0,false		# Gan cho thong bao sai
	la	$a1,0
	j	END			# Nhay den ky tu ket thuc 
		
OUT:
	la	$a0,out			# Gan cho thoong bao 
	la	$a1,4
	j	END			# Nhay den ket thuc
	
END:
	li	$v0, 55	
	syscall				# in ra show ky tu True hoac False 
	
EXIT:
