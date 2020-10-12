get_pi(long long):                  ; Инициализация при запуске функции
        pushq   %r12
        movq    %rdi, %r12
        pushq   %rbp
        pushq   %rbx
        subq    $16, %rsp
        testq   %rdi, %rdi
        jle     .L6                 ; Если total равно нулю - сразу выйти
        xorl    %ebx, %ebx          ; Установка i и matched нулями
        xorl    %ebp, %ebp
.L5:                                ; Начало цикла
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
.LC4:                               ; Форматная строка
        .string "PI = %lf\n"
main:                               ; Функция main
        subq    $8, %rsp            ; Она вызывает get_pi от 90000000
        movl    $90000000, %edi
        call    get_pi(long long)
        movl    $.LC4, %edi         ; Вызов printf
        movl    $1, %eax            ; 1 аргумент
        call    printf              ; 
        xorl    %eax, %eax
        addq    $8, %rsp
        ret
.LC1:                               ; RAND_MAX (с плавающей точкой)
        .long   4290772992
        .long   1105199103
.LC2:                               ; 1.0
        .long   0
        .long   1072693248
.LC3:
        .long   0                   ; 4.0
        .long   1074790400
; INTEGER передаются через следующий свободный регистр rdi, rsi, rdx, rcx, r8, r9 в именно таком порядке.