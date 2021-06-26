# Nguyen Tung Lam MSSV:20176800
.data
	Message: .asciiz "Enter your name”
	MessageOut: .asciiz "Your name is: \n"
	MessageFailse: .asciiz " Invalid Input"
	string: .space 100
	output: .space 100
.text

# get input in InputMessageDialog
	li $v0, 54
	la $a0, Message
	la $a1, string
	la $a2, 100
	syscall

	la $s0,10 				  # assign s0 is end char ‘\n’ 
	li $t5,0 				  # assign t5 = i = 0
	la $a0,string                             # a0=addr (inputString[0])
	la $a1, output
	add $a2,$a0,0                         	  # $a2 = $a0 ($a0 is string)


#-----------------------------------------------------------------------------------------------
#getlength, check_char and continue to find length of input string
# if length =0 ->exit
#if lenght !=0  has 3 case
# first, string has 1 word ? exit beacause not in form lastName- firstName
# second, string has >2 word -> findFistName copy to output string and then add space character and finally copy the last name
# third, no word in input string or special character ? exit 

#--------------------------------------------------------------------------------------------------	

get_length: 
	
 		li $v1,0                #v1 = length = 0 (init length = 0 $v1 is current character)

check_char:	
		add $t1,$a0,$v1 	# t1 = a0 + t0 ( t1 = string + length ) dia chi ki tu dang duoc doc 
					# addr string [0]+i
		lb $t2,0($t1) 		#t2 = string[i] (take string[i] init i = 0)
		
		beq $t2,32,flat		#if t2 == ' ' go to flat
		beq $t2,10,trim	        #if is end char? (if t2 = \n => trim)
		jal checkCharCondition  # save address of the next line in $ra 

continue:	addi $v1,$v1,1	        #v1++->length=length+1 ( i++ current character)
		j check_char
		

checkCharCondition:     sgt $t3,$t2,122   	# if t2 > 'z' ( t2 = string[i]) t3 you know the flag 1 or 0 
			beq $t3,1, exit 	# if t2 > ’z’ exit ( if t3 # text go to exit)
			slti $t3,$t2,65 	# if(t2 < A) exit ( lenh so sanh voi hang so )
			beq $t3,1,exit
			
		
			slti $t3,$t2,97  	# if t2<'a' t3=1 else t3=0
			sgt $t6,$t2,90 		# if t2>'Z' t6=1 else t6 =0
			
			beq $t3,1,next		# if  t2 < ’a’ next

backloop:  		jr $ra    		# continue loop check_char

next:			beq $t6,$t3, exit	# if  t2 <’a’ && t2 >’Z’ ? exit
		        j backloop

add:		        addi $a2,$a2,1 	        # a2++, a2 = next address character
			 j t


#-----------------------------------------------------------------------------------------------
#s3 to determine space at beginning of input string and count number of element in stack(dem so phan tu trong ngan xep)
#-------------------------------------------------------------------------------------------------



flat: 			beq $s3,$v1,add  	 # if s3 = v1 => add, means space at beginning of input (dau cach cuoi cung) #string
					 	 # kiem tra dau cach dau current charactor = s3 = 0 dang co dau cach
# tim duoc dia chi chu cai dau tien cua moi tu trong ten sau do push vao stack
t:			addi $sp, $sp, -4  	 #adjust the stack pointer (mo rong stack )
			addi $s3,$s3,1		 # s3++ t?ng                 
			la   $s0,($t1)		 # s0 is address of $t1( address of string[$v1])
			addi $s4,$v1,1           # s4 is index+1 of space  $v1 is current charecter (s4 dia chi chu cái dau cua tên)
			sw   $s4,0($sp)          # push s4 to stack
	
 			j continue  		 # continue loop



trim:   
#------------------------------------------------------------------------------------------------
		# first I determine some invalid situation of input string
#-------------------------------------------------------------------------------------------------

		 beq $s3,$v1,exit 	# if string input only have spaces-> exit( so dau cach duoc dem  (so tu s3) ) 
	         beq $s0,10,exit 	# if s0 = endchar that means string has 1 word go to exit( ten co 1 tu) 10 = \n
	         beq $v1,0,exit 	# if string has no word-> exit (v1 = length input )

	         addi $t6,$v1,0         # t6=v1= length of input ( vi tri cua dau cach cuoi)
			                # when index of space= t6 means space at end of input

# lay cac dia chi trong stack => 
loop2:			addi $t8,$t8,1 			# t8=j++ (init t8 = 1)
			lw   $s4,0($sp)  		# pop s4 from stack ( s4 is address of current charector + 1)
			addi $sp,$sp,4            	# adjust the stack pointer ( chinh con tro ngan sep theo quy tac)
			bne  $s4,$t6, findFirstName     # s4 = t6 thi dang o vi tri dau cach cuoi 
			addi $t6,$t6,-1           	# else t6-- ( tr? t?i khi 
			bne  $s3,$t8, loop2  		# if s3!=t8 means stack still have (s3 is word number) #elements continue loop2.
	
# => dia chi dau cach cuoi cung + kiem tra dieu kien vv..
findFirstName:
			           
   			add $t6,$t6,$a0  		# t6 = address Input[i] = address of last (a0 address of first charector)#character after last letter 

			addi $s4,$s4,-1  		# s4-- Note before I add 1 to index now i have #to sub 1
			add $s0,$a0,$s4                 # s0=adrress of last space before letter(s0 dia chi dau cách cuoi cùng)
			ble $s0,$a2, exit               # if s0<a2 means have 1 word ? exit ( dia chi dau cach < dia chi kí tu dau tien )
						        # a2 is addr of the first letter of input #string
			addi $v0,$s0,-1	                # v0 = s0 -1

# take the first name then sb to t3 			
 loop:   		addi $v0,$v0,1      		# go to next addr of v0 ( v0 is dia chi dau cách cuoi cung)
  	  		lb $t2,0($v0)  			# load value of v0 ( load charactor of first name )
   	 		beq $v0,$t6,addSpace 		# if t2=t6 -> addSpace ( t6 dia chi input)
			add $t3,$t5,$a1  	        # t3=output[i]  (t5 bien dem kí tu trong tu)
			sb $t2,0($t3)			# store t2 to output[i]
			nop
 			addi $t5,$t5,1		        # i=i+1
 			j loop  	 		# jump to loop

 	
addSpace: 		lb $t4,0($s0) 				# load value s0 ( s0 vi tri cua dau cach cuoi)
			seq $t9,$t4,$zero 			# if t4 == 0(null char) => t9 = 1  (t9 is flag) 
			beq $t9,1, FindLastName 		# go to FindLastName ( neu ma co dau cach roi)
 			add $t3,$t5,$a1			        # output[i]
			sb  $t4,0($t3)				# t4 dang la address cua dau cach cuoi (output[i]=value of s0( ghi dau cach vao output)
			addi $t5,$t5,1				# i++
		
			

				# copy last name to output string
# lay cac ki tu con lai cua ten bat dau tu dia chi input $a2 		
FindLastName:	
              		lb $t4,0($a2)  			# t4 = value of a2
   			beq $a2,$s0,exit1 		# if a2=s0 exit ( dia chi ki tu duoc doc = dia chi dau cach cuoi)
			add $t3,$t5,$a1 		# output[i]	(  $t3 dia chi ki tu se duoc ghi vao  )
			sb  $t4,0($t3)			#( t4 is current character) output[i]=t4   
			nop
			addi $a2,$a2,1			# next addr of character(load tu dau string $a2 )
 			addi $t5,$t5,1			#i++ (bien dem ki tu duoc doc)
 			j  FindLastName



exit1:   
		        sub $t9,$s3,$t8  		# t9=s3-t8= number of elements are not popped
 							# in stack
			mul $t9,$t9,4   		# t9=t9*4 vi tri con tro top 
 			add $sp,$sp,$t9  		# point stack to top
 			li $v0, 59            		# print output
			la $a0, MessageOut
			la $a1, ($a1)
			syscall
			j terminate   			# jump terminate

exit:   
			 sub $t9,$s3,$t8   		# same in exit1
			 mul $t9,$t9,4
			 add $sp,$sp,$t9
			 
			 
			 li $v0, 55   			# print messageFailse
			 la $a0, MessageFailse
			 syscall
 
terminate:
		         li $v0,4 				 # terminate program
