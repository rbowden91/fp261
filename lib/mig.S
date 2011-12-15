.text
.globl mig
mig:
    movl (%ebp), %ecx
    leal 4(%ebp), %eax
    push %ebp
    movl %esp, %ebp
    
    push %eax
    push %ecx
	pushal
    movl 8(%ebp), %edx
    movl $0, %eax

loop:
    movl (%esp,%eax,4), %ecx
    movl %ecx, (%edx, %eax, 4)
    add $1, %eax
    cmp $8, %eax
    jne loop
    
    popal
    pop %eax
    movl 0xc(%ebp), %edx
    movl %eax, (%edx)
    pop %eax
    movl 0x10(%ebp), %edx
    movl %eax, (%edx)
    
    movl %ebp, %esp
    popl %ebp
    ret
