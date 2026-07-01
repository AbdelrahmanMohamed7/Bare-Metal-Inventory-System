.MODEL SMALL
.STACK 100h

; Data segment
.DATA
fname DB 'temp.txt',0
fname1 DB 'temp1.txt',0
invent DB 30 dup('$')
quant DB 10 dup('$')
endl DB 13, 10, '$'
fhandle DW ?
fhandle1 DW ?
openErrMsg db 'Error opening file!', '$'
readErrMsg db 'Error reading file!', '$'
msg DB ' ::Product::', '$'
msg1 DB '::Quantity::', '$'
msg2 db '-----------------------------------MAIN MENU-----------------------------------','$'
msg3 db 'Order added to inventory successfully','$'
quit_message DB 'Do you want to quit? Press "q" to quit or any other key to continue.', '$'
LOW_INVENTORY_MESSAGE DB 'Low inventory. Would you like to order more of this product? (y/n)','$'
order_quantity_message DB 'Enter the quantity you want to order : ','$'
writeErrMsg DB 'Error During Writing in File ','S'
; Code segment
.CODE

; Main program
MAIN PROC
  mov ax,@data
  mov ds,ax
  call LOAD_DATA
  goagain:
  ;display data from buffer
  call DISPLAY_INVENTORY
  call CHECK_INVENTORY_LEVELS
  call ASK_TO_QUIT
  cmp ax,1
  je goagain
  
  ;exit
  mov ah,4ch
  int 21h
MAIN ENDP
; Function to load data from file into buffer

LOAD_DATA PROC
;inventory file
  ;open file
  mov ah,3dh
  lea dx,fname
  mov al,0
  int 21h
  jc OpenError
  mov fhandle,ax
  ;read from file  
  mov ah,3fh
  lea dx,invent
  mov cx,29
  mov bx,fhandle
  int 21h
  jc ReadError
  ;close file
  mov ah,3eh
  mov bx,fhandle
  int 21h
  ;exit
  jmp nxtfile
  
OpenError:
  ;handle file open error here
  mov ah,09h
  lea dx,openErrMsg
  int 21h
  jmp Quit
ReadError:
  ;handle file read error here
  mov ah,09h
  lea dx,readErrMsg
  int 21h
  jmp Quit
Quit:
  ret
 ;doing same for quantity file
 nxtfile:
    ;open file
  mov ah,3dh
  lea dx,fname1
  mov al,0
  int 21h
  jc OpenError1
  mov fhandle1,ax
  ;read from file  
  mov ah,3fh
  lea dx,quant
  mov cx,9
  mov bx,fhandle1
  int 21h
  jc ReadError1
  ;close file
  mov ah,3eh
  mov bx,fhandle1
  int 21h
  ;exit
  jmp Quit1
  
OpenError1:
  ;handle file open error here
  mov ah,09h
  lea dx,openErrMsg
  int 21h
  jmp Quit1
ReadError1:
  ;handle file read error here
  mov ah,09h
  lea dx,readErrMsg
  int 21h
  jmp Quit1
Quit1:
  ret
LOAD_DATA ENDP

; Function to display data from buffer


DISPLAY_INVENTORY PROC
;print heading
  ; print endl
  mov ah, 09h
  lea dx, endl
  int 21h
  
  mov ah, 09h
  lea dx, msg2
  int 21h
   ; print endl
  mov ah, 09h
  lea dx, endl
  int 21h

  ;print heading
  mov ah, 09h
  lea dx, msg
  int 21h

  ; print inventory message
  
  mov ah, 09h
  lea dx, invent
  int 21h

  ; print endl
  mov ah, 09h
  lea dx, endl
  int 21h
  
  ;print heading
  mov ah, 09h
  lea dx, msg1
  int 21h

  ; print quantity message
  mov ah, 09h
  lea dx, quant
  int 21h

  ; print endl
  mov ah, 09h
  lea dx, endl
  int 21h
  RET
DISPLAY_INVENTORY ENDP


CHECK_INVENTORY_LEVELS PROC
    MOV CX, 5        ; set the loop counter to 5, assuming there are 5 products
    MOV SI, 0           ; set the source index to 0

CHECK_LOOP:
 ; print endl
  mov ah, 09h
  lea dx, endl
  int 21h
  
    MOV AX, 0
    MOV AL, quant[SI]
    SUB AL, 48   ; convert character to number
    CMP AX, 5    ; compare the quantity with the threshold
    JGE NEXT_PRODUCT  ;
  
  
    MOV DL, invent[SI]     ; set DL to the current product name
    MOV AH, 02H         ; set print character function
    INT 21H             ; print the product name
    MOV DL, ':'         ; print a colon to separate the product name and quantity
    INT 21H             ; print the colon
    MOV DL, ' '         ; print a space to separate the colon and quantity
    INT 21H             ; print the space
    MOV DL, quant[SI]       ; set DL to the current product quantity
    MOV AH, 02H         ; set print character function
    INT 21H             ; print the quantity
    MOV DL, ' '         ; print a space to separate the quantity and inventory message
    INT 21H             ; print the space
	;/////
  mov ah, 09h
  lea dx, LOW_INVENTORY_MESSAGE
  int 21h           ; print the low inventory message

    ; read the user's response
    MOV AH, 01H         ; set read character function
    INT 21H             ; read a character from the user
    CMP AL, 'y'         ; compare the user's response to 'y' (yes)
    JE ORDER_MORE       ; if the user responded with 'y', jump to the ORDER_MORE label

NEXT_PRODUCT:
    ADD SI, 2           ; increment the source index by 2 (to skip the comma)
    LOOP CHECK_LOOP     ; loop until all products have been checked

    RET

ORDER_MORE:
    ; code to order more of the current product would go here
    ; ...
	 ; print endl
  mov ah, 09h
  lea dx, endl
  int 21h
  
  mov ah, 09h
  lea dx,order_quantity_message 
    INT 21H                 ; print the order quantity message
	
    MOV AH, 01H             ; set read character function
    INT 21H                 ; read a character from the user
    SUB AL, '0'             ; convert the input character to a number
    MOV BL, AL              ; move the quantity to order to BL
    ; add the quantity to order to the inventory
    add quant[SI], BL;
	call WRITE_DATA
 ; print endl
  mov ah, 09h
  lea dx, endl
  int 21h
  
  mov ah, 09h
  lea dx,msg3 ;print order saved 
  INT 21H 
    JMP NEXT_PRODUCT    ; jump back to the loop to check the next product
CHECK_INVENTORY_LEVELS ENDP

ASK_TO_QUIT PROC
    ; ask user if they want to quit the application
    ; use appropriate input and output commands to get user response
    ; return 0 if user chooses to quit, 1 otherwise
	; print endl first
  mov ah, 09h
  lea dx, endl
  int 21h
  
    MOV AH, 9 ; display message
    MOV DX, offset quit_message
    INT 21H
    
    MOV AH, 1 ; get user input
    INT 21H
    
    CMP AL, 'q' ; check if user entered 'q' to quit
    JNE quit_not_selected
    
    XOR AX, AX ; set return value to 0
    JMP quit_selected
    
quit_not_selected:
    MOV AX, 1 ; set return value to 1
    
quit_selected:
    RET
ASK_TO_QUIT ENDP

WRITE_DATA PROC
  ; Inventory file
  ; Open file
  mov ah, 3dh
  lea dx, fname
  mov al, 2
  int 21h
  jc WriteError
  mov fhandle, ax
  ; Write to file
  mov ah, 40h
  lea dx, invent
  mov cx, 9
  mov bx, fhandle
  int 21h
  jc WriteError
  ; Close file
  mov ah, 3eh
  mov bx, fhandle
  int 21h

  ; Quantity file
  ; Open file
  mov ah, 3dh
  lea dx, fname1
  mov al, 2
  int 21h
  jc WriteError
  mov fhandle1, ax
  ; Write to file
  mov ah, 40h
  lea dx, quant
  mov cx, 9
  mov bx, fhandle1
  int 21h
  jc WriteError
  ; Close file
  mov ah, 3eh
  mov bx, fhandle1
  int 21h

  ; Exit
  ret

WriteError:
  ; Handle file write error here
  mov ah, 09h
  lea dx, writeErrMsg
  int 21h
  ret
WRITE_DATA ENDP


END MAIN
