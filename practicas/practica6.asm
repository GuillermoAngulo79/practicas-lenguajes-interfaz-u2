; Materia: Lenguajes de Interfaz
; Alumno: Guillermo Enrique Angulo Reynaga
; Horario: 10:00-11:00
; Docente: Dr. José Luis Medina Jiménez
; Práctica: 6.1 Decremento e incremento (Control de ocupación de un estacionamiento)
; Descripción: Programa interactivo que simula el control de un estacionamiento con capacidad 
;              máxima de 20 vehículos, gestionando entradas, salidas y validando límites.

INCLUDE Irvine32.inc

.data
    capacidad   = 20                    ; Constante que define el límite máximo de autos permitidos

    msgOp1      BYTE "1. Entra un carro", 0
    msgOp2      BYTE "2. Sale un carro", 0
    msgOp3      BYTE "3. Salir", 0
    msgOpcion   BYTE "Opcion: ", 0
    msgLleno    BYTE "ESTACIONAMIENTO LLENO: no se permite entrar mas carros.", 0
    msgVacio    BYTE "ESTACIONAMIENTO VACIO.", 0
    msgCarros   BYTE "Carros dentro: ", 0

.code
main PROC
    mov ebx, 0                          ; Inicializa el registro EBX en 0. 
                                        ; EBX funcionará como nuestra variable de estado (contador de carros dentro).

menu:                                   ; Etiqueta que marca el inicio del ciclo del menú principal
    call Crlf
    mov edx, OFFSET msgOp1
    call WriteString
    call Crlf
    mov edx, OFFSET msgOp2
    call WriteString
    call Crlf
    mov edx, OFFSET msgOp3
    call WriteString
    call Crlf
    mov edx, OFFSET msgOpcion
    call WriteString
    call ReadInt                        ; Lee la opción numérica ingresada por el usuario y la almacena en EAX

    ; --- Evaluación de la opción del menú ---
    cmp eax, 1                          ; Compara si el usuario eligió la opción 1
    je entrada                          ; Si es igual a 1, salta a la rutina 'entrada'
    cmp eax, 2                          ; Compara si el usuario eligió la opción 2
    je salida                           ; Si es igual a 2, salta a la rutina 'salida'
    cmp eax, 3                          ; Compara si el usuario eligió la opción 3
    je fin                              ; Si es igual a 3, salta a la etiqueta 'fin'
    jmp menu                            ; Si ingresó cualquier otra cosa, repite el menú (opción inválida)

entrada:                                ; Rutina para registrar la entrada de un vehículo
    cmp ebx, capacidad                  ; Compara la cantidad actual de carros (EBX) con la capacidad máxima (20)
    jae lleno                           ; Salto condicional (Jump Above or Equal): Si EBX es mayor o igual a 20, 
                                        ; significa que ya está lleno y salta a la etiqueta 'lleno'.
    
    inc ebx                             ; Incrementa en 1 el contador de carros (EBX = EBX + 1)
    cmp ebx, capacidad                  ; Vuelve a comparar si tras incrementar alcanzó exactamente el límite
    jne mostrar                         ; Si no es igual al límite (aún hay espacio), salta directamente a 'mostrar'

lleno:                                  ; Etiqueta manejadora del estado de saturación
    mov edx, OFFSET msgLleno            ; Carga el mensaje de estacionamiento lleno
    call WriteString
    call Crlf
    jmp mostrar                         ; Salta a mostrar el estado actual de vehículos

salida:                                 ; Rutina para registrar la salida de un vehículo
    cmp ebx, 0                          ; Compara si el contador de carros es cero (estacionamiento vacío)
    je vacio                            ; Salto condicional (Jump if Equal): Si EBX es 0, salta a la etiqueta 'vacio'
    
    dec ebx                             ; Decrementa en 1 el contador de carros (EBX = EBX - 1)
    jnz mostrar                         ; Salto condicional: Si el resultado no es cero, 
                                        ; significa que todavía hay carros dentro, salta a 'mostrar'.

vacio:                                  ; Etiqueta manejadora del estado sin vehículos
    mov edx, OFFSET msgVacio            ; Carga el mensaje de estacionamiento vacío
    call WriteString
    call Crlf

mostrar:                                ; Rutina para desplegar el reporte visual del estado actual
    mov edx, OFFSET msgCarros           ; Carga el texto "Carros dentro: "
    call WriteString
    mov eax, ebx                        ; Copia el valor actual del contador (EBX) al registro EAX
    call WriteDec                       ; Imprime en pantalla el número decimal que está en EAX
    call Crlf
    jmp menu                            ; Regresa de manera incondicional al menú principal para la siguiente acción

fin:                                    ; Etiqueta de salida del programa
    exit                                ; Finaliza el programa y devuelve el control al S.O.
main ENDP
END main
