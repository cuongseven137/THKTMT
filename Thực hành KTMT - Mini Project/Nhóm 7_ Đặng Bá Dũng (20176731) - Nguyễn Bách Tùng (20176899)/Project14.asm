.data
  s1: .space 50					# xau s1
  s2: .space 50					# xau s2
  count_s1: .word 0:256				# mang dem so lan xuat hien cua cac chu cai trong xau s1
  count_s2: .word 0:256				# mang dem so lan xuat hien cua cac chu cai trong xau s2
  count_common_char_freq: .word 0:256		# mang luu tong so cac chu cai trung nhau cua 2 xau s1 va s2
  Message1: .asciiz  "commonCharacterCount(s1, s2) = "
  Message2: .asciiz "\n"
  Message3: .asciiz " \" "
  Message4: .asciiz " Nhap xau thu nhat:"
  Message5: .asciiz " Nhap xau thu hai:"
  errorMessage: .asciiz "Input value isn't valid!"
  
.text
string_1:					#ham yeu cau nhap xau s1
	li $v0,54         			#thuc hien lenh nhap so 54
	la $a0, Message4			#gan a0 = mess4 = 'nhap xau thu nhat :'
	la $a1, s1				#gan dia chi xau s1 vao thanh ghi a1
	li $a2, 50				#a2 la do dai toi da cua xau s1 =50
	li $t9, 0				#do dai xau s1 ban dau t9 = 0 
	syscall 
get_length_s1: 					# ham lay do dai cua xau s1
	lb $t8, s1($t9)				#luu gia tri thu t9 cua xau s1 vao t8
	beq $t8, $zero, end_get_length_s1	#neu nhu t8 bang 0 goi ham end_get_length_s1
	add $t9,$t9,1				#neu t8 khac 0 thi cong t9 len 1
	j get_length_s1				#de quy
end_get_length_s1:				#ham lay do dai cua xau s1
 	subi $s0, $t9 , 1			# s0 = t9-1 la do dai thuc te cua xau s1 do cuoi moi xau deu co dau enter
 	
string_2:					#ham yeu cau nhap xau s1
	li $v0,54				#thuc hien lenh nhap so 54	
	la $a0, Message5			#gan a0 = mess45 = 'nhap xau thu hai :'
	la $a1, s2				#gan dia chi xau s2 vao thanh ghi a1
	li $a2, 50				#a2 la do dai toi da cua xau s2 =50
	li $t9, 0				#do dai xau s2 ban dau t9 = 0 
	syscall 
get_length_s2:					# ham lay do dai cua xau s2
	lb $t8, s2($t9)				#luu gia tri thu t9 cua xau s2 vao t8
	beq $t8, $zero, end_get_length_s2	#neu nhu t8 bang 0 goi ham end_get_length_s2
	add $t9,$t9,1				#neu t8 khac 0 thi cong t9 len 1
	j get_length_s2				#de quy
end_get_length_s2:				#ham lay do dai cua xau s2
 	subi $s1, $t9 , 1			# s1 = t9-1 la do dai thuc te cua xau s2 do cuoi moi xau deu co dau enter
 	
 	li $s2, 0				# chi so i cua xau s1
 	li $s3,0				# chi so j cua xau s2
 	
count_char_s1: 					#dem so luong chu cai xuat hien trong xau 1
	slt $s4, $s2, $s0			# kiem tra xem chi so hien tai(s2) co <= do dai xau s1 (s0) khong
	beq $s4, $zero, end_count_char_s1	# neu s4 = 0 ( s2>s0) thi goi ham end_count_char_s1
	lb $s5, s1($s2)				# $s5 = s1[i]
	sub $s5, $s5, 0				# $s5 = s1[i] - 'a'	
	add $s5, $s5, $s5
	add $s5, $s5, $s5			# $s5 = 4*(s1[i] -'a') vi trong mang no moi phan tu no luu 4 byte
	lw $s6, count_s1($s5)			# $s6 = count_s1[s1[i]-'a']
	addi $s6, $s6, 1			# $s6++
	sw $s6, count_s1($s5)			# count_s1[s1[i]-'a'] = $s6d luu lai
	addi $s2, $s2, 1			# tang chi so len 1
	j count_char_s1				# tiep tuc vong lap
end_count_char_s1:				# thoat

	
count_char_s2:
	slt $s4, $s3, $s1			# kiem tra xem chi so hien tai(s2) co <= do dai xau s1 (s0) khong
	beq $s4, $zero, end_count_char_s2	# neu s4 = 0 ( s2>s0) thi goi ham end_count_char_s1
	lb $s5, s2($s3)				# $s5 = s2[j]
	sub $s5, $s5, 0				# $s5 = s2[j] - 'a'
	add $s5, $s5, $s5
	add $s5, $s5, $s5			# $s5 = 4*(s2[i] -'a') vi trong mang no moi phan tu no luu 4 byte
	lw $s6, count_s2($s5)			# $s6 = count_s1[s1[i]-'a']	
	addi $s6, $s6, 1			# $s6++
	sw $s6, count_s2($s5)			# count_s1[s1[i]-'a'] = $s6d 
	addi $s3, $s3, 1			# tang chi so len 1
	j count_char_s2				# tiep tuc vong lap
end_count_char_s2:				# thoat
	
	li $t0, 256				# so phan tu n cua mang count_common_char_freq
	li $t1, 0				# chi so i cua mang count_common_char_freq
	
count_common_char:				#ham dem so chu cai lap trong 2 xau
	slt $t2, $t1, $t0			# i< n ?
	beq $t2, $zero, end_count_common_char	# neu sai ket thuc vong lap
	add $t3, $t1, $t1
	add $t3, $t3, $t3			# $t3 = 4*i
	lw $t4, count_s1($t3)			# $t4 = count_s1[i]
	lw $t5, count_s2($t3)			# $t5 = count_s2[i]
	slt $t6, $t4, $t5			# count_s1[i] < count_s2[i] ?
	bne $t6, $zero, add_count_s1		# neu t6 = 0 thi thuc hien add_count_s1
add_count_s2:
	add $t7, $t7, $t5			# commonCharacterCount += count_s2[i]
	sw $t5,  count_common_char_freq($t3)	#count_common_char_freq[i] =  count_s2[i]
	addi $t1, $t1, 1			# i++
	j count_common_char			# de quy
add_count_s1:
	add $t7, $t7, $t4			# commonCharacterCount += count_s1[i]
	sw $t4,  count_common_char_freq($t3)	# count_common_char_freq[i] =  count_s1[i]
	addi $t1, $t1, 1			# i++
	j count_common_char			# de quy
end_count_common_char:

print:						# in tong so cac chu cai trung trong 2 xau	
	li $v0, 4				# print string			
	la $a0, Message1			#"commonCharacterCount(s1, s2) = "
	syscall
	
	li $v0, 1				# print interger				
	li $a0, 0				# gan a0 = 0
	add $a0, $a0, $t7			# a0 = a0 + t7
	syscall 
 	
 	li $t1, 0				
 print_character:				#in so lan xuat hien cua tung ki tu chung o ca hai mang
 	slt $t2, $t1, $t0			# so sanh chi so voi do dai trong mang 	count_common_char_freq	
	beq $t2, $zero, end_print_character	# neu t2 = 0 thi thuc hien end_print_character
	add $t3, $t1, $t1
	add $t3, $t3, $t3			# $t3 = 4*i
 	lw $t4, count_common_char_freq($t3)	#lay count_common_char_freq[i] gan vao t4
 	beq $t4, $zero, add_index		#neu t4 = 0 thi thuc hien add_index (tuc la ko co chu cai chung tai vi tri do ) 
 	li $v0,4				# print string	
 	la $a0, Message2			#"\n"
 	syscall
 	
 	li $v0,1				# print interger
 	li $a0, 0				# $a0 = 0
	add $a0, $a0, $t4			#$a0 = $a0 + $t4 = $a0 + count_common_char_freq[i]
	syscall
	
	li $v0, 4				# print string
	la $a0, Message3 			#" \" "
	syscall
	
	li $v0, 11				# print character
        addi $a0, $t1,0				# in chu cai
        syscall 
        
        li $v0, 4				# print string
	la $a0, Message3 			#" \" "
	syscall
add_index:
	addi $t1, $t1, 1
	j print_character			
end_print_character: