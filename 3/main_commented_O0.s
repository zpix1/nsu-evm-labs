get_pi(long long):
        push    rbp                         ; складываем адрес возврата на стек
        mov     rbp, rsp                    ; обновляем адрес
        sub     rsp, 48                     ; выделяем место на стеке
        mov     QWORD PTR [rbp-40], rdi     ; кладем total на стек
        mov     QWORD PTR [rbp-8], 0        ; кладем i на стек и ставим = 0
        mov     QWORD PTR [rbp-16], 0       ; кладем matched на стек и ставим = 0
.L5:
        mov     rax, QWORD PTR [rbp-16]     ; кладем i со стека на регистр
        cmp     rax, QWORD PTR [rbp-40]     ; сравниваем i и total
        jge     .L2                         ; если i >= total, то цикл кончился, идем на метку конца цикла
        call    rand                        ; вызываем функцию rand, она кладет 32 битное случайное число (int) в eax
        cvtsi2sd        xmm0, eax           ; конвертируем int (который вернул rand) в double
        movsd   xmm1, QWORD PTR .LC0[rip]   ; кладем RAND_MAX в регистр
        divsd   xmm0, xmm1                  ; делим случайное число (которое получили) на RAND_MAX
        movsd   QWORD PTR [rbp-24], xmm0    ; сохраняем это число на стек (x)
        call    rand                        ; повторяем операцию (для y)
        cvtsi2sd        xmm0, eax           ; повторяем операцию (для y)
        movsd   xmm1, QWORD PTR .LC0[rip]   ; повторяем операцию (для y)
        divsd   xmm0, xmm1                  ; повторяем операцию (для y)
        movsd   QWORD PTR [rbp-32], xmm0    ; повторяем операцию (для y)
        movsd   xmm0, QWORD PTR [rbp-24]    ; берем x со стека
        movapd  xmm1, xmm0                  ; копируем между регистрами (для double movapd быстрее)
        mulsd   xmm1, xmm0                  ; возводим x в квадрат
        movsd   xmm0, QWORD PTR [rbp-32]    ; берем y со стека
        mulsd   xmm0, xmm0                  ; возводим y в квадрат
        addsd   xmm1, xmm0                  ; складываем
        movsd   xmm0, QWORD PTR .LC1[rip]   ; берем из памяти 1.0
        comisd  xmm0, xmm1                  ; сравниваем x*x + y*y и 1.0
        jb      .L3                         ; если > 1.0, пропускаем инкремент matched
        add     QWORD PTR [rbp-8], 1        ; инкрементируем matched
.L3:
        add     QWORD PTR [rbp-16], 1       ; инкрементируем i
        jmp     .L5                         ; переходим в начало цикла
.L2:
        cvtsi2sd xmm1, QWORD PTR [rbp-8]    ; конвертируем matched в double
        movsd   xmm0, QWORD PTR .LC2[rip]   ; берем из памяти 4.0
        mulsd   xmm0, xmm1                  ; умножаем
        cvtsi2sd xmm1, QWORD PTR [rbp-40]   ; конвертируем total в double
        divsd   xmm0, xmm1                  ; делим
        leave                               ; возвращаем стек и                 
        ret                                 ; выходим по адресу возврата
.LC3:
        .string "PI = %lf\n"                ; форматная строка
main:
        push    rbp                         ; складываем адрес возврата на стек
        mov     rbp, rsp                    ; обновляем адрес
        sub     rsp, 16                     ; выделяем место для локальных переменных
        mov     edi, 90000000               ; складываем аргумент total
        call    get_pi(long long)           ; вызываем функцию get_pi
        movq    rax, xmm0                   ; get_pi сложила результат в xmm0, берем его
        mov     QWORD PTR [rbp-8], rax      ; складываем результат на стек
        mov     rax, QWORD PTR [rbp-8]      ; ??
        movq    xmm0, rax                   ; ??
        mov     edi, OFFSET FLAT:.LC3       ; кладем указатель на форматную строку в edi
        mov     eax, 1                      ; число аргументов printf
        call    printf                      ; вызываем printf
        mov     eax, 0                      ; кладем адрес возврата - 0
        leave                               ; возвращаем стек и
        ret                                 ; выходим по адресу возврата
.LC0:                                       ; RAND_MAX
        .long   4290772992
        .long   1105199103
.LC1:                                       ; 1.0
        .long   0
        .long   1072693248
.LC2:                                       ; 4.0
        .long   0
        .long   1074790400
; INTEGER передаются через следующий свободный регистр rdi, rsi, rdx, rcx, r8, r9 в именно таком порядке.