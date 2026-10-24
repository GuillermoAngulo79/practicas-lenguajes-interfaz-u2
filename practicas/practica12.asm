; Materia: Lenguajes de Interfaz
; Alumno: Guillermo Enrique Angulo Reynaga
; Horario: 10:00-11:00
; Docente: Dr. José Luis Medina Jiménez
; Práctica: 12. Desplazamiento y rotación
; Descripción: Programa demostrativo de operaciones de desplazamiento lógico y aritmético (SHL, SHR, SAR) 
;              así como de rotación circular y a través del acarreo (ROR, ROL, RCL, RCR) en registros de 8 bits.

INCLUDE Irvine32.inc   

.data                   

.code                   
main PROC               
    ;  Limpieza inicial de registros 
    mov eax, 0          ; Limpia el registro EAX
    mov ebx, 0          ; Limpia el registro EBX
    mov ecx, 0          ; Limpia el registro ECX
    mov edx, 0          ; Limpia el registro EDX

    ;  1. SHL: Desplazamiento lógico a la izquierda (Multiplica por 2) 
    mov al, 10000000b     ; Carga el valor binario 10000000b (128 decimal) en el registro AL
    shl al, 1             ; Desplaza 1 bit a la izquierda; el bit 7 sale y pasa al Carry Flag (CF), 
                          ; dejando el registro en AL = 00000000b. Equivale a multiplicar por 2 con desbordamiento.

    call DumpRegs         ; Muestra el estado de los registros y banderas en consola
    call WriteBin         ; Imprime el contenido binario actual de EAX/AL
    call Crlf             ; Realiza un salto de línea

    ;  2. SHR: Desplazamiento lógico a la derecha (Divide sin signo entre 2) 
    mov al, 00001101b     ; Carga el valor binario 00001101b (13 decimal) en AL
    shr al, 1             ; Desplaza 1 bit a la derecha; el bit 0 sale y pasa al Carry Flag (CF), 
                          ; dejando AL = 00000110b (6 decimal). Equivalente a división entera sin signo entre 2.

    call DumpRegs         ; Muestra los registros
    call WriteBin         ; Imprime el binario en consola
    call Crlf             ; Salto de línea

    ; 3. SAR: Desplazamiento aritmético a la derecha (Conserva el bit de signo) 
    mov al, -9            ; Carga el valor negativo -9 (representado en complemento a dos como 11110111b) en AL
    sar al, 1             ; Desplaza a la derecha replicando el bit más significativo (bit de signo), 
                          ; resultando en AL = 11111011b (-5 decimal). Conserva el signo negativo.

    call DumpRegs         ; Muestra los registros
    call WriteBin         ; Imprime el binario
    call Crlf             ; Salto de línea

    ;  4. SHL con constante 
    mov al, 00001111b     ; Carga el valor binario 00001111b 
    shl al, 2             ; Desplaza 2 bits consecutivos a la izquierda (AL = 00111100b = 60 decimal). 
                          ; Multiplica el valor por 2 elevado a la potencia 2 ($15 * 4 = 60$).

    call DumpRegs         ; Muestra los registros
    call WriteBin         ; Imprime el binario
    call Crlf             ; Salto de línea

    ;  5. SHR utilizando el registro CL como contador dinámico 
    mov al, 00010100b     ; Carga el valor binario 00010100b 
    mov cl, 2             ; Carga el valor 2 en el registro auxiliar CL para usarlo como contador de desplazamiento
    shr al, cl            ; Desplaza a la derecha tantas posiciones como indique el registro CL (AL = 00000101b = 5 decimal)

    call DumpRegs         ; Muestra los registros
    call WriteBin         ; Imprime el binario
    call Crlf             ; Salto de línea

    ;  6. Instrucciones de Rotación 

    ; ROR: Rotación circular a la derecha
    mov al, 10000001b     ; Carga el valor binario 10000001b en AL
    ror al, 1             ; Rota 1 bit a la derecha de manera circular; el bit 0 sale, se reubica en la posición 7 
                          ; y también se copia al Carry Flag (AL = 11000000b)

    call DumpRegs         ; Muestra los registros
    call WriteBin         ; Imprime el binario
    call Crlf             ; Salto de línea

    ; ROL: Rotación circular a la izquierda
    mov al, 10000001b     ; Carga el valor binario 10000001b en AL
    rol al, 1             ; Rota 1 bit a la izquierda de manera circular; el bit 7 sale, se reubica en la posición 0 
                          ; y también se copia al Carry Flag (AL = 00000011b)

    call DumpRegs         ; Muestra los registros
    call WriteBin         ; Imprime el binario
    call Crlf             ; Salto de línea

    ; RCL: Rotación a la izquierda a través del acarreo (CF)
    clc                   ; Instrucción Clear Carry: Limpia el bit de acarreo (CF = 0)
    mov al, 10000001b     ; Carga el valor binario 10000001b en AL
    rcl al, 1             ; Rota 9 bits en total a la izquierda 
                          ; resultando en AL = 00000010b y CF = 1.

    call DumpRegs         ; Muestra los registros
    call WriteBin         ; Imprime el binario
    call Crlf             ; Salto de línea

    ; RCR: Rotación a la derecha a través del acarreo (CF)
    clc                   ; Limpia el bit de acarreo (CF = 0)
    mov al, 10000001b     ; Carga el valor binario 10000001b en AL
    rcr al, 1             ; Rota 9 bits en total a la derecha incorporando el CF (AL = 01000000b, CF = 1)

    call DumpRegs         ; Muestra los registros
    call WriteBin         ; Imprime el binario
    call Crlf             ; Salto de línea

    exit                 
main ENDP

END main
