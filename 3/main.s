	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 13
	.intel_syntax noprefix
	.section	__TEXT,__literal8,8byte_literals
	.p2align	3
LCPI0_0:
	.quad	4616189618054758400     ## double 4
LCPI0_1:
	.quad	4607182418800017408     ## double 1
LCPI0_2:
	.quad	4746794007244308480     ## double 2147483647
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_get_pi
	.p2align	4, 0x90
_get_pi:                                ## @get_pi
	.cfi_startproc
## BB#0:
	push	rbp
Lcfi0:
	.cfi_def_cfa_offset 16
Lcfi1:
	.cfi_offset rbp, -16
	mov	rbp, rsp
Lcfi2:
	.cfi_def_cfa_register rbp
	sub	rsp, 48
	mov	qword ptr [rbp - 8], rdi
	mov	qword ptr [rbp - 16], 0
	mov	qword ptr [rbp - 24], 0
LBB0_1:                                 ## =>This Inner Loop Header: Depth=1
	mov	rax, qword ptr [rbp - 24]
	cmp	rax, qword ptr [rbp - 8]
	jge	LBB0_6
## BB#2:                                ##   in Loop: Header=BB0_1 Depth=1
	call	_rand
	movsd	xmm0, qword ptr [rip + LCPI0_2] ## xmm0 = mem[0],zero
	movsd	xmm1, qword ptr [rip + LCPI0_1] ## xmm1 = mem[0],zero
	cvtsi2sd	xmm2, eax
	mulsd	xmm2, xmm1
	divsd	xmm2, xmm0
	movsd	qword ptr [rbp - 32], xmm2
	call	_rand
	movsd	xmm0, qword ptr [rip + LCPI0_1] ## xmm0 = mem[0],zero
	movsd	xmm1, qword ptr [rip + LCPI0_2] ## xmm1 = mem[0],zero
	cvtsi2sd	xmm2, eax
	mulsd	xmm2, xmm0
	divsd	xmm2, xmm1
	movsd	qword ptr [rbp - 40], xmm2
	movsd	xmm1, qword ptr [rbp - 32] ## xmm1 = mem[0],zero
	mulsd	xmm1, qword ptr [rbp - 32]
	movsd	xmm2, qword ptr [rbp - 40] ## xmm2 = mem[0],zero
	mulsd	xmm2, qword ptr [rbp - 40]
	addsd	xmm1, xmm2
	ucomisd	xmm0, xmm1
	jb	LBB0_4
## BB#3:                                ##   in Loop: Header=BB0_1 Depth=1
	mov	rax, qword ptr [rbp - 16]
	add	rax, 1
	mov	qword ptr [rbp - 16], rax
LBB0_4:                                 ##   in Loop: Header=BB0_1 Depth=1
	jmp	LBB0_5
LBB0_5:                                 ##   in Loop: Header=BB0_1 Depth=1
	mov	rax, qword ptr [rbp - 24]
	add	rax, 1
	mov	qword ptr [rbp - 24], rax
	jmp	LBB0_1
LBB0_6:
	movsd	xmm0, qword ptr [rip + LCPI0_0] ## xmm0 = mem[0],zero
	cvtsi2sd	xmm1, qword ptr [rbp - 16]
	mulsd	xmm1, xmm0
	cvtsi2sd	xmm0, qword ptr [rbp - 8]
	divsd	xmm1, xmm0
	movaps	xmm0, xmm1
	add	rsp, 48
	pop	rbp
	ret
	.cfi_endproc

	.globl	_main
	.p2align	4, 0x90
_main:                                  ## @main
	.cfi_startproc
## BB#0:
	push	rbp
Lcfi3:
	.cfi_def_cfa_offset 16
Lcfi4:
	.cfi_offset rbp, -16
	mov	rbp, rsp
Lcfi5:
	.cfi_def_cfa_register rbp
	sub	rsp, 32
	mov	eax, 90000000
	mov	edi, eax
	mov	dword ptr [rbp - 4], 0
	call	_get_pi
	lea	rdi, [rip + L_.str]
	movsd	qword ptr [rbp - 16], xmm0
	movsd	xmm0, qword ptr [rbp - 16] ## xmm0 = mem[0],zero
	mov	al, 1
	call	_printf
	xor	ecx, ecx
	mov	dword ptr [rbp - 20], eax ## 4-byte Spill
	mov	eax, ecx
	add	rsp, 32
	pop	rbp
	ret
	.cfi_endproc

	.section	__TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
	.asciz	"PI = %lf\n"


.subsections_via_symbols
