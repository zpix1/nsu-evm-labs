get_pi(long long):
        pushq   %rbp                    ; Пролог
        movq    %rsp, %rbp
        subq    $48, %rsp
        movq    %rdi, -40(%rbp)
        movq    $0, -8(%rbp)
        movq    $0, -16(%rbp)
.L5:
        movq    -16(%rbp), %rax
        cmpq    -40(%rbp), %rax
        jge     .L2                     ; Проверка условия цикла
        call    rand                    ; Вычисления
        pxor    %xmm0, %xmm0
        cvtsi2sdl       %eax, %xmm0
        movsd   .LC0(%rip), %xmm1
        divsd   %xmm1, %xmm0
        movsd   %xmm0, -24(%rbp)
        call    rand
        pxor    %xmm0, %xmm0
        cvtsi2sdl       %eax, %xmm0
        movsd   .LC0(%rip), %xmm1
        divsd   %xmm1, %xmm0
        movsd   %xmm0, -32(%rbp)
        movsd   -24(%rbp), %xmm0
        movapd  %xmm0, %xmm1
        mulsd   %xmm0, %xmm1
        movsd   -32(%rbp), %xmm0
        mulsd   %xmm0, %xmm0
        addsd   %xmm0, %xmm1
        movsd   .LC1(%rip), %xmm0
        comisd  %xmm1, %xmm0
        jb      .L3
        addq    $1, -8(%rbp)            ; инкрементируем matched
.L3:
        addq    $1, -16(%rbp)           ; инкрементируем i
        jmp     .L5
.L2:
        pxor    %xmm1, %xmm1            ; финальные вычисления
        cvtsi2sdq       -8(%rbp), %xmm1
        movsd   .LC2(%rip), %xmm0
        mulsd   %xmm1, %xmm0
        pxor    %xmm1, %xmm1
        cvtsi2sdq       -40(%rbp), %xmm1
        divsd   %xmm1, %xmm0
        movq    %xmm0, %rax
        movq    %rax, %xmm0
        leave
        ret
.LC3:
        .string "PI = %lf\n"
.LC5:
        .string "Time: %lf sec.\n"
main:
        pushq   %rbp                    ; Пролог
        movq    %rsp, %rbp
        subq    $48, %rsp
        leaq    -32(%rbp), %rax
        movq    %rax, %rsi
        movl    $4, %edi
        call    clock_gettime           ; Первое измерение времени
        movl    $90000000, %edi
        call    get_pi(long long)
        movq    %xmm0, %rax
        movq    %rax, -8(%rbp)
        leaq    -48(%rbp), %rax
        movq    %rax, %rsi
        movl    $4, %edi
        call    clock_gettime           ; Второе измерение
        movq    -8(%rbp), %rax
        movq    %rax, %xmm0
        movl    $.LC3, %edi
        movl    $1, %eax
        call    printf                  ; Печать PI
        movq    -48(%rbp), %rax
        movq    -32(%rbp), %rdx
        subq    %rdx, %rax
        pxor    %xmm1, %xmm1
        cvtsi2sdq       %rax, %xmm1
        movq    -40(%rbp), %rax
        movq    -24(%rbp), %rdx
        subq    %rdx, %rax
        pxor    %xmm2, %xmm2
        cvtsi2sdq       %rax, %xmm2
        movsd   .LC4(%rip), %xmm0
        mulsd   %xmm2, %xmm0
        addsd   %xmm0, %xmm1
        movq    %xmm1, %rax
        movq    %rax, %xmm0
        movl    $.LC5, %edi
        movl    $1, %eax
        call    printf                  ; Печать времени
        movl    $0, %eax
        leave
        ret
.LC0:
        .long   -4194304
        .long   1105199103
.LC1:
        .long   0
        .long   1072693248
.LC2:
        .long   0
        .long   1074790400
.LC4:
        .long   -400107883
        .long   1041313291