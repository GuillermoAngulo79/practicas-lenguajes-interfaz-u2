; Materia: Lenguajes de Interfaz
; Alumno: Guillermo Enrique Angulo Reynaga
; Horario: 10:00-11:00
; Docente: Dr. José Luis Medina Jiménez
; Práctica: 7. Validación de formato
; Descripción: Programa que valida una cadena de entrada con un formato estricto de 
;              7 caracteres (3 letras mayúsculas, 1 espacio y 3 dígitos.) 
;              utilizando punteros en memoria (ESI) y validación de rangos ASCII.

INCLUDE Irvine32.inc    

.data
    msgPide   BYTE "Ingrese el codigo (Ej. ABC 123): ", 0  ; Mensaje para solicitar la cadena
    msgValido BYTE "Formato valido", 0                     ; Mensaje si la estructura es correcta
    msgInval  BYTE "Formato invalido", 0                   ; Mensaje si la estructura falla

    buffer    BYTE 21 DUP(0)                              ; Arreglo de bytes (buffer) de 21 posiciones inicializado en ceros

.code
main PROC               ; Inicio del procedimiento principal 
    
    ; 1. Solicitar la cadena al usuario
    mov  edx, OFFSET msgPide
    call WriteString

    ; 2. Leer la cadena desde el teclado
    mov  edx, OFFSET buffer       ; EDX apunta al inicio del buffer donde se guardará el texto
    mov  ecx, SIZEOF buffer - 1   ; Establece el tamaño máximo de lectura permitida
    call ReadString               ; Lee la cadena introducida; devuelve la cantidad de caracteres leídos en EAX

    ; 3. Validar la longitud exacta de la cadena
    cmp  eax, 7                   ; Comprueba si el usuario ingresó exactamente 7 caracteres
    jne  invalido                 ; Si la longitud es diferente de 7, salta directo a 'invalido'

    ; 4. Inicializar el puntero de memoria
    mov  esi, OFFSET buffer       ; Carga en el registro ESI la dirección de memoria del primer carácter de la cadena

    ; 5. Validar las primeras 3 posiciones: Letras mayúsculas de la 'A' a la 'Z'
    mov  ecx, 3                   ; Establece el contador del ciclo en 3 (para las 3 letras)
letras:
    mov  al, [esi]                ; Copia el carácter actual apuntado por ESI al registro AL
    cmp  al, 'A'                  ; Compara si es menor al código ASCII de la 'A'
    jb   invalido                 ; Si es menor (jb = Jump Below), el formato no es válido
    cmp  al, 'Z'                  ; Compara si es mayor al código ASCII de la 'Z'
    ja   invalido                 ; Si es mayor (ja = Jump Above), no es una letra mayúscula válida
    inc  esi                      ; Avanza el puntero ESI a la siguiente posición de memoria
    loop letras                   ; Decrementa ECX y repite el ciclo si ECX > 0

    ; 6. Validar la posición 4: Debe ser obligatoriamente un espacio (' ')
    cmp  BYTE PTR [esi], ' '      ; Comprueba si el carácter actual en memoria es un espacio
    jne  invalido                 ; Si no es un espacio, salta a 'invalido'
    inc  esi                      ; Avanza el puntero ESI superando el espacio

    ; 7. Validar las últimas 3 posiciones: Dígitos numéricos del '0' al '9'
    mov  ecx, 3                   ; Establece el contador del ciclo en 3 (para los 3 números)
digitos:
    mov  al, [esi]                ; Copia el carácter actual apuntado por ESI al registro AL
    cmp  al, '0'                  ; Compara si es menor al código ASCII del '0'
    jb   invalido                 ; Si es menor, no es un dígito válido
    cmp  al, '9'                  ; Compara si es mayor al código ASCII del '9'
    ja   invalido                 ; Si es mayor, no es un dígito válido
    inc  esi                      ; Avanza el puntero ESI a la siguiente posición
    loop digitos                  ; Decrementa ECX y repite el ciclo si ECX > 0

    ; 8. Si pasó todas las validaciones, el formato es correcto
    mov  edx, OFFSET msgValido    ; Carga el mensaje de éxito
    jmp  mostrar                  ; Salta a la sección de impresión

invalido:                         ; Etiqueta de ruta de error
    mov  edx, OFFSET msgInval     ; Carga el mensaje de error de formato

mostrar:                          ; Sección común de salida en pantalla
    call WriteString              ; Imprime el mensaje correspondiente 
    call Crlf                     ; Realiza un salto de línea
    
    exit                          
main ENDP
END main
