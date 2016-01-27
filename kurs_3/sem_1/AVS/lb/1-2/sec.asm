[org 0x7c00]
  [bits 16]
    cli          ; запрет прерываний
    lgdt [GDT]     ; загружаем регистр GDTR

    ; устанавливаем системный бит PE регистра CR0 в 1 для перехода в защищенный режим
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    ; jump far на первую комманду защищенного режима
    jmp CODE_SEGMENT:PM_FIRST_COMMAND

  [bits 32]
    PM_FIRST_COMMAND:

    mov ax, DATA_SEGMENT
    mov ds, ax

    mov ax, TASK_0
    ltr ax          ; загрузка значения в регистр TR, который хранит селектор дескриптора TSS текущей задачи

    jmp TASK_1:0

    PRINT_STRING_PM_DONE:

    ; переход в режим реальных адресов
    mov eax, cr0
    and al, 0xfe
    mov cr0, eax

    ; разрешить прерывания
    sti
    jmp $

    TASK_1_LABEL:
      mov ebx, PM_MSG1

      PRINT_PM_TASK_1:
        mov al, [ebx]          ; читаем байт из строки
        mov ah, 0x0f           ; 0 - фон, f - текст

        mov ecx, 1000000h
        loop $                 ;задает бесконечный цикл
        cmp al, 0
        jmp TASK_2:0
        je PRINT_STRING_PM_DONE

        mov [edi], ax         ; символ с атрибутом в видеопамять по смещению
        add ebx, 1            ; следующий символ
        add edi, 2            ; следующий символ в видеопамяти

        jmp PRINT_PM_TASK_1
    TASK_2_LABEL:
    mov ebx, PM_MSG2

      PRINT_PM_TASK_2:
        mov al, [ebx]
        mov ah, 0x05
        mov ecx, 1000000h
        loop $
        cmp al, 0
        jmp TASK_1:0
        je PRINT_STRING_PM_DONE
        mov [edi], ax
        add ebx, 1
        add edi, 2
        jmp PRINT_PM_TASK_2
    TASK_3_LABEL:
    mov ebx, PM_MSG3

      PRINT_PM_TASK_3:
        mov al, [ebx]
        mov ah, 0x0d
        mov ecx, 1000000h
        loop $
        cmp al, 0
        jmp TASK_1:0
        je PRINT_STRING_PM_DONE

        mov [edi], ax
        add ebx, 1
        add edi, 2

        jmp PRINT_PM_TASK_3

  gdt_start:
    gdt_null:
      dq 0
    gdt_code:
      dw 0xffff; limit 0-15
      dw 0x0 ; base 0-15
      db 0x0 ; base 16-23
      db 10011010b ; P-1, DPL -00, S-1,Code-1,Conform-1,Readable-1,A-0
      db 11001111b ;G-1, 32-bit - 1, 64-bit seg - 0, AVL - 0, limit 16-19
      db 0x0; base 24-31
    gdt_data:
      dw 0xffff ; limit
      dw 0x0 ; base
      db 0x0 ;base
      db 10010010b ; flags
      db 11001111b ; flags, limit
      db 0x0 ; base
    gdt_task0:
      dw 103
      dw TSS_0
      db 0
      db 89h ; busy, 32-bit, 0-ring privileges
      db 0
      db 0
    gdt_task1:
      dw 103
      dw TSS_1
      db 0
      db 89h ; busy, dpl
      db 0
      db 0

    gdt_task2:
      dw 103
      dw TSS_2
      db 0
      db 89h ; busy, dpl
      db 0
      db 0

    gdt_task3:
      dw 103
      dw TSS_3
      db 0
      db 89h ; busy, dpl
      db 0
      db 0

    gdt_end:

  GDT:        ;глобальная дескрипторная таблица
    dw gdt_end - gdt_start - 1       ;предел
    dd gdt_start                     ;адрес GDT

  CODE_SEGMENT equ gdt_code - gdt_start
  DATA_SEGMENT equ gdt_data - gdt_start
  TASK_0 equ gdt_task0 - gdt_start
  TASK_1 equ gdt_task1 - gdt_start
  TASK_2 equ gdt_task2 - gdt_start
  TASK_3 equ gdt_task3 - gdt_start
  VIDEO_MEMORY equ 0xb8000

  PM_MSG1 db 'Task 1!',0
  PM_MSG2 db 'Task 2!',0
  PM_MSG3 db 'Task 3!',0

  TSS_0:
    dw 0, 0 ; back link
    dd 0 ; ESP0
    dw 0, 0 ; SS0, reserved
    dd 0 ; ESP1
    dw 0, 0 ; SS1, reserved
    dd 0 ; ESP2
    dw 0, 0 ; SS2, reserved
    dd 0 ; CR3
    dd TASK_1_LABEL, 0 ; EIP, EFLAGS (EFLAGS=0x200 for ints)
    dd 0, 0, 0, 0 ; EAX, ECX, EDX, EBX
    dd 0, 0, 0, 0 ; ESP, EBP, ESI, EDI
    dw DATA_SEGMENT, 0 ; ES, reserved
    dw CODE_SEGMENT, 0 ; CS, reserved
    dw DATA_SEGMENT, 0 ; SS, reserved
    dw DATA_SEGMENT, 0 ; DS, reserved
    dw DATA_SEGMENT, 0 ; FS, reserved
    dw DATA_SEGMENT, 0 ; GS, reserved
    dw 0, 0 ; LDT, reserved
    dw 0, 0 ; debug, IO perm. bitmap

  TSS_1:
    dw 0, 0 ; back link
    dd 0 ; ESP0
    dw 0, 0 ; SS0, reserved
    dd 0 ; ESP1
    dw 0, 0 ; SS1, reserved
    dd 0 ; ESP2
    dw 0, 0 ; SS2, reserved
    dd 0 ; CR3
    dd TASK_1_LABEL, 0 ; EIP, EFLAGS (EFLAGS=0x200 for ints)
    dd 0, 0, 0, 0 ; EAX, ECX, EDX, EBX
    dd 0, 0, 0, VIDEO_MEMORY ; ESP, EBP, ESI, EDI
    dw DATA_SEGMENT, 0 ; ES, reserved
    dw CODE_SEGMENT, 0 ; CS, reserved
    dw DATA_SEGMENT, 0 ; SS, reserved
    dw DATA_SEGMENT, 0 ; DS, reserved
    dw DATA_SEGMENT, 0 ; FS, reserved
    dw DATA_SEGMENT, 0 ; GS, reserved
    dw 0, 0 ; LDT, reserved
    dw 0, 0 ; debug, IO perm. bitmap

  TSS_2:
    dw 0, 0 ; back link
    dd 0 ; ESP0
    dw 0, 0 ; SS0, reserved
    dd 0 ; ESP1
    dw 0, 0 ; SS1, reserved
    dd 0 ; ESP2
    dw 0, 0 ; SS2, reserved
    dd 0 ; CR3
    dd TASK_2_LABEL, 0 ; EIP, EFLAGS (EFLAGS=0x200 for ints)
    dd 0, 0, 0, 0 ; EAX, ECX, EDX, EBX
    dd 0, 0, 0, VIDEO_MEMORY + 160 ; ESP, EBP, ESI, EDI
    dw DATA_SEGMENT, 0 ; ES, reserved
    dw CODE_SEGMENT, 0 ; CS, reserved
    dw DATA_SEGMENT, 0 ; SS, reserved
    dw DATA_SEGMENT, 0 ; DS, reserved
    dw DATA_SEGMENT, 0 ; FS, reserved
    dw DATA_SEGMENT, 0 ; GS, reserved
    dw 0, 0 ; LDT, reserved
    dw 0, 0 ; debug, IO perm. bitmap
  TSS_3:
    dw 0, 0 ; back link
    dd 0 ; ESP0
    dw 0, 0 ; SS0, reserved
    dd 0 ; ESP1
    dw 0, 0 ; SS1, reserved
    dd 0 ; ESP2
    dw 0, 0 ; SS2, reserved
    dd 0 ; CR3
    dd TASK_3_LABEL, 0 ; EIP, EFLAGS (EFLAGS=0x200 for ints)
    dd 0, 0, 0, 0 ; EAX, ECX, EDX, EBX
    dd 0, 0, 0, VIDEO_MEMORY + 320 ; ESP, EBP, ESI, EDI
    dw DATA_SEGMENT, 0 ; ES, reserved
    dw CODE_SEGMENT, 0 ; CS, reserved
    dw DATA_SEGMENT, 0 ; SS, reserved
    dw DATA_SEGMENT, 0 ; DS, reserved
    dw DATA_SEGMENT, 0 ; FS, reserved
    dw DATA_SEGMENT, 0 ; GS, reserved
    dw 0, 0 ; LDT, reserved
    dw 0, 0 ; debug, IO perm. bitmap

times 1022 - ($-$$) db 0
; определение, как далеко находитесь от начала секции

dw 0xaa55