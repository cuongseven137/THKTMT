.data
slpt: .asciiz "So luong phan tu cua mang:"
element: .asciiz "Nhap phan tu:"
err: "Loi nhap lieu"
.text
main:
	la $s7,0x10010060 	 #dia chi co so cua mang
	li $v0,51
	la $a0,slpt
	syscall
	add $s0,$0,$a0		 #so luong phan tu
	li $t0,0		 #i=0
input:
	beq $t0,$s0,end_input		#neu i=slpt=>ket thuc nhap
	sll $t2,$t0,2			#i=4i
	add $t1,$s7,$t2  		# chua dia chi cua a[i]
	li $v0,51
	la $a0,element
	syscall
	bnez $a1,error			#neu nhap bi loi thong bao error va thoat chuong trinh
	sw $a0,0($t1) 			# luu gia tri cua a[i]
	add $t0,$t0,1 			# i++
	j input
end_input:

la $a0,0($s7)			#dia chi co so cua mang
add $s1,$zero,$s0		#do dai mang luu o $s1
xor $t0,$zero,$zero		#add = 0
xor $s0,$zero,$zero		#result = 0
xor $t1,$zero,$zero		#i=0
jal arrayChange
nop
li $v0,10
syscall
arrayChange:
loop:
	slt $t4, $t1, $s1		#$t6 = i < length ? 1 : 0 
	beq $t4, $zero, print_result 	#if i>=length => end
	xor $t0, $zero, $zero		#add = 0
	sll $t2, $t1, 2			#i=4i
	add $t3, $t2, $a0
	lw  $t6, 0($t3)			#A[i]
	beq $t1, $0, next_step		#neu i = 0 => next_step
	slt $t4, $t5, $t6		
	beq $t4, 1, next_step		#A[i]<A[i-1] => loop
	j add_moves
next_step:
	add $t1, $t1, 1			#i=i+1
	add $t5, $t6, $0		#$t4=A[i]
	j loop
add_moves:
	sub $t0, $t5, $t6		#add = A[i-1]-A[i]
	add $t0, $t0, 1			#add = A[i-1]-A[i]+1
	add $s0, $s0, $t0		#result = result + add
	add $t6, $t6, $t0		#A[i]=A[i]+add
	j   next_step
	
print_result:
	li $v0, 1
	add $a0, $s0, $zero
	syscall
	jr $ra
error:
	la $a0,err
	li $v0,4
	syscall
	li $v0,10
	syscall
