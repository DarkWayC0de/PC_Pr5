.data

  orden:        .word 0
  punto:        .float 0.0  
  petOrden:     .asciiz "Introduzca el orden del polinomio: "
  petPunto:     .asciiz "Introduzca el punto a evaluar: "
  noopc:        .asciiz "\nWARNING: OPCION INTRODUCIDA NO VALIDA." 
  mensajeError: .asciiz "\nWARNING: Orden introducido no valido.\n"
  opcion:       .asciiz "\nIntroduzca una opcion:\n0--> Fin del programa.\n1--> Metodo iterativo.\n2--> Metodo recursivo.\nOpcion: "
  HI:           .asciiz "El resultado iterativo es: "
  HR:           .asciiz "El resultado recursivo es: "
.text

main:
  addi $sp, $sp, -24
  sw $ra, 16($sp)

again:
  li $v0, 4
  la $a0, opcion
  syscall
  
  li $v0, 5
  syscall
  move $t2, $v0
  
  beq $t2, $zero, FINAL
  
  blt $t2, $zero, CD
  
  bgt $t2, 2, CD
  
  li $v0, 4 
  la $a0, petOrden
  syscall
  li $v0, 5
  syscall
  move $t1, $v0

  li $v0, 4 
  la $a0, petPunto
  syscall

  li $v0, 6
  syscall

  move $a0, $t1
  mov.s $f12, $f0

  blt $a0, $zero, ERROR

#C1:
  bne $t2, 1, C2
  jal hermiteIterativo
  
  li $v0, 4
  la $a0, HI
  syscall
  
  li $v0, 2
  mov.s $f12, $f0
  syscall
  
  j again
  
C2:
  jal hermiter
  
  li $v0, 4
  la $a0, HR
  syscall
  
  li $v0, 2
  mov.s $f12, $f0
  syscall
   
  j again

CD:
  li $v0, 4
  la $a0, noopc
  syscall
  
  j again

ERROR:
  li $v0, 4
  la $a0, mensajeError
  syscall
  
  j again
  
FINAL:  
  lw $ra, 16($sp)
  addi $sp, $sp, 24
  
  jr $ra
  
#************************************************  
#*****************FUNCION ITERATIVA**************
#************************************************
hermiteIterativo:
  sw $a0, 0($sp)
  s.s $f12, 4($sp)
  
  li.s $f2, 2.0

  li.s $f4, 1.0

  li.s $f20, 1.0
  
  mul.s $f6, $f12, $f2

  beq $a0, $zero, CERO
  
  beq $a0, 1, UNO

  j MAYOR

  CERO:
    mov.s $f0, $f4
    jr $ra
    
  UNO:
    mov.s $f0, $f6
    jr $ra
    
  MAYOR:
    li $t0, 2
    FOR: 
      mtc1 $t0, $f16
      cvt.s.w $f16, $f16

      #2*X
      mul.s $f14, $f2, $f12
      #2*x*H1
      mul.s $f14, $f14, $f6

      #i-1
      sub.s $f18, $f16, $f20
      # 2*( i - 1 )
      mul.s $f18, $f18, $f2
      # 2*( i - 1 )* H0
      mul.s $f18, $f18, $f4

      sub.s $f0, $f14, $f18
       
      # H0 = H1
      mov.s $f4, $f6
      # H1 = res
      mov.s $f6, $f0

      add $t0, $t0, 1
      ble $t0, $a0, FOR

  jr $ra
  
#************************************************  
#*****************FUNCION RECURSIVA**************
#************************************************
hermiter:
#Reservamos el stack nada mas empezar el programa
  addi $sp,$sp,-32
  sw $ra, 16($sp)

#guardamos los argumentos en la pila reservada por el programa q me llamo
  sw $a0,32($sp)
  s.s $f12,36($sp)
  
  #orden = 0
  beq $a0,$zero, true
  
  li $t0,1
  #orden = 1
  beq $a0,$t0,truelse

  addi $t0,$a0,-1
  sw $t0,20($sp)
  addi $a0,$t0,-1

  jal hermiter

  lw $t0,20($sp)
  
  mtc1 $t0,$f2
  cvt.s.w $f2,$f2
  mul.s $f2,$f2,$f0

  li.s $f6, 2.0
  
  mul.s $f2,$f2,$f6
  s.s $f2,24($sp)
  lw $a0,20($sp)
  l.s $f12, 36($sp)

  jal hermiter

  l.s $f4, 36($sp)
  mul.s $f4,$f4,$f0
  li.s $f6, 2.0

  mul.s $f4,$f4,$f6
  l.s $f2, 24($sp)
  sub.s $f0,$f4,$f2

  j fin

true:
  li.s $f0,1.0
  j fin

truelse:
  li.s $f2, 2.0
  l.s $f4,36($sp)
  mul.s $f0,$f2,$f4

fin:
  ###Restablecemose el stack
  lw $ra,16($sp)
  addi $sp,$sp, 32
  jr $ra

#include <iostream>

#using namespace std;

#double HERMITER ( int orden, float x)
#{
 # double res;
  #if( orden == 0 ){
   # res = 1;
  #}else {
   # if (orden == 1) {
    ##  res = 2 * x;
    #} else {
 #     int ordenmenosuno = orden -1;#
#      double aux1;
   #   aux1 = HERMITER( ordenmenosuno - 1, x );
  #    aux1 *= (ordenmenosuno);
 #     aux1 *= 2;
#      res=HERMITER(ordenmenosuno, x);
#      res*= x;
##      res*= 2;
##      res = res - aux1;
#    }
#  }

#  return res;
#}

#double HERMITEI( int orden, float x)
#{
#  double res = 0;
#  double H0 = 1;
#  double H1 = 2 * x;
#   if( orden == 0 ){
#     return H0;
#   }else if( orden == 1 ){
#      return H1;
#   }
#  for ( int i = 2; i <= orden; i++ ){
#    res = ( 2 * x * H1 ) - ( 2 * ( ( ( double ) i)- 1 ) * H0 );
#    H0 = H1;
#    H1 = res;
#  }
#  return res;
#}

#int main ( void )
#{
#  int orden;
#  double x;
#  double resultado = 0;

#  cout << "Introduzca el orden: ";
#  cin >> orden;
#  cout << "Introduzca el valor de 'X': ";
#  cin >> x;

#  resultado = HERMITER ( orden, x );

#  cout << "El resultado recursivo es: " << resultado << endl;
#  resultado = HERMITEI ( orden, x );

#  cout << "El resultado iterativo es: " << resultado << endl;
#  return 0;
#}