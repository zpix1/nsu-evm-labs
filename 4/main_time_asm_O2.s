get_pi(long long):              ; Пролог
        push    {r4, r5, r6, r7, r8, r9, r10, fp, lr}
        mov     r3, r0
        mov     r4, r1
        sub     sp, sp, #20
        cmp     r0, #1
        stm     sp, {r3-r4}     
        sbcs    r3, r1, #0      
        blt     .L6             ; если total - 1 < 0
        mov     r4, #0          ; matched = 0, i = 0
        mov     r5, #0          ; Оптимизация - сразу 2 переменные обнуляются за 1 раз
        ldr     r8, .L11        ; Загрузка RAND_MAX
        ldr     r9, .L11+4
        str     r4, [sp, #8]    ; Сохраняем matched
        str     r5, [sp, #12]
.L5:
        bl      rand            ;
        bl      __aeabi_i2d     ; int to floating point
        mov     r2, r8
        mov     r3, r9
        bl      __aeabi_ddiv    ; Делим на rand_max
        mov     r7, r1
        mov     r6, r0
        bl      rand            ; Повторяем
        bl      __aeabi_i2d
        mov     r2, r8
        mov     r3, r9
        bl      __aeabi_ddiv
        mov     r2, r6
        mov     r10, r0
        mov     fp, r1
        mov     r3, r7
        mov     r0, r6
        mov     r1, r7
        bl      __aeabi_dmul    ; x*x - r0-r1 - x, r2-r3 - x
        mov     r2, r10
        mov     r6, r0
        mov     r7, r1
        mov     r3, fp
        mov     r0, r10
        mov     r1, fp
        bl      __aeabi_dmul    ; y*y
        mov     r2, r0
        mov     r3, r1
        mov     r0, r6
        mov     r1, r7
        bl      __aeabi_dadd    ; x*x + y*y
        mov     r2, #0
        ldr     r3, .L11+8      ; Загружаем 1.0
        bl      __aeabi_dcmple  ; Сравниваем
        cmp     r0, #0          ;
        beq     .L3             ; Не прибавляем matched если не сработал if
        ldr     r3, [sp, #8]    ; matched++
        adds    r3, r3, #1      ;
        str     r3, [sp, #8]
        ldr     r3, [sp, #12]
        adc     r3, r3, #0
        str     r3, [sp, #12]
.L3:
        adds    r4, r4, #1      ; i++
        adc     r5, r5, #0
        ldmia   sp, {r2-r3}     ; Сравниваем total и i
        cmp     r3, r5
        cmpeq   r2, r4      
        bne     .L5             ; Переход в начало цикла
        ldr     r10, [sp, #8]   ; Вычисляем PI
        ldr     fp, [sp, #12]
        mov     r0, r10
        mov     r1, fp
        bl      __aeabi_l2d
        mov     r2, #0
        ldr     r3, .L11+12     ; 4.0
        bl      __aeabi_dmul
        mov     r4, r0
        mov     r5, r1
.L2:
        ldmia   sp, {r0-r1}
        bl      __aeabi_l2d
        mov     r2, r0
        mov     r3, r1
        mov     r0, r4
        mov     r1, r5
        bl      __aeabi_ddiv    ; Делим на total
        add     sp, sp, #20     ; Эпилог
        pop     {r4, r5, r6, r7, r8, r9, r10, fp, pc}
.L6:
        mov     r4, #0
        mov     r5, #0
        b       .L2
.L11:
        .word   -4194304
        .word   1105199103
        .word   1072693248
        .word   1074790400
main:
        push    {r4, r5, lr}    ; Пролог
        sub     sp, sp, #20
        mov     r1, sp
        mov     r0, #4
        bl      clock_gettime   ; Первый замер
        adr     r1, .L15        ; 90000000
        ldmia   r1, {r0-r1}
        bl      get_pi(long long)   ; Получаем pi
        mov     r4, r0
        mov     r5, r1
        mov     r0, #4
        add     r1, sp, #8
        bl      clock_gettime   ; Второй замер
        mov     r2, r4
        mov     r3, r5
        ldr     r0, .L15+8
        bl      printf          ; Печать pi
        ldr     r3, [sp, #4]    ; Вычисление времени
        ldr     r0, [sp, #12]
        sub     r0, r0, r3
        bl      __aeabi_i2d
        ldr     r2, .L15+12
        ldr     r3, .L15+16
        bl      __aeabi_dmul
        ldr     r3, [sp]
        mov     r4, r0
        ldr     r0, [sp, #8]
        mov     r5, r1
        sub     r0, r0, r3
        bl      __aeabi_i2d
        mov     r2, r0
        mov     r3, r1
        mov     r0, r4
        mov     r1, r5
        bl      __aeabi_dadd
        mov     r2, r0
        mov     r3, r1
        ldr     r0, .L15+20
        bl      printf          ; Печать времени
        mov     r0, #0
        add     sp, sp, #20
        pop     {r4, r5, pc}
.L15:
        .word   90000000
        .word   0
        .word   .LC0
        .word   -400107883
        .word   1041313291
        .word   .LC1
.LC0:
        .ascii  "PI = %lf\012\000"
.LC1:
        .ascii  "Time: %lf sec.\012\000"