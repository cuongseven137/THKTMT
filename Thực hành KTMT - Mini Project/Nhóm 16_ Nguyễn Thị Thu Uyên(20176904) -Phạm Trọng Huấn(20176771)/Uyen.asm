.data
SV: .space 200
MAX_OF_SV: .word 10
Message : .asciiz "Danh sach sinh vien truot la: \n\n"
Message1: .asciiz "so luong SV phai > 0"
Number_Of_SV: .asciiz "Nhap so luong sinh vien MAX = 10"
Name_Of_SV : .asciiz "Nhap ten SV: "
Check_Mark: .asciiz "diem >0 and diem <10"
Diem: .asciiz "Nhap diem <= 10"

.text
Main:
	jal Nhap
	nop
	jal Print
	nop
end_Main:
	li $v0, 10
	syscall 	
Nhap: #Ham nhap so luong 
	lw $s1,MAX_OF_SV #max of sinh vien  doc du lieu word tu bo nho vao thanh ghi s1
	#---------------nhap n( Nhap so luong sinh vien )------------------------------
	li $v0,51# goi hop thoai nhap vao so luong sinh  
	la $a0,Number_Of_SV #$a0 tieu de: nhap vao oso luong sinh vien Max=10
	syscall#$a0 Nhap vao so luong  sinh vien 
		
	slt $t0,$s1,$a0  # so sánh $s1 < $a0 ? neu dung thi $t0=1( so sanh so sinh vien max < so sinh vien nhap vao ko ??)
	bne $t0,$0,Main #neu($t0!=0) thì nhay lai lenh main (neu < thi lap lai ham main)
	slt $t0,$0,$a0# con neu ($t0!=0) sai t?c là  $a0<$s1  thì thuc hien so sanh tiep $0<$a0??( so sanh so sinh vien nhap vao>0 ko ??)
	bne $t0,$0,Continue #neu ($t0!=$0)hay ($0<$a0) dung thi nhay lenh Countinue( neu so sinh vien nhap vao >0 thi nhay sang lenh Continue)
	li $v0,55# neu 0<$a0 goi hop thong bao
	la $a0,	Message1# $a0 tieu de :"so luong SV phai > 0"
	syscall
	j Nhap
Continue:
	#khoi tao gia tri các giá tri
	add $s0,$a0,$0 # $ gan s0 = n( =a0= so luong sv)
	la $s1,SV # nap dia chi cua mang s1
	add $t1,$0,$s0  # Khoi tao i = n
	addi $s3,$s1,0  #Khoi tao s3=sv[0]
NhapMang:
	#nhap ten 
	beq $t1,0,Done  #neu $t1==0 thi nhay sang Done 
	li $v0,54 # con neu ko thi goi hop thoai nhap ten sinh vien   
	la $a0,Name_Of_SV# tieu de Name_Of_SV
	la $a1,0($s3)# chi ra vi tri luu ten 
	la $a2,16# gioi han do dai la 16 ki tu  
	syscall# nhap ten
	addi $s3,$s3,16	# chuyen sang vi tri tiep theo 
Mark:
	#nhap diem
	li $v0,51# goi hop thoai
	la $a0,Diem# tieu de : Diem
	syscall# Nhap diem
	slti $t0,$a0,11# so sánh diem nhap vao a0<11 dung thi t0=1
	beq $t0,$0,Mark# neu t0==0 thì nhay lai lenh Mark( nghia la khi nay a0>10)
	
	slt $t0,$0,$a0# con neu ko thi so sánh 0<a0,neu dung t0=1
	bne $t0,$0,Continue1#neu t0!=0 thì nhay sang lenh Continue1
	li $v0,55 # neu ko thi goi hop thong bao
	la $a0,	Check_Mark# tieu de:"diem >0 and diem <10"
	syscall# nhan ok
	j Mark #va nhay lai lenh main
Continue1:	
	#l?u thong tin vua nhap và nhay sang phan tu tiep theo cua mang 
	sw $a0,0($s3)# dua du lieu tu a0 ra dia chi co so cua s3
	addi $s3, $s3, 4# nhay sang phan tu tiep theo cua s3
	addi $t1,$t1,-1# Khoi tao lai t1=t1-1
	
	j NhapMang# nhay lai lenh NhapMang
Done:
	# ket thuc viec nhap 
	li $v0,4# thong bao ket qua ra console 
	la $a0,Message	# tieu de: "Danh sach sinh vien truot la \n"
	syscall
	jr $ra
Print:
	#B?t ??u in
	addi $t3, $0,0 # i = 0 
	add $s4,$0,$s1 # dia chi sv[0]
	
for:
	#vong lap nap diem va check diem 
		
	add $s5,$s4, $0 #s5=s4

	addi $t5,$s4,16 #sv[0]+16
	lw   $t6,0($t5) #nap sv[0].diem
	
	slti $t7,$t6,5# ?diem check là 5, so sánh diem nhap vao voi 5, neu < thì t7=1
	bne $t7,$0,print_char # neu  t7!=0(hay t7=1) thì nhay sang lenh print_char
	j next# còn neu không thì nhay sang lenh next

print_char: #in ten
	lb $t2,0($s5) # load byte
	beq $t2,10, end_for # = \n. neu t2==10 thì nhay lenh end_for
	addi $a0,$t2,0 # neu khong thi a0 = t2
	li $v0, 11 # print char
	syscall
	addi $s5, $s5, 1 # j++
	j print_char 
end_for:
	#ket  thuc  vong lap 
	li $v0,11# in char
	li $a0,10# thoat chuong trinh
	syscall
	
next:
	#chuyen toi vi tri tiep theo 
	addi $t3, $t3,1 #sv[i++]
	beq $t3, $s0, end_print #i = n? thi nhay sang lenh end_print 
	mul $t4,$t3,20	#i*20
	add $s4,$s1,$t4 # dia chi  sv[i] 
	j for# nhay sang lenh for

end_print:
	jr $ra
	

	
	
	
 	
	
	

	
	
	
	
