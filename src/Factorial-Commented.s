	.file	"Factorial.c"
	.text
	.type	factorial, @function
factorial:
.LFB0:
	.cfi_startproc
	pushq	%rbp # pushes the base pointer value from the register onto the stack to save it, according to x86-64 calling conventions.
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp # copies the stack pointer register value to the base pointer register (rsp currently points to newly pushed base pointer) to set up a new 
	                   # stack frame, according to x86-64 calling conventions.
	.cfi_def_cfa_register 6
	subq	$16, %rsp # sets the stack pointer to point 16 bytes lower than the base pointer, allowing for the manipulation of 16 bytes of memory space on the stack 
					  # (allocating 16 bytes of space for local variables and temporary storage). 
	movq	%rdi, -8(%rbp) # copies the value "n" into the location 8 bytes below the base pointer. The rdi register corresponds to the value "n" according to 
                           # calling conventions on x86-64, as the function has less than 6 arguments, meaning that the first value goes into the rdi register.
	movq	%rsi, -16(%rbp) # copies the value "accumulator" into the location 16 bytes below the base pointer. The rsi register correponds to the value 
	                        # "accumulator" according to calling conventions on x86-64, as the function has less than 6 arguments, meaning that the second value 
							# (i.e. "accumulator") goes into the rsi register.
	cmpq	$1, -8(%rbp) # compares the value "n" with the number 1. The result is stored in the status flags.
	ja	.L2 # jumps (transfers control) to .L2 label if the value of "n" is greater than 1 (this is an unsigned comparison). If not, the next instruction is executed.                                              
	movl	$7, %edi # copies the value 7 to the edi register (possibly a compiler optimisation for the value 6l + 1l in the function).
	call	printStackFrames # calls the printStackFrames function, pushing the value of rip onto the stack (changing rsp) and setting rip to the given address.
	movq	-16(%rbp), %rax # the "accumulator" value is copied into the rax register, which is conventionally used for returning values in x86-64.
	jmp	.L3 # jumps (transfers control) to .L3 label when the base case of the recursion is reached (i.e. n <= 1).
.L2:
	movq	-8(%rbp), %rax # copies the value "n" to the rax register, which is conventionally used for returning values in x86-64.
	imulq	-16(%rbp), %rax # performs signed multiplication of "n" by "accumulator", storing the result in the rax register.
	movq	-8(%rbp), %rdx # the "n" value is copied into the rdx register, which is the next register conventionally used after rdi and rsi.
	subq	$1, %rdx # subtracts the constant 1 from "n" (equivalent to "n - 1"), which is stored back in the rdx register.
	movq	%rax, %rsi # copies value in the rax (return) register (i.e. "n * accumulator") to the rsi register as it is conventionally used to hold the second 
	                   # argument for function calls.
	movq	%rdx, %rdi # copies value in rdx register (i.e. "n - 1") to the rdi register as it is conventionally used to hold the first argument for function calls. 
	call	factorial # calls factorial function recursively, pushing the value of rip (the instruction pointer) onto the stack (changing rsp) and 
	                  # setting rip to the given address. The values stored in the rdi and rsi registers ("n - 1" and "n * accumulator" respectively) 
					  # correspond to n and accumulator in the factorial function, according to the calling conventions.
.L3:
	leave # sets stack pointer value to that of the base pointer (resetting it to the position before the function call), then pops top of stack (the old 
	      # base pointer value) and copies it to the rbp register, effectively resetting the base pointer to its previous value before the function call.
	.cfi_def_cfa 7, 8
	ret # pops the top value from the stack (which would be the return address saved during the function call above the recently popped base pointer) and 
	    # copies it to the rip (instruction pointer) register, transferring control to the address stored in the rip register and resetting the program to 
		# the instruction after the function call was made.
	.cfi_endproc
.LFE0:
	.size	factorial, .-factorial
	.section	.rodata
	.align 8
.LC0:
	.string	"executeFactorial: basePointer = %lx\n"
	.align 8
.LC1:
	.string	"executeFactorial: returnAddress = %lx\n"
	.align 8
.LC2:
	.string	"executeFactorial: about to call factorial which should print the stack\n"
	.align 8
.LC3:
	.string	"executeFactorial: factorial(%lu) = %lu\n"
	.text
	.globl	executeFactorial
	.type	executeFactorial, @function
executeFactorial:
.LFB1:
	.cfi_startproc
	pushq	%rbp 
	.cfi_def_cfa_offset 16 
	.cfi_offset 6, -16
	movq	%rsp, %rbp 
	.cfi_def_cfa_register 6
	subq	$48, %rsp 
	movl	$0, %eax 
	call	getBasePointer 
	movq	%rax, -8(%rbp) 
	movq	-8(%rbp), %rax 
	movq	%rax, %rsi 
	movl	$.LC0, %edi 
	movl	$0, %eax 
	call	printf 
	movl	$0, %eax 
	call	getReturnAddress 
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax 
	movq	%rax, %rsi 
	movl	$.LC1, %edi 
	movl	$0, %eax 
	call	printf 
	movl	$.LC2, %edi
	call	puts
	movq	$0, -24(%rbp)
	movq	$6, -32(%rbp)
	movq	$1, -40(%rbp)
	movq	-40(%rbp), %rdx
	movq	-32(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	factorial
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rdx
	movq	-32(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC3, %edi
	movl	$0, %eax
	call	printf
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	executeFactorial, .-executeFactorial
	.ident	"GCC: (GNU) 11.4.1 20230605 (Red Hat 11.4.1-2)"
	.section	.note.GNU-stack,"",@progbits
