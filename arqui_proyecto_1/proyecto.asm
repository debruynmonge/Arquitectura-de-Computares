;proyecto 1 arquitectura de Computadores
%include "linux64.inc"

section .data
; aqui se definen las varibles inicializadas
archconf db "configuracion.txt",0	;nombre del archivo con texto
archdat db "archivo.txt",0		;nombre del archivo con los datos
ttc equ 140    ;almacena ttc= tamaño de texto de configuracion
tad equ 900	; almacena tad =tamaño de archivo con datos

section .bss
;aqui se definen las variables no inicializadas

textconf resb 140 ; Guarda el archivo de texto del configuracion
textdat resb 900  ;Guarda el archivo de texto con los datos
address resb 1; Guarda la direccion del dato leido  del documento


;Las siguientes variables pertenecen a informacion del archivo configuracion
	nda resb 2 ;esta variable almacena la nda= nota de aprobacion
	ndr resb 2 ;esta variabla almacena la ndr = nota de  reposicion
	tdgn resb 2 ; almacena  el tdgn =tamaño de los grupos de notas
	edg resb 2 ;esta variable almacena la edg = escala del grafico
	tdo resb 1; esta variable almacena el tdo = tipo de ordenamiento



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
		mov [nda], ax	; almacena en nda el contenido de ax
		print nda
		;leyendo nota de  reposición
                mov ax,[textconf+45]
                mov [ndr], ax
                print ndr
		;leyendo el tamaño de los grupos de notas
                mov ax,[textconf+80]
                mov [tdgn], ax
                print tdgn
		;leyendo Escala del gráfico
                mov ax,[textconf+105] ; almacena en ax el contenido de la direc$
                mov [edg], ax   ; almacena en edg el contenido de ax
                print edg
		;leyendo Tipo de Ordenamiento
                mov al,[textconf+122] ; almacena en ax el contenido de la direc$
                mov [tdo], al   ; almacena en tdo el contenido de ax
                print tdo







        ;--------------------------------leer archivo con datos----------------------------------------------


	 finalprograma: ; codigo para finalizar correctamente el programa
			; y solucionar el segmentation fault

			mov rax,60	;cargando la llamada 60d(sys_exit)
			mov rdi,0	;cargando 0 en rdi
			syscall		;llamando al sistema operativo

