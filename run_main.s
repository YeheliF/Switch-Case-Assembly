#   207233222   Yeheli Frangi
.section    .rodata # read only data section
format_string:    .string   " %s"
format_int:       .string   " %hhu"

    .text
.globl	run_main	# the label "run_main" is used to state the initial point of this program
	.type	run_main, @function	# the label "run_main" representing the beginning of a function

run_main:
# this function get inpus from the usuer - long of string, string,long of string, string and an option
        # make place in the stack to 3 ints- lenght,length ,option and to 2 strings.
        pushq  %rbp
        movq  %rsp, %rbp
        subq  $528, %rsp

        # call scanf for length1 and save in in the stack
        movq    $format_int, %rdi # scanf format
        movq    %rsp, %rsi  # rsp -> length string1
        xorq    %rax, %rax
        call    scanf

        # call scanf for string1 and save in in the stack
        movq    $format_string, %rdi # scanf format
        leaq    1(%rsp), %rsi # rsp+1 -> string1
        xorq    %rax, %rax
        call    scanf

        # call scanf for length2 and save in in the stack
        movq    $format_int, %rdi # scanf format
        leaq    256(%rsp), %rsi  # rsp+256 -> length string2
        xorq    %rax, %rax
        call    scanf

        # call scanf for string2 and save in in the stack
        movq    $format_string, %rdi # scanf format
        leaq    257(%rsp), %rsi # rsp+257 -> string2
        xorq    %rax, %rax
        call    scanf

        # call scanf for option and save in in the stack
        movq    $format_int, %rdi # scanf format
        leaq    512(%rsp), %rsi  # rsp+512 -> option
        xorq    %rax, %rax
        call    scanf

        # call run_func - pass all the arguments to the first registers
        movzb   512(%rsp), %rdi
        leaq    (%rsp), %rsi
        leaq    256(%rsp), %rdx
        xorq    %rax, %rax
        call    run_func

        # empty the stack.
        movq  %rbp, %rsp
        pop %rbp
        ret

