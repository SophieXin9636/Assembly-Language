	.text
	.align  2
	.global main
main:
	stmfd	sp!, {r0, r1, r2, r3, fp, lr}	@ store into memory
	add	fp, sp, #4
	ldr r4, [r1, #4]	@ get string

	ldr r0, =string1	@ print "reversed result:"
	bl printf
STRLEN:
	LDRB r2,[r4], #1
	CMP	r2, #0
	BNE	STRLEN
	SUB	r4,r4,#2
LOOP:
	ldrb r2, [r4], #-1
	cmp r2, #0			@ enpty char '\0'
	beq ENDLOOP
	cmp r2, #90		 	@ check whether the character is upper
	ble TOLOWER			@ transform into lower whether the character is in [65,90] (uppercase)
	b PRINT
TOLOWER:
	cmp r2, #64
	ble	PRINT
	add r2, r2, #32
PRINT:
	ldr r0, =string
	mov r1, r2
	bl printf
	b LOOP
ENDLOOP:
	ldr r0, =string
	mov r1, #10			@ print endline character
	bl printf
	sub	sp, fp, #4
	ldmfd sp!, {r0, r1, r2, r3, fp, lr}
	bx lr
string:
	.asciz	"%c"
string1:
	.asciz  "reversed result: "
	.end
@ arm-none-eabi-gcc a.s -T generic-hosted.ld
@ arm-none-eabi-run a.out
