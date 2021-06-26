.data
Message1:	.asciiz	"Enter string: "
Message2:	.asciiz	"Number of different characters: "
ErrorMessage:	.asciiz "Character is out of range(a-z)"
string:		.space	20
AppearedChars:	.space 	26

.text
main:		li $v0, 54
		la $a0, Message1
		la $a1, string
		la $a2, 20
		syscall
		
		la $a0, AppearedChars	# a0 = Address(AppearedChars[0])
		la $a1, string		# a1 = Address(string[0])
		
		jal validate		# validate
		nop
		add $s1, $0, $0 	# s1 = number of different character = 0
		jal count_dif		# count_dif
		nop
output:		
		li $v0, 56
		la $a0, Message2
		addi $a1, $s1, 0
		syscall
		
		li $v0, 10 		#exit
		syscall
end_main:
#-------------------------------------------------------------------------------
# procedure validate
# function: check if input string only consists of lower alphabetic characters (a-z)
# $t0: pointer to characters of input string (a1) 
# $s0: init i = 0
# $s5, $s6: store hexadecimal value of character 'a', 'z'
#-------------------------------------------------------------------------------
validate:
		add $s0, $0, $0			# s0 = i = 0
		li $s5, 'a'			# s5 = 'a'
		li $s6, 'z'			# s6 = 'z'	
loop_valid:
		add $t0, $s0, $a1 		# t0 = s0 + a1 = address of string[i]
		lb $t1, 0($t0) 			# t1 = value at t1 = string[i]
		beq $t1, 0xa, end_of_validate	# if string[i] == \n, exit
		nop
		slt $t2, $s6, $t1 		# check if string[i] > 'z'
		bne $t2, $0, error		# then error
		nop
		slt $t2, $t1, $s5 		# check if string[i] < 'a'
		bne $t2, $0, error		# then error
		nop
		addi $s0, $s0, 1 		# i = i + 1
		j loop_valid			# next character
end_of_validate:	
		jr $ra
#-------------------------------------------------------------------------------
# procedure count_dif
# function: count the number of different characters in string
# $a0:	address of the array that mark the characters appeared in input string
# $a1: address of input string
# $s1: store the number of different characters in input string (output)	
# $s0: init i = 0
#-------------------------------------------------------------------------------	
# first_met: if it's the first time character appeared then 
# increase the value of s1 ((s1++)
# save in AppearedChars value by 1 (means 'appeared')
# return to loop
#-------------------------------------------------------------------------------
count_dif:	
		add $s0,$0,$0			# s0 = i = 0
loop:
		add $t0, $s0, $a1 		# t0 = s0 + a1 = address of string[i]
		lb $t1, 0($t0) 			# t1 = value at t1 = string[i]
		sub $t2, $t1, $s5		# t2 = string[i] - 'a'
		add $t3, $t2, $a0 		# t3 = (string[i] - 'a') + a0 = address of AppearedChars[string[i]-'a']
		lb $t4, 0($t3)			# t4 = AppearedChars[i])
		beq $t1, $0, end_count_dif	# if string[i] == 0, exit
		nop
		beq $t4, 0, first_met		# check if the character have appeared ? if not go to first_met
		nop
		addi $s0, $s0, 1 		# i = i + 1
		j loop				# next character
first_met:
		addi $s1, $s1, 1		# s1 = s1 + 1
		addi $t4, $t4, 1		# t4 = 0 + 1 = 1
		sb $t4, 0($t3)			# AppearedChars[i]) = 1
	
		addi $s0, $s0, 1 		# i = i + 1
		j loop				# next character
end_count_dif:	
		jr $ra
#-------------------------------------------------------------------------------
# procedure error
# function: print error
#-------------------------------------------------------------------------------
error:
	li $v0, 55
	la $a0, ErrorMessage
	la $a1, 0
	syscall
