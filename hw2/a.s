	.text
	.align  2
	.global main
fibc: @ recursive call of fibonacci
	STR lr,[sp, #-4]!
	mov v5, a1
	cmp v5, #1			@ if (a1 <= 1)
	ldrle pc,[sp], #4	@ return a1

	@ calculate fib(a1)
	mov v5, a1
	sub a1, v5, #1
	bl fibc 		@ return a1	
	mov v1, a1

	@ calculate fib(n-2)
	sub a1, v5, #2
	bl fibc 		@ return a1
	mov v2, a1
	add a1, v1, v2 @ fib(n-1) + fib(n-2)

	@ print fib[i]
	@ldr r0, =string
	@mov r1, v5
	@bl printf
	ldr pc,[sp], #4	@ pc = r15

main:
	stmfd sp!, {r0, r1, r2, r3, fp, lr}	@ store into memory
	add	fp, sp, #4
	ldr v1, [r1, #4]	@ get string "fibonacci $int"

	ldrb r1,[v1, #10]	@ argv[10]
	cmp r1, #'-'		@ if argv[10] == '-' goto FAIL
	beq	FAIL
	ldr r0, =string1	@ print "The Fibonacci sequence of length ? is 0"
	bl printf

	ldrb v6,[v1, #10]	@ argv[10]
	sub v6, v6, #'0'	@ char to integer

	@ create array
	sub sp, sp, v6,LSL,#2 @ create size v6 array

	mov r0, v6
	bl fibc

	ldr r0, =string3
	bl printf
	sub	sp, fp, #4
	ldmfd sp!, {r0, r1, r2, r3, fp, lr}
	bx lr
FAIL:
	ldr r0, =string2	@ "Length of sequence %c%c is not valid."
	ldrb r1,[v1, #10]	@ argv[10]
	ldrb r2,[v1, #11]	@ argv[11]
	bl printf
	sub	sp, fp, #4
	ldmfd sp!, {r0, r1, r2, r3, fp, lr}
	bx lr
END:
	mov v1, #0			@ do nothing
strint:
	.asciz	"\n****%d***\n"
string:
	.asciz	",%d"
string1:
	.asciz  "The Fibonacci sequence of length %c is 0"
string2:
	.asciz	"Length of sequence %c%c is not valid."
string3:
	.asciz	".\n"
.end

@ https://stackoverflow.com/questions/42503417/arm-assembly-arrays
@ arm-none-eabi-gcc a1.s -T generic-hosted.ld
@ arm-none-eabi-run a.out "fibonacci 7"
