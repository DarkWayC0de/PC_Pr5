        .data
orden:  .word 2
x:      .double 3.6
resultado:  .float 0.0

        .text
main:
###reserva de stack nada más empezar el main
addi $sp,$sp,-40
sw $s0,20($sp)
s.d $f20,24($sp)
sw $ra ,32($sp)


#####cargamos los datos
lw $s0, orden
l.d $f20, x

#####Preparamos la llamamada a la funcion
move $a0,$s0
mov.d $f12,$f20

###realiamos la llamada
jal hermiter

###guardamos el resultado
s.d $f0, resultado


####restablecer stack
lw $s0, 20($sp)
l.d $f20,24($sp)
lw $ra,32($sp)
addi $sp,$sp,40

# terminar main
jr $ra

## vammos a usar como variable locar $f20
hermiter:
###Reservamos el stack nada mas empezar el programa
addi $sp,$sp,-40
sw $ra, 20($sp)

###empieza el codigo de hermiter
###guardamos los argumentos en la pila reservada por el programa q me llamo
sw $a0,40($sp)
s.d $f12,44($sp)

beq $a0,$zero, true
li $t0,1
beq $a0,$t0,truelse

addi $t0,$a0,-1
sw $t0,24($sp)
addi $a0,$t0,-1

jal hermiter

lw $t0,24($sp)
mtc1 $t0,$f2
cvt.d.w $f2,$f2
mul.d $f2,$f2,$f0
li $t0, 2
mtc1 $t0,$f6
cvt.d.w $f6,$f6
mul.d $f2,$f2,$f6
s.d $f2,28($sp)
lw $a0,24($sp)
l.d $f12, 44($sp)

jal hermiter

l.d $f4, 44($sp)
mul.d $f4,$f4,$f0
li $t0, 2
mtc1 $t0, $f6
cvt.d.w $f6,$f6
mul.d $f4,$f4,$f6
l.d $f2, 28($sp)
sub.d $f0,$f4,$f2

j fin

true:
li $t0,1
mtc1 $t0,$f2
cvt.d.w $f0,$f2
j fin

truelse:
li $t0,2
mtc1 $t0,$f2
cvt.d.w $f2,$f2
l.d $f4,44($sp)
mul.d $f0,$f2,$f4

fin:
###Restablecemose el stack
lw $ra,20($sp)
addi $sp,$sp,40
jr $ra