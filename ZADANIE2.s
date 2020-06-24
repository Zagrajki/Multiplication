EXIT=1
READ=3
WRITE=4
STDIN=0
STDOUT=1
#as -o drugie3.o drugie3.s && ld -o drugie3 drugie3.o
#as drugie3.s --32 -o drugie3.o -g && ld drugie3.o -m elf_i386 -o drugie3
.section .data
A: .space 256
B: .space 256
POSREDNI: .space 257
WYNIK: .space 512
.section .text
.globl _start
_start:
LOOP1:
movl $READ, %eax
movl $STDIN, %ebx
movl $A, %ecx
movl $512, %edx
int $0x80
cmpl $0, %eax
je KONIEC
#zaczynamy od wczytania danych do A i B
movl $0, %edi
LOOP2:
movb $0, %ah
movl $1, %esi
movb B(,%edi,1), %bl
subl $1, %esi
#LOOP3:
.rept 256
movb $0, %cl
adcb %ah, %cl
movb A(,%esi,1), %al
mulb %bl
addb %al, %cl
movb %cl, POSREDNI(,%esi,1)
incl %esi
.endr
#cmpl $256, %esi
#jl LOOP3
adcb $0, %ah
movb %ah, POSREDNI(,%esi,1)
subl $256, %esi
#LOOP4:
.rept 257
movb POSREDNI(,%esi,1), %al
adcb %al, WYNIK(%edi, %esi, 1)
incl %esi
.endr
#cmpl $65, %esi
#jl LOOP4
incl %edi
cmpl $256, %edi
jl LOOP2
movl $WRITE, %eax
movl $STDOUT, %ebx
movl $WYNIK, %ecx
movl $512, %edx
int $0x80
movl $0, %esi
ZERUJW:
movl $0, WYNIK(,%esi,1)
incl %esi
cmpl $512, %esi
jl ZERUJW
jmp LOOP1

KONIEC:
movl $EXIT, %eax
movl $0, %ebx
int $0x80

