.data
string:		.space	20
Message:	.asciiz	"Enter string: "
Message1:	.asciiz	"Is a surpassing word!"
Message2:	.asciiz	"Not a surpassing word!"

.text
main:
		li $v0, 54
		la $a0, Message
		la $a1, string
		la $a2, 20
		syscall
		la $a0,string			# a0 = Address(string[0])
		li $s1,-1			# s1 = gap = -1
		
		jal check_special
		nop
		bne $s3, $0, true_cls		# if s3 != 0, mean 'true' then print true
		nop
		jal surpassing_word		# jump to suprpassing_word
		nop
		beq $s3, $0, false_cls		# if s3 = 0, mean 'false' then print false
		nop
		j true_cls			# else, mean 'true' then print true
end_main:	li $v0, 10 			#exit
		syscall
		
#-------------------------------------------------------------------------------
# check_special: the empty string and a 1-character string is a valid surpassing word
# 	if string is 1 of 2 cases, return value 1 in $s3
#-------------------------------------------------------------------------------
check_special:		
		lb $t0,0($a0)			# t0 = string[0]
		beq $t0,$zero, true		# if empty string then jump to true case
		lb $t0,1($a0)			# t0 = string[1]
		beq $t0,0xa,true		# if 1-character string then jump to true case
		nop
		j after_special_check
true:		
		addi $s3, $0, 1			# s3 = 1
		j after_special_check
after_special_check:
		jr $ra
#-------------------------------------------------------------------------------
# procedure surpassing_word
# function: check if input string is a surpassing word 
#	(the gap between each adjacent pair of letters strictly increases)
# $a0: address of input string
# $s1: store the gap between previous adjacent pair of letters, init = -1	
# $s3: return value 1 if string is surpassing word and 0 if not a surpassing word 
#-------------------------------------------------------------------------------
surpassing_word:
		add $s0,$0,$0			# s0 = i = 0
loop:		
		add $t0,$s0,$a0 		# t0 = s0 + a0 = address of string[i]
		lb $t1,0($t0)			# t1 = string[i]
		lb $t2,1($t0) 			# t2 = string[i+1]
		
		beq $t2,0xa,end_of_loop		# if string[i+1] == \n, exit
		slt $t0,$t1,$t2			# check if string[i] < string[i+1] ?
		beq $t0,$0, calc_gap		# if not, jump to calc_gap
		nop
		sub $s2, $t2, $t1		# s2 = current gap = string[i+1] - string[i]	
after_cal_gap:
		slt $t0,$s1,$s2			# if prev gap < current gap  
		beq $t0,$0, false_case		# if not, jump to false conclusion
		nop
		add $s1,$s2,$0			# then s1 = s2 (prev gap = cur gap)
		nop
		addi $s0,$s0,1 			# i = i + 1
		j loop				# next character
true_case:	
		addi $s3, $0, 1			# s3 = 1
		j end_surpassing_word
false_case:	
		addi $s3, $0, 0			# s3 = 0
		j end_surpassing_word
end_of_loop:	
		j true_case
end_surpassing_word:
		jr $ra
#-------------------------------------------------------------------------------
# calc_gap: calculate gap if string[i] > string[i+1]		
#-------------------------------------------------------------------------------	
calc_gap:
		sub $s2,$t1,$t2			# s2 = current gap = string[i] - string[i+1]	
		j after_cal_gap
#-------------------------------------------------------------------------------
# true_cls: show dialog if input string is a surpassing word 
# false_cls: show dialog if input string isn't a surpassing word 		
#-------------------------------------------------------------------------------
true_cls:	
		li $v0, 55
		la $a0, Message1
		la $a1, 1
		syscall	
		j end_main
false_cls:	
		li $v0, 55
		la $a0, Message2
		la $a1, 0
		syscall
		j end_main
