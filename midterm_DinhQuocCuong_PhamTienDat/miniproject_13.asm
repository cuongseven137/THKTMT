# Bài mini-project 13 
.data
inputMessage: .asciiz "Input Ticket numbers: "
errorMessage: .asciiz "Input value isn't valid!"
luckyMessage: .asciiz "Ticket is Lucky"
notluckyMessage: .asciiz "Ticket is not Lucky" 

.text

# START: Khoi tao cac bien su dung trong chuong trinh
START:	
	li $t0, 10				# $t0 = 10 la hang so chia lay phan nguyen va phan du
	li $s1, 0				# $s1 la bien dem so chu so cua so nhap vao.
	li $s4, 0				# $s4 la bien luu tong cac chu so cua so nhap vao
	li $s5, 0				# $s5 la bien luu nua tong cac chu so ben phai cua so nhap vao

# MAIN: Chuong trinh chinh		
MAIN: 						
	jal INPUT				# Goi thu tuc INPUT lay gia tri nhap vao cua nguoi dung
	nop
	jal COUNT_SUM				# Goi thu tuc COUNT_SUM dem so luong chu so va tinh tong cac chu so do.
	nop
	jal CHECK				# Goi procedure CHECK de kiem tra so chu so la chan hay le
	nop
	div $s1, $s1, 2				# Giam so chu so xuong 1 nua
	jal SUM_HALF				# Goi thu tuc SUM_HALF de tinh tong nua cac chu so ben phai cua so nhap vao.
	nop
	add $s5, $s5, $s5			# Nhan doi tong nua cac chu so ben phai
	beq $s5, $s4, LUCKY			# Neu tong = 2 * nua tong => Thong bao so may man
	j NOT_LUCKY				# Thong bao so khong may man
		
# INPUT: Yeu cau nguoi dung nhap so can kiem tra
INPUT:						
	li $v0, 51				# Goi syscall InputDialogInt(51) Lay so nhap vao tu nguoi dung
	la $a0, inputMessage			# $v0: ma lenh, $a0: tin nhan, $a0: gia tri ma nguoi dung nhap vao, $a1: trang thai nhap vao
	syscall					
	bne $a1, $zero, ERROR			# Truong hop gia tri nhap vao khong phai la so thi thong bao loi 
	add $s0, $a0, $zero			# Luu gia tri vua nhap vao $s0
	add $t1, $s0, $zero			# Luu gia tri vua nhap vao $s1 => Dung cho thu tuc COUNT_SUM
	add $t2, $s0, $zero			# Luu gia tri vua nhap vao $s2 => Dung cho thu tuc SUM_HALF
	jr $ra					# Quay tro lai ham MAIN 

# COUNT_SUM: Dem so luong cac chu so va tinh tong cua chung.
COUNT_SUM:					
	div $t1, $t0             		# Thuc hien chia so vua nhap ($t1) cho 10
	mflo $t1                		# Gan lai $t1 = phan nguyen cua phep chia
	mfhi $t3                		# Gan $t3 = phan du cua phep chia => Day la cac chu so cua so nhap vao.
	add $s4, $s4, $t3         		# Tinh tong cac chu so
	add $s1, $s1, 1				# Tang so luong chu so them 1
	bne $t1, $zero, COUNT_SUM   		# Neu so nhap vao != 0 (chua chia het) thi tiep tuc tinh toan den khi lay het cac chu so
	jr $ra					# Quay tro lai ham MAIN 

# SUM_HALF: Tinh tong nua cac chu so ben phai
SUM_HALF: 					
	div $t2, $t0             		# Thuc hien chia so vua nhap ($t2) cho 10
	mflo $t2                		# Gan lai $t2 = phan nguyen cua phep chia
	mfhi $t3                		# Gan $t3 = phan du cua phep chia => Day la cac chu so cua so nhap vao.
	add $s5, $s5, $t3         		# Tinh tong cac chu so
	sub $s1, $s1, 1				# Giam so luong chu so can phai tinh tong xuong 1
	bne $s1, $zero, SUM_HALF  		# Neu so luong chu so can tinh != 0 thi tiep tuc tinh toan
	jr $ra					# Quay tro lai ham MAIN 

# CHECK: Kiem tra so luong chu so la chan hay le, neu le thi bao loi
CHECK:						
	andi $t4 , $s1 , 1			# Kiem tra so chu so cua so nhap vao la chan hay le?  $t4 = chan ? 0 : 1
	bne $t4, $zero, ERROR			# Neu so luong chu so le thi thong bao loi
	jr $ra					# Quay tro lai ham MAIN 
	
# ERROR: Hien thi loi neu du lieu nhap vao khong phai la so hoac so chu so la so le
ERROR: 						
	li $v0, 55				# Goi syscall MessageDialog(55) => Hien thi loi
	la $a0, errorMessage			# $v0: ma lenh, $a0: tin nhan
	syscall
	j EXIT					# Thoat chuong trinh

# LUCKY: Hien thi thong tin so nhap vao la so may man	
LUCKY:						
	li $v0, 55 				# Goi syscall MessageDialog(55) => Hien thi tin nhan
	la $a0, luckyMessage 			# $v0: ma lenh, $a0: tin nhan
	syscall
	j EXIT					# Thoat chuong trinh

# NOT_LUCKY: Hien thi thong tin so nhap vao khong la so may man	
NOT_LUCKY:					
	li $v0, 55 				# Goi syscall MessageDialog(55) => Hien thi tin nhan
	la $a0, notluckyMessage  		# $v0: ma lenh, $a0: tin nhan
	syscall	
	j EXIT					# Thoat chuong trinh

EXIT:
