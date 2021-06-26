# de bai: Write a program that input some variable names. 
#Check if variable names consist only of English letters, digits and underscores and they can't start with a digit.

.data 

    string:     .space   500 				# do dai cua xau
    Message1:       .asciiz "Nhap xau:" 		# chuoi yeu cau nhap xau vao	
    Message2:   .asciiz "variableName(name) = " 	# chuoi dua ra ket qua
    False: 	.asciiz "false"				# ket qua tra ve khi ten kieu bi sai
    True:	.asciiz "true"				# ket qua tra ve khi ten kieu dung
    ERROR:	.asciiz "Khong nhap gi!\n"
    Again:	.ascii "Yeu cau nhap lai!!!"
.text 

main:
	jal NHAP					# di vao ham "Nhap"
	nop
	jal TEST					# di vao ham "TEST"
	nop
exit:
	li $v0, 10					# ket thuc chuong trinh
	syscall 
end_main:

	#slt 

NHAP:
	la $a0, Message1				#-----------------------------------------------------
    	la $a1, string					#for C
    	la $a2, 50					#printf("Nhap xau:"); <-> $a0, Message1
    	li $v0, 54					#scanf("%s", string); <-> $a1, string
    	syscall						#jr $ra <-> quay lai main:
    	jr $ra						#------------------------------------------------------
    	
TEST:
	la   $a0, string        # a0 = Address(string[0])
	add $s7, $ra, $zero 
	jal CHECK		# di vao ham "CHECK"
	nop
	add $ra, $s7, $zero
	jr $ra			# quay lai exit de ket thuc chuong trinh
CHECK:
	li $s5, 47		#------------------------------------------------------
	li $s6, 58		# Gan cac gia tri ASCCI
	li $s1, 64		# $s5, 47 (la gia tri HEXA dang truoc gia tri cua '0')
	li $s2, 91		# $s6, 58 (gia tri HEXA sau '9'), $s1 = 64, $s2 = 91( HEXA truoc 'A' va sau 'Z'
	li $s3, 96		# $s3 = 96 va $s4 = 123 (HEXA truoc 'a' va sau 'z'
	li $s4, 123		#-------------------------------------------------------
	xor  $v0, $zero, $zero  # v0 = length = 0               
    	xor  $t0, $zero, $zero  # t0 = i = 0 
	check_string0:
		add $t1, $a0, $t0	#-----------------------------------------------------------------
		lb $t2, 0($t1)		# Form C: if(string[0] > 47 && string[0] < 58)
		beq $t2, $zero, error	#
		slt $t3, $t2, $s6	#		jump for:
		slt $t4, $s5, $t2	#	else jump false (tra ve loi ten bien)
		and $t5, $t3, $t4	#
		bne $t5, $zero, false	#-----------------------------------------------------------------
#-----------------------------------------------------------------
# while(string[i] != '\n'){
#	if(string[i] == '-')
#		jump false
#	if((string[i] > 64 && string[i] < 91)
#	|| (string[i] > 96 $$ string[i] < 123)
#	|| string[i] == 95){
#	   i++;	
#	}else jump false
#}
	while:				
		add $t1, $a0, $t0	# address string[i]	
		lb $t2, 0($t1)		# gia tri cua string[i]
				
		beq $t2, 10, end_while	# if string[i] == '\n' thi ket thuc vong lap
				
		beq $t2, 45, false	# if string[i] = '-' thi bi false
	
		slt $t3, $t2, $s2	#-----------------------------------------------------------------
		slt $t4, $s1, $t2	# if (string[i] > 'A' && string[i] < 'Z') ? $t5 = 1 || 0 (1)
		and $t5, $t3, $t4	#-----------------------------------------------------------------
				
		slt $t3, $t2, $s4	#-----------------------------------------------------------------
		slt $t4, $s3, $t2	# if (string[i] > 'a' && string[i] < 'z') ? $t6 = 1 || 0 (2)
		and $t6, $t3, $t4	#-----------------------------------------------------------------
				
		beq $t2, 95, gan	# if string[i] == '_' thi jump gan (3)
	tieptuc:			
		or $t6, $t5, $t6	#-----------------------------------------------------------------
		or $t6, $t6, $t3	# if( (1)||(2)||(3) ) ? $t6 = 1 || 0
		beq $t6, $zero, false	# if $t6 == 0 ( string[i] nam ngoai chu cai va '_' thi sai )
		addi $t0, $t0, 1	# i = i + 1
		j while			# jump lai while
		
	gan:
		li $t3, 1		# gan $t3 = 1
		j tieptuc		# jump toi 'tieptuc' cua 'while'
	
	end_while: 			# if khong xuat hien ki tu sai thi dua ra man hinh 'True'
		li $v0, 59
		la $a0, Message2
		la $a1, True
		syscall
		jr $ra
	false:				# dua ra bi sai khi gap ki tu sai
		li $v0, 59
		la $a0, Message2
		la $a1, False
		syscall 
		j exit
	error:				# bao loi chuong trinh vao yeu cau nhap lai
		li $v0, 59
		la $a0, ERROR
		la $a1, Again
		syscall 
	
		j main	

