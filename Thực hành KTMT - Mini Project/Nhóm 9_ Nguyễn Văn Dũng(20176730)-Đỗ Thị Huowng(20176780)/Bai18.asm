.data
arrayA: .space 100
arrayB: .space 100
messageLength: .asciiz "\nNhap vao so luong phan tu mang:" #hien thi loi nhan
message: .asciiz "Nhap vao phan tu thu "
messageInputA: .asciiz "Nhap vao phan tu mang A\n"
messageInputB: .asciiz "Nhap vao phan tu mang B\n"
colon: .asciiz ":"
result_true: .asciiz "areSimilar(A,B)=true" #output khi mang A l� ho�n vi mang  B
result_false: .asciiz "areSimilar(A,B)=false" # ouput khi mang A kh�ng phai l� ho�n vi mang B
buffer: .space 100 #mang buffer nhap vao 1 xau --> kiem tra co phai la so
messageError: .asciiz "phan tu khong phai la so"
.text
# h�m main
# m� C
# main(){
# 	read_array(arrayA)
# 	read_array(arrayB)
# 	sort(A)
# 	sort(B)
# 	areSimilar(A,B)
#}
main: 
# hien thi loi nhac "Nhap vao so luong phan tu mang:"
	li $v0, 4 # load dich vu printf string
	la $a0, messageLength # hien thi string 
	syscall
	# nhap do d�i cua mang 
	li $v0, 8
	la $a0, buffer
	li $a1, 100
	syscall
	jal checkType
	move $s7, $s0 # luu gi� tri do d�i mang v�o thanh ghi $s7
# read arrayA
li $v0, 4
la $a0, messageInputA
syscall
la $s6, arrayA 
jal read_array # chay ham read_array luu dia chi thanh ghi pc v�o $ra

#read arrayB
li $v0, 4
la $a0, messageInputB
syscall
la $s6, arrayB
jal read_array # chay h�m read_array luu dia chi thanh ghi pc v�o $ra
#sort A

la $s0, arrayA
jal sort #chay h�m sort luu dia chi thanh ghi pc v�o $ra

# sort B
la $s0, arrayB
jal sort #chay h�m sort luu dia chi thanh ghi pc v�o $ra

# areSimilar(A,B)
jal areSimilar #chay h�m areSimilar luu dia chi thanh ghi pc v�o $ra

# exit program
li $v0, 10
syscall

# h�m read_array cac gi� tri v�o mang
read_array:
	
	sub $sp, $sp, 8
	sw $ra, 4($sp)
	
	li $t0, 0 # vi tr� i=0 cua mang 
	
	# v�ng lap nhap gi� tri c�c phan tu cua mang
	loop_read:
	
		beq $t0, $s7, end_read  #dieu kien lap i<length
		
		#hien thi loi nhan "Nhap vao phan tu thu"
		li $v0, 4
		la $a0, message
		syscall
		# hien thi thu tu phan tu dang nhap
		li $v0, 1
		move $a0, $t0
		syscall
		# hien thi dau ":"
		li $v0, 4
		la $a0, colon
		syscall
		# nhap v�o gi� tri cua phan tu array[i]					
		li $v0, 8
		la $a0, buffer
		li $a1, 100
		syscall
		
		jal checkType
		
		sw $s0, ($s6) #luu tru gi� tri v�o mang  $s0 l� dia chi phan tu array[i] cua mang
		addi $s6, $s6, 4 # tro $s0 l�n dia chi cua phan tu aray[i+1]
		addi $t0, $t0, 1 #i=i+1 phan ta tiep theo
		j loop_read # lap lai v�ng lap nhap gi� tri
end_read:
	lw $ra, 4($sp)
	jr $ra #tro lai h�m main 


# sort c�c phan tu cua mang
# m� C
#	for(int i=0; i<n; i++){
#		for(int j=i+1;j<n;j++){
#			if(array[i]<array[j]) swap
#			else noswap
#		}
#	}
sort:
	li $t1, 0 # gi� tri i
	
	loopI:
  		beq $t1, $s7 , end_sort #i < n
  		add $t2, $t1, $t1 #2i
  		add $t2, $t2, $t2 #4i
  		addi $t3, $t1, 1 # j = i+1
  		
  		loopJ:
  			add $s1, $s0, $t2 # s1 chua dia chi array[i]
  			lw $s4, ($s1) # load gi� tri array[i] v�o $s4
  			beq $t3, $s7, nextLoopI # j < n
  			add $t4, $t3, $t3 #2j
  			add $t4, $t4, $t4 #4j
  			add $s2, $s0, $t4 # s1 chua dia chi array[j]
  			lw $s5, ($s2) # load gi� tri array[i] v�o $s5
  			ble $s4, $s5, nextLoopJ # array[i] < array[j] noswap
  			sw $s4,($s2) #store gi� tri thanh ghi $s4 v�o array[j]
  			sw $s5,($s1) #store gi� tri thanh ghi $s4 v�o array[j]
  		nextLoopJ:
  			addi $t3, $t3, 1 # j = j+1
  			j loopJ # lap lai vong j
  	
  	nextLoopI:
  		addiu $t1, $t1, 1 #i = i+1
  		j loopI # lap lai vong i
end_sort:

jr $ra #ho�n th�nh h�m sort tro lai h�m main 

# h�m kiem tra xem c� phai arrayA, arrayB c� phai l� ho�n vi cua nhau
#m� C
# for(int i=0; i<n; i++){
#	if(i==n) return true
#	if(arrayA[i]!=arrayB[i]) return false 
#	}
#}
#
areSimilar:
li $t0, 0 #i
  loop:
	beq $t0, $s7, true_end # i==n return true 
	add $t1, $t0, $t0 #2i
	add $t1, $t1, $t1 #4i
	lw $s4, arrayA($t1) #s4 = value arrayA[i]
	lw $s5, arrayB($t1) #s5 = value arrayB[i]
	bne $s4, $s5, false_end # arrayA[i]!=arrayB[i] return false
	addi $t0, $t0, 1 # i=i+1
 j loop
# in ket qua areSimilar(A,B)=true
true_end:
li $v0, 55
la $a0, result_true
syscall
jr $ra # tro lai h�m main

# in ket qua areSimilar(A,B)=false
false_end:
li $v0, 55
la $a0, result_false
syscall
jr $ra #tro lai h�m main

checkType:	# kiem tra xem kieu nhap vao co dung la cac chu so khong
	li $t1, 0 # vi tri i cua ki tu trong xau
	li $s0, 0 #luu gia tri so khi chuyen tu chuoi sang so
	li $s3, 0 # xac dinh so co phai la so am
	loopCheck:
	add $t2, $a0, $t1	# Address string[i]
	lb $t3, 0($t2)		# gia tri string[i]
	
	beq $t3, 10, end_check	# string[i] = '\n' ? true thi jump
	beq $t3, 45, So_Am	# jump toi chuyen so am
	li $s1, '0'
	li $s2, '9'
	sle $t4, $s1, $t3	# string[i] >= '0' ? $t4 = 1 : 0
	sle $t5, $t3, $s2	# string[i] <= '9' ? $t5 = 1 : 0
	
	and $t6, $t4, $t5	# if '0' <= string[i] <=  '9' ? $t6 = 1 : 0
	
	addi $t1, $t1, 1	# i = i+1
	
	bne $t6, $zero, toNumber	# if $t6 = 1 jump toNumber
	beq $t6, $zero, error		# if string[i] <= '0' || string[i] >= '9' thi bi loi
	
end_check:
	beq $s3, $zero, jumpReadArray
	sub $s0, $zero, $s0
	j jumpReadArray
jumpReadArray:
jr $ra
toNumber:	
#	sum = sum * 10 + i ( i = str[i] -'0')
	sub $t7, $t3, $s1	# tru de lay gia tri so cua ki tu
	
	mul $s0, $s0, 10	# nhan tong len 
	
	add $s0, $s0, $t7	# tong ra so
	
	j loopCheck		# jump to CheckType
	
So_Am:
	bne $t1, $zero, error	# if ki tu '-' la ki tu o vi tri != 0 thi bao loi
	li $s3, 1		# thi?t l?p c? b�o s? �m
	add $t1, $t1, 1		# tang vi tri
	j loopCheck		# jump lai ve 
error:
li $v0, 4
la $a0, messageError
syscall
li $v0, 10
syscall
