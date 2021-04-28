# Metehan Sacakci - 21802788
.data
	prompt: .asciiz "Please enter A, B, C, D, respectively for following operation X = (A / B) + (C * D - A) % B \n"
	message: .asciiz "\nX is "

.text
	# Prompt to enter A B C D
	li $v0, 4	
	la $a0, prompt	
	syscall
	
	# Get the A
	li $v0, 5
	syscall
	
	# Store the A in $t0
	move $t0, $v0
	
	# Get the B
	li $v0, 5
	syscall
	
	# Store the B in $t1
	move $t1, $v0
	
	# Get the C
	li $v0, 5
	syscall
	
	# Store the C in $t2
	move $t2, $v0
	
	# Get the D
	li $v0, 5
	syscall
	
	# Store the D in $t2
	move $t3, $v0
	
	# $t4 = A / B
	div $t0, $t1
	mflo $t4
	
	# $t5 = C * D
	mult $t2, $t3
	mflo $t5
	
	# $t5 = C * D - A
	sub $t5, $t5, $t0
	
	# $t5 = (C * D - A) % B
	div $t5, $t1
	mfhi $t5

	# $t4 = (A / B) + (C * D - A) % B
	add $t4, $t4, $t5
			
	# Display message
	li $v0, 4
	la $a0, message
	syscall
	
	# Print x
	li $v0, 1
	move $a0, $t4
	syscall
