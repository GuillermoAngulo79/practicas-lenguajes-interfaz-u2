; Materia: Lenguajes de Interfaz
; Alumno: Guillermo Enrique Angulo Reynaga
; Horario: 10:00-11:00
; Docente: Dr. José Luis Medina Jiménez
; Práctica: 3. Comparación y prueba
; Descripción: Programa que compara dos valores enteros (positivo y negativo) 
;              utilizando la instrucción CMP y saltos condicionales para desplegar 
;              un mensaje en consola según el resultado de la comparación.

INCLUDE Irvine32.inc   

.data                   
    msgIguales    BYTE "los valores son iguales", 0      ; Cadena terminada en cero (nula) si son iguales
    msgDiferentes BYTE "los valores son diferentes", 0   ; Cadena terminada en cero (nula) si son diferentes

.code                   ; Sección de código ejecutable
main PROC               ; Inicio del procedimiento principal del programa
    
    mov eax, 5          ; Carga el valor entero 5 en el registro acumulador EAX
    mov ebx, -5         ; Carga el valor entero negativo -5 en el registro EBX

    cmp eax, ebx        ; Compara EAX con EBX realizando internamente una resta (EAX - EBX) 
                        ; sin alterar sus valores, pero actualizando los registros de banderas (Flags).
    
    je iguales          ; Salto condicional: Salta a la etiqueta 'iguales' si la bandera de cero 
                        ; indica que el resultado de la comparación fue cero (es decir, si EAX == EBX).

    ; --- Bloque que se ejecuta si los valores SON DIFERENTES ---
    mov edx, OFFSET msgDiferentes   ; Carga la dirección de memoria de la cadena 'msgDiferentes' en el registro EDX.
    call WriteString                ; Llama a la función de Irvine32 para imprimir en consola la cadena apuntada por EDX.
    jmp fin                         ; Salto incondicional: Salta directamente a la etiqueta 'fin' para 
                                    ; evitar que se ejecute por error el código del bloque 'iguales'.

iguales:                            ; Etiqueta de destino para cuando los valores coinciden
    ; --- Bloque que se ejecuta si los valores SON IGUALES ---
    mov edx, OFFSET msgIguales      ; Carga la dirección de memoria de la cadena 'msgIguales' en el registro EDX.
    call WriteString                ; Llama a la función de Irvine32 para imprimir la cadena de igualdad.

fin:                                ; Etiqueta que marca el punto final de las bifurcaciones del programa
    call Crlf                       ; Llama a la función de Irvine32 para realizar un salto de línea en la consola.
    
    exit                            ; Finaliza el programa seguido devuelve el control al sistema operativo
main ENDP                           ; Fin del procedimiento 

END main                            
