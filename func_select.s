#   207233222   Yeheli Frangi
    .section    .rodata # read only data section
format_invalid:    .string "invalid option!\n"
format50_60:       .string "first pstring length: %d, second pstring length: %d\n"
format_char:       .string " %c"
format_int:        .string " %d"
format52:          .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
format53:          .string "length: %d, string: %s\n"
format54:          .string "length: %d, string: %s\n"
format55:          .string "compare result: %d\n"




    .text
.globl	run_func	# the label "run_func" is used to state the initial point of this program
	.type	run_func, @function	# the label "run_func" representing the beginning of a function

# this function decide which case we need to go to - according to the option the user gave
run_func:
    # chack to which label the case is
    movq	$0,%rax
    leaq    -50(%rdi),%rcx
    # check if it in the range of labels.
    cmpq    $10,%rcx
    ja  .L51 # default label
    jmp *.switch_case(,%rcx,8)


    # case 50 + case 60
    .L50:
        # call the function pstlen with pointer to the string1
        movq	$0,%rax
        movq    %rsi, %rdi # rdi -> string1
        call    pstrlen
        movq  %rax, %r8 # r8 -> the length of string1

        # call the function pstlen with pointer to the string2
        movq	$0,%rax
        movq    %rdx, %rdi # rdi -> string2
        call    pstrlen
        movq  %rax, %r9 # r9 -> the length of string2     

        # passing the arguments, and call printf
        movq	$0,%rax
        movq    $format50_60, %rdi # the print format
        movq    %r8,%rsi # length of string1
        movq    %r9,%rdx # length of string2
        call    printf # calling to printf AFTER we passed its parameters.
        ret

    # case 51 -- DEFAULT
    .L51:
        movq    $format_invalid,%rdi # the string is the only paramter passed to the printf function
        movq    $0, %rax
        call    printf
        ret
    # case 52

    .L52:
        # save the strings we got from the function
        movq    %rsi, %r10 # r10 -> string1
        movq    %rdx, %r11 # r11 -> string2

        # make place in the stack to 2 chars, 2 old strings and 2 new strings.
        push    %rbp
        movq    %rsp, %rbp
        sub     $48,%rsp

        # place the strings in the stack
        movq   %rsi, -48(%rbp) # string1
        movq   %rdx, -40(%rbp) # string2
        
        
        # call scanf for old char
        movq    $format_char,%rdi # the pront format
        leaq    -32(%rbp), %rsi # put old char in the stack
        movq	$0,%rax
        call    scanf

        # call scanf for new char
        movq    $format_char,%rdi
        leaq    -24(%rbp), %rsi # put new char in the stack
        movq	$0,%rax
        call    scanf
       

        # call replaceChar for string1
        movq    -48(%rbp), %rdi # rdi -> string1
        movq    -32(%rbp), %rsi # rsi -> old char
        movq    -24(%rbp), %rdx # rdx -> new char
        call    replaceChar
        movq    %rax, -16(%rbp) # save the new string1 in the stack

        # call replaceChar for string2
        movq    -40(%rbp), %rdi # rdi -> string2
        movq    -32(%rbp), %rsi # rsi -> old char
        movq    -24(%rbp), %rdx # rdx -> new char
        call    replaceChar
        movq    %rax, -8(%rbp) # save the new string2 in the stack

        # call printf
        movq    $format52, %rdi # rdi -> print format
        movq    -32(%rbp), %rsi # rsi -> old char
        movq    -24(%rbp), %rdx # rdx -> new char
        movq    -16(%rbp), %rcx # rcx -> string 1
        incq    %rcx
        movq    -8(%rbp), %r8 # r8 -> string 2
        incq    %r8        
        movq    $0, %rax
        call    printf # calling to printf AFTER we passed its parameters.

        # empy the stack
        movq    %rbp, %rsp # restoring the old stack pointer
        pop     %rbp # restoring the old frame pointer
        ret


    # case 53
    .L53:

        # make place in the stack to 2 chars, 2 strings.
        pushq  %rbp
        movq  %rsp, %rbp
        subq  $48, %rsp   

        # place the strings in the stack
        movq    %rsi, -48(%rbp)  # string1
        movq    %rdx, -40(%rbp)  # string2

        # call scanf to index i
        movq    $format_int, %rdi # scanf format
        leaq    -32(%rbp), %rsi # save first index - i in the stack
        movq    $0, %rax
        call  scanf

        # call scanf for index j
        movq    $format_int, %rdi # scanf format
        leaq    -24(%rbp), %rsi # save second index - j in the stack
        movq    $0, %rax
        call  scanf

        # call pstrln to string1
        movq    -48(%rbp), %rdi  # rdi -> string1
        movq    $0, %rax
        call    pstrlen
        movq    %rax, -16(%rbp)  # save the length of string 1 in the stack

        # call pstrln to string2
        movq    -40(%rbp), %rdi    # rdi -> string1
        movq    $0, %rax
        call    pstrlen
        movq    %rax, -8(%rbp)  # save the length of string 2 in the stack
    
        # call pstrijcpy
        movq    -48(%rbp), %rdi  # rdi -> string 1 
        movq    -40(%rbp), %rsi # rsi -> string 2
        movq    -32(%rbp), %rdx # rdx -> first index i
        movq    -24(%rbp), %rcx # rcx -> second index j
        movq    $0, %rax
        call    pstrijcpy
    
        movq    %rax, -48(%rbp)  # save the new string1 in the stack

        # call printf for string1
        movq    $format53, %rdi  # rdi -> print format
        movq    -16(%rbp), %rsi   # rsi -> lenght string 1
        movq    -48(%rbp), %rdx   # rdx -> string 1
        incq    %rdx
        movq    $0, %rax
        call    printf # calling to printf AFTER we passed its parameters.

        
        # call printf for string2
        movq    $format53, %rdi  # rdi ->  print format
        movq    -8(%rbp), %rsi   # rsi -> lenght string 2
        movq    -40(%rbp), %rdx   # rdx -> string2
        incq    %rdx        
        movq    $0, %rax
        call    printf # calling to printf AFTER we passed its parameters.

        # empty the stack
        movq    %rbp, %rsp # restoring the old stack pointer
        pop     %rbp # restoring the old frame pointer
        ret

    # case 54
    .L54:
        # make place in the stack to 2 strings.
        push    %rbp
        movq    %rsp, %rbp
        sub     $32,%rsp

        # place the strings in the stack
        movq   %rsi, -32(%rbp) # string1
        movq   %rdx, -16(%rbp) # string2

        # send to swapCase for string1
        movq	$0,%rax
        movq    -32(%rbp), %rdi # rdi -> string1 
        call    swapCase
        movq  %rax, -32(%rbp) # save the new string1

        # call to pstrlen for string1
        movq	$0,%rax
        movq    -32(%rbp), %rdi # rdi -> string1 
        call    pstrlen
        movq  %rax, -24(%rbp)  # save the length of string1


        # call printf for string1
        movq    $format54, %rdi # rdi -> print format
        movq    -24(%rbp), %rsi # rsi -> length string1
        movq    -32(%rbp), %rdx # rdx -> string1
        incq    %rdx        
        movq    $0, %rax
        call    printf # calling to printf AFTER we passed its parameters.

        # send to swapCase to string2
        movq	$0,%rax
        movq    -16(%rbp), %rdi # rdi -> string2
        call    swapCase
        movq  %rax, -16(%rbp) # save the new string2

        # call to pstrlen for string2
        movq	$0,%rax
        movq    -16(%rbp), %rdi # rdi -> string1 
        call    pstrlen
        movq  %rax, -8(%rbp) # save the length of string1

        # call printf for string2
        movq    $format54, %rdi # rdi -> print format
        movq    -8(%rbp), %rsi # rsi -> length string2
        movq    -16(%rbp), %rdx # rdx -> string2
        incq    %rdx
        movq    $0, %rax
        call    printf # calling to printf AFTER we passed its parameters.

        # empy the stack
        movq    %rbp, %rsp # restoring the old stack pointer
        pop     %rbp # restoring the old frame pointer
        ret
        
    .L55:
        # make place in the stack to 2 chars, 2 strings.
        pushq    %rbp
        movq    %rsp, %rbp
        subq     $48,%rsp 
        
        # place the strings in the stack
        movq   %rsi, -48(%rbp) # string1
        movq   %rdx, -40(%rbp) # string2

        # call scanf for index i
        movq    $format_int, %rdi # scanf format
        leaq    -32(%rbp), %rsi # rsi -> first index i
        movq    $0, %rax
        call  scanf

        # call scanf for index j
        movq    $format_int, %rdi # scanf format
        leaq    -24(%rbp), %rsi # rsi -> second index j
        movq    $0, %rax
        call  scanf

    
        # call pstrijcmp
        movq    -48(%rbp), %rdi # rdi -> string 1
        movq    -40(%rbp), %rsi # rsi -> string 2
        movq    -32(%rbp), %rdx # rdx -> first index i
        movq    -24(%rbp), %rcx # rcx -> second index j
        movq    $0, %rax
        call    pstrijcmp
        movq    %rax, -16(%rbp) # save the compare result in the stack

        # call print
        movq    $format55, %rdi # rdi -> print format
        movq    -16(%rbp), %rsi # rsi -> the compare result
        movq    $0, %rax
        call    printf # calling to printf AFTER we passed its parameters.

        # empty the stack
        movq    %rbp, %rsp # restoring the old stack pointer
        pop     %rbp # restoring the old frame pointer
        ret


	.align 8
    
	.switch_case:
	    .quad .L50
		.quad .L51
		.quad .L52
		.quad .L53
		.quad .L54
		.quad .L55
		.quad .L51
		.quad .L51
		.quad .L51
		.quad .L51
		.quad .L50
