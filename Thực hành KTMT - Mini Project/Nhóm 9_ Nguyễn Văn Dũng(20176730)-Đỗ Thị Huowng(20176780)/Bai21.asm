#ma C
#int main(){
#	int n;
#	printf("Nhap n:");
#	scanf("%d", &n);
#	int count = 0; 
#	while(n>=10){
#		sum = 0;
#		count++;
#		while(n!=0){
#		sum +=n%10
#		n=n/10
#		}
# 	n=sum
#	}
#   return count;
#}
.data
message: .asciiz "Nhap vao n:" # loi nhac
buffer : .space 100 #xau nguoi dung nhap
messageError: .asciiz "phan tu khong phai la so"
.text
# in loi nhac Nhap vao n:
 li $v0, 4
 la $a0, message
 syscall
# nhap n tu ban phim
 li $v0, 8
 la $a0, buffer
 li $a1, 100
 syscall
 # luu gia tri $v0 ==> $s0
 jal checkType
 jal digitDegree
 
 #in ket qua
 li $v0, 1
 move $a0, $s1
 syscall
 li $v0, 10
 syscall
 
 
 # ham kiem tra
 digitDegree:
 li $s1, 0 # count = 0
 While1:
	ble $s0, 9, exit # if n<= 9 exit 
	addi $s1, $s1, 1 # count ++
	li $s7, 0 # sum =0
 	while2:
 		beqz $s0, nextWhile1 # if(n==0) ket thuc vong while --> set gia tri n cho vong doWhile tiep theo
		div $s0,$s0, 10 # n = n/10
		mfhi $t0 # thanh ghi hi luu gia tri du cua phep chia a % b
		add $s7, $s7, $t0 # sum = sum + n%10		
 	j while2
nextWhile1:
	move $s0, $s7 #n=sum
	j While1
exit:
nop 
jr $ra

# kiem tra gia tri
 checkType:	# kiem tra xem kieu nhap vao co dung la cac chu so khong
	li $t1, 0 # vi tri i cua ki tu trong xau
	li $s0, 0 #luu gia tri so khi chuyen tu chuoi sang so
	loopCheck:
	add $t2, $a0, $t1	# Address string[i]
	lb $t3, 0($t2)		# gia tri string[i]
	
	beq $t3, 10, end_check	# string[i] = '\n' ? true thi jump
	li $s1, '0'
	li $s2, '9'
	slt $t4, $s1, $t3	# string[i] >= '0' ? $t4 = 1 : 0
	sle $t5, $t3, $s2	# string[i] <= '9' ? $t5 = 1 : 0
	
	and $t6, $t4, $t5	# if '0' <= string[i] <=  '9' ? $t6 = 1 : 0
	
	addi $t1, $t1, 1	# i = i+1
	
	bne $t6, $zero, toNumber	# if $t6 = 1 jump toNumber
	beq $t6, $zero, error		# if string[i] <= '0' || string[i] >= '9' thi bi loi
	
end_check:
	nop
	jr $ra
toNumber:	
#	sum = sum * 10 + i ( i = str[i] -'0')
	sub $t7, $t3, $s1	# tru de lay gia tri so cua ki tu
	mul $s0, $s0, 10	# nhan tong len 
	add $s0, $s0, $t7	# tong ra so
	j loopCheck		# jump to CheckType
	
error:
li $v0, 4
la $a0, messageError
syscall
li $v0, 10
syscall