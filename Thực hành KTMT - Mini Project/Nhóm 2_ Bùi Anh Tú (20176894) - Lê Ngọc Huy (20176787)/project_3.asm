.data 
list: .space 128
nhapvao: .asciiz "Nhap vao mot so nguyen [0-999 999 999] " 
new: .asciiz "\n" 

linh: .asciiz "linh "
khong0: .asciiz "khong " 
mot1: .asciiz "mot " 
hai2: .asciiz "hai " 
ba3: .asciiz "ba " 
bon4: .asciiz "bon " 
nam5: .asciiz "nam " 
sau6: .asciiz "sau " 
bay7: .asciiz "bay " 
tam8: .asciiz "tam " 
chin9: .asciiz "chin " 
muoi10: .asciiz "muoi "
muoimot11: .asciiz "muoi mot " 
muoihai12: .asciiz "muoi hai " 
muoiba13: .asciiz "muoi ba " 
muoibon14: .asciiz "muoi bn " 
muoinam15: .asciiz "muoi nam " 
muoisau16: .asciiz "muoi sau " 
muoibay17: .asciiz "muoi bay " 
muoitam18: .asciiz "muoi tam " 
muoichin19: .asciiz "muoi chin "
tram100: .asciiz "tram "
nghin: .asciiz "nghin " 
trieu: .asciiz "trieu "   




.text
###########################################################################################################################
#main
    # s0: gia tri nhap vao
    # input: nhap gia tri vao, check xem co hop le khong
    # check4 neu s0 >= 1000.000 , thuc hien chia 1000.000, in ra gia tri thuoc hang trieu
    # check3 neu s0 >=1000  , thuc hien chia 1000 , in ra gia tri hang nghin
    # check2 neu s0 >=100  , thuc hien chia 1000 , in ra "tram" , linh
    # check1 neu s0 >= 20   ,thuc hien chia 10, in ra gia tri tu 20 den 99
    # convert0to19 , in ra gia tri tu 0 den 19
###########################################################################################################################
main:
    
 input:
  la $a0, nhapvao  #load address into $a0
  li $v0, 4      #call to print string
  syscall

  li $v0, 5       #read integer
  syscall
  move $s0, $v0   #inter stored in $s0 $t0 isn't saved registry 

  blt $s0, $zero, input
  bgt $s0, 999999999, input
  
 check4: # neu >= 1000.000 , thuc hien chia 1000.000 
  bge $s0, 1000000, chiamottrieu
 check3: #xem >=1000 hay <1000, neu >= 1000 , thuc hien chia 1000
  bge $s0,1000,chiamotnghin 
 check2: #xem >=100 hay <100, neu >= 100 , thuc hien chia 100
  add $fp,$ra,$zero # luu vi tri , khi ham chia mot nghin goi toi

  bge $s0,100,chiamottram 
 
 check1: #xem >19 hay <=19, neu lon hon hoac ban 20 , thuc hien chia 10

  bge $s0,20,chiamuoi
  
 j convert0to19 
    
  # end main      
                    
 #########################################################################################################################################    
  convert0to19 :#convert0to19: dan den duong linh tuong ung cua tung so
  beq $s0,0,khong 
  beq $s0,1,mot 
  beq $s0,2,hai 
  beq $s0,3,ba 
  beq $s0,4,bon 
  beq $s0,5,nam 
  beq $s0,6,sau 
  beq $s0,7,bay 
  beq $s0,8,tam 
  beq $s0,9,chin
  beq $s0,10,muoi 
  beq $s0,11,muoimot 
  beq $s0,12,muoihai
  beq $s0,13,muoiba
  beq $s0,14,muoibon
  beq $s0,15,muoinam
  beq $s0,16,muoisau
  beq $s0,17,muoibay
  beq $s0,18,muoitam
  beq $s0,19,muoichin


  

 
 output1to19:# in ra tu 0 den 19  
   khong:
      li $v0, 4  
      la $a0, khong0
      syscall
      
      beq $ra,$zero,back
      jr $ra
      
   mot:
      li $v0, 4  
      la $a0, mot1
      syscall 
      
      beq $ra,$zero,back 
      jr $ra
      
    hai:
      li $v0, 4  
      la $a0, hai2
      syscall 
      
      beq $ra,$zero,back 
      jr $ra  
 
    ba:
      li $v0, 4  
      la $a0, ba3
      syscall 
      
      beq $ra,$zero,back 
      jr $ra 
 
     bon:
      li $v0, 4  
      la $a0, bon4
      syscall 
      
      beq $ra,$zero,back
      jr $ra  
      
    nam:
      li $v0, 4  
      la $a0, nam5
      syscall
       
      beq $ra,$zero,back 
      jr $ra  
      
     sau:
      li $v0, 4  
      la $a0, sau6
      syscall 
      
      beq $ra,$zero,back 
      jr $ra  

    bay:
      li $v0, 4  
      la $a0, bay7
      syscall 
      
      beq $ra,$zero, back 
      jr $ra  
                                                                                                                                                                                                                                                                                                                    
    tam:
      li $v0, 4  
      la $a0, tam8
      syscall 
      
      beq $ra,$zero,back
      jr $ra  
      
    chin:
      li $v0, 4  
      la $a0, chin9
      syscall 
      
      beq $ra,$zero,back
      jr $ra  
      
    muoi:
      li $v0, 4  
      la $a0, muoi10
      syscall 
      
      beq $ra,$zero, back 
      jr $ra  
      
    muoimot:
      li $v0, 4  
      la $a0, muoimot11
      syscall 
      
      beq $ra,$zero,back 
      jr $ra  
      
    muoihai:
      li $v0, 4  
      la $a0, muoihai12
      syscall 
      
      beq $ra,$zero,back 
      jr $ra
    
    muoiba:
      li $v0, 4  
      la $a0, muoiba13
      syscall 
      
      beq $ra,$zero,back 
      jr $ra 
      
    muoibon:
      li $v0, 4  
      la $a0, muoibon14
      syscall 
      
      beq $ra,$zero,back 
      jr $ra 
     
    muoinam:
      li $v0, 4  
      la $a0, muoinam15
      syscall 
      
      beq $ra,$zero, back 
      jr $ra 
      
    muoisau:
      li $v0, 4  
      la $a0, muoisau16
      syscall 
      
      beq $ra,$zero,back
       jr $ra 
      
    muoibay:
      li $v0, 4  
      la $a0, muoibay17
      syscall 
      
      beq $ra,$zero,back 
      jr $ra 
      
    muoitam:
      li $v0, 4  
      la $a0, muoitam18
      syscall 
      
      beq $ra,$zero,back
       jr $ra 
      
    muoichin:
      li $v0, 4  
      la $a0, muoichin19
      syscall 
      
      beq $ra,$zero,back 
      jr $ra
          
 chiamottrieu:          
  li $t1,1000000     
  div $s0,$t1  #s0 chia 1.000.000
  mflo $s0     # s0 = s0 /1.000.000
  mfhi $s1   # s1 = S1 %1.000.000
  
  jal check2
  li $ra,0
  li $fp,0
  
  
  li $v0, 4  
  la $a0, trieu
  syscall 
  
  add $s0,$s1,$zero # s0 = S0 %1.000.000
  
  
  
 chiamotnghin:
 
  beq $s0,$zero,back # gia tri = 0 , goi toi back
  li $t1,1000     
  div $s0,$t1  #s0 chia 1000
  mflo $s0     # s0 = s0 /1000
  mfhi $s1   # s1 = s1 %1000
  
  jal check2
  li $ra,0
  li $fp,0
  
  
  li $v0, 4  
  la $a0, nghin
  syscall 
  
  add $s0,$s1,$zero
  
  
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
 chiamottram:
  beq $s0,$zero,back # gia tri = 0 , goi toi back
 
  li $t1,100     
  div $s0,$t1  #s0 chia 100
  mflo $s0     # s0 = s0 /100
  
  jal convert0to19
  li $ra,0
  
  
  li $v0, 4  
  la $a0, tram100 
  syscall 
  
  mfhi $s0   # s0 = S0 %100
  
  beq $s0,$zero,back # phan du bang 0 , thi goi toi back 
  slti $t1,$s0,10
  beq  $t1,1,xuatlinh # vd 101 : mot tram linh mot ( <>mot tram mot)
  j check1
     xuatlinh:
      li $v0, 4  
      la $a0, linh
      syscall 
   j check1    
      
  
 chiamuoi:
  li $t1,10
  div $s0,$t1
  
  mflo $s0
  jal convert0to19
  jal muoi
  
  mfhi $s0
  beq $s0,$zero,back # phan du bang 0 , thi goi toi back 
  jal convert0to19
 

back: #quay lai ham chia mot nghin
  beq $fp,$zero,end
  jr $fp
end:
  
  
