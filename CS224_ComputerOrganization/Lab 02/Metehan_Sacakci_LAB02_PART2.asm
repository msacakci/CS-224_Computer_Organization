# Part 2 #

# Metehan Sacakci - 21802788

.data	
	welcomeMessage: .asciiz "Welcome to the Lab 02 - Part 2!\n\n"
	requestDecimalNumber: .asciiz "Please type a decimal number and then press enter:\n\n"
	enteredDecimalAsHexadecimal: .asciiz "\nEntered value as hexadecimal is "
	printResultMessage: .asciiz "Reversed bit version of the given number in hexadecimal form is "
	
	newLine: .asciiz "\n"

.text
	main:	
		# Print welcome message
		li $v0, 4
		la $a0, welcomeMessage
		syscall
	
		# Reguest decimal number
		li $v0, 4
		la $a0, requestDecimalNumber
		syscall
	
		# Get decimal number
		li $v0, 5
		syscall
		
		move $s0, $v0
		
		li $v0, 4
		la $a0, enteredDecimalAsHexadecimal
		syscall
		
		li $v0, 34
		move $a0, $s0
		syscall
		
		li $v0, 4
		la $a0, newLine
		syscall
	
		# Put user's value to $a0 as parameter
		move $a0, $s0
	
		jal ReverseBitsOfANumber
		j final
	
	ReverseBitsOfANumber:
	
		# $s0 = index
		# $s1 = reversed
		# $s2 = givenValue
	
		# Save $s0 on stack
		addi $sp, $sp, -4
		sw $s0, 0($sp)
	
		add $s0, $zero, $zero # index = 0
	
		# Save $s1 on stack
		addi $sp, $sp, -4
		sw $s1, 0($sp)
	
		add $s1, $zero, $zero # reversed = 0
	
		# Save $s2 on stack
		addi $sp, $sp, -4
		sw $s2, 0($sp)
	
		add $s2, $zero, $a0 # givenValue = $a0
	
		# Save $s3 on stack
		addi $sp, $sp, -4
		sw $s3, 0($sp)
	
		add $s3, $zero, $zero # $s3 = 0
	
		# Save $s4 on stack
		addi $sp, $sp, -4
		sw $s4, 0($sp)
	
		add $s4, $zero, $zero # $s4 = 0
	
		for:
			beq $s0, 32, forEnd # index == 32
		
			srlv $s3, $s2, $s0 # $s3 = (givenValue >> index)
			and $s3, $s3, 1 # $s3 = ((givenValue >> index) & 1)
		
			addi $s4, $zero, 31 # $s4 = (32 - 1)
			sub $s4, $s4, $s0 # $s4 = (32 - index - 1)
		
			sllv $s3, $s3, $s4 # $s3 = ((givenValue >> index) & 1) << (32 - index - 1)
		
			or $s1, $s1, $s3 # reserved = reserved | ((givenValue >> index) & 1) << (32 - index - 1)
		
			addi $s0, $s0, 1 # index = index + 1
			j for
	
		forEnd:
			# Printing result
			li $v0, 4
			la $a0, printResultMessage
			syscall
		
			li $v0, 34
			move $a0, $s1
			syscall
		
			add $v0, $zero, $s1 # $v0 = reversed
		
			# Restore $s4 from stack
			lw $s4, 0($sp)
			addi $sp, $sp, 4
			
			# Restore $s3 from stack
			lw $s3, 0($sp)
			addi $sp, $sp, 4
			
			# Restore $s2 from stack
			lw $s2, 0($sp)
			addi $sp, $sp, 4
			
			# Restore $s1 from stack
			lw $s1, 0($sp)
			addi $sp, $sp, 4
		
			# Restore $s0 from stack
			lw $s0, 0($sp)
			addi $sp, $sp, 4
		
			jr $ra	
				
	
	final:
	
# End of Part 2 #