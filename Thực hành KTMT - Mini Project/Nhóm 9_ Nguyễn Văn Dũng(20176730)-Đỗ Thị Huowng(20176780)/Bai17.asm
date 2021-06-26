#Viết chương trình nhập chuỗi. Trích xuất các ký tự số và hiển thị ra màn hình theo thứ tự nghịch đảo bằng cách sử dụng ngăn xếp.
# MIPS assembly language program to extract number characters and show to screen in inverse order using stack
# $a0 = $t0 = xau nguoi dung nhap
# $t1 = counter // String's index 
# $t2 = gia tri cua str[i] 
.data
   	 str: .space 100    # cấp 100 byte nhớ chưa được khởi tạo
   	 ip: .asciiz "\nNhap vao xau: "
   	 op2: .asciiz "Chuoi cac so trong xau sau khi nghich dao: "
   	 op3: .asciiz "xau khong co ky tu so. "
.text
main:
#Hien thi yeu cau nguoi dung nhap xau
   	la $a0, ip #load gia tri xau can hien thi vao thanh ghi $a0
  	li $v0, 4 #load gia tri dich vu hien thi xau 
  	syscall #Hien thi xau yeu cau nguoi dung nhap
#Lay du lieu tu nguoi dung
  	li $v0, 8 #load gia tri dich vu nhap xau
   	la $a0, str #load dia chi chua du lieu nguoi dung nhap
   	addi $a1, $0, 100 #set maxlength cho xau
   	syscall

   	move $t0, $a0  #chuyen dia chi xau nguoi dung nhap vao thanh ghi $t0
   	addi $t1, $0, 0 #khoi tao vi tri i=0 cua xau
   	addiu $s1, $sp, 0 # luu gia tri ban dau thanh ghi stack
   	jal check # chuyen den ham check
   	li $v0, 10 # bien exit ket thuc chuong trinh 
   	syscall
check:
#vong lap kiem tra gia tri cac phan tu trong xau co chua gia tri >=0( 48 ma ascii)
lowerBound: 
  	lb $t2, 0($t0) #load gia tri dau tien trong chuoi vao thanh ghi $t2
 	addi $t0, $t0, 1 #gia tăng ký tự tiép theo trong chuỗi
 	bge $t2, 48, upperBound # nhay sang upperBound neu $t2>=0(48 ma ascii)
 	beqz $t2, popStack #if character = 0 (end of string) nhay sang popStack 
  	j lowerBound #lap lai ham lowerBound

#kiem tra gia tri cac phan tu trong chuoi co gia tri <=9 (57 ma ascii)
upperBound:
   	ble  $t2, 57, pushStack  #neu $t2<=9 (57 ma ascii) thi push gia tri trong t2 vao stack
   	j lowerBound #lap lai ham lowerBound
# push gia tri vao stack
pushStack:
    	addiu $sp, $sp, -4 # giam tra tri thanh ghi $sp de ghi du lieu vao stack
	sw $t2, ($sp) # luu du lieu trong thanh ghi $t2 vao dinh stack
	j lowerBound	#lower lai ham lowerBound
#lap lay gia tri ra khoi stack va in gia tri 
popStack:
   	beq $sp, $s1, null #neu $sp == $s1 ( gia tri $sp ban dau) ==> stack rong  in ra thong bao xau khong co ky tu so
   	li $v0, 4
    	la $a0, op2
   	syscall
   	loop:
    	beq $sp, $s1, end # neu lay het cac phan tu thi ket thuc chuong trinh 
    	li $v0, 11 #load gia tri dich vu in ki tu
    	lw $a0, ($sp) #load gia tri dinh stack vao tanh ghi $a0
    	addiu $sp, $sp, 4 #giam gia tri tahnh ghi $sp ==> $sp tro den phan tu tiep theo trong stack
    	syscall #in du lieu
    	j loop #loop lai popStack de lay phan tu tiep theo trong stack
null:
	la $a0, op3 #load gia tri xau can hien thi vao thanh ghi $a0
	li $v0, 4 #load gia tri dich vu hien thi xau 
	syscall
end: 
	jr $ra 	
