#--------------------------------------------------------------------------------------------------------------------
# project 17
# Write a program that inputs a string. Extract number characters and show to screen in inverse order using stack.
#-----------------------------------------------------------------------------------------------------------------------
.data
    input:.asciiz "\n hay nhap vao mot xau: "
    output:.asciiz "\n chuoi so trong xau ban dau sau khi dao nguoc: "
    error: .asciiz "\n chuoi ban vua nhap khong chua ki tu so"
     string:.space 100
     lenght:.word 100
     
.text
#-------------------------------------------------------------------------
# ma C
# int main(void){
#     printf("hay nhap vao mot xau:");
#     gets(str);
#     for(i=0; i<strlen(str);i++)
#     {
#        if(str[i]>=0 && str[i]<=9)
#        pushStack(str[i]);
#     }
#     printf("chuoi so trong xau ban dau sau khi dao nguoc:");
#     while(stack!=null){
#       popStack();
#     }
# }
#-----------------------------------------------------------------------


main:
#yeu cau nguoi dung nhap vao mot xau
          
     la   $a0, input         # thanh ghi $a0 chua xau
     li   $v0, 4             # in xau ra man hinh  
     syscall
#doc du lieu tu nguoi dung
     
     la   $a0, string        # thanh ghi $a0 chua xau ban vua nhap
     li   $v0, 8             # doc mot xau vua nhap
     lw   $a1, lenght        # luu xau vua doc vao thanh ghi $a1
     syscall 
     
     move  $t0, $a0          # chuyen dia chi xau nguoi dung nhap vao thanh ghi $t0
     addi  $a1, $0, 0        # khoi tao vi tri i=0 cua xau
     addiu $s0, $sp, 0       # $s0 luu gia tri ban dau thanh ghi stack

     jal   checkNumber
     li    $v0, 10    	
     syscall	
#----------------------------------------------------------
# kiem tra cac kí tu so trong xau 
# theo bang ma ASCII ki tu so bat dau tu 48 den 57 (0-9)
#---------------------------------------------------------
checkNumber:
# kiem tra gia tri phan tu trong chuoi >=0
loop1:
     lb   $t1, 0($t0)          # luu gia tri dau tien trong chuoi vao thanh ghi $t1
     addi $t0, $t0, 1          # i++
     bge  $t1, 48, loop2       # chuyen den loop2 neu $t1>=0 (48 là kí tu so 0 trong bang ma ASCII)
     beqz $t1, print           # if end of string nhay sang print
     j    loop1                # lap lai ham loop1
#kiem tra gia tri cac phan tu trong chuoi <=9
loop2:
     ble  $t1, 57, push        # neu $t1<=9 (57 là kí tu so 9 trong bang ma ascii) thi push gia tri trong t1 vao stack
     j    loop1                # neu $t1 không <=9 lap lai ham loop1
     
#-------------------------------------------------
# sau khi kiem tra dua lan luot cac ki tu vao stack
#sau khi dua tat cac ca ki tu so vao stack roi lay ra va in 
#-----------------------------------------------------------

# push gia tri vao stack
push:
     addiu   $sp, $sp, -4       # khoi tao stack, khai bao kich thuoc cho stack
     sw      $t1, ($sp)         # luu du lieu trong thanh ghi $t1 vao dinh stack
     j       loop1	       # lap lai ham loop1

#hien thi messege ket qua 
print:
     beq   $sp, $s0, Error     # neu $sp= 0 thì nhay den Erorr de in ra thong bao loi
     la   $a0, output          # thanh ghi $a0 chua xau
     li   $v0, 4               # in xau ra man hinh  
     syscall
#lap lay gia tri ra khoi stack va in gia tri 
pop:
       # beq   $sp, $s0, erro
      li    $v0, 11            # in ki tu
      beq   $sp, $s0, end      # neu $sp == gia tri $sp ban dau =>ket thuc chuong trinh
      lw    $a0, ($sp)         # load gia tri dinh stack vao thanh ghi $a0
      addiu $sp, $sp, 4        # $sp tro den phan tu tiep theo trong stack
      syscall              
      j     pop	              # lap lai pop de lay phan tu tiep theo trong stack
Error:
     la   $a0, error          # in ra thong bao loi 
     li   $v0, 4              
     syscall
          
end:
    jr $ra
    
 
     
