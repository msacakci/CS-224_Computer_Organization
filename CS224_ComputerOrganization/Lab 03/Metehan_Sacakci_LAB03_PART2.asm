# PART 2 #

# Metehan Sacakci - 21802788

.data
	welcomeMessage: .asciiz "Welcome to the Lab 3 - Part 2\n"
	requestNumbers: .asciiz "\n\nPlease enter two numbers one by one and consider that first number will be dividend and second number will be divisor:\nHowever, if you would like to quit please press enter -1.\n"
	quotientMessage: .asciiz "Quotient: "
	remainderMessage: .asciiz "Remainder: "
	
	zeroDivisorMessage: .asciiz "\nWarning: You are entered divisor as zero which is not correct input!\n"
	
	newLine: .asciiz "\n"
	

.text
	initial:
		# Print welcome message
		li $v0, 4
		la $a0, welcomeMessage
		syscall

	main:
		# For main,
		# $s0 register carries the dividend
		# $s1 register carries the divisor
		# $s2 register carries the quotient
		# $s3 register carries the remainder
		
		# Request the numbers
		li $v0, 4
		la $a0, requestNumbers
		syscall
		
		# Get dividend
		li $v0, 5
		syscall
		
		# Quit checker
		beq $v0, -1, final
		
		move $s0, $v0
		
		# Get divisor
		li $v0, 5
		syscall
		
		move $s1, $v0
		
		# Setting parameters		
		add $a0, $zero, $s0
		add $a1, $zero, $s1
		
		jal recursiveDivision
		
		add $s2, $zero, $v0
		add $s3, $zero, $v1
		
		# Printing quotient
		li $v0, 4
		la $a0, quotientMessage
		syscall
		
		li $v0, 1
		add $a0, $zero, $s2
		syscall
		
		# Skip to next line
		li $v0, 4
		la $a0, newLine
		syscall
		
		# Printing remainder
		li $v0, 4
		la $a0, remainderMessage
		syscall
		
		li $v0, 1
		add $a0, $zero, $s3
		syscall		
		
		j main
		
	recursiveDivision:
		# make room on stack for $a0, $a1, $s0, $s1, $s2, $s3, $ra and store them.
		addi $sp, $sp, -28
		sw $a0, 24($sp)
		sw $a1, 20($sp)
		sw $s0, 16($sp)
		sw $s1, 12($sp)
		sw $s2, 8($sp)
		sw $s3, 4($sp)
		sw $ra, 0($sp)
		
		# Base case
		# if( ($a0 - $a1 <= 0))
		sub $s2, $a0, $a1
		
		beq $a1, $zero, BaseCase1
		j elseIf1
		
		BaseCase1:
			# Warning Message
			li $v0, 4
			la $a0, zeroDivisorMessage
			syscall
		
			#return 0
			add $v0, $zero, $zero
			add $v1, $zero, $zero		
						
			# Restore $a0, $a1, $s0, $s1, $s2, $s3, $ra
			lw $ra, 0($sp)
			lw $s3, 4($sp)
			lw $s2, 8($sp)
			lw $s1, 12($sp)
			lw $s0, 16($sp)
			lw $a1, 20($sp)
			lw $a0, 24($sp)
			addi $sp, $sp, 28
			
			jr $ra
			
		elseIf1:
			blt $a0, $a1, BaseCase2
			j elseIf2
			
		BaseCase2:
			#return 0
			add $v0, $zero, $zero
			add $v1, $zero, $a0
			
			# Restore $a0, $a1, $s0, $s1, $s2, $s3, $ra
			lw $ra, 0($sp)
			lw $s3, 4($sp)
			lw $s2, 8($sp)
			lw $s1, 12($sp)
			lw $s0, 16($sp)
			lw $a1, 20($sp)
			lw $a0, 24($sp)
			addi $sp, $sp, 28
			
			jr $ra
			
		elseIf2:
			beq $a1, 1, BaseCase3
			j elseIf3
		
		BaseCase3:
			#return 0
			add $v0, $zero, $a0
			add $v1, $zero, $zero
			
			# Restore $a0, $a1, $s0, $s1, $s2, $s3, $ra
			lw $ra, 0($sp)
			lw $s3, 4($sp)
			lw $s2, 8($sp)
			lw $s1, 12($sp)
			lw $s0, 16($sp)
			lw $a1, 20($sp)
			lw $a0, 24($sp)
			addi $sp, $sp, 28
			
			jr $ra
		
		elseIf3:		
			ble $s2, $zero, BaseCase4
			j else
			
		BaseCase4:
			# return 1
			addi $v0, $zero, 1	
				
			sub $v1, $a0, $a1
			
			# Restore $a0, $a1, $s0, $s1, $s2, $s3, $ra
			lw $ra, 0($sp)
			lw $s3, 4($sp)
			lw $s2, 8($sp)
			lw $s1, 12($sp)
			lw $s0, 16($sp)
			lw $a1, 20($sp)
			lw $a0, 24($sp)
			addi $sp, $sp, 28
			
			jr $ra
			
		# Else
		else:
			# Recursive call			
			sub $a0, $a0, $a1
			
			# recursiveDivision( $a0 - $a1, $a1)
			jal recursiveDivision
			 
			# Restore $a0, $a1, $s0, $s1, $s2, $s3, $ra
			lw $ra, 0($sp)
			lw $s3, 4($sp)
			lw $s2, 8($sp)
			lw $s1, 12($sp)
			lw $s0, 16($sp)
			lw $a1, 20($sp)
			lw $a0, 24($sp)
			
			addi $sp, $sp, 28
			
			addi $v0, $v0, 1
			
			jr $ra
			
		
	
	final:
		li $v0, 10
		syscall
	

# End of PART 2 #
