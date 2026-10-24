; Materia: Lenguajes de Interfaz
; Alumno: Guillermo Enrique Angulo Reynaga
; Horario: 10:00-11:00
; Docente: Dr. José Luis Medina Jiménez
; Práctica: 8. Operaciones aritméticas
; Descripción: Programa demostrativo de operaciones aritméticas básicas y avanzadas (ADD, SUB, MUL, IMUL, DIV, IDIV), 
;              así como el manejo de banderas de desbordamiento (CF, OF) y extensión de signo (CDQ).

INCLUDE Irvine32.inc    

.data                   ; Sección de declaración de variables 

.code                   ; Sección de código ejecutable
main PROC               ; Inicio del procedimiento principal del programa

   ; 1. ADD y SUB: Operaciones básicas de suma y resta
   mov eax, 50          ; Carga 50 en el registro EAX
   mov ebx, 20          ; Carga 20 en el registro EBX

   add eax, ebx         ; Suma el contenido de EBX a EAX (EAX = 50 + 20 = 70)
   sub eax, 15          ; Resta 15 al contenido actual de EAX (EAX = 70 - 15 = 55)

   nop                  ; Instrucción nula 

   ; 2. CF (Carry Flag): Acarreo en una suma sin signo
   mov eax, 0
   mov al, 255          ; Carga el valor máximo representable en un registro de 8 bits sin signo (255 / FFh)

   add al, 1            ; Suma 1: AL rebasa su límite, vuelve a 0, y activa la bandera de acarreo (CF = 1)

   nop

   ; 3. OF (Overflow Flag): Desbordamiento en una suma con signo
   mov eax, 0
   mov al, 127          ; Carga el valor positivo máximo para un registro de 8 bits con signo (127)

   add al, 1            ; Suma 1: El valor cambia al equivalente en complemento a dos 80h (-128), 
                        ; lo que altera el bit de signo y activa la bandera de desbordamiento (OF = 1)

   nop

   ; 4. MUL: Producto dentro del rango de 32 bits
   mov eax, 1000
   mov ebx, 2000

   mul ebx              ; Multiplicación sin signo: Multiplica EAX por EBX. 
                        ; Como cabe perfectamente en 32 bits, la parte alta en EDX queda en 0, y las banderas CF y OF se limpian.

   nop

   ; 5. MUL: Producto que excede los 32 bits (requiere el par EDX:EAX)
   mov eax, 131000
   mov ebx, 131000

   mul ebx              ; Multiplicación sin signo: El resultado supera la capacidad de 32 bits. 
                        ; La parte alta se almacena en EDX (EDX = 4) y la baja en EAX. Se activan CF = 1 y OF = 1.

   nop

   ; 6. IMUL: Producto con signo (formato de tres operandos)
   mov eax, -5
   imul eax, eax, 3     ; Multiplica el valor de EAX (-5) por 3 y almacena el producto directamente en EAX (EAX = -15)

   nop

   ; 7. DIV: División de valores pequeños sin signo
   mov eax, 125
   mov edx, 0           ; Limpia obligatoriamente el registro EDX antes de dividir sin signo 
                        ; (el dividendo completo es la combinación de 64 bits EDX:EAX)
   mov ebx, 12

   div ebx              ; Divide EDX:EAX entre EBX: El cociente se guarda en EAX (10) y el residuo (módulo) en EDX (5)

   nop

   ; 8. IDIV y CDQ: División con signo de 32 bits
   mov eax, -125
   cdq                  ; Extiende el bit de signo del registro EAX a lo largo de todo el registro EDX. 
                        ; Es un paso previo obligatorio para formar el dividendo de 64 bits con signo sin alterar la cantidad negativa.

   mov ebx, 12

   idiv ebx             ; División con signo: EAX almacena el cociente (-10) y EDX almacena el residuo (-5)

   nop

   ; Mostrar el resultado final en pantalla mediante una tabla de registros
   call DumpRegs        ; Llama a la función de Irvine32 para desplegar el estado visual de los registros y banderas

   exit                 
main ENDP

END main
