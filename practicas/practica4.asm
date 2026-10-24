; Materia: Lenguajes de Interfaz
; Alumno: Guillermo Enrique Angulo Reynaga
; Horario: 10:00-11:00
; Docente: Dr. José Luis Medina Jiménez
; Práctica: 4. Saltos y estructuras condicionales (Ciclo del 1 al 100)
; Descripción: Programa que implementa un ciclo tipo "while" mediante la instrucción 
;              de comparación y saltos condicionales  e incondicionales
;              para imprimir en consola los números enteros del 1 al 100.

INCLUDE Irvine32.inc    

.data                   ; Sección de declaración de variables 

.code                   ; Sección de código ejecutable
main PROC               ; Inicio del procedimiento principal del programa
    mov ebx, 1          ; Inicializa el registro EBX con el valor 1. 
                        ; EBX funcionará como nuestro contador o variable de control del ciclo.

ciclo:                  ; Etiqueta que marca el punto de retorno 
    cmp ebx, 100        ; Compara el valor actual de EBX con el número 100 
                        ; y actualiza las banderas del procesador sin alterar el valor de EBX.
    
    jg fin              ; Salto condicional (Jump if Greater): Si el resultado de la comparación 
                        ; indica que EBX es estrictamente mayor a 100, rompe el ciclo y salta a la etiqueta fin.

    mov eax, ebx        ; Copia el valor actual del contador almacenado en EBX hacia el registro EAX,
                        ; ya que la función WriteDec de Irvine32 requiere que el número a imprimir esté en EAX.
    
    call WriteDec       ; Llama a la función de Irvine32 para imprimir en la consola el valor decimal de EAX.
    
    call Crlf           ; Llama a la función de Irvine32 para realizar un salto de línea (Carriage Return / Line Feed),
                        ; evitando que los números se imprima uno al lado del otro.

    inc ebx             ; Incrementa en 1 el valor del registro EBX (Equivalente a: ebx = ebx + 1).
    
    jmp ciclo           ; Salto incondicional: Regresa obligatoriamente el flujo del programa a la 
                        ; etiqueta 'ciclo' para evaluar de nuevo la condición con el nuevo valor.

fin:                    ; Etiqueta de salida del bucle
    exit                ; Finaliza el programa para despues devolver el control al sistema operativo
main ENDP               ; Fin del procedimiento

END main               
