;proyecto 1 arquitectura de Computadores
%include "linux64.inc"

section .data
; aqui se definen las varibles inicializadas
archconf db "configuracion.txt",0	;nombre del archivo con texto
archdat db "archivo.txt",0		;nombre del archivo con los datos
textordnotas db "--------El archivo a sido ordenado--------/n----------de acuerdo a las notas obtenidas-----------",0
textordalfa db "--------El archivo a sido ordenado--------/n----------Por orden alfabetico-----------",0
voyaqui db "voy por aqui",0
iguales db "son iguales",0
f1esmenor db "f1 es menor",0
f1esmayor db "f1 es mayor",0



ttc equ 140    ;almacena ttc= tamaño de texto de configuracion
ttd equ 900	; almacena tad =tamaño de texto con datos
contadorfilas db 0d
byteactualcopia dw 0d

section .bss
;aqui se definen las variables no inicializadas

textconf resb 140 ; Guarda el archivo de texto del configuracion
textdat resb 900  ;Guarda el archivo de texto con los datos
numcolum resb 2	  ; Almacena el  numero de columnas del Histograma
numfil resb 2	 ; Almacena el numero de filas del histograma
textdatcopia resb 100  ;Guarda una copia del archivo de texto para poder ordenarlo
;Las siguientes variables pertenecen a informacion del archivo configuracion
	nda resb 3 ;esta variable almacena la nda= nota de aprobacion
	ndr resb 3 ;esta variabla almacena la ndr = nota de  reposicion
	tdgn resb 3 ; almacena  el tdgn =tamaño de los grupos de notas
	edg resb 3 ;esta variable almacena la edg = escala del grafico
	tdo resb 2; esta variable almacena el tdo = tipo de ordenamiento

;Variables para el ordenamiento
	iniciof1 resb 2
	iniciof2 resb 2
	finalf1 resb 2
	finalf2 resb 2
	byteactual resb 2
	var1 resb 1
	var2 resb 1
	byteiniciocopia1 resb 2
	bytefinalcopia1 resb 2
        byteiniciocopia2 resb 2
        bytefinalcopia2 resb 2


section .text
	global _start
	_start:    ; aqui comienza el programa


	;-----------------Leer el archivo de configuracion----------------------

	; Abriendo el archivo
		mov rax, SYS_OPEN
		mov rdi, archconf
		mov rsi, O_RDONLY
		mov rdx, 0
		syscall

	;Leyendo el  archivo
		push rax
		mov rdi, rax
		mov rax, SYS_READ
		mov rsi, textconf
		mov rdx,ttc
		syscall

	;cerrando el archivo
		mov rax, SYS_CLOSE
		pop rdi
		syscall


	;Imprimir texto leido
		print textconf

	;extraer informacion del texto leido
		;leyendo nota de aprobación
		mov ax,[textconf+21] ; almacena en ax el contenido de la direccion
		mov word [nda], ax	; almacena en nda el contenido de ax
		;leyendo nota de  reposición
                mov ax,[textconf+45]
                mov word [ndr], ax
		;leyendo el tamaño de los grupos de notas
                mov ax,[textconf+80]
                mov word [tdgn], ax
		;leyendo Escala del gráfico
                mov ax,[textconf+105] ; almacena en ax el contenido de la direc$
                mov word [edg], ax   ; almacena en edg el contenido de ax
		;leyendo Tipo de Ordenamiento
                mov al,[textconf+122] ; almacena en ax el contenido de la direc$
                mov byte [tdo], al   ; almacena en tdo el contenido de ax





        ;-----------------Leer el archivo de datos----------------------

        ; Abriendo el archivo
                mov rax, SYS_OPEN
                mov rdi, archdat
                mov rsi, O_RDONLY
                mov rdx, 0
                syscall

        ;Leyendo el  archivo
                push rax
                mov rdi, rax
                mov rax, SYS_READ
                mov rsi, textdat
                mov rdx,ttd
                syscall

        ;cerrando el archivo
                mov rax, SYS_CLOSE
                pop rdi
                syscall

	; imprimir texto con datos
		print textdat

	;------------------------------------------------ordenando el texto--------------------------------------------
	; algoritmo bubble sort
bublesort1:
	;Paso 1; identificar donde comienza fila 1
		cmp byte [contadorfilas], 0d  ; si la fila es la numero cero, se entiende que comienza en el byte 0 del texto
		jne filaceroNO
		;--------fila cero Si--------
		mov word [iniciof1],0d
		mov word [byteactual],0d
		jmp lugarbyte
filaceroNO:   mov word ax,[iniciof2]
		mov word [iniciof1],ax

lugarbyte:	mov word ax, [byteactual]   ;carga en ax  el byte actual
		cmp byte [textdat+rax],10d  ; es el byte actual igual a enter
		je Efinalf1
		;incrementa en 1 el byte actual
		mov word ax, [byteactual]
		inc ax
		mov word [byteactual],ax
		jmp lugarbyte


Efinalf1:	 mov word ax,[byteactual] ; almacena el byte donde finaliza la fila 1
		mov word [finalf1],ax
		;incrementar el contador de fila en 1
		mov word dx,[contadorfilas]
		inc dx
		mov word [contadorfilas],dx

		;Establecer el inicio de la fila 2
		inc ax
		mov word [iniciof2],ax
		mov word [byteactual],ax

		;Comparar el byte actual para saber si es un enter
lugarbyte2:	mov word ax, [byteactual]    ;almacena en ax el byte actual
		cmp  byte [textdat+rax],10d   ;compara si el byte actual es un enter
		je Efinalf2
		;se incrementa en 1 el byte actual
		inc ax
		mov word [byteactual],ax
		jmp lugarbyte2

Efinalf2:       ;Almacenando la direccion del final de la fila f2
		mov word ax, [byteactual]
		inc ax
		mov word [finalf2],ax


		;-----------Determina el tipo de ordenamiento---------------
		cmp word [tdo], 97d  ; compara si el tipo de ordenamiento comienza con a de alfabetico
		je ordenalfa
		print textordnotas




		;---------------------ordenamiento por notas-----------------
		;Paso 1 Leer el la fila e identificar donde comienza y donde ter


		jmp finordenamiento
		; ordenamiento alfabetico




ordenalfa: 	print textordalfa
alfabetico:	mov word ax,[iniciof1] ;almacena en ax los byte de inicio de la fila 1
		mov word bx,[iniciof2] ;almacena en bx los byte de inicio de la fila 2
		mov byte cl, [textdat+rax] ;carga en cl el dato en la fila 1
		mov byte dl, [textdat+rbx] ;carga en dl el dato en fila 2
		mov byte [var1],cl
		mov byte [var2],dl
breakpoint:		print var1
		;print var2


		;Determinando si el la letra de la fila 1 es mayor que la letra de la fila 2
		;f1>f2
comparacion:	cmp byte cl,dl
		jg f1mayorf2
		mov byte cl,[var1]
		mov byte dl,[var2]
		cmp byte cl,dl
		jb f1menorf2
		;Ambas letras son iguales, se incrementea
		; el byte de inicio de ambas filas
		;incrementando byte de inicio fila 1
		mov word ax, [iniciof1]
		inc ax
		mov word [iniciof1],ax
		;incrementando byte de inicio fila 2
		mov word ax,[iniciof2]
		inc ax
		mov word [iniciof2],ax
		print iguales
		jmp alfabetico  ;salta al inicio de las comparaciones

	;Caso cuando  f1 mayor a f2
f1mayorf2:
		print f1esmayor
		;Copiando la linea en orden
                ;Almacenando la direccion en la nueva variable
                ;Almacena el limite final de la fila que se va a copiar
                mov word ax,[finalf2]
                mov word [bytefinalcopia1],ax
                ;Almacena el limite inicila de la fila que se va a copiar
                mov word ax,[iniciof2]
                mov word [byteiniciocopia1],ax

		;Almacenando la direccion en la nueva variable
                ;Almacena el limite final de la fila que se va a copiar
                mov word ax,[finalf1]
                mov word [bytefinalcopia2],ax
                ;Almacena el limite inicila de la fila que se va a copiar
                mov word ax,[iniciof1]
                mov word [byteiniciocopia2],ax


		jmp copiarfila1


	;Caso cuando f1 menor que f2
f1menorf2:
		print f1esmenor
		;Copiando la linea en orden
		;Almacenando la direccion en la nueva variable
		;Almacena el limite final de la primer fila que se va a copiar
		mov word ax,[finalf1]
		mov word [bytefinalcopia1],ax
		;Almacena el limite inicial de la fila que se va a copiar
		mov word ax,[iniciof1]
		mov word [byteiniciocopia1],ax


		;Almacena el limite final de la segunda fila que se va a copiar
                mov word ax,[finalf2]
                mov word [bytefinalcopia2],ax
                ;Almacena el limite inicial de la fila que se va a copiar
                mov word ax,[iniciof2]
                mov word [byteiniciocopia2],ax



		print voyaqui ; hay un error en el copiado
copiarfila1: ;copia la fila de acuerdo al orden
		;copiando la primer fila
		;Copia la letra actual de la fila
		mov word bx, [byteiniciocopia1] ; carga desde donde va a copiar
		mov word ax, [byteactualcopia]  ;carga la el espacio donde se va a colocar la copia
		mov byte cl,[textdat+rbx]   ;extrae el dato a copiar
		mov byte [textdatcopia+rax], cl  ;copia el dato en la otra variable

		;incrementa en 1 el byte actual de la copia
		mov word ax, [byteactualcopia]
		inc rax
		mov word [byteactualcopia],ax


		;Incrementa en uno  el byte de inicio de la fila

		;Comparaciones para salir del loop de copia fila
		;Es igual al byte Final?
		mov word ax, [byteactual]
		cmp ax,[bytefinalcopia1]
		jbe copiarfila1


finalcopiarfila: print textdatcopia
		;limpiar byteactualcopia al final de la copia
		mov word [byteactualcopia],0d

		;------------------------------Verificar que el contador de bytes sea menor que el final del archivo----------------
		;mov word ax,[bytefinalcopia]		;error potencial... no estoy contando los bytes recorridos
	; y cuando llego al final no se si copio la ultima fila
		;cmp ax,ttd












finordenamiento:




		;-------------------------------------Tratando informacion extraida del archivo de configuracion---------------------------
		;Determinando el numero de  columnas del histograma (grupos de notas)
		print nda
		print ndr
		print tdgn
		print edg
		print tdo





        ;--------------------------------leer archivo con datos----------------------------------------------


	 .finalprograma: ; codigo para finalizar correctamente el programa
			; y solucionar el segmentation fault

			mov rax,60	;cargando la llamada 60d(sys_exit)
			mov rdi,0	;cargando 0 en rdi
			syscall		;llamando al sistema operativo


