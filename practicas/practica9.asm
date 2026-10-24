; Materia: Lenguajes de Interfaz
; Alumno: Guillermo Enrique Angulo Reynaga
; Horario: 10:00-11:00
; Docente: Dr. José Luis Medina Jiménez
; Práctica: 9. PUSH y POP (Manejo de la pila)
; Descripción: Programa demostrativo del funcionamiento de la pila del sistema (Stack), 
;              el comportamiento LIFO (Last In, First Out), el uso de PUSH/POP para respaldar datos 
;              y la gestión automática de la pila mediante las instrucciones CALL y RET.

INCLUDE Irvine32.inc   
.data                   ; Sección de declaración de variables (vacía, operando directamente con registros y la pila)

.code                   ; Sección de código ejecutable
main PROC               ; Inicio del procedimiento principal del programa

    ;  1. Operaciones básicas de PUSH y POP 
    mov eax, 40         ; Carga el valor entero 40 en el registro EAX
    push eax            ; Instrucción PUSH: Decrementa automáticamente el puntero de pila (ESP en -4) 
                        ; y almacena el valor de EAX (40) en la cima de la pila.

    call DumpRegs       ; Llama a Irvine32 para mostrar el estado de los registros y el cambio en el puntero ESP.

    mov eax, 0          ; Limpia el registro EAX 
    pop ebx             ; Instrucción POP: Extrae el valor de la cima de la pila, 
                        ; lo guarda en el registro EBX y decrementa el puntero de pila.

    call DumpRegs       ; Muestra el resultado tras el POP.


    ;  2. Comportamiento LIFO (Last In, First Out / Último en entrar, primero en salir) 
    mov eax, 10         ; Carga 10 en EAX
    push eax            ; Mete 10 a la pila
    mov eax, 20         ; Carga 20 en EAX
    push eax            ; Mete 20 a la pila
    mov eax, 30         ; Carga 30 en EAX
    push eax            ; Mete 30 a la pila (este fue el último en ingresar)

    call DumpRegs       ; Muestra la pila cargada con los 3 elementos en orden (ESP apuntando al 30)

    pop eax             ; Saca el elemento de la cima: como el 30 fue el último en entrar, sale primero (EAX = 30)
    pop ebx             ; Saca el siguiente elemento de la pila (EBX = 20)
    pop ecx             ; Saca el primer elemento que ingresó (ECX = 10)

    call DumpRegs       ; Muestra los registros tras vaciar completamente la pila en orden inverso.


    ;  3. Intercambio de valores entre registros usando la pila 
    mov eax, 100        ; Inicializa EAX con 100
    mov ebx, 200        ; Inicializa EBX con 200

    push eax            ; Guarda temporalmente el valor de EAX (100) en la pila
    push ebx            ; Guarda temporalmente el valor de EBX (200) en la pila

    pop ebx             ; Saca el valor de la cima (200) y lo asigna a EBX
    pop eax             ; Saca el siguiente valor (100) y lo asigna a EAX (Intercambio completado)

    call DumpRegs       ; Muestra en pantalla el resultado del intercambio de datos.


    ;  4. Llamada a procedimiento y la pila (CALL / RET) 
    mov eax, 50         ; Carga 50 en EAX
    mov ebx, 100        ; Carga 100 en EBX

    call aumentarDiez   ; Instrucción CALL: Guarda automáticamente la dirección de retorno en la pila 
                        ; salta la ejecución hacia la subrutina 'aumentarDiez'.

    call DumpRegs       ; Muestra el resultado tras volver de la subrutina (notarás que EAX ahora vale 60).

    exit                
main ENDP

; Procedimiento secundario 
aumentarDiez PROC
    add eax, 10         ; Suma 10 al registro EAX (EAX pasa de 50 a 60)
    ret                 ; Instrucción RET: Extrae de la pila la dirección de retorno guardada 
                        ; previamente por el CALL y regresa exactamente a la línea siguiente en 'main'.
aumentarDiez ENDP

END main
