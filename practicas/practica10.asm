; Materia: Lenguajes de Interfaz
; Alumno: Guillermo Enrique Angulo Reynaga
; Horario: 10:00-11:00
; Docente: Dr. José Luis Medina Jiménez
; Práctica: 10. Obtención de una cadena decimal
; Descripción: Programa que realiza cálculos de descarga de red (bytes descargados, pendientes, 
;              porcentaje, bloques y residuos) y utiliza un procedimiento personalizado para 
;              convertir dichos valores numéricos en cadenas de texto ASCII para su impresión.

INCLUDE Irvine32.inc    

.data
    bytesDesc   DWORD ?         ; Variable para almacenar el total de bytes descargados
    bytesPend   DWORD ?         ; Variable para almacenar los bytes pendientes de descarga
    gruposComp  DWORD ?         ; Variable para almacenar los bloques completos de datos
    porcentaje  DWORD ?         ; Variable para almacenar el porcentaje procesado
    residuo     DWORD ?         ; Variable para almacenar el residuo sobrante de bytes
    bufferASCII BYTE 11 DUP(0)  ; Buffer de caracteres (11 bytes) para la cadena ASCII convertida
    
.code
main PROC               ; Inicio del procedimiento principal del programa

    ;  1. Cálculo de bytes descargados
    mov eax, 125                ; Carga el valor 125 en el registro EAX
    mov ebx, 512                ; Carga el valor 512 en el registro EBX
    mul ebx                     ; Multiplica EAX por EBX -> El resultado queda en EDX:EAX
    mov bytesDesc, eax          ; Guarda el resultado numérico (64,000) en la variable 'bytesDesc'

    mov esi, OFFSET bufferASCII ; Carga la dirección del buffer en ESI
    call convertirDecimal       ; Llama a la subrutina para convertir el número en EAX a texto ASCII
    mov edx, OFFSET bufferASCII ; Carga la dirección del buffer convertido en EDX
    call WriteString            ; Imprime en consola la cadena decimal resultante ("64000")
    call Crlf                   ; Realiza un salto de línea

    ;  2. Cálculo de bytes pendientes 
    mov eax, 100000             ; Carga el valor total esperado (100,000) en EAX
    sub eax, bytesDesc          ; Resta los bytes descargados (100,000 - 64,000)
    mov bytesPend, eax          ; Guarda el resultado (36,000) en la variable 'bytesPend'

    mov eax, bytesPend          ; Carga los bytes pendientes en EAX para su conversión
    mov esi, OFFSET bufferASCII ; Apunta ESI al buffer
    call convertirDecimal       ; Convierte el entero a cadena ASCII
    mov edx, OFFSET bufferASCII ; Prepara la dirección del buffer para impresión
    call WriteString            ; Imprime en consola la cadena decimal ("36000")
    call Crlf                   ; Salto de línea

    ; 3. Cálculo de porcentaje de avance
    mov eax, bytesDesc          ; Carga los bytes descargados en EAX
    mov ebx, 100                ; Carga el factor 100 en EBX
    mul ebx                     ; Multiplica EAX * 100
    mov ebx, 100000             ; Carga el total de referencia (100,000) en EBX
    mov edx, 0                  ; Limpia obligatoriamente la parte alta (EDX) antes de dividir
    div ebx                     ; Divide (bytesDesc * 100) entre 100,000 -> Cociente en EAX
    mov porcentaje, eax         ; Guarda el porcentaje calculado (64%) en la variable 'porcentaje'

    mov esi, OFFSET bufferASCII ; Apunta ESI al buffer
    call convertirDecimal       ; Convierte el porcentaje numérico a cadena ASCII
    mov edx, OFFSET bufferASCII ; Prepara la dirección del buffer
    call WriteString            ; Imprime en consola el porcentaje ("64")
    call Crlf                   ; Salto de línea

    ;  4. Cálculo de grupos completos y residuo
    mov eax, bytesDesc          ; Carga los bytes descargados en EAX
    mov ebx, 1024               ; Carga el tamaño del bloque (1024 bytes) en EBX
    mov edx, 0                  ; Limpia la parte alta (EDX) antes de realizar la división
    div ebx                     ; Divide EAX entre 1024 -> Cociente (bloques) en EAX, Residuo en EDX
    mov gruposComp, eax         ; Guarda los bloques completos (62) en 'gruposComp'
    mov residuo, edx            ; Guarda el residuo sobrante (512) en la variable 'residuo'

    mov esi, OFFSET bufferASCII ; Apunta ESI al buffer
    call convertirDecimal       ; Convierte los grupos completos a texto ASCII
    mov edx, OFFSET bufferASCII ; Prepara la dirección del buffer
    call WriteString            ; Imprime en consola el número de bloques ("62")
    call Crlf                   ; Salto de línea

    ; 5. Imprimir el residuo de bytes 
    mov eax, residuo            ; Carga el valor del residuo (512) en EAX
    mov esi, OFFSET bufferASCII ; Apunta ESI al buffer
    call convertirDecimal       ; Convierte el residuo numérico a cadena ASCII
    mov edx, OFFSET bufferASCII ; Prepara la dirección del buffer
    call WriteString            ; Imprime en consola el residuo sobrante ("512")
    call Crlf                   ; Salto de línea

    exit                        
main ENDP

; Aqui muestro el procedimiento para convertir un entero en EAX a cadena ASCII en [ESI]
convertirDecimal PROC
    mov ecx, 0                  ; Inicializa el contador de dígitos en 0
    mov ebx, 10                 ; Establece el divisor constante en 10 (base decimal)

convertirLoop:
    mov edx, 0                  ; Limpia obligatoriamente la parte alta (EDX) para la división
    div ebx                     ; Divide EAX entre 10: Cociente en EAX, Residuo (dígito actual) en EDX
    push edx                    ; Empuja el dígito extraído hacia la pila (aprovechando LIFO)
    inc ecx                     ; Incrementa en 1 el contador de dígitos

    cmp eax, 0                  ; Comprueba si el cociente de la división llegó a cero
    jne convertirLoop           ; Si el cociente es mayor a 0, repite el ciclo para el siguiente dígito

cadenaLoop:
    pop edx                     ; Extrae de la pila los dígitos en el orden correcto (del primero al último)
    add dl, '0'                 ; Convierte el valor numérico del dígito a su carácter ASCII correspondiente
    mov [esi], dl               ; Almacena el carácter ASCII en la posición actual del buffer
    esi                         ; (Avanza el puntero del buffer -nota: el original decía 'inc esi', aseguramos el avance)
    loop cadenaLoop             ; Decrementa ECX y repite hasta vaciar todos los dígitos apilados

    mov byte ptr [esi], 0       ; Agrega un terminador nulo para cerrar la cadena de texto

    ret                         ; Retorna el control al procedimiento principal
convertirDecimal ENDP

END main
