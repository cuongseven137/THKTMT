.data
iterator: .word 1
input1: .asciiz                               "1. Input a number: \n"
size: .word 0


output1: .asciiz                              "\n---------------\n2. 2^n where n is value of input equal to: "
output2: .asciiz                              "\n---------------\n3. square value of input equal to: "
#space: .asciiz                                "\n"

message: .asciiz                              "wait\n"
ans: .asciiz                                  "\n---------------\n4. nHexadecimal equivalent: " 
result: .space 8                              #byte space


.text
#================================================================#
main:
        li $t2, 2             # store t2 = 2
        
#store iterator value to $t1
	lw $t1, iterator                       #t1=iterator
	jal input                              #jump to input
	nop
	jal power                              #jump to power
	nop
	jal square                             #jump to square
	nop

end_main:li $v0, 10                                # exit
       syscall
       
       
#=============================================================#
#Proceduce: input
#@param [in]         $t0: chua so n nhap tu ban phim
#@return         khong co
#=============================================================#
input:
	li	$v0, 4                        #print decimal integer
	la	$a0, input1                   #print input1
	syscall                               #call system 
	
#Get input
	li $v0, 5                             #read integer
	syscall
#store input1 value to $t0
	move $t0, $v0                          #t0=v0
	blt $t0,$zero,input                    #if t0<0 jump to input 
#if t0=0 then print value of zero	
	bnez $t0,power                          #jump to power if t0 >< 0
	li $t2, 1                              #print integer
	j  print_value                         #jump to print_value


#=============================================================#
#Proceduce: power   
#param   [in] $t0: gia tri n ban dau    
#@return $t2 : gia tri 2^n
#=============================================================#

power:
       beq $t1, $t0, print_value                         #if t1=t0 then print_value
       sll $t2, $t2, 1                                  #2^n
       addi $t1, $t1, 1                               #increment iterator
       j power           
print_value:                                  
       li $v0, 4                                      #in chuoi
       la $a0, output1                                #print output1
       syscall
       li $v0, 1                                      #in gia tri 2^n
       move $a0, $t2                                  #print value 
       syscall
       

#=============================================================#
#Proceduce: square
#@param  [in]  $a0: gia tri n nhap vao
#@return $t1: gia tri n^2
#=============================================================#

square:
       li $v0, 4                                 #in chuoi
       la $a0, output2                           #print output2
       syscall

#calculate n^2
       move $t1, $t0                             #t1=t0
       mul $t1, $t1, $t1                         #t1=t1*t1


#print value
       li $v0, 1                                      #in n^x
       move $a0, $t1                                  #store a0 to t1
       syscall
end_square:    j hexa
#=============================================================#
#Proceduce: chance n from dec to hexa
#@param [in]  $t0: gia tri n ban dau
#@return   $t3: result of calculate 
#=============================================================#

hexa:
       move $t2, $t0                                  #t2=t0

       la $a0, ans                                    #print ans
       li $v0, 4                                      #print chuoi
       syscall 
       li $t0, 8                                 # couter = 8
       la $t3, result                            # where answer will be stored 


Loop: 
       beqz $t0, Exit                            # if t0=0 then exit//8bit
       rol $t2, $t2, 4                           # rotate 4 bits from the left to the right 
       and $t4, $t2, 0xf                         # mask with 1111 
       ble $t4, 9, Sum                           # if less than or equal to nine, branch to sum 
       addi $t4, $t4, 55                         # if greater than nine, add 55 

       b End                                     # branch to end

Sum: 
       addi $t4, $t4, 48                         # add 48 to result 


End: 
       sb $t4, 0($t3)                            # store hex digit into result 
       addi $t3, $t3, 1                          # increment address counter 
       addi $t0, $t0, -1                         # decrement loop counter // 8bit -1
       j Loop                                    # jump to Loop
end_hexa: jr $ra                                

Exit: 
       la $a0, result                            #load dia chi cua result vao a0
       li $v0, 4                                 # print result
       syscall 

