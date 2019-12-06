	.text
	.align  2
	.global main
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
	sub v6, v6, #'0'		@ char to integer
	mov v2, #2			@ i=2
	mov v3, #0			@ fib[0] = 0
	mov v4, #1			@ fib[1] = 1
	add v6, v6, #1
LOOP:
	cmp v2, v6			@ if i == $(length)
	beq ENDLOOP
	add v5, v3, v4		@ fib[i] (v5) = fib[i-2] (v3) + fib[i-1] (v4)
	mov v3, v4
	mov v4, v5
	add v2, v2, #1		@ i++
	ldr r0, =string
	mov r1, v5			@ fib[i]
	bl printf
	b LOOP
FAIL:
	ldr r0, =string2	@ "Length of sequence %c%c is not valid."
	ldrb r1,[v1, #10]	@ argv[10]
	ldrb r2,[v1, #11]	@ argv[11]
	bl printf
	sub	sp, fp, #4
	ldmfd sp!, {r0, r1, r2, r3, fp, lr}
	bx lr
ENDLOOP:
	ldr r0, =string3
	bl printf
	sub	sp, fp, #4
	ldmfd sp!, {r0, r1, r2, r3, fp, lr}
	bx lr
string:
	.asciz	",%d"
string1:
	.asciz  "The Fibonacci sequence of length %c is 0"
string2:
	.asciz	"Length of sequence %c%c is not valid."
string3:
	.asciz	".\n"
.end
@ arm-none-eabi-gcc a.s -T generic-hosted.ld
@ arm-none-eabi-run a.out "fibonacci 7"
