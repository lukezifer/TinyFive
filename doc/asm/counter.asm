_start:
	xor ra, ra, ra
	xor sp, sp, sp
	addi sp, sp, 100

count:
	addi ra, ra, 1
	blt ra, sp, count

reset:
	xor ra, ra, ra
	beq ra, ra, count
