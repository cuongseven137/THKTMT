# Mid Term Project 10
.data
message:	.asciiz"Enter an integer"
table:	.asciiz"i	Power(2, i)	Square(i)	Hexadecimal(i)\n"
space1:	.asciiz"	"
space2:	.asciiz"		"
newLine:                        .asciiz	       "\n"
hex:	.space		10
	
.text
li	$v0, 4	# print table header
la	$a0, table
syscall 

start:
li	$v0, 51
la	$a0, message
syscall

beq	$a1, -1, start	# $a1 status value (if input is invalid => Re-input)
beq	$a1, -3, start	# $a1 status value (if input is invalid => Re-input)
beq	$a1, -2, exit	# exit if user click cancel
	
blt	$a0, -31, start                 # check if i < -31
bgt	$a0, 30, start	# check if i > 30
add	$s0, $zero, $a0                 # $s0 = i
	
jal	power	# call function power(2, i)
add	$s1, $zero, $v0
	
jal	square	# call function square(i)
add	$s2, $zero, $v0		

jal	hexadecimal	# call function hexadecimal(i)

printResult:	
li	$v0, 1	# print i
add	$a0, $zero, $s0
syscall
li	$v0, 4
la	$a0, space1
syscall
	
checkPowerResult:
bge 	$s0, $zero, printInt
printFloat:
li	$v0, 2	# print float power(2, i)
syscall
li	$v0, 4
la	$a0, space2
syscall
j	printSquare
printInt	:	
li	$v0, 1	# print integer power(2, i)
add	$a0, $zero, $s1
syscall
li	$v0, 4
la	$a0, space2
syscall
	
printSquare:
li	$v0, 1	# print square(i)
add	$a0, $zero, $s2
syscall	
li	$v0, 4
la	$a0, space2
syscall
	
printHex:
li	$v0, 4	# print hexadecimal(i)
la	$a0, hex					
syscall
li	$v0, 4
la	$a0, newLine
syscall
jal	clearHex
	
j	start
	
exit:
li	$v0, 10
syscall
	
#--------------------------------------------------------------------
# @function power
# @param[in]	$s0	User entered integer i
# @return	$v0	i >= 0 power(2, i)
# @return	$f12	i < 0 power(2, i)
#--------------------------------------------------------------------
power:
li	$v0, 1
li	$a0, 0	# $a0 = 0
add	$a1, $zero, $s0	# $a1 = $s0	
bge	$s0, $zero, powerLoop	# $s0 >= 0
sub	$a1, $zero, $s0	# $a1 = -$s0
powerLoop:
beq	$a0, $a1, powerDone	# $a0 == i ? done : loop
sll	$v0, $v0, 1	# $v0 = $v0 * 2
addi	$a0, $a0, 1	# $a0 += 1
j	powerLoop
powerDone:
bge	$s0, $zero, done	# $s0 >= 0
li	$t0, 1
mtc1	$t0, $f0	# $f0 = 1.0
cvt.s.w	$f0, $f0
	
mtc1	$v0, $f2	# $f2 = (float)$v0
cvt.s.w	$f2, $f2
div.s	$f12, $f0, $f2	# $f12 = $f0/$f2
done:	
jr	$ra
		
		
#--------------------------------------------------------------------
# @function square
# @param[in]	$s0	User entered integer i
# @return	$v0	square(i)
#--------------------------------------------------------------------
square:
mul	$v0, $s0, $s0	# $v0 = i * i
jr	$ra
	
	
#--------------------------------------------------------------------
# @function hexadecimal
# @param[in]	$s0	User entered integer i
# @return	none
#--------------------------------------------------------------------
hexadecimal:
la	$a0, hex	# load hex to $a0
add	$a1, $zero, $s0	# $a1 = i
	
li	$t1, 48	# add 0x to hex string
sb	$t1, 0($a0)				
addi	$a0, $a0, 1				
li	$t1, 120					
sb	$t1, 0($a0)				
addi	$a0, $a0, 1				
	
beqz	$s0, hexZero	# $s0 = 0 => hex = "0x0"
	
li	$t0, 8	# counter loop through 32 bits
li	$t2, 0	# flag $t2 ignore 0
	
hexLoop:
beqz	$t0, hexDone	# counter == 0 => return function
andi	$t1, $a1, 0xf0000000	# get most left 4 bits
srl	$t1, $t1, 28	# move 4 bits to most right
beq	$t1, $t2, continue	# $t1 == $t2 (= 0) => ignore 0
ble	$t1, 9, less	# $t1 <= 9 => ASCII Code
addi	$t1, $t1, 55	# [A-F]
j	writeHex
	
less:	
addi	$t1, $t1, 48	# [1-9]
	
writeHex:	
addi	$t2, $t2, -1	# remove flag ignore 0
sb	$t1, 0($a0)	# write ASCII Code to hex string
addi	$a0, $a0, 1
	
continue:	
sll	$a1, $a1, 4	# shift left to get next 4 bits
addi	$t0, $t0, -1	# counter -= 1
j	hexLoop
		
hexZero:
li	$t1, 48	# add 0x to hex string
sb	$t1, 0($a0)				
	
hexDone:
jr	$ra

#--------------------------------------------------------------------
# @function clearHex
# @param[in]		none
# @return		none
#--------------------------------------------------------------------
clearHex:
la	$a0, hex                           # load hex to $a0
li	$a1, 0
clearLoop:
beq	$a1, 10, doneClear
sb	$zero, 0($a0)				
addi	$a0, $a0, 1
addi	$a1, $a1, 1
j                               clearLoop
doneClear:
jr	$ra	





