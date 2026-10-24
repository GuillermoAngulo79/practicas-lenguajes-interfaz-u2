; Materia: Lenguajes de Interfaz
; Alumno: Guillermo Enrique Angulo Reynaga
; Horario: 10:00-11:00
; Docente: Dr. José Luis Medina Jiménez
; Práctica: 2. Operaciones aritméticas
; Descripción: Programa que realiza operaciones básicas (suma y resta) utilizando 
;              variables de 32 bits (DWORD) y muestra el estado de los registros con DumpRegs.

INCLUDE Irvine32.inc    ; Incluye la biblioteca

.data                  
    val1     dword  10000h  ; Declara una variable de 32 bits (DWORD) con el valor hexadecimal 10000
    val2     dword  40000h  ; Declara una variable de 32 bits con el valor hexadecimal 40000
    val3     dword  20000h  ; Declara una variable de 32 bits con el valor hexadecimal 20000
    finalVal dword  ?       ; Declara una variable de 32 bits sin inicializar ('?'), reservada para el resultado

.code                   
main PROC               ; Inicio del procedimiento principal del programa

    mov	eax, val1       ; Aqui se copia el valor de la variable 'val1' (10000h) al registro acumulador EAX
    add	eax, val2       ; Suma el valor de 'val2' (40000h) al contenido actual de EAX (EAX = 10000h + 40000h = 50000h)
    sub	eax, val3       ; Resta el valor de 'val3' (20000h) al contenido actual de EAX (EAX = 50000h - 20000h = 30000h)
    mov	finalVal, eax   ; Almacena el resultado final que está en EAX (30000h) dentro de la variable en memoria 'finalVal'
    call DumpRegs       ; Llama a la función de Irvine32 para mostrar en pantalla el valor de todos los registros de la CPU

    exit                ; Finaliza el programa para despues retornar el control al sistema operativo
main ENDP               ; Fin del procedimiento 

END main                
