# Metehan Sacakci - 21802788
.data
	prompt: .asciiz "Please enter a, b, c, d, respectively for following operation x = a * (b - c) % d \n"
	message: .asciiz "\nx is "

.text
	# Prompt to enter a b c d
	li $v0, 4	
	la $a0, prompt	
	syscall
	
	# Get the a
	li $v0, 5
	syscall
	
	# Store the a in $t0
	move $t0, $v0
	
	# Get the b
	li $v0, 5
	syscall
	
	# Store the b in $t1
	move $t1, $v0
	
	# Get the c
	li $v0, 5
	syscall
	
	# Store the c in $t2
	move $t2, $v0
	
	# Get the d
	li $v0, 5
	syscall
	
	# Store the d in $t3
	move $t3, $v0
	
	# $t4 = b - c
	sub $t4, $t1, $t2
	
	# a * $t4
	mult $t0, $t4
	mfhi $t5
	mflo $t6
	
	# $t6 % d
	div $t6, $t3
	mfhi $t7 # result
	
	# Display message
	li $v0, 4
	la $a0, message
	syscall
	
	# Print x
	li $v0, 1
	move $a0, $t7
	syscall
