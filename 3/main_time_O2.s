get_pi(long long):                      
        pushq   %r12                    ; Пролог
        movq    %rdi, %r12
        pushq   %rbp
        pushq   %rbx
        subq    $16, %rsp
        testq   %rdi, %rdi              ; Проверка условия цикла
        jle     .L6
        xorl    %ebx, %ebx
        xorl    %ebp, %ebp
.L5:
        call    rand                ; Вызов библиотечной функции rand
        pxor    %xmm0, %xmm0
        cvtsi2sdl %eax, %xmm0       ; Конвертирование результата rand в double
        divsd .LC1(%rip), %xmm0     ; Делим на RAND_MAX
        movsd   %xmm0, 8(%rsp)  
        call    rand                ; Повторный вызов rand и деление
        movsd   8(%rsp), %xmm0
        pxor    %xmm1, %xmm1
        movsd .LC2(%rip), %xmm2     ; Загрузка 1.0 в регистр
        cvtsi2sdl       %eax, %xmm1
        divsd   .LC1(%rip), %xmm1
        mulsd   %xmm1, %xmm1        ; Возведение в квадрат
        mulsd   %xmm0, %xmm0
        addsd   %xmm1, %xmm0
        comisd  %xmm0, %xmm2        ; Сравнение x*x+y*y с 1
        sbbq    $-1, %rbp           ; subtract with borrow 
        addq    $1, %rbx            ; Инкремент i
        cmpq    %rbx, %r12          ; Сравниванем i с total
        jne     .L5                 ; Если не равны - цикл не кончился - идем в начало цикла
        pxor    %xmm0, %xmm0
        cvtsi2sdq %rbp, %xmm0
        mulsd .LC3(%rip), %xmm0     ; Умножаем результат на 4.0
.L2:
        pxor    %xmm1, %xmm1
        addq    $16, %rsp
        cvtsi2sdq %r12, %xmm1       ; Конвертируем total в double
        popq    %rbx
        popq    %rbp
        popq    %r12
        divsd   %xmm1, %xmm0        ; Делим matched * 4.0 на total, результат - в xmm0
        ret
.L6:
        pxor    %xmm0, %xmm0
        jmp     .L2
.LC4:
        .string "PI = %lf\n"
.LC6:
        .string "Time: %lf sec.\n"
main:
        subq    $56, %rsp                ; Пролог
        movl    $4, %edi
        leaq    16(%rsp), %rsi
        call    clock_gettime            ; Первое измерение
        movl    $90000000, %edi
        call    get_pi(long long)        ; Вызов get_pi
        leaq    32(%rsp), %rsi
        movl    $4, %edi
        movsd   %xmm0, 8(%rsp)           ; Сохранение результата
        call    clock_gettime
        movsd   8(%rsp), %xmm0
        movl    $.LC4, %edi
        movl    $1, %eax
        call    printf                   ; Печать PI
        movq    40(%rsp), %rax           ; Вычисления времени
        pxor    %xmm0, %xmm0
        subq    24(%rsp), %rax
        cvtsi2sdq       %rax, %xmm0
        pxor    %xmm1, %xmm1
        movq    32(%rsp), %rax
        subq    16(%rsp), %rax
        mulsd   .LC5(%rip), %xmm0
        cvtsi2sdq       %rax, %xmm1
        movl    $.LC6, %edi
        movl    $1, %eax
        addsd   %xmm1, %xmm0
        call    printf                  ; Печать времени
        xorl    %eax, %eax
        addq    $56, %rsp
        ret
.LC1:				        ; RAND_MAX
        .long   -4194304
        .long   1105199103
.LC2:				        ; 1.0
        .long   0
        .long   1072693248
.LC3:
        .long   0			; 4.0
        .long   1074790400
.LC5:				        ; 0.000000001
        .long   -400107883
        .long   1041313291