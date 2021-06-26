.data
A: .space 100
B: .space 100
size: .asciiz "Nhap so luong phan tu cua mang: " # hien thi loi nhan nhap so luong phan tu cua mang
message: .asciiz "\nNhap phan tu thu "
colon: .asciiz ":" # hien thi dau :
messageA: .asciiz "Nhap vao mang A\n" # hien thi loi nhan
messageB: .asciiz "Nhap vao mang B\n"  #hien thi loi nhan
true: .asciiz "areSimilar(A,B)=true" # hien thi mang A va mang B la hai mang tuong tuong
false: .asciiz "areSimilar(A,B)=false" # hien thi mang A va mang B khong la hai mang tuong duong
loinhan: .asciiz "nhap sai,moi ban nhap lai\n"
xau: .space 100
.text
#------------------------------------------------------------
# thuat toan cua ham main theo ma C
# main(){
# 	read_array(A) # doc vao mang A
# 	read_array(B) # doc vao mang B
# 	sort_array(A) # sap xep mang A
# 	sort_array(B) # Sap xep mang B
# 	areSimilar(A,B) # check two arrays are similar ?
#}
#-------------------------------------------------------------
main: 
        # hien thi loi nhan "Nhap so luong phan tu cua mang:"
	li $v0, 4      # load dich vu printf string
	la $a0, size   # hien thi string 
	syscall 
	# nhap length(array)
	li $v0, 8        # load dich vu read string
	la $a0, xau      # a0 chua dia chi mang xau
	li $a1, 100      # danh trong bo nho khoang 100 phan tu
	syscall
	jal checkNumber    #nhay jum and link de kiem tra xem du lieu vua nhap co la so nguyen khong
	beq $s7, 1, main   # meu s7=1 thi nhay ve main,yeu cau nhap lai
	move $s6, $s4      # luu gia tri n vao thanh ghi $s6
	
# read_array(A) 
la $s0, A        # luu dia chi mang A vao thanh ghi $s0
li $v0,4
la $a0,messageA  # hien thi loi nhan nhap vao mang A
syscall
jal read_array   # chay ham read_array luu dia chi thanh ghi pc vao $ra

#read_array(B) 
la $s0, B         # luu dia chi mang B vao thanh ghi $s0
li $v0,4
la $a0,messageB   # hien thi loi nhan nhap vao mang B
syscall
jal read_array    # chay ham read_array luu dia chi thanh ghi pc vao $ra

#sort_array( A)
la $s0, A         #luu dia chi mang A vao thanh ghi $s0
jal sort_array   #chay ham sort_array luu dia chi thanh ghi pc vao $ra
# sort B
la $s0, B         #luu dia chi mang B vao thanh ghi $s0
jal sort_array    #chay ham sort_array luu dia chi thanh ghi pc vao $ra
# areSimilar(A,B)
jal areSimilar    #chay ham areSimilar(A,B) luu dia chi thanh ghi pc vao $ra
# thoat chuong trinh
li $v0, 10
syscall

# ham doc cac mang
read_array: li $t0, 0#i=0
	
	    sub $sp, $sp, 4 #tao 1 vi tri cho stack
	    sw $ra, 0($sp)  # luu gia tri cua thanh ghi $ra vao stack
	
	loop_read:          # vong lap nhap gia tri cua phan tu cua mang
		
	        slt $t1,$t0,$s6           # $t1= i<n?1:0
		beq $t1, $zero, end_read  # if i>n branh to end_read
		
		#hien thi loi nhan "Nhap phan tu thu"
		li $v0, 4 
		la $a0, message
		syscall
		# hien thi thu tu phan tu dang nhap
		
		li $v0, 1   
		move $a0, $t0 #luu gia tri thu tu phan tu mang vao thanh ghi $a0
		syscall
		
		# hien thi dau ":"
		li $v0, 4   
		la $a0, colon
		syscall
		
		# nhap vao gia tri cua phan tu array[i]					
		li $v0, 8     #load dich vu read string
		la $a0, xau   # a0 chua dia chi cua mang xau
		li $a1, 100
	        syscall
		jal checkNumber         #kiem tra gia tri vua nhap co phai là so khong
                beq $s7, 1, loop_read  # neu s7=1 thi lap lai vong lap,yeu cau nhap lai
                sw $s4, ($s0)          # luu gia tri cua thanh ghi s4 vao mang,s4 luu gia tri so khi chuyen tu chuoi sang so
	        addi $s0, $s0, 4 #  $s0 tro den dia chi cua phan tu tiep theo a,rray[i+1]
		addi $t0, $t0, 1 #i=i+1
		j loop_read # lap lai vong lap loop_read
end_read:
lw $ra, 0($sp)      #load gia tri dau stack vao thanh ghi $ra
jr   $ra            # tro lai ham main
#-----------------------------------------------------------------------
checkNumber:	  # kiem tra xem kieu nhap vao co dung la cac chu so khong
	li $s7, 0 # thiet lap co de kiem soat loi
	li $t9, 0 # vi tri i cua ki tu trong xau
	li $s4, 0 #luu gia tri so khi chuyen tu chuoi sang so
	li $s3, 0 # xac dinh so co phai la so am
	loopCheck:
	add $t2, $a0, $t9	# t2 chua Address string[i]
	lb $t3, 0($t2)		# t3 chua gia tri string[i]
	
	beq $t3, 10, endcheck	# kiem tra xem string[i] = '\n' ? if true then jump endcheck
	beq $t3, 45, SoAm	# kiem tra xem string[i] co la so am? jump toi chuyen so am
	li $s1, '0'            #gan gia tri 0 cho s1
	li $s2, '9'            #gan gia tri 9 cho s2
	sle $t4, $s1, $t3	# kiem tra xem string[i] >= '0' ? $t4 = 1 : 0
	sle $t5, $t3, $s2	# kiem tra xem string[i] <= '9' ? $t5 = 1 : 0
	
	and $t1, $t4, $t5	# if '0' <= string[i] <=  '9' ? $t1 = 1 : 0
	
	addi $t9, $t9, 1	# i = i+1,nhay den vi tri tiep theo
	
	bne $t1, $0, chuyenso	# if t1 = 1 jump toNumber
	beq $t1, $0, error		# if string[i] <= '0' || string[i] >= '9' thi bi loi
	
endcheck:
	beq $s3, $0, jumpReadArray  #if so vua nhap la so duong thi nhay den jumpreadarrray
	sub $s4, $0, $s4            # s4=0-s4
	j jumpReadArray
jumpReadArray:
jr $ra # tro lai ham read_array
chuyenso:	
#	sum = sum * 10 + i ( i = str[i] -'0')
	sub $t8, $t3, $s1	# tru de lay gia tri so cua ki tu,t3= string[i],s1 ='0'
	
	mul $s4, $s4, 10	# nhan tong len ,s4=s4*10
	
	add $s4, $s4, $t8	# tong ra so ,s4=s4+t8
	
	j loopCheck		# jump to CheckType
	
SoAm:
	bne $t9, $0, error	# if ki tu '-' la ki tu o vi tri != 0 thi bao loi
	li $s3, 1		# thiet lap co bao so am
	add $t9, $t9, 1		# tang vi tri
	j loopCheck		# jump lai ve 
error:
li $v0, 55
la $a0, loinhan
li $s7, 1                      # bat co loi yeu cau nhap lai
syscall
jr $ra
#------------------------------------------------------------------------------
# thuat toan sap xep mang theo ma C
#	for(int i=0; i<n; i++){  
#		for(int j=i+1;j<n;j++){
#			if(array[i]<array[j]){
#                        int temp = array[i]; array[i]= array[j]; array[j]=temp;}
#                                          
#		}
#	}
#-------------------------------------------------------------------------------
sort_array:  #ham sort_array,sap xep
	li $t0,0 #i=0
	FOR_I:  slt $t1,$t0,$s6              #$t1= i<n?1:0
  		beq $t1, $0,end_sort_array# if i>n then branch to end_sort_array
  		sll $t2,$t0,2 #4i, dich thanh ghi $t0 sang trai 2 bits luu ket qua vao hanh ghi $t2
  		addi $t3, $t0, 1             # j = i+1
  		
  		FOR_J:
  			add $s1, $s0, $t2      # $s1 chua dia chi array[i]
  			lw $s4, ($s1)          # load gia tri array[i] vao $s4
  			beq $t3, $s6, nextFORI # j ==n
  			sll $t4,$t3,2          #4j
  			add $s2, $s0, $t4      # $s2 chua dia chi array[j]
  			lw $s5, ($s2)          # load gia tri array[j] vao $s5
  			bge $s4, $s5, nextFORJ # array[i] > array[j] noswap
  			sw $s4,($s2)         #luu gia tri thanh ghi $s4 vao array[i],swap
  			sw $s5,($s1)        #luu gia tri thanh ghi $s5 vao array[j],swap
  		nextFORJ:
  			addi $t3, $t3, 1 # j = j+1
  			j FOR_J          # lap lai vong for cua j
  	
  	        nextFORI:
  		addiu $t0, $t0, 1 #i = i+1
  		j FOR_I           # lap lai vong for cua i
end_sort_array:
jr $ra #ket thuc ham sort_array va tro lai ham main 
#------------------------------------------------
# ham check two arrays are similar? theo ma C
# for(int i=0; i<n; i++){
#	if(i==n) return true;
#	if(arrayA[i]!=arrayB[i]) return false ;
#	}
#}
# -------------------------------------------------
areSimilar: #ham check two arrays are similar?
li $t0, 0 #i=0
  loop: beq $t0,$s6,true_end# if i==n thi true
	sll $t1,$t0,2       #4i
	lw $s4, A($t1)      #s4 = A[i]
	lw $s5, B($t1)      #s5 = B[i]
	bne $s4, $s5, false_end # A[i]!=B[i] return false
	addi $t0, $t0, 1    # i=i+1
        j loop
# in ket qua areSimilar(A,B)=true
true_end:
li $v0, 55
la $a0, true
syscall
jr $ra # tro lai ham main

# in ket qua areSimilar(A,B)=false
false_end:
li $v0, 55
la $a0, false
syscall
jr $ra #tro lai ham main

