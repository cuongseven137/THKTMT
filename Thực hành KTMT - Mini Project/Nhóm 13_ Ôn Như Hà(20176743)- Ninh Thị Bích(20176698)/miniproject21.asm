# @ PROJECT 21--------------------------
#  Ma C
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
# 	n=sum;
#	}
#   return count;
#}
#-------------------------------------------------
.data
message: .asciiz "Nhap vao n:" # loi nhan
result: .asciiz "DegieDegree("
re2: .asciiz")= "
loinhan: .asciiz "nhap sai,moi ban nhap lai\n"
xau: .space 100
.text
main:


# in loi nhan "Nhap vao n:"
 li $v0, 4 # load dich vu printf string
 la $a0, message
 syscall
# nhap n tu ban phim
        li $v0, 8        # load dich vu read string
	la $a0, xau      # a0 chua dia chi mang xau
	li $a1, 100      # danh trong bo nho khoang 100 phan tu
	syscall
	jal checkNumber    #nhay jum and link de kiem tra xem du lieu vua nhap co la so nguyen khong
	beq $s6, 1, main   # meu s6=1 thi nhay ve main,yeu cau nhap lai
	move $s0, $s4      # luu gia tri n vao thanh ghi $s
	
	jal digitDegrre
	
	li $v0, 10
	syscall
	
 
digitDegrre:
	li $s1, 0 # $s1= count = 0
	move $t8, $s0

While1:
	ble $s0, 9, printfResult # if n<= 9 exit 
	addi $s1, $s1, 1 # count ++
	li $s7, 0 # sum =0
 	while2:
 		beqz $s0, nextWhile1 # if(n==0) ket thuc vong while --> set gia tri n cho vong do While tiep theo
		div $s0,$s0, 10 # n = n/10
		mfhi $t0 # thanh ghi hi luu gia tri du cua phep chia a % b luu vao thanh ghi t0
		add $s7, $s7, $t0 # sum = sum + n%10		
 	j while2 #  vong lap while2
nextWhile1:
	move $s0, $s7 #n=sum, luu gia tri sum vao thanh ghu s0
	j While1 # v?ng lap while1
 # in ra gia tri cua count == ket qua de bai
 printfResult:
 li $v0,4
 la $a0,result
 syscall
 li $v0, 1 # load dich vu print decimal integer
 move $a0, $t8 # luu gia tri n vao thanh ghi a0
 syscall
 li $v0,4
 la $a0,re2
 syscall
 li $v0, 1 # load dich vu print decimal integer
 move $a0, $s1 # luu gia tri count vao thanh ghi a0
 syscall
 
 nop
 jr $ra # tro lai ham main
 
 checkNumber:	# kiem tra xem kieu nhap vao co dung la cac chu so khong
	li $s6, 0 # thiet lap co de kiem soat loi
	li $t9, 0 # vi tri i cua ki tu trong xau
	li $s4, 0 #luu gia tri so khi chuyen tu chuoi sang so
	
	
	loopCheck:
	add $t2, $a0, $t9	# t2 chua Address string[i]
	lb $t3, 0($t2)		# t3 chua gia tri string[i]
	
	beq $t3, 10, endcheck	# kiem tra xem string[i] = '\n' ? if true then jump
	beq $t3, 45, error	# kiem tra xem string[i] co la so am? jump toi chuyen so am
	li $s2, '0'            #gan gia tri 0 cho s2
	li $s5, '9'            #gan gia tri 9 cho s5
	sle $t4, $s2, $t3	# kiem tra xem string[i] >= '0' ? $t4 = 1 : 0
	sle $t5, $t3, $s5	# kiem tra xem string[i] <= '9' ? $t5 = 1 : 0
	
	and $t6, $t4, $t5	# if '0' <= string[i] <=  '9' ? $t6 = 1 : 0
	
	addi $t9, $t9, 1	# i = i+1,nhay den vi tri tiep theo
	
	bne $t6, $zero, toNumber	# if $t6 = 1 jump toNumber
	beq $t6, $zero, error		# if string[i] <= '0' || string[i] >= '9' thi bi loi
	
endcheck:
	jr $ra # tro lai ham read_array

toNumber:	
#	sum = sum * 10 + i ( i = str[i] -'0')
	sub $t7, $t3, $s2	# tru de lay gia tri so cua ki tu,t3= string[i],s2='0'
	
	mul $s4, $s4, 10	# nhan tong len ,s4=s4*10
	
	addu $s4, $s4, $t7	# tong ra so ,s4=s4+t7
	
	j loopCheck		# jump to CheckType
	
error:
li $v0, 4
la $a0, loinhan
li $s6, 1 # bat co loi yeu cau nhap lai
syscall
jr $ra
