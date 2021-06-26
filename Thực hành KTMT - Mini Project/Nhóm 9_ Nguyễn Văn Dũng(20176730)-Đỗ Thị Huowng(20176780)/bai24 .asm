# max C
#int main(){
#	char str[100];
#	gets(str);
#	int i = 0;
#	int j = strlen(str)-1;
#	int k=0;
#	while(i<=j){
#		while(str[i]==' ') i++;
#		while(str[j]==' ') j--;
#		if(i>j) return 0;
#		if(i<=j){
#				if(k%2==0) {
#				if(str[i]>=str[j]) return 0;
#				i++;k++;
#					if(str[i]=<str[j]) return 0;
#					j--;k++;
#				}
#				
#		}
#	}
#}



.data
str: .space 100 # luu string nguoi dung nhap
message: .asciiz "Nhap vao xau can xet:" # loi nhac
true: .asciiz "true" # ket qua khi xau la xoay oc
false: .asciiz "false"# két qua khi xau khong phai la xoay oc

.text
# ham main
main:
# in ra loi nhac "Nhap vao xau can xet:"
li $v0, 4
la $a0, message
syscall
# nhap string tu ban phim
li $v0, 8
la $a0, str
li $a1, 100
syscall
# xác dinh chieu dài cua xâu dã nhap
jal getLength
jal CycloneWord
li $v0, 10
syscall

# xác dinh xem xau co phai la xau xoay oc

CycloneWord:
	la $s0, str # luu lai dia chi string vào thanh ghi $s0
	li $t0, 0 # thu tu cac phan tu trong xau ( i thu tu xau tu trai qua phai) 
	move $t1, $s7 # do dai cua xau	( j thu tu xau tu phai qua trai)
	li $s6, 0 # k dung de thay doi thu tu zet
	
	while:
	ble $t1, $t0, result_true # vong lap thuc hien khi i<=j
	# bo qua cac kí tu space tu trai sang
	while1: 
		add $t2, $s0, $t0 #dia chi str[i[
		lb $s1, ($t2) # luu gia tri str[i]
		bne $s1, 32, while2 # neu $s1 khong phai la ki tu trang thi break khoi vong lap
		add $t0, $t0, 1 # neu $s1 la ki tu trang, bo qua ki tu trang duyet tiep xau
		j while1 
	# bo qua cac ki tu trang tu phai sang
	while2:
		add $t3, $s0, $t1 # dia chi Str[j]
		lb $s2, ($t3) #luu gia tri str[i]
		bne $s2, 32, end_while2 # neu $s2 khong phai la ki tu trang thi break khoi vong lap
		add $t1, $t1, -1 # neu $s2 la ki tu trang, bo qua ki tu trang duyet tiep xau
		j while2	
	end_while2:
	slt $t4, $t1, $t0 # j<i ==> $t4=1
	beq $t4,1, result_false # if t4==0 (i>j) ==> false
	div $t5, $s6, 2 #xac dinh xem k co phai so chan
	mfhi $t5 # load gia tri du cua phep chia vao $t5
	beqz $t5, kChan #neu $t5 ==0 ==> kChan
	j kLe # $t5!=0 ==> K Le
kChan:
	slt $t5, $s2, $s1 # so sanh gia trij $s2, $s1, (str[j] vs str[i])
	beq $t5, 1, result_false # if s2<s1 => khong phai la xoay oc ==> return false
	addi $s6, $s6, 1# thoa man cap i,j ==> tang k, tang i, xet cap tiep theo str[++i] vs str[j]
	addi $t0, $t0, 1 # tang i len 1
	j while
kLe:
	slt $t5, $s1, $s2 # so sanh gias trij $s2, $s1 ( str[j] vs str[i])
	beq $t5, 1, result_false #if s1<s2 ==> khong phai la hinh xoay oc => return false
	addi $s6, $s6, 1# thoa man cap i,j  ==> tang k, giam j, xet cap ke tiep str[i] vs str[j--]
	addi $t1, $t1, -1 # j = --j
	j while
	
# in ket qua true
result_true:
li $v0, 55
la $a0, true
syscall
jr $ra
# in ket qua false
result_false:
li $v0, 55
la $a0, false
syscall
jr $ra

# ham xac dinh chiue dai cua xau
getLength:
la $s0, str # dia chi cua xau
li $s7, 0 # khoi tao gia tri chieu dai cua xau 
	loop:
	lb  $t0, ($s0) # load ki thu i vao $t0
	beq $t0, 10 ,endGetLength # neu str[i]='\n' ket thuc vong lap 
	add $s7, $s7, 1 #tang chieu dai xau
	add $s0, $s0, 1 #tro den phan tu tiep theo
	j loop
endGetLength:
addi $s7, $s7, -1 
jr $ra 