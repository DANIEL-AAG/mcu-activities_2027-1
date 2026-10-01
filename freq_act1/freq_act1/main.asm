;
; freq_act1.asm
;
; Created: 29/09/2026 03:47:41 p. m.
; Author : alber
;

.cseg
.org 0x00

.def temp = r16
.def counter = r17
.def multiplier = r18


// Se inicializan los registros que se utilizarán


// Se inicia el Stack para poder utilizar subrutinas

	ldi temp,high(RAMEND)
	out SPH,temp

	ldi temp,low(RAMEND)
	out SPL,temp


// Se configura PB0 y PB1 como entradas
// Se configura PB5 como salida

	ldi temp,(1<<PB5)
	out DDRB,temp


// Se inicia PB5 en nivel bajo

	cbi PORTB,PB5


// Programa principal
// Se leen PB0 y PB1 para seleccionar una de las cuatro frecuencias

start:

	in temp,PINB
	andi temp,0b00000011


// Se compara con 00
// PB1=0 y PB0=0 corresponde a 100 kHz

	cpi temp,0b00000000
	breq freq1


// Se compara con 01
// PB1=0 y PB0=1 corresponde a 500 kHz

	cpi temp,0b00000001
	breq freq2


// Se compara con 10
// PB1=1 y PB0=0 corresponde a 1 MHz

	cpi temp,0b00000010
	breq freq3


// Si no se encontró ninguna de las anteriores
// entonces PB1=1 y PB0=1 corresponde a 2 MHz

	rjmp freq4


// Rutina para generar 100 kHz
// Se genera la señal en PB5 y después se regresa a start
// para volver a leer las entradas

freq1:

	ldi counter,10

f1_loop:

	sbi PORTB,PB5
	rcall delay100

	cbi PORTB,PB5
	rcall delay100

	dec counter
	brne f1_loop

	jmp start


// Rutina para generar 500 kHz


freq2:

	ldi counter,10

f2_loop:

	sbi PORTB,PB5
	rcall delay500

	cbi PORTB,PB5
	rcall delay500

	dec counter
	brne f2_loop

	jmp start


// Rutina para generar 1 MHz


freq3:

	ldi counter,10

f3_loop:

	sbi PORTB,PB5

	nop
	nop
	nop
	nop

	cbi PORTB,PB5

	nop
	nop
	nop
	nop

	dec counter
	brne f3_loop

	jmp start


// Rutina para generar 2 MHz


freq4:

	ldi counter,10

f4_loop:

	sbi PORTB,PB5

	nop
	nop

	cbi PORTB,PB5

	nop
	nop

	dec counter
	brne f4_loop

	jmp start


// Subrutina de retardo para 100 kHz
// Se utiliza para generar el semiperiodo de la señal

delay100:

	ldi multiplier,26

d100:

	dec multiplier
	brne d100

	ret


// Subrutina de retardo para 500 kHz
// Se utiliza para generar el semiperiodo de la señal

delay500:

	nop
	nop
	nop
	nop
	nop
	nop

	ret