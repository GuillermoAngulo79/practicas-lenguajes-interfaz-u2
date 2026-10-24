; Materia: Lenguajes de Interfaz
; Alumno: Guillermo Enrique Angulo Reynaga
; Horario: 10:00-11:00
; Docente: Dr. José Luis Medina Jiménez
; Práctica: 11. Operaciones lógicas
; Descripción: Programa que manipula el registro de estado de un equipo utilizando operaciones lógicas 
;              a nivel de bits (AND, OR, XOR y TEST) para evaluar, encender, alternar y probar banderas de control de hardware.

INCLUDE Irvine32.inc   

.data
    alarmaEncencida BYTE "Alarma encendida", 0  ; Mensaje si la alarma está activa
    alarmaApagada   BYTE "Alarma apagada", 0    ; Mensaje si la alarma está inactiva

    ; Mapa de bits de estado hipotético:
    ; Bit 0: Computadora encendida (1) / apagada (0)
    ; Bit 1: Alarma encendida (1) / apagada (0)
    ; Bit 2: Conectada a internet (1) / desconectada (0)
    ; Estado inicial evaluado: 00000101b (Bit 0 y Bit 2 en 1, Bit 1 en 0)

.code
main PROC               ; Inicio del procedimiento principal del programa

    ;  1. Operación AND: Aislar un bit específico (Máscara de bits) 
    mov eax, 0            ; Limpia el registro EAX
    mov al, 00000101b     ; Carga el estado inicial en el registro AL (0000 0101)
    and al, 00000010b     ; Aplica una máscara AND con 0000 0010b para aislar únicamente el Bit 1 (la alarma).
                          ; Resultado en AL: 0000 0000b porque el bit 1 original era 0.

    call WriteBin         ; Llama a Irvine32 para mostrar el resultado en formato binario en pantalla
    call Crlf             ; Realiza un salto de línea

    ;  2. Operación OR: Encender o forzar un bit a 1 
    mov eax, 0            ; Limpia el registro EAX
    mov al, 00000101b     ; Carga el estado inicial (0000 0101b)
    or al, 00000010b      ; Fuerza a 1 el Bit 1 mediante una operación OR con la máscara 0000 0010b.
                          ; Resultado en AL: 0000 0111b la alarma ahora está encendida.

    call WriteBin         ; Muestra el nuevo estado modificado en formato binario
    call Crlf             ; Realiza un salto de línea

    ; 3. Operación XOR: Invertir o alternar el estado de un bit
    mov eax, 0            ; Limpia el registro EAX
    mov al, 00000101b     ; Carga el estado inicial (0000 0101b)
    xor al, 00000001b     ; Alterna el Bit 0 usando XOR con 0000 0001b. 
                          ; Como el Bit 0 era 1, al aplicarle XOR se invierte a 0. Si hubiera sido 0, pasaría a 1.
                          ; Resultado en AL: 0000 0100b.

    call WriteBin         ; Muestra el resultado de la inversión en binario
    call Crlf             ; Realiza un salto de línea

    ;  4. Operación TEST: Evaluar un bit sin modificar el registro original 
    mov eax, 0            ; Limpia el registro EAX
    mov al, 00000111b     ; Carga un estado de prueba donde la alarma está activa (Bit 1 = 1)

    test al, 00000010b    ; Ejecuta un AND interno entre AL y la máscara, pero DESCARTA el resultado numérico.
                          ; Su único propósito es actualizar las banderas del procesador, específicamente el Zero Flag (ZF).
    
    jz apagarAlarma       ; Salto condicional (Jump if Zero): Si el resultado del TEST dio cero (ZF = 1), 
                          ; significa que la alarma estaba apagada y salta a la etiqueta 'apagarAlarma'.
                          ; Como aquí el bit 1 es 1, ZF = 0, por lo que el salto no se realiza y continúa el flujo.

    ; Bloque ejecutado si la alarma está encendida
    mov edx, OFFSET alarmaEncencida
    call WriteString      ; Imprime en consola el texto "Alarma encendida"
    call Crlf             ; Salto de línea
    jmp fin               ; Salta incondicionalmente al final para evitar ejecutar el bloque de apagado

apagarAlarma:             ; Etiqueta en caso de que la alarma esté desactivada
    mov edx, OFFSET alarmaApagada
    call WriteString      ; Imprime en consola el texto "Alarma apagada"
    call Crlf             ; Salto de línea

fin:                      ; Etiqueta de cierre del programa
    exit                  ; Finaliza el programa de forma segura y devuelve el control al S.O.
main ENDP

END main
