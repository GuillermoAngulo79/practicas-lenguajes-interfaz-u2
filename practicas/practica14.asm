; Materia: Lenguajes de Interfaz
; Alumno: Guillermo Enrique Angulo Reynaga
; Horario: 10:00-11:00
; Docente: Dr. José Luis Medina Jiménez
; Práctica: 14. Captura y almacenamiento de datos numéricos
; Descripción: Programa interactivo que solicita una cantidad numérica por teclado (1-99), 
;              valida estrictamente su longitud, formato y rango, actualiza un inventario sumando 
;              la existencia inicial y despliega los resultados convirtiéndolos a formato de texto ASCII.

INCLUDE Irvine32.inc    

.data
    cantidadInicial  DWORD 25           ; Cantidad base preexistente en el inventario
    cantidadRecibida DWORD ?            ; Variable para almacenar la cantidad ingresada y validada
    existenciaActual DWORD ?            ; Variable para almacenar el resultado de la suma total
    recepcion        BYTE "Ingrese una cantidad (1-99): ", 0  ; Mensaje de solicitud de entrada
    msgError         BYTE "Cantidad recibida invalida", 0     ; Mensaje en caso de error de validación
    msg1             BYTE "Existencia inicial ", 0            ; Fragmento de texto para el reporte
    msg2             BYTE " + recepcion de ", 0               ; Fragmento de texto para el reporte
    msg3             BYTE " existencia actual ", 0              ; Fragmento de texto para el reporte
    msg4             BYTE " unidades", 0                      ; Fragmento de texto final para el reporte
    cadena           BYTE 10 DUP(0)     ; Buffer auxiliar de 10 bytes para convertir números a texto
    buffer           BYTE 3 DUP(0)      ; Buffer de entrada de teclado 

.code
main PROC               ; Inicio del procedimiento principal del programa

capturar:               ; Etiqueta de punto de retorno para solicitar la entrada nuevamente en caso de error
    ;  Captura de entrada del usuario desde teclado 
    mov edx, OFFSET recepcion 
    call WriteString                ; Imprime en pantalla el mensaje de solicitud 

    mov edx, OFFSET buffer 
    mov ecx, SIZEOF buffer 
    call ReadString                 ; Lee la cadena escrita por el usuario; EAX devuelve la cantidad exacta de caracteres leídos

    ;  Validaciones iniciales de longitud 
    cmp eax, 0 
    je error                        ; Salta a 'error' si el usuario no ingresó nada

    cmp eax, 2 
    ja error                        ; Salta a 'error' si ingresó más de 2 caracteres 

    ;  Validación del primer carácter 
    mov bl, buffer[0]               ; Copia el primer carácter ingresado al registro BL

    cmp bl, '0' 
    jb error                        ; Salta a 'error' si el código ASCII es menor al del carácter '0'.


    cmp bl, '9' 
    ja error                        ; Salta a 'error' si el código ASCII es mayor al del carácter '9' 

    cmp eax, 1 
    je unDigito                     ; Si la longitud leída fue exactamente 1 carácter, salta directo a procesarlo como un solo dígito

    ;  Validación del segundo carácter (se ejecuta solo si la longitud fue de 2 dígitos) 
    mov bl, buffer[1]               ; Copia el segundo carácter ingresado a BL

    cmp bl, '0'  
    jb error                        ; Valida que el segundo carácter sea un número válido
    cmp bl, '9' 
    ja error                        ; Si no lo es, marca error

    ;  Conversión matemática de 2 dígitos ASCII a un valor entero binario 
    movzx eax, buffer[0]            ; Carga el primer dígito ASCII en EAX rellenando con ceros a la izquierda
    sub eax, '0'                    ; Convierte el carácter ASCII a su valor numérico real restándole '0'.

    mov ebx, 10 
    mul ebx                         ; Multiplica el valor de las decenas por 10 (EAX = EAX * 10)

    movzx ebx, buffer[1]            ; Carga el segundo dígito ASCII en EBX
    sub ebx, '0'                    ; Convierte el segundo carácter ASCII a su valor numérico real

    add eax, ebx                    ; Suma las unidades: EAX = (Decena * 10) + Unidad
    jmp validarRango                ; Salta a la sección de validación de límites

unDigito:                           ; Etiqueta para procesar cuando la entrada tiene un solo dígito
    movzx eax, buffer[0] 
    sub eax, '0'                    ; Convierte el carácter ASCII a su valor numérico entero correspondiente

validarRango:                       ; Sección de comprobación del rango permitido
    ; Validación estricta de rango numérico (1 - 99) 
    cmp eax, 1 
    jb error                        ; Salta a 'error' si el número resultante es menor a 1 

    cmp eax, 99 
    ja error                        ; Salta a 'error' si el número resultante es mayor a 99 

    ;  Operación lógica de inventario 
    mov cantidadRecibida, eax       ; Almacena el valor numérico validado en la variable 'cantidadRecibida'
    mov eax, cantidadInicial        ; Carga la existencia base (25) en EAX
    add eax, cantidadRecibida       ; Suma la cantidad recibida a la existencia inicial
    mov existenciaActual, eax       ; Guarda el resultado total en la variable 'existenciaActual'

    ; Despliegue formateado de resultados en consola 
    mov edx, OFFSET msg1
    call WriteString                ; Imprime: "Existencia inicial "

    mov eax, cantidadInicial
    mov esi, OFFSET cadena
    call convertirDecimal           ; Convierte el número entero a texto ASCII
    mov edx, OFFSET cadena
    call WriteString                ; Imprime el valor numérico inicial ("25")

    mov edx, OFFSET msg2
    call WriteString                ; Imprime: " + recepcion de "

    mov eax, cantidadRecibida
    mov esi, OFFSET cadena
    call convertirDecimal           ; Convierte el número recibido a texto ASCII
    mov edx, OFFSET cadena
    call WriteString                ; Imprime el valor de la recepción validada

    mov edx, OFFSET msg3
    call WriteString                ; Imprime: " existencia actual "

    mov eax, existenciaActual
    mov esi, OFFSET cadena
    call convertirDecimal           ; Convierte el total del inventario a texto ASCII
    mov edx, OFFSET cadena
    call WriteString                ; Imprime el valor de la existencia actual calculada

    mov edx, OFFSET msg4
    call WriteString                ; Imprime: " unidades"

    call Crlf 
    exit                            ; Finaliza la ejecución del programa de forma segura y exitosa

error:                              ; Rutina de manejo de errores en la entrada
    ;  Manejo y recuperación de errores 
    mov edx, OFFSET msgError 
    call WriteString                ; Imprime el mensaje: "Cantidad recibida invalida"
    call Crlf 
    jmp capturar                    ; Salta de regreso al inicio ('capturar') para obligar al usuario a reintentar

main ENDP

; Procedimiento auxiliar para convertir un entero en EAX a cadena de caracteres ASCII 
convertirDecimal PROC
    mov ecx, 0 
    mov ebx, 10 

convertirLoop:
    mov edx, 0 
    div ebx                         ; Divide el valor entre 10: Cociente en EAX, Residuo (dígito actual) en EDX

    push edx                        ; Empuja el dígito extraído a la pila (aprovechando LIFO)
    inc ecx                         ; Incrementa el contador de dígitos

    cmp eax, 0 
    jne convertirLoop               ; Repite el ciclo mientras el cociente sea mayor a 0

cadenaLoop:
    pop edx 
    add dl, '0'                     ; Convierte el valor numérico del dígito de vuelta a su carácter ASCII correspondiente

    mov [esi], dl                   ; Almacena el carácter en la posición actual del buffer de texto
    inc esi                         ; Avanza el puntero del buffer

    loop cadenaLoop                 ; Repite hasta vaciar todos los dígitos almacenados en la pila

    mov BYTE PTR [esi], 0           ; Agrega el terminador nulo (0) al final de la cadena de texto

    ret                             ; Retorna el control al flujo principal del programa
convertirDecimal ENDP

END main
