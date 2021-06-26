#Let's define the digit degree of some positive integer as the number of times we need to replace this number with the sum of its digits until we get to a one digit number. 
#Given an integer, find its digit degree.
.data
Mess1:	.asciiz "Nhap so "
KetQua: .asciiz "Ket Qua : "
Err:	.asciiz "Error "
Again:	.asciiz "Chay lai"
string:	.space 100

.text
main:	
	li $t0, 0 		# count
	
	li 	$v0, 54
	la 	$a0, Mess1
	la 	$a1, string
	la 	$a2, 100
	syscall			# Nhap so A
	
	la 	$a0, string	# Lay phan tu string
	add 	$t6, $0, $0	# j = 0
	
	jal   	Check		# kiem tra so nhap vao
	nop
	add 	$s1, $0, $s0	# sumA = A
	jal  	DigitDegree
	nop
the_end:
	li 	$v0, 10
	syscall
	
Check:
	add 	$t7, $a0, $t6		# $t7 = dia chi A lay ki tu dau tien cua string
	lb  	$t2, 0($t7)		# $t2 = A
	li 	$t7, 58			# $t7 = '/'
	li 	$a2, 47			# $a2 = ':'
	beq 	$t2, 10, end_Check	# if(A[j] == '\n') end check
	slt 	$t3, $t2, $t7		# A[j] <= 9 ?
	slt 	$t4, $a2, $t2		# A[j] >= 0 ?
	and 	$t5, $t3, $t4		# A[j] <= 9 ? && A[j] >= 0 ?
	add 	$t6, $t6, 1		# j++
	bne 	$t5, 0, ADD1		# if(true) qua ADD1
	beq 	$t5, 0, err		# else error

end_Check:
	li 	$t0, 0			# sum = 0
	li 	$t1, 10			# $t1=10
	jr  	$ra
ADD1:
	sub 	$t2, $t2, 1		# A[j] --
	sub 	$t7, $t2, $a2		# $t7 = A[j] - 47
	mul 	$s0, $s0, 10		# A = A*10
	add 	$s0, $s0, $t7		# A += $t7
	j 	Check

SumA: #123/10 = 12 du 3 A=12/10 1 va 2 sumA=3+2+1
	slt 	$t2, $0, $s0	# 0 < A ?
	beq 	$t2, $0, DigitDegree# if(A <= 0) nhay ve DigitDegree
	div 	$s0, $t1		# A/10
	mfhi 	$t3		# $t3 = A % 10
	mflo 	$t4		# $t4 = A / 10
	add 	$s1, $s1, $t3       # sumA += $t3
	add 	$s0, $0, $t4  	# A = $t4
	j   	SumA
DigitDegree:
	add 	$s0, $0, $s1	# A = sumA
	slt 	$t2, $s0, $t1	# A < 10 ?
	bne 	$t2, $0, end	# if(A < 10) end
	add 	$t0, $t0, 1	# else : count += 1
	li  	$s1, 0		# sumA = 0
	j 	SumA
end:
	li 	$v0, 56
	la 	$a0, KetQua
	add 	$a1, $t0, $0
	syscall
	jr 	$ra
	
err:
	li 	$v0, 59
	la 	$a0, Err
	la 	$a1, Again
	syscall

