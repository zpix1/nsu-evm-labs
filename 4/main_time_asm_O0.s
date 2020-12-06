get_pi(long long):                  ; Пролог
        push    {r4, r5, r6, r7, r8, r9, r10, fp, lr}
        add     fp, sp, #32         ; fp = sp + 32 ставим указатель кадра
        sub     sp, sp, #44         ; sp = sp - 44 ставим указатель вершины стека
        str     r0, [fp, #-76]      ; Кладем total на стек
        str     r1, [fp, #-72]
        mov     r3, #0              ; matched = 0
        mov     r4, #0
        str     r3, [fp, #-44]      ; Кладем matched на стек
        str     r4, [fp, #-40]
        mov     r3, #0              ; i =  0
        mov     r4, #0
        str     r3, [fp, #-52]      ; Кладем i на стек
        str     r4, [fp, #-48]
.L5:
        sub     r2, fp, #52         ; Проверяем условие цикла
        ldmia   r2, {r1-r2}         ; Загружаем i со стека
        sub     r4, fp, #76         
        ldmia   r4, {r3-r4}         ; Загружаем total со стека
        cmp     r1, r3              ; Сравниваем старшие 2 байта
        sbcs    r3, r2, r4          ; Вычитаем младшие 2 байта, ставим флаги; Subtract with carry, setting the condition flags.
        bge     .L2                 ; Выходим если i >= total
        bl      rand                ; r0 = rand
        mov     r3, r0
        mov     r0, r3
        bl      __aeabi_i2d         ; Конвертируем r0 в число с плавающей точкой
        ldr     r2, .L8             ; Загружаем RAND_MAX
        ldr     r3, .L8+4
        bl      __aeabi_ddiv        ; Делим
        mov     r3, r0
        mov     r4, r1
        str     r3, [fp, #-60]      ; Сохраняем результат x
        str     r4, [fp, #-56]
        bl      rand                ; Повторяем действия
        mov     r3, r0
        mov     r0, r3
        bl      __aeabi_i2d
        ldr     r2, .L8
        ldr     r3, .L8+4
        bl      __aeabi_ddiv
        mov     r3, r0
        mov     r4, r1
        str     r3, [fp, #-68]      ; Сохраняем результат y
        str     r4, [fp, #-64]
        sub     r3, fp, #60         ; Загружаем x со стека
        ldmia   r3, {r2-r3}
        sub     r1, fp, #60
        ldmia   r1, {r0-r1}
        bl      __aeabi_dmul        ; Возводим x в квадрат и результат в r9
        mov     r3, r0
        mov     r4, r1
        mov     r9, r3
        mov     r10, r4
        sub     r3, fp, #68
        ldmia   r3, {r2-r3}
        sub     r1, fp, #68
        ldmia   r1, {r0-r1}
        bl      __aeabi_dmul        ; Возводим y в квадрат и результат в r10
        mov     r3, r0
        mov     r4, r1
        mov     r2, r3
        mov     r3, r4
        mov     r0, r9
        mov     r1, r10
        bl      __aeabi_dadd        ; Складываем x*x и y*y
        mov     r3, r0
        mov     r4, r1
        mov     r0, r3
        mov     r1, r4
        mov     r2, #0
        ldr     r3, .L8+8           ; Выгружаем 1.0
        bl      __aeabi_dcmple      ; Сравниваем сумму квадратов и 1.0
        mov     r3, r0              ; ???
        cmp     r3, #0
        beq     .L3 
        sub     r4, fp, #44
        ldmia   r4, {r3-r4}
        adds    r7, r3, #1          ; Если if сработал, то matched++
        adc     r8, r4, #0
        str     r7, [fp, #-44]
        str     r8, [fp, #-40]
.L3:
        sub     r4, fp, #52
        ldmia   r4, {r3-r4}
        adds    r5, r3, #1          ; i++
        adc     r6, r4, #0
        str     r5, [fp, #-52]
        str     r6, [fp, #-48]
        b       .L5
.L2:                                ; Конец цикла
        sub     r1, fp, #44
        ldmia   r1, {r0-r1}
        bl      __aeabi_l2d
        mov     r2, #0
        ldr     r3, .L8+12
        bl      __aeabi_dmul        ; Умножаем matched на 4.0
        mov     r3, r0
        mov     r4, r1
        mov     r5, r4
        mov     r4, r3
        sub     r1, fp, #76
        ldmia   r1, {r0-r1}
        bl      __aeabi_l2d
        mov     r2, r0
        mov     r3, r1
        mov     r0, r4
        mov     r1, r5
        bl      __aeabi_ddiv        ; Делим на total
        mov     r3, r0
        mov     r4, r1
        mov     r0, r3
        mov     r1, r4
        sub     sp, fp, #32
        pop     {r4, r5, r6, r7, r8, r9, r10, fp, pc}
.L8:
        .word   -4194304
        .word   1105199103
        .word   1072693248
        .word   1074790400
.LC0:
        .ascii  "PI = %lf\012\000"
.LC1:
        .ascii  "Time: %lf sec.\012\000"
main:
        push    {r4, r5, fp, lr}    ; Пролог
        add     fp, sp, #12
        sub     sp, sp, #24
        sub     r3, fp, #28
        mov     r1, r3
        mov     r0, #4              ; CLOCK_MONOTONIC_RAW
        bl      clock_gettime       ; Первый замер
        adr     r1, .L12
        ldmia   r1, {r0-r1}
        bl      get_pi(long long)
        str     r0, [fp, #-20]      ; Сохраняем PI
        str     r1, [fp, #-16]
        sub     r3, fp, #36
        mov     r1, r3
        mov     r0, #4
        bl      clock_gettime       ; Второй замер
        sub     r3, fp, #20
        ldmia   r3, {r2-r3}
        ldr     r0, .L12+8
        bl      printf              ; Печатаем pi
        ldr     r2, [fp, #-36]      ; Вычисляем время в секундах
        ldr     r3, [fp, #-28]
        sub     r3, r2, r3
        mov     r0, r3
        bl      __aeabi_i2d
        mov     r4, r0
        mov     r5, r1
        ldr     r2, [fp, #-32]
        ldr     r3, [fp, #-24]
        sub     r3, r2, r3
        mov     r0, r3
        bl      __aeabi_i2d
        ldr     r2, .L12+12
        ldr     r3, .L12+16
        bl      __aeabi_dmul
        mov     r2, r0
        mov     r3, r1
        mov     r0, r4
        mov     r1, r5
        bl      __aeabi_dadd
        mov     r3, r0
        mov     r4, r1
        mov     r2, r3
        mov     r3, r4
        ldr     r0, .L12+20
        bl      printf              ; Печатаем время
        mov     r3, #0
        mov     r0, r3
        sub     sp, fp, #12
        pop     {r4, r5, fp, pc}
.L12:
        .word   90000000
        .word   0
        .word   .LC0
        .word   -400107883
        .word   1041313291
        .word   .LC1