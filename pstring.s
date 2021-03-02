#   207233222   Yeheli Frangi
.section    .rodata # read only data section

format_invalid:    .string      "invalid input!\n"

.text

.globl	pstrlen	# the label "pstrlen" is used to state the initial point of this program
	.type	pstrlen, @function	# the label "pstrlen" representing the beginning of a function

pstrlen:
# this function returns the length of the string
    # the first byte if the string is the length, we put the first byte in rax and return it.
    movq    $0,%rax
    movzbq    (%rdi),%rax # the lenght -> rax
    ret

.globl	replaceChar	# the label "replaceChar" is used to state the initial point of this program
	.type	replaceChar, @function	# the label "replaceChar" representing the beginning of a function

replaceChar:
# this function replace the xld char with the new char each time it appears in the string
    # creat stack with the string in it, save the lenght of the string in %r9.
    .start1:
        push    %rbp # save place to save dst string
        movq    %rdi, %rbp # rbp -> point to dst string
        movq    $0,%r8 # r8-> creat counter to 0
        movq	$0,%rax
        call    pstrlen
        movq  %rax, %r9 # r9-> length.string
        cmpq    %r9,%r8 # if length.string=0
        je      .endloop1
    .LOOP1:
        # check if we got to the index j - the last index we need to change
        cmpq    %r8,%r9
        jb      .endloop1
        # chack if the index of counter (r8) in the string is equal to the old char
        cmpb    (%rdi,%r8,1) ,%sil # dst string[counter] = xld char 
        je .change
        
        incq     %r8 # add 1 to the counter
        jmp     .LOOP1

    .change:
        # change the old char to the new char - put the new char at the index counter in the string.
        movb  %dl,(%rdi,%r8,1) # dst string[counter] = new char 
        incq     %r8 # add 1 to the counter
        jmp      .LOOP1
    
    .endloop1:
        # empty the stack, and return a pointer to the string.
        movq    %rbp, %rax
        popq    %rbp     
        ret
    
    
.globl	pstrijcpy	# the label "pstrijcpy" is used to state the initial point of this program
	.type	pstrijcpy, @function	# the label "pstrijcpy" representing the beginning of a function
pstrijcpy:
# the function copy each char from index i to j from the src string to the dst string
    # creat the stack, put the dst string in it, and assign the lenghts in registers.
    .start2:
        push    %rbp # save place to save dst string
        movq    %rdi, %rbp # rbp -> point to dst string
        movq    $0,%r8 # r8-> creat counter to 0 
        movzb    (%rdi),%r9 # r9-> length.dst
        movzb    (%rsi),%r10 # r10-> length.src
        movzb    %dl, %rdx
        movzb    %cl, %rcx
        jmp .check
    # check if all the input is correct
    .check:
        cmpq    %r9,%r8 # if length.dst=0
        je      .problam
        cmpq    %r10,%r8 # if length.src=0
        je      .problam
        cmpb    %dl, %cl  # if j>i
        jb      .problam
        cmpb    %r9b,%dl # if length.dst>i
        jge      .problam
        cmpb    %r9b,%cl # if length.dst>j
        jge      .problam
        cmpb    %r10b,%dl # if lenght.src>i
        jge      .problam
        cmpb    %r10b,%cl # if lenght.src>j
        jge      .problam
        movq    %rdx, %r8 # counter = i
        # add 1 to the indexes because the first index is the length
        incq    %r8
        incq    %rcx
        jmp     .LOOP2
    .LOOP2:
        # check if we got to the index j - the last index we need to change
        cmpq    %r8, %rcx # if j - counter
        jb      .endloop2
        movq    $0, %r12
        # pass the char in src string to the dst string
        movb    (%rsi,%r8,1), %r12b # r12b = src[counter] 
        movb    %r12b, (%rdi,%r8,1) # dst[counter] = r12b
        # add 1 to the counter
        incq     %r8
        jmp     .LOOP2
    .endloop2:
        # empty the stack, and return a pointer to the string.
        movq    %rbp, %rax # pass dst string
        popq    %rbp # free the stack     
        ret
    .problam:
        # when there was a problam in the input, we print invalid input
        movq    $format_invalid,%rdi
        movq    $0, %rax
        call    printf
        # empty the stack, and return a pointer to the string.
        movq    %rbp, %rax # pass dst string
        popq    %rbp # free the stack   
        ret

.globl	swapCase	# the label "swapCase" is used to state the initial point of this program
	.type	swapCase, @function	# the label "swapCase" representing the beginning of a function
swapCase:
# this function swap between big and lottle chars
    .start3:
        # creat the stack, save the string we swap on
        movq    $0,%rax
        push    %rbp # save place to save pstr string
        movq    %rdi, %rbp # rbp -> point to pstr string
        movq    $1,%r8 # r8-> creat counter to 0
        movzbq    (%rdi),%r9 # r9-> length.pstr
        movq    $0,%r12
        # check if the string is exsist
        cmpq    %r12,%r9 # if length.dst=0
        je      .endloop3
        jmp     .LOOP3
    
    .LOOP3:
        # check if we got to the end of the string - the last index we need to swap
        cmpq    %r9,%r8 # if length.pstr > counter
        ja      .endloop3
        # condition 1 to a little letter
        movq    $97,%r12
        cmpb    %r12b,(%rdi,%r8,1)
        jge      .changeLITTLE
        # condition 1 to a big letter
        movq    $65,%r12
        cmpb    %r12b,(%rdi,%r8,1)
        jge      .changeBIG
        # add one to the counter
        incq     %r8 # counter++
        jmp     .LOOP3
    
    .changeBIG:
        # condition 2 to a big letter    
        movq    $90,%r12
        cmpb    %r12b,(%rdi,%r8,1)
        ja      .LOOP3
        # change to little letter
        movq    $32,%r12
        addb    %r12b, (%rdi,%r8,1) # big letter -> little letter
        incq     %r8 # counter++
        jmp     .LOOP3

    .changeLITTLE:
        # condition 2 to a little letter    
        movq    $122,%r12
        cmpb    %r12b,(%rdi,%r8,1)
        ja      .LOOP3
        # change to big letter
        movq    $-32,%r12
        addb    %r12b,(%rdi,%r8,1) # little letter -> big letter
        incq     %r8 # counter++
        jmp     .LOOP3

    .endloop3:
        # empty the stack, and return a pointer to the string.
        movq    %rbp, %rax # pass pstr string
        popq    %rbp # free the stack     
        ret
        
.globl	pstrijcmp	# the label "pstrijcmp" is used to state the initial point of this program
	.type	pstrijcmp, @function	# the label "pstrijcmp" representing the beginning of a function
pstrijcmp:
# this function compare between two strings , and return a value  that shows which string is bigger
    # save the lenght of the strings, and set counter
    start3:
        movq    $0,%r8 # r8-> creat counter to 0 
        movzb    (%rdi),%r9 # r9-> length.dst
        movzb    (%rsi),%r10 # r10-> length.src
        movzb    %dl, %rdx
        movzb    %cl, %rcx
        jmp .check2
    # check if all the input is correct    
    .check2:
        cmpq    %r9,%r8 # if length.dst=0
        je      .endM2
        cmpq    %r10,%r8 # if length.src=0
        je      .endM2
        cmpb    %dl, %cl  # if j>i
        jb      .endM2
        cmpb    %r9b,%dl # if length.dst>i
        jge      .endM2
        cmpb    %r9b,%cl # if length.dst>j
        jge      .endM2
        cmpb    %r10b,%dl # if lenght.src>i
        jge      .endM2
        cmpb    %r10b,%cl # if lenght.src>j
        jge      .endM2
        movq    %rdx, %r8 # counter = i
        # add 1 to the indexes because the first index is the length
        incq    %r8
        incq    %rcx
        jmp     .LOOP4
        

    .LOOP4:
        # check if we got to the index j - the last index we need to change
        cmpq    %r8, %rcx # if j - counter
        jb      .end0
        # pass the char in src string and dst string to different registers
        movb    (%rdi,%r8,1), %r11b # r11b = sdt[counter] = str1
        movb    (%rsi,%r8,1),%r12b # r12b = src[counter] = str2
        # add 1 to the counter
        incq     %r8 # counter++
        # compare       
        cmpb    %r11b,%r12b # if str1[x] = str2[x] 
        je      .LOOP4
        cmpb    %r11b,%r12b # if str1[x] < str2[x] 
        ja       .endM1
        cmpb    %r12b,%r11b # if str1[x] > str2[x] 
        ja       .end1
    # when the first string is bigger
    .end1:
        movq    $1, %rax # pass dst string
        ret
    # when the strings are equals.
    .end0:
        movq    $0, %rax # pass dst string
        ret
    # when the second string is bigger
    .endM1:
        movq    $-1, %rax # pass dst string
        ret
    # when there was a problam in the input, we print invalid input
    .endM2:
        movq    $format_invalid,%rdi
        movq    $0, %rax
        call    printf
        movq    $-2, %rax # pass dst string
        ret




    


        

    
        

        
