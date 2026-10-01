	.def	 _relocate;
	.scl	2;
	.type	32;
	.endef
	.text
	.globl	_relocate
	.align	16, 0x90
_relocate:                              # @_relocate
# BB#0:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	leaq	.L.str(%rip), %rdx
	leaq	.L.str1(%rip), %r8
	leaq	_relocate(%rip), %r9
	callq	*__imp__iki_relocate(%rip)
	addq	$32, %rsp
	popq	%rbp
	ret

	.def	 _sensitize;
	.scl	2;
	.type	32;
	.endef
	.globl	_sensitize
	.align	16, 0x90
_sensitize:                             # @_sensitize
# BB#0:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	leaq	.L.str(%rip), %rdx
	callq	*__imp__iki_sensitize(%rip)
	addq	$32, %rsp
	popq	%rbp
	ret

	.def	 _simulate;
	.scl	2;
	.type	32;
	.endef
	.globl	_simulate
	.align	16, 0x90
_simulate:                              # @_simulate
# BB#0:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	leaq	.L.str(%rip), %rdx
	callq	*__imp__iki_schedule_processes_at_time_zero(%rip)
	callq	*__imp__iki_execute_processes(%rip)
	addq	$32, %rsp
	popq	%rbp
	ret

	.def	 _main;
	.scl	2;
	.type	32;
	.endef
	.globl	_main
	.align	16, 0x90
_main:                                  # @_main
# BB#0:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rsi
	pushq	%rdi
	subq	$64, %rsp
	movq	%rdx, %rsi
	movl	%ecx, %edi
	leaq	.L.str2(%rip), %rcx
	leaq	.L.str3(%rip), %rdx
	xorl	%r8d, %r8d
	movl	$10485760, %r9d         # imm = 0xA00000
	callq	*__imp__iki_heap_initialize(%rip)
	callq	*__imp__isimBridge_getWdbWriter(%rip)
	movq	%rsi, 56(%rsp)
	movl	%edi, 48(%rsp)
	movq	%rax, 32(%rsp)
	movl	$0, 40(%rsp)
	leaq	.L.str4(%rip), %rcx
	leaq	_relocate(%rip), %rdx
	leaq	_sensitize(%rip), %r8
	leaq	_simulate(%rip), %r9
	callq	*__imp__iki_create_design(%rip)
	leaq	.L.str5(%rip), %rcx
	callq	*__imp__iki_set_sv_type_file_path_name(%rip)
	callq	*__imp__iki_simulate_design(%rip)
	addq	$64, %rsp
	popq	%rdi
	popq	%rsi
	popq	%rbp
	ret

	.section	.rdata,"r"
.L.str:                                 # @.str
	.asciz	"xsim.dir/PCPU_tb_behav/xsim.reloc"

.L.str1:                                # @.str1
	.asciz	"xsim.dir/PCPU_tb_behav/xsimk.exe"

.L.str2:                                # @.str2
	.asciz	"ms"

.L.str3:                                # @.str3
	.asciz	"isimmm"

.L.str4:                                # @.str4
	.asciz	"xsim.dir/PCPU_tb_behav/xsim.mem"

.L.str5:                                # @.str5
	.asciz	"xsim.dir/PCPU_tb_behav/xsim.svtype"


