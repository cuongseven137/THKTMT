xj# Project giua ky mon THUC HANH KIEN TRUC MAY TINH

.data 
	userInput: .space 50			# luu xau vua nhap vao		
	userInputx: .space 50			# luu xau vua nhap vao nhung da qua xu ly de khong phan biet chu hoa chu thuong
	palindromes: .space 1000
	isPali: .asciiz " is a palindrome :)\n\n"
	notPali: .asciiz " is not a palindrome :(\n\n"
	goAgainMessage: .asciiz "Would you like to enter another? (yes/no): "
	goAgainInput: .space 4
	exitMessage: .asciiz "Program is finished. "
	startPrompt: .asciiz "\nEnter a string to check if it is a palindrome: "
	duplicateString: .asciiz "\nThe String just have entered is exist in Palindromes\n\n"
	invalid_length: .asciiz "\nLength of string is too long\n\n"
	invalid_char: .asciiz "\nThe string you just entered contains a special character\n\n"
.text
la $a3, palindromes		# $a3 la dia chi cua mang cac palindromes
main:
    la $a0, startPrompt 	# In ra thong bao nguoi dung nhap xau
    li $v0, 4
    syscall
    la $a0, userInput 		# dia chi cua xau nguoi dung vua nhap vao
    li $a1, 50			# So ki tu toi da co the doc vao cua moi lan nhap xau
    li $v0, 8			
    syscall 			# doc vao xau nguoi dung nhap
    
#---------------------------------------------------------------------------------------- 
# check_lengthInput      Kiem tra xem xau nhap vao co vuot qua do dai cho phep hay khong? 
# Su dung vong lap while duyet xau, dem so luong ki tu trong xau
#----------------------------------------------------------------------------------------

check_lengthInput:		
    li $t0, 0
    countLength:
     lb $t1, ($a0)
     beqz $t1, end_countLength
     addi $t0, $t0, 1
     addi $a0, $a0, 1
     j countLength
    end_countLength:
    bgt $t0, 26, invalid_lengthInput
    j end_check_lengthInput
    invalid_lengthInput:
     la $a0, invalid_length
     li $v0, 4
     syscall
     j goAgainX
end_check_lengthInput:
    addi $a0, $a0, -1
    sb $zero, ($a0)				# xoa ki tu '\n' cuoi xau vua nhap vao
    
#---------------------------------------------------------------------------------------- 
# duplicate : Kiem tra xem xau da ton tai trong bo nho hay khong ? 
# Su dung vong lap while, su dung 1 thanh ghi duyet tu dau xau va 1 thanh ghi duyet tu cuoi xau
# next_checkdup : kiem tra vi tri duyet xau hien tai
# isDuplicate : xau vua nhap da ton tai va tiep tuc hoi nguoi dung muon nhap tiep hay khong
# notDuplicate : xau vua nhap chua ton tai trong bo nho va tiep tuc kiem tra tinh hop le cua cac ki tu trong xau
#----------------------------------------------------------------------------------------

duplicate:					
 la $a0, userInput
 la $a1, palindromes
 li $t0, 27
 add $t6, $s0, $zero
 loop_dup:
 	beqz $s0, end_duplicate			# Neu chua co xau nao duoc lau thi ket thuc luon kiem tra duplicate
 	mult $t0, $t6	
 	mflo $t2
 	add $t1, $a1, $t2			# $t1 = 0(palindromes[i]) (dia chi phan tu dau tien cua cac palindromes)
 	sub $t1, $t1 , 27
 	add $t5, $a0, $zero			# $t5 = 0(userInput)
 	while:					# So sanh xau vua nhap vao voi cac xau da luu trong bo nho ( neu co )
 		lb $t2, ($t1)			# $t2 dung lay du lieu tu palindromes trong bo nho
    		lb $t3, ($t5)			# $t3 dung de lay du lieu tu xau vua nhap vao dem di so sanh
    		beq $t2, $t3, next_check_dup	# palidrome[i] = userInput[i] => check vi tri dang so sanh hien tai
    		j notDuplicate
    	next_check_dup:
    		addi $t1, $t1, 1		# $t1 = 1(palindromes[i])
    		addi $t5, $t5, 1		# $t5 = 1(userInput)
    		lb $t2, ($t1)
    		lb $t3, ($t5)
    		add $t4, $t2, $t3
    		beqz $t4, isDuplicate
    		j while
    	end_while:
 end_loop_dup:
 isDuplicate:
 	la $a0, duplicateString			# In thong bao xau vua nhap da trung lap trong bo nho
    	li $v0, 4
    	syscall
    	j goAgainX
 notDuplicate:					# In khong trung lap thi tiep tuc thuc hien chuong trinh
    	addi $t6, $t6, -1
    	beqz $t6, end_duplicate
    	j loop_dup	
end_duplicate:

#--------------------------------------------------------------------------------------------------------------
# checkInput :  Kiem tra tinh hop le cac ki tu cua xau vua nhap vao (co ki tu dac biet khong?)
# Dung vong lap kiem tra tung ki tu trong xau vua nhap co thuoc dung khoang gia tri ma Ascii cho chu cai va chu so hay khong
#--------------------------------------------------------------------------------------------------------------    
checkInput: 					
    la $a0, userInput
    la $t1, userInputx				
    loop:					
        lb $t7, ($a0)				# load a[i] to $t7
        beq $t7, 0, checkPali  			# khi ket thuc viec kiem tra tinh hop le cac ki tu cua xau
        
        bgt $t7, 47, test1
        j invalidChar
        test1: 
         blt $t7, 58, addToInputx		# a[0] là 1 chu so tu 0->9, ma ascii [48,57]
         j test2
        test2: 
         bgt $t7, 64, test3
         j invalidChar
        test3: 
         blt $t7, 91, addToInputx		# a[i] là 1 chu cai viet hoa (A,B,C ...), ma ascii [65,90]
         bgt $t7, 96, test4 		
         j invalidChar
        test4:
         blt $t7, 123, addToInputx		# a[i] la 1 chu cai viet thuong (a,b,c ...), ma ascii [97,122]
         j invalidChar
    addToInputx: 				
        bgt $t7, 96, makeCap
        j notCap
        makeCap: 
         addi $t7, $t7, -32 			# Chuyen cac chu cai viet thuong thanh viet hoa (a -> A)
        notCap:
         sb $t7, ($t1)				# userInputX[i] = userInput[i]
         addi $a0, $a0, 1 			
         addi $t1, $t1, 1
         j loop

    invalidChar:				# Thong bao la xau co ki tu dac biet va hoi nguoi dung co muon nhap tiep khong.
    	la $a0, invalid_char
    	la $v0, 4
    	syscall 
    	j goAgainX
   
#-----------------------------------------------------------------------------------------------------------------
# checkPali : kiem tra xau vua nhap co phai la 1 palindrome hay khong?
# loop2 : load tung ki tu de kiem tra tinh doi xung
# testLocation : Kiem tra vi tri cac con tro dung de duyet xau neu 2 con tro gap nhau thi no la 1 palindrome
# isPaliX : thuc hien luu xau palindrome va tang so luong phan tu trong mang palindromes len 1
# notPaliX : In thong bao va hoi nguoi dung co muon nhap tiep hay khong
#-----------------------------------------------------------------------------------------------------------------
checkPali:					
    la $t4, userInputx				# $t4 = dia chi phan tu dau tien trong xau vua nhap (userInpur[0])
    addi $t1, $t1, -1   			# $t1 = dia chi phan tu cuoi cung trong xau vua nhap (userInput[n])
    loop2:          		
        lb $t3, ($t4)				# $t3 = userInput[0]
        lb $t2, ($t1)   			# $t2 = userInput[n]
        beq $t3, $t2, next  			# userInput[0] = userInput[n] (gia su xau vua nhap co n phan tu)
        j notPaliX  				# khong la 1 palindrome
        next: 			
         jal testLocation 
         nop 			
         addi $t4, $t4, 1 	
         addi $t1, $t1, -1 	
         j loop2   		

    testLocation:
        beq $t4, $t1, isPaliX			# Khi con tro chay tu cuoi xau va dau xau gap nhau thi ket thuc qua trinh duyet
        addi $t1, $t1, -1			# Kiem tra xem co tiep tuc duyet them hay khong
        beq $t4, $t1, isPaliX   
        addi $t1, $t1, 1    	
        jr $ra          	

    isPaliX:
        la $a0, userInput
        li $v0, 4   				# In ra thong bao xau vua nhap la 1 palindromes
        syscall
        la $a0, isPali
        syscall
        la $a0, userInput
     	li $t8, 27
        loop3:					# Luu xau thoa man dieu kien vao mang palindromes da khai bao
         lb $t5, ($a0)
         beqz $t8, end_loop3
         sb $t5, ($a3)
         addi $a0, $a0, 1
         addi $a3, $a3, 1
         addi $t8, $t8, -1
         j loop3
        end_loop3:
      
        addi $s0, $s0, 1			# Luu lai so luong palindromes da luu trong bo nho
        j goAgainX

    notPaliX:					# Thuc hien khi xau nhap khong phai la 1 palindromes
        la $a0, userInput 	
        li $v0, 4
        syscall
        la $a0, notPali		
        syscall					# In ra cau lenh thong bao xau vua nhap khong phai la palidromes
        j goAgainX 		

    goAgainX:					# Hoi nguoi dung xem co muon nhap tiep hay khong?
        la $a0, goAgainMessage
        syscall
        li $a1, 4
        li $v0, 8
        la $a0, goAgainInput    
        syscall
        lb $t0, ($a0)
        beq $t0, 121, goAgain			# input[0] = 'y'
        j exit
#-------------------------------------------------------------------------------------------------------
# Ket thuc chuong trinh
# reset lai phan bo nho khong phuc vu luu tru palindromes
#-------------------------------------------------------------------------------------------------------
exit:						
    la $a0, exitMessage
    li $v0, 4   		
    syscall
    la $a0, userInput
    li $t9, 100
    loopReset2:					
        beqz $t9, end_loopReset  	 
        addi $t9, $t9, -1
        sb $zero, ($a0)
        addi $a0, $a0, 1
        j loopReset2
    end_loopReset:
    li $v0, 10
    syscall
#--------------------------------------------------------------------------------------------------------------------
# reset lai phan bo nho khong phuc vu luu tru palindromes va quay tro lai ham main
#--------------------------------------------------------------------------------------------------------------------
goAgain:					
    la $a0, userInput
    li $t9, 100
    loopReset:
        beqz $t9, main  	 
        addi $t9, $t9, -1
        sb $zero, ($a0)
        addi $a0, $a0, 1
        j loopReset
