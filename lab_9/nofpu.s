	.file	"fpu.c"
	.text
	.globl	add_floats
	.def	add_floats;	.scl	2;	.type	32;	.endef
add_floats:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movss	%xmm0, 16(%rbp)
	movss	%xmm1, 24(%rbp)
	movss	16(%rbp), %xmm0
	addss	24(%rbp), %xmm0
	movss	%xmm0, -4(%rbp)
	movss	-4(%rbp), %xmm0
	mulss	16(%rbp), %xmm0
	movss	%xmm0, -4(%rbp)
	movss	-4(%rbp), %xmm0
	leave
	ret
	.globl	add_doubles
	.def	add_doubles;	.scl	2;	.type	32;	.endef
add_doubles:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movsd	%xmm0, 16(%rbp)
	movsd	%xmm1, 24(%rbp)
	movsd	16(%rbp), %xmm0
	addsd	24(%rbp), %xmm0
	movsd	%xmm0, -8(%rbp)
	movsd	-8(%rbp), %xmm0
	mulsd	16(%rbp), %xmm0
	movsd	%xmm0, -8(%rbp)
	movsd	-8(%rbp), %xmm0
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	leave
	ret
	.globl	_asm_add_floats
	.def	_asm_add_floats;	.scl	2;	.type	32;	.endef
_asm_add_floats:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movss	%xmm0, 16(%rbp)
	movss	%xmm1, 24(%rbp)
/APP
 # 26 "fpu.c" 1
	mov %eax, 16(%rbp)
	mov %eax, 24(%rbp)
	
 # 0 "" 2
/NO_APP
	movl	%eax, -4(%rbp)
	movss	-4(%rbp), %xmm0
	leave
	ret
	.def	__main;	.scl	2;	.type	32;	.endef
	.globl	main
	.def	main;	.scl	2;	.type	32;	.endef
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	call	__main
	movl	$0, %eax
	leave
	ret
	.ident	"GCC: (GNU) 10.2.0"
