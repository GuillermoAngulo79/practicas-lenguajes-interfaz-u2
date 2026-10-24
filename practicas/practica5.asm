; Materia: Lenguajes de Interfaz
; Alumno: Guillermo Enrique Angulo Reynaga
; Horario: 10:00-11:00
; Docente: Dr. José Luis Medina Jiménez
; Práctica: 5.1 Condicionales (Repetir hasta que el usuario ingrese cero)
; Descripción: Programa que solicita un número entero al usuario de forma repetitiva 
;              utilizando una estructura condicional hasta que se introduzca el número cero.

INCLUDE Irvine32.inc   

.data
    msgPrompt BYTE "Ingrese un numero (ingrese 0 para terminar): ", 0  ; Mensaje para solicitar el número
    msgSalida BYTE "Ha ingresado cero. Fin del programa.", 0          ; Mensaje cuando el ciclo termina

.code
main PROC               ; Inicio del procedimiento principal del programa

ciclo:                  ; Etiqueta que marca el inicio de la iteración (el bucle)
    
    ; 1. Solicitar el número al usuario
    mov edx, OFFSET msgPrompt       ; Carga la dirección del mensaje en EDX
    call WriteString                ; Imprime el mensaje en consola

    ; 2. Leer la entrada del usuario
    call ReadInt                    ; Lee un número entero desde el teclado y lo guarda automáticamente en EAX
    call Crlf                       ; Realiza un salto de línea

    ; 3. Evaluar la condición (¿El número ingresado es cero?)
    cmp eax, 0                      ; Compara el valor de EAX con el número 0
    je fin                          ; Salto condicional: Si es igual a cero, 
                                    ; rompe el ciclo y salta a la etiqueta 'fin'

    ; (Aquí podrías agregar instrucciones adicionales si quisieras hacer algo con el número ingresado)

    jmp ciclo                       ; Salto incondicional: Si no fue cero, regresa al inicio para repetir el proceso

fin:                   
    ; 4. Mensaje de cierre
    mov edx, OFFSET msgSalida       ; Carga el mensaje de despedida en EDX
    call WriteString                ; Imprime el mensaje en consola
    call Crlf                       ; Salto de línea

    exit                            
main ENDP                           ; Fin del procedimiento principal

END main                            
