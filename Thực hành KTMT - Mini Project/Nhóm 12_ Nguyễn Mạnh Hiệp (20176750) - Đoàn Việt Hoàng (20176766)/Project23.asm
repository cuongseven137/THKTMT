.data
string: .space 50
message1: .asciiz "Nhap xau: "
TRUE: .asciiz "TRUE"
FALSE: .asciiz "FALSE"
.text
main:
	li $s1,10			#Ma ascii cua ki tu xuong dong
	li $s5, 0			#Ket qua
get_string:	
	li $v0,54 			#input dialog string code
	la $a0,message1			#address of the null-terminated message string
	la $a1,string			#address of input buffer
	la $a2,100			#maximum number of characters to read
	syscall
get_length:	
	la $a0,string		#a0 = Address(string[0])
	xor $s0,$zero,$zero	#s0 = length = 0
	xor $t0,$zero,$zero	#t0 = i = 0
check_char:	
	add $t1,$a0,$t0		
	lb $t2,0($t1)		#t2 = string[i]
	beq $t2,$s1,end_of_str	#Is null char?
	addi $s0,$s0,1		#length=length+1
	addi $t0,$t0,1		#i = i + 1
	j check_char		#jump to check char
end_of_str:
end_of_get_length:
jal process

process:
#init value
add $s2,$s0,-2			#$2=length-2
li $t0, 0 			#i = 0
add $t1, $zero, $a0		#gia tri co so cua string

loop:
	beq $t0,$s2,true 	#neu i = length -2 tra ve true
	lb $t4,0($t1)		#string[i]
	lb $t5,1($t1)		#string[i+1]
	lb $t6,2($t1)		#string[i+2]
	sub $t7, $t5, $t4  	#$t7=t5-$t4
	sub $t8, $t6, $t5  	#$t8=$t6-$t5
	abs $t7, $t7		# $t7 = |$t7|
	abs $t8, $t8		# $t8 = |$t8|
	bge $t7,$t8,false	#neu $t7 >= $t8 =>false
	add $t1,$t1, 1		#tang dia chi co so len 1
	add $t0,$t0,1		#i+=1
	j loop
true:
	li $v0,4
	la $a0, TRUE
	syscall
	
	li $s5,1				#tra ve $s5=1 neu true
	li $v0, 10
	syscall
	
false:
	li $v0,4
	la $a0, FALSE
	syscall
	
	li $s5,0				#tra ve $s5=0 neu false
	li $v0, 10
	syscall
exit:
jr $ra
