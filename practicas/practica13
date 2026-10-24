; Materia: Lenguajes de Interfaz
; Alumno: Guillermo Enrique Angulo Reynaga
; Horario: 10:00-11:00
; Docente: Dr. José Luis Medina Jiménez
; Práctica: 13. Obtención de una cadena hexadecimal
; Descripción: Programa que convierte un valor numérico entero de 32 bits en una cadena de texto 
;              ASCII en formato hexadecimal (base 16), procesando nibble por nibble mediante 
;              desplazamientos y máscaras de bits.

INCLUDE Irvine32.inc    

.data
    valorOriginal DWORD 12AB34CDh       ; Valor entero de 32 bits a convertir 
    bufferHex     BYTE 9 DUP(0)         ; Buffer de 8 caracteres para el texto hexadecimal + 1 byte para el terminador nulo (0)

.code
main PROC               ; Inicio del procedimiento principal del programa
    mov eax, 12AB34CDh                  ; Carga el valor numérico completo a convertir en el registro EAX
    mov ecx, 8                          ; Inicializa el contador en 8 
    mov esi, 7                          ; Índice inicial en 7: apunta al final del buffer para escribir los caracteres de derecha a izquierda

conv_loop:                              ; Etiqueta del ciclo principal de conversión
    push eax                            ; Resguarda temporalmente el valor completo de EAX en la pila (Stack)
    and eax, 0Fh                        ; Aplica una máscara AND para aislar únicamente los 4 bits menos significativos (el nibble actual)
    
    cmp al, 9                           ; Compara el valor numérico del nibble aislado con el número 9
    jbe es_num                          ; Salto condicional (Jump if Below or Equal): si es menor o igual a 9, va a la conversión numérica
    
    add al, 'A' - 10                    ; Si es de 10 a 15 (osea letras A-F), ajusta el valor sumándole el ASCII de 'A' menos 10
    jmp almacenar                       ; Salta directamente al almacenamiento para evitar el bloque numérico

es_num:                                 ; Etiqueta para valores numéricos del 0 al 9
    add al, '0'                         ; Convierte el valor numérico (0-9) a su respectivo carácter ASCII sumándole el código de '0'

almacenar:                              ; Etiqueta para guardar el carácter resultante
    mov bufferHex[esi], al              ; Guarda el carácter ASCII obtenido en la posición actual del buffer indicada por ESI

    pop eax                             ; Recupera de la pila el valor completo de EAX que teníamos resguardado
    shr eax, 4                          ; Desplaza 4 bits a la derecha para deshacernos del nibble ya procesado y preparar el siguiente
    dec esi                             ; Retrocede una posición en el índice del buffer 
    loop conv_loop                      ; Decrementa ECX en 1 y repite el ciclo mientras ECX sea diferente de 0

    ; --- Despliegue en consola ---
    mov edx, OFFSET bufferHex           ; Carga en EDX la dirección de memoria de la cadena hexadecimal ya construida
    call WriteString                    ; Llama a Irvine32 para imprimir la cadena completa de texto en la pantalla
    call Crlf                           ; Realiza un salto de línea

    exit                               
main ENDP

END main
