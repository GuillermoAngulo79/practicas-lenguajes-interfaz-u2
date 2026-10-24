; Materia: Lenguajes de Interfaz
; Alumno: Guillermo Enrique Angulo Reynaga
; Horario: 10:0-11:00
; Docente: Dr. José Luis Medina Jiménez
; Práctica: 1. Ciclos numéricos
; Descripción: Programa que utiliza un ciclo (loop) para imprimir en consola 
;              los números del 5 al 1 en orden descendiente utilizando la librería Irvine32.

INCLUDE Irvine32.inc    ; Incluye la biblioteca de funciones de Kip Irvine para consola de 32 bits

.data                   ; Sección de declaración de variables (en este programa está vacía porque no se requieren variables)
.code                   ; Sección de código: aquí inician las instrucciones ejecutables

main PROC               ; Inicio del procedimiento principal del programa
    
    mov ecx, 5          ; Inicializa el registro contador ECX con el valor 5. 
                        ; El registro ECX actúa automáticamente como contador en la instrucción 'loop'.

ciclo:                  ; Etiqueta que marca el punto de retorno del ciclo numérico
    mov eax, ecx        ; Copia el valor actual del contador (ECX) al registro EAX, 
                        ; ya que las funciones de impresión de Irvine32 leen los datos desde EAX.
    
    call WriteDec       ; Llama a la función de Irvine32 para imprimir en pantalla 
                        ; el número decimal que se encuentra guardado en el registro EAX.
    
    call Crlf           ; Llama a la función de Irvine32 para realizar un salto de línea 
                        ; (Carriage Return / Line Feed), evitando que los números se junten.
    
    loop ciclo          ; Instrucción de control de ciclo: decrementa automáticamente 
                        ; el registro ECX en 1, y si ECX es mayor a 0, salta de nuevo a la etiqueta 'ciclo'.

    exit                ; Finaliza el programa y devuelve el control al sistema operativo
main ENDP               ; Fin del procedimiento principal

END main                ; Directiva que indica el punto final del archivo y el inicio del programa
