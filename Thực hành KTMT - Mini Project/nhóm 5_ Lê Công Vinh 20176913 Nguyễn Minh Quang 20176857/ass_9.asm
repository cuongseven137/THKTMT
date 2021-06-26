.data 

	num: .word '5'
	
	James: .asciiz "\nJames    "
	John: .asciiz  "\nJohn   "
	Mary: .asciiz "\nMary  "
	Henry: .asciiz "\nHenry   "
	Linda: .asciiz "\nLinda   "

	names: .word James, John, Mary, Henry, Linda	#N={James, John, Mary, Henry, Linda}
	
	i: .word 0					#i=0
	size: .word 4 					#n=4
	marks: .word  5, 6, 8, 2, 3			#M={5, 6, 8, 2, 3}
	
	mes1: .asciiz "1. The number of students in the class is: "
	mes2: .asciiz "\n\n---------------\n\n2. The information about each student is: "
	mes3: .asciiz  "\n\n---------------\n\n3. List the names of all students who have not passed the Math exam is: "

.text 

main:
	#The number of students in the class
	li 	$v0, 4
	la 	$a0, mes1				#print mes1
	syscall 	
	
	li 	$v0, 4
	la 	$a0, num				#print num
	syscall 	
	
	#The information about each student
	la 	$t0, names
	lw 	$t1, i					#i=0
	lw 	$t2, size				#n=4
	la 	$t5, marks
	
	li 	$v0, 4
	la 	$a0, mes2				#print mes2
	syscall 	

begin_loop:	
 	bgt 	$t1, $t2, exit_loop			#if i>n, endloop
	sll 	$t3, $t1, 2				#t3=4*i = 4*t1
	
	addu 	$t6, $t3, $t0				#t6 = 4*i + memory location of the names
	addu 	$t4, $t3, $t5				#t4 = 4*i + memory location of the marks
	
	li	$v0, 4
	lw	$a0, 0($t6)				#print N[i]
	syscall
	
	li      $v0, 1
	lw      $a0, 0($t4)				#print M[i]
	syscall
	
	addi	 $t1, $t1, 1				#i=i+1
	
	j begin_loop					#jump to begin_loop
	
exit_loop:

	#List the names of all students who have not passed the Math exam
	la 	$t0, names
	lw 	$t1, i					#i = 0
	lw 	$t2, size				#n = 4
	la 	$t5, marks		
	
	li 	$v0, 4
	la 	$a0, mes3 				#printf mes3
	syscall 	
	
start_loop:	
	bgt 	$t1, $t2, out_loop			#if i>n, endloop
	sll 	$t3, $t1, 2				#t3=4*i
	addu 	$t4, $t3, $t5				#4*i = 4*i + memory location of the marks
	
	lw	$t7, 0($t4)
	
	slti    $t7, $t7,4				#if M[i]<4
	beq 	$t7, 0, continue 
	
	addu 	$t6, $t3, $t0				#4*i = 4*i + memory location of the names
	
	li	$v0, 4
	lw	$a0, 0($t6)				#print N[i]
	syscall
	
	li      $v0, 1
	lw    $a0, 0($t4)				#print M[i]
	syscall
	
	addi 	$t1, $t1, 1				#i=i+1
	
	j	start_loop				#jump to start_loop
	
continue:
	
	addi $t1, $t1, 1				#i=i+1
	
	j start_loop					#jump to start_loop
out_loop:
	
	
