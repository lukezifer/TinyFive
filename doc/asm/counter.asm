_start:
	xor a0, a0, a0
	xor a1, a1, a1
	addi a1, a1, 100

count:
	addi a0, a0, 1
	blt a0, a1, count

reset:
	xor a0, a0, a0
	beq a0, a0, count
