; Materia: Lenguajes de Interfaz
; Alumno: Guillermo Enrique Angulo Reynaga
; Horario: 10:00-11:00
; Docente: Dr. José Luis Medina Jiménez
; Práctica: 15. Manipulación de archivos
; Descripción: Programa que crea un archivo de texto en el disco local utilizando CreateOutputFile, escribe una 
;              cadena en él mediante WriteToFile y cierra el manejador adecuadamente con la librería Irvine32.

INCLUDE Irvine32.inc    

.data
    nombreArchivo BYTE "Inventario.txt", 0        
    texto         BYTE "125", 0                 
    archivoHandle DWORD ?                       ; Variable para almacenar el manejador (handle) del archivo

    mensajeExito BYTE "Archivo guardado correctamente.", 0  ; Mensaje en caso de éxito
    mensajeError BYTE "No se pudo guardar el archivo.", 0   ; Mensaje en caso de fallo general

.code
main PROC               

    ;  1. Crear / Abrir el archivo para escritura 
    mov edx, OFFSET nombreArchivo
    call CreateOutputFile            ; Llama a la función de Irvine32 para crear o sobreescribir el archivo.
                                     ; Devuelve un manejador (file handle) único en el registro EAX.

    cmp eax, INVALID_HANDLE_VALUE    ; Compara el valor devuelto con la constante de error de Windows
    je error                         ; Si son iguales, significa que hubo un fallo al crear el archivo y salta a 'error'

    mov archivoHandle, eax           ; Guarda el manejador devuelto en la variable 'archivoHandle' para futuras operaciones

    ;  2. Escribir contenido en el archivo 
    mov eax, archivoHandle           ; Carga el manejador del archivo en EAX
    mov edx, OFFSET texto            ; EDX apunta a la dirección de memoria de la cadena que queremos escribir ("125")
    mov ecx, LENGTHOF texto - 1      ; Define la cantidad exacta de bytes a escribir (excluyendo el terminador nulo 0)
    call WriteToFile                 ; Ejecuta la escritura de los datos en el archivo físico
    
    jc errorEscritura                ; Comprueba la bandera Carry Flag (CF): si está activa, ocurrió un error durante la escritura

    ;  3. Cerrar el archivo correctamente 
    mov eax, archivoHandle           ; Carga el manejador del archivo
    call CloseFile                   ; Cierra el flujo del archivo para liberar los recursos del sistema operativo

    ;  4. Notificar éxito al usuario
    mov edx, OFFSET mensajeExito
    call WriteString                 ; Imprime: "Archivo guardado correctamente."
    call Crlf
    jmp fin                          ; Salta incondicionalmente al final del programa

errorEscritura:                      ; Rutina manejadora si falla la escritura con el archivo abierto
    mov eax, archivoHandle
    call CloseFile                   ; Asegura cerrar el archivo antes de salir para evitar bloqueos en el S.O.

error:                               ; Rutina general de manejo de errores
    mov edx, OFFSET mensajeError
    call WriteString                 
    call Crlf

fin:                                 
    exit                             
main ENDP

END main
