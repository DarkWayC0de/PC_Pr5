.data

  orden:        .word 0
  punto:        .double 0.0  
  petOrden:     .asciiz "Introduzca el orden del polinomio: "
  petPunto:     .asciiz "Introduzca el punto a evaluar: "
  noopc:        .asciiz "OPCION NO VALIDA."  
  mensajeError: .asciiz "WARNING: Orden introducido no valido."
  opcion:       .asciiz "\nIntroduzca un 1 para realizarlo de manera iterativa, 2 para realizarlo de manera recursiva o 0 para salir del programa: "
  HI:           .asciiz "El resultado iterativo es: "
  HR:           .asciiz "El resultado recursivo es: "
.text

main:
  addi $sp, $sp, -24
  sw $ra, 20($sp)

again:
  li $v0, 4
  la $a0, opcion
  syscall
  
  li $v0, 5
  syscall
  move $t2, $v0
  
  beq $t2, $zero, FINAL
  
  blt $t2, $zero, again
  
  bgt $t2, 2, again
  
  li $v0, 4 
  la $a0, petOrden
  syscall
  li $v0, 5
  syscall
  move $t1, $v0

  li $v0, 4 
  la $a0, petPunto
  syscall

  li $v0, 7
  syscall

  move $a0, $t1
  mov.d $f12, $f0

  blt $a0, $zero, ERROR

#C1:
  bne $t2, 1, C2
  jal hermiteIterativo
  
  li $v0, 4
  la $a0, HI
  syscall
  
  li $v0, 3
  mov.d $f12, $f0
  syscall
  
  j again
  
C2:
  jal hermiter
  
  li $v0, 4
  la $a0, HR
  syscall
  
  li $v0, 3
  mov.d $f12, $f0
  syscall
   
  j again

ERROR:
  li $v0, 4
  la $a0, noopc
  syscall
  
  j again
  
FINAL:  
  lw $ra, 20($sp)
  addi $sp, $sp, 24
  
  jr $ra
  
#************************************************  
#*****************FUNCION ITERATIVA**************
#************************************************
hermiteIterativo:
  sw $a0, 0($sp)
  s.d $f12, 4($sp)
  
  li.d $f2, 2.0

  li.d $f4, 1.0

  li.d $f20, 1.0
  
  mul.d $f6, $f12, $f2

  beq $a0, $zero, CERO
  
  beq $a0, 1, UNO

  j MAYOR

  CERO:
    mov.d $f0, $f4
    jr $ra
    
  UNO:
    mov.d $f0, $f6
    jr $ra
    
  MAYOR:
    li $t0, 2
    FOR: 
      mtc1.d $t0, $f16
      cvt.d.w $f16, $f16

      #2*X
      mul.d $f14, $f2, $f12
      #2*x*H2
      mul.d $f14, $f14, $f6

      #i-1
      sub.d $f18, $f16, $f20
      # 2*( i - 1 )
      mul.d $f18, $f18, $f2
      # 2*( i - 1 )* H1
      mul.d $f18, $f18, $f4

      sub.d $f0, $f14, $f18
       
      # H1 = H2
      mov.d $f4, $f6
      # H2 = res
      mov.d $f6, $f0

      add $t0, $t0, 1
      ble $t0, $a0, FOR

  jr $ra
  
#************************************************  
#*****************FUNCION RECURSIVA**************
#************************************************
hermiter:
#Reservamos el stack nada mas empezar el programa
  addi $sp,$sp,-40
  sw $ra, 20($sp)

#guardamos los argumentos en la pila reservada por el programa q me llamo
  sw $a0,40($sp)
  s.d $f12,44($sp)
  
  #orden = 0
  beq $a0,$zero, true
  li $t0,1
  #orden = 1
  beq $a0,$t0,truelse

  addi $t0,$a0,-1
  sw $t0,24($sp)
  addi $a0,$t0,-1

  jal hermiter

  lw $t0,24($sp)
  mtc1 $t0,$f2
  cvt.d.w $f2,$f2
  mul.d $f2,$f2,$f0

  li.d $f6, 2.0
  
  mul.d $f2,$f2,$f6
  s.d $f2,28($sp)
  lw $a0,24($sp)
  l.d $f12, 44($sp)

  jal hermiter

  l.d $f4, 44($sp)
  mul.d $f4,$f4,$f0
  li.d $f6, 2.0

  mul.d $f4,$f4,$f6
  l.d $f2, 28($sp)
  sub.d $f0,$f4,$f2

  j fin

  true:
  li.d $f0,1.0
  j fin

  truelse:
  li.d $f2, 2.0
  l.d $f4,44($sp)
  mul.d $f0,$f2,$f4

  fin:
  ###Restablecemose el stack
  lw $ra,20($sp)
  addi $sp,$sp,40
  jr $ra
