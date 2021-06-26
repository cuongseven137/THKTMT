# Group 3 : Can Duc Loi - Le Duc Loi
# Teacher : Le Xuan Thanh
#****************************************************************
# Ex5: Get Decimal number. Convert result to the binary and hexa
#****************************************************************
# convertBinary 	:function that convert decimal to Binary
# convertHexa	 	:function that convert decimal to Hex 
# $s0			:The Float point 's Decimal
# $s6, $s7		:Decimal's value coppy
# Hex_result		:Where contains Hexa's value


.data 
	mess:		.asciiz "Input the number: "
	errorMess1:	.asciiz "Invalid format"
	errorMess2:	.asciiz "The number is over follow"
	output:		.asciiz "Input's Decimal: "
	output1:	.asciiz "\nDecimal -> Binary:     "
	output2:	.asciiz "\nDecimal -> Hexa:       0x"
	Hex_result: 	.space 8 	
	
.text
	li $t9, 2147483647	# max number, if greater than max, invalid number
start:
	
	la $a0, mess		
	li $v0, 53		# $f0 contains double value, $a1 contains status 
	syscall 
	bne $a1, $zero, error1	# if a1 # 0 (error), check to error branch
	cvt.w.d $f0, $f0	# take the double FP num and convert to int
	mfc1	$s0, $f0	# store the Decimal's value
	subu $t9, $t9, $s0 
	beq $t9, $zero, error2	# branch to error2
	j main

# Invalid format error proceduce
error1:
	la $a0, errorMess1
	li $v0, 55
	syscall
	j start			# if input number is invalid format => input again

# The number is too big	proceduce
error2:
	la $a0, errorMess2
	li $v0, 55
	syscall
	j start			# if input number is too big => input again
	
# main function
	.globl	main
main:	
	la $a0, output
	li $v0, 4
	syscall
	add $a0, $s0, $zero
	li $v0, 1
	syscall
	la $a0, output1		
	li $v0, 4
	syscall
	jal ConvertBinary	# call convertBinay function to print Binary's result
	la $a0, output2
	li $v0, 4
	syscall
	jal ConvertHexa		# call convertHexa function to print Hexa's result
	j exit
	
exit:
	li $v0, 10		# exit the program
	syscall

# Convert Binary function
ConvertBinary:
	move $s6, $s0		# coppy the Decaimal's value to use in convertBinary
	li $t0, 32		# set i = 32 ( 32 bits in Binary Base)
	li $v0, 1		# print a0
Loop1: 
	bltz $s6, Bit1		# if $s0 < 0 (negative) => check to Bit1 (branch to set a0 = 1)
	li $a0, 0		# else a0 = 1
	j Display
Bit1: 	
	li $a0, 1
Display:
	syscall
Next:
	subi $t0, $t0, 1	# next letter
	beqz $t0, return	# check print's ability. If  == 0, exit the function
	sll $s6, $s6, 1		# s0 << 1
	j Loop1
	
return:
	jr $ra			# return main

#Convert Hexa Function	
ConvertHexa:
	move $s7, $s0		# coppy Decimal's value 
	li $t0, 8		# set i = n ( 32 bits was printed with 8 letters in Hexa)
	la $t1, Hex_result	# load address of result
Loop2: 
	beqz $t0, Return2 	# branch to exit if i == 0
	rol $s7, $s7, 4 	# rotate 4 bits to the left 
				# bit shiffted of the left end of a data word fill the vacated positons on the right
	and $t2, $s7, 0xf 	# mask with 1111
	ble $t2, 9, Sum 	# if $t2 <= 9 , branch to sum 
	addi $t2, $t2, 55 	# if $t2 > 9, add 55 (ascii's code: A)
	j End 			
Sum: 
	addi $t2, $t2, 48 	# add 48 to result ( from 48 is Ascii's code: 0)
End: 
	sb $t2, 0($t1)		# store hex digit into result 
	addi $t1, $t1, 1 	# increment address counter 
	addi $t0, $t0, -1 	# i --
	j Loop2
Return2: 	
	la $a0, Hex_result 	# get Result to print
	li $v0, 4
	syscall
	jr $ra			# return main
	
	
	
	

	
	
