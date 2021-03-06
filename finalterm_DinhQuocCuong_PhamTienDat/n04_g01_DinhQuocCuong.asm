# Mars bot
.eqv HEADING 0xffff8010 			#Integer: 1 goc giua 0-359
.eqv MOVING 0xffff8050 				#Boolean: co di chuyen hay khong di chuyen
.eqv LEAVETRACK 0xffff8020			#Boolean (1/0): co hay khong de lai track 
# .eqv thay gia tri bang bien
# Key matrix
.eqv OUT_ADDRESS_HEXA_KEYBOARD 0xFFFF0014
.eqv IN_ADDRESS_HEXA_KEYBOARD 0xFFFF0012
.data
#.asciiz Luu chuoi gia tri
# postscript-DCE => num 0
# (rotate,time,0=untrack | 1=track;)
postscript1: .asciiz "90,3000,0;180,4000,0;180,5800,1;80,500,1;70,500,1;60,500,1;50,500,1;40,500,1;30,500,1;20,500,1;10,500,1;0,500,1;350,500,1;340,500,1;330,500,1;320,500,1;310,500,1;300,500,1;290,500,1;280,490,1;90,6000,0;260,500,1;260,500,1;260,500,1;200,500,1;200,500,1;200,500,1;200,500,1;200,500,1;160,500,1;160,500,1;160,500,1;160,500,1;160,500,1;160,500,1;90,500,1;90,500,1;90,500,1;90,500,1;90,3800,0;270,2400,1;0,5600,1;90,2400,1;180,2600,0;270,2400,1;90,2400,0;"
# postscript-CUONG => num 4
postscript2: .asciiz "90,3000,0;180,4000,0;260,500,1;260,500,1;260,500,1;200,500,1;200,500,1;200,500,1;200,500,1;200,500,1;160,500,1;160,500,1;160,500,1;160,500,1;160,500,1;160,500,1;90,500,1;90,500,1;90,500,1;90,500,1;90,900,0;0,5600,1;180,5600,0;90,2800,1;0,5600,1;90,3700,0;290,500,1;260,500,1;250,500,1;240,500,1;230,500,1;220,500,1;210,500,1;200,500,1;190,500,1;180,500,1;170,500,1;160,500,1;150,500,1;140,500,1;130,500,1;120,500,1;110,500,1;100,500,1;90,500,1;80,500,1;70,500,1;60,500,1;50,500,1;40,500,1;30,500,1;20,500,1;10,500,1;0,500,1;350,500,1;350,500,1;330,500,1;320,500,1;310,500,1;300,500,1;290,500,1;280,500,1;270,500,1;90,3800,0;180,5600,1;0,5600,0;150,6200,1;0,5600,1;90,3600,0;290,500,1;260,500,1;250,500,1;240,500,1;230,500,1;220,500,1;210,500,1;200,500,1;190,500,1;180,500,1;170,500,1;160,500,1;150,500,1;140,500,1;130,500,1;120,500,1;110,500,1;100,500,1;90,500,1;80,500,1;70,500,1;60,500,1;50,500,1;0,500,1;0,500,1;0,500,1;0,500,1;270,900,1;90,900,0;90,900,1;90,100,0;"
# postscript-TDAT => num 8
postscript3: .asciiz "90,3000,0;180,4000,0;180,5800,1;0,5800,1;270,1200,1;90,1200,0;90,1200,1;90,1000,0;180,5800,1;80,500,1;70,500,1;60,500,1;50,500,1;40,500,1;30,500,1;20,500,1;10,500,1;0,500,1;350,500,1;340,500,1;330,500,1;320,500,1;310,500,1;300,500,1;290,500,1;280,490,1;90,2100,0;180,5800,0;20,6050,1;160,6050,1;340,3100,0;270,1950,1;90,1200,0;180,3000,0;90,2050,0;0,5800,1;270,1200,1;90,1200,0;90,1200,1;"
.text
# key matrix
	li $t3, IN_ADDRESS_HEXA_KEYBOARD 	#gan 2 cai t3, t4
	li $t4, OUT_ADDRESS_HEXA_KEYBOARD
polling: 
	li $t5, 0x01 				# dong1 key matrix 
        sb $t5, 0($t3)                        
	lb $a0, 0($t4)                        # lay phim 0
	bne $a0, 0x11, NOT_NUM_0              # 0 thi doc ps1 / not 0 -> check num #
	la $a1, postscript1 
	j START
	NOT_NUM_0:
	li $t5, 0x02 				# dong2 key matrix
	sb $t5, 0($t3)                         #luu tru bit
	lb $a0, 0($t4)                         # lay phim 4
	bne $a0, 0x12, NOT_NUM_4               # 4 thi doc ps2 / not 4 -> check num #
	la $a1, postscript2
	j START
	NOT_NUM_4:
	li $t5, 0X04 				# dong3 key matrix
	sb $t5, 0($t3)
	lb $a0, 0($t4)                         # lay phim 8
	bne $a0, 0x14, COME_BACK               # 
	la $a1, postscript3
	j START
COME_BACK: j polling 				# khi cac so 0,4,8 khong duoc chon -> quay lai doc tiep

# xu li mars bot
START:
	jal GO
READ_POSTSCRIPT: 
	addi $t0, $zero, 0 			# luu gia tri goc quay
	addi $t1, $zero, 0			# luu gia tri time
	
READ_ROTATE:                                   # doc goc quay
 	add $t7, $a1, $t6 			# dich tung ki tu    # start t6=0    #$a1: dia chi postscript  
        lb $t5, 0($t7)  			# doc cac ki tu cua postscript   #$t5: gia tri so nhap vao
	beq $t5, 0, END 			# khong gap ki tu nao, ket thuc postscript
 	beq $t5, 44, READ_TIME 			# gap ki tu ','
 	mul $t0, $t0, 10                       # x10
 	addi $t5, $t5, -48 			# So 0 co thu tu 48 trong bang ascii.
 	add $t0, $t0, $t5  			# cong cac chu so lai voi nhau.
 	addi $t6, $t6, 1 			# tang ky tu can dich chuyen len 1
 	j READ_ROTATE 				# quay lai doc tiep den khi gap dau ','
 	
READ_TIME: 				        # doc thoi gian chuyen dong.
 	add $a0, $t0, $zero                    # gan a0=t0
	jal ROTATE
 	addi $t6, $t6, 1
 	add $t7, $a1, $t6 			# ($a1 luu dia chi cua postscript)
	lb $t5, 0($t7) 				# doc cac ki tu cua postscript #$t5: gia tri so nhap vao
	beq $t5, 44, READ_TRACK			# gap ki tu ','
	mul $t1, $t1, 10
 	addi $t5, $t5, -48			# So 0 co thu tu 48 trong bang ascii.
 	add $t1, $t1, $t5			# cong cac chu so lai voi nhau.
 	j READ_TIME 				# quay lai doc tiep den khi gap dau ','
 	
READ_TRACK:                                    # cat
 	addi $v0,$zero,32 			# Keep mars bot running by sleeping with time=$t1
 	add $a0, $zero, $t1                    #t1 time
 	addi $t6, $t6, 1 
 	add $t7, $a1, $t6			# ($a1 luu dia chi cua postscript)
	lb $t5, 0($t7) 				# doc cac ki tu cua postscript #$t5: gia tri so nhap vao
 	addi $t5, $t5, -48			# So 0 co thu tu 48 trong bang ascii.
 	beq $t5, $zero, CHECK_UNTRACK 		# 1=track | 0=untrack
        jal UNTRACK
	jal TRACK
	j INCREAMENT
	
CHECK_UNTRACK:
	jal UNTRACK
INCREAMENT:
	syscall
 	addi $t6, $t6, 2 			# bo qua dau ';'
 	j READ_POSTSCRIPT
#-----------------------------------------------------------
# GO procedure, to start running
# param[in] none
#-----------------------------------------------------------
GO: 
 	li $at, MOVING 		# change MOVING port
 	addi $k0, $zero,1 	# to logic 1,
 	sb $k0, 0($at) 		# to start running
 	nop
 	jr $ra
 	nop
#-----------------------------------------------------------
# STOP procedure, to stop running
# param[in] none
#-----------------------------------------------------------
STOP: 
	li $at, MOVING 		# change MOVING port to 0
 	sb $zero, 0($at)	# to stop
 	nop
 	jr $ra
	nop
#-----------------------------------------------------------
# TRACK procedure, to start drawing line
# param[in] none
#----------------------------------------------------------- 
TRACK: 
	li $at, LEAVETRACK 	# change LEAVETRACK port
 	addi $k0, $zero,1 	# to logic 1,
	sb $k0, 0($at) 		# to start tracking
 	nop
 	jr $ra
 	nop
#-----------------------------------------------------------
# UNTRACK procedure, to stop drawing line
# param[in] none
#----------------------------------------------------------- 
UNTRACK:
	li $at, LEAVETRACK 	# change LEAVETRACK port to 0
 	sb $zero, 0($at) 	# to stop drawing tail
 	nop
 	jr $ra
 	nop
#-----------------------------------------------------------
# ROTATE procedure, to rotate the robot
# param[in] $a0, An angle between 0 and 359
# 0 : North (up)
# 90: East (right)
# 180: South (down)
# 270: West (left)
#-----------------------------------------------------------
ROTATE: 
	li $at, HEADING 	# change LEAVETRACK port to 0
 	sw $a0, 0($at)		# to stop drawing tail
 	nop
 	jr $ra
 	nop
END:
	jal STOP
	li $v0, 10
	syscall
	j polling
#end
