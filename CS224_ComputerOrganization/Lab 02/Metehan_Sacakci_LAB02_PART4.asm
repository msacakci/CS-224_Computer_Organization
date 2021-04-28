# Part 4 #
# Metehan Sacakci - 21802788

.data
	welcomeMessage: .asciiz "Welcome to the Lab 02 - Part 4!\n\n"
	requestSearchedPattern: .asciiz "Please enter be searched pattern as integer, bit size of the searched pattern as integer and total pattern as integer, respectively\n"
	
	searchedPattern: .asciiz "Searched pattern: "
	totalPattern: .asciiz "Total pattern: "
	numberOfOccurrenceMessage: .asciiz "Number of occurence: "
	
	nextline: .asciiz "\n"
.text
	main:
		#For main,
		# $s0 register contains the searched pattern,
		# $s1 register contains the total pattern,
		# $s2 register contains the size of the serached pattern
		# $s3 register contains the number of occurence
	
		# Print welcome message
		li $v0, 4
		la $a0, welcomeMessage
		syscall
		
		# Please enter be searched pattern as decimal
		li $v0, 4
		la $a0, requestSearchedPattern
		syscall
		
		# Get searched pattern
		li $v0, 5
		syscall
		
		move $s0, $v0
		
		# Get searched pattern size as bits
		li $v0, 5
		syscall
		
		move $s2, $v0
		
		# Get total pattern
		li $v0, 5
		syscall
		
		move $s1, $v0
		
		# Parameter setting
		add $a0, $s0, $zero
		add $a1, $s1, $zero
		add $a2, $s2, $zero
		
		jal NumberOfOccurrences
		
		move $s3, $v0
		
		# Print searched pattern		
		li $v0, 4
		la $a0, searchedPattern
		syscall
		
		li $v0, 34
		move $a0, $s0
		syscall
		
		# Print next line
		li $v0, 4
		la $a0, nextline
		syscall
		
		# Print total pattern		
		li $v0, 4
		la $a0, totalPattern
		syscall
		
		li $v0, 34
		move $a0, $s1
		syscall
		
		# Print next line
		li $v0, 4
		la $a0, nextline
		syscall
		
		# Print number of occurences		
		li $v0, 4
		la $a0, numberOfOccurrenceMessage
		syscall
		
		li $v0, 34
		move $a0, $s3
		syscall
		
		# Print next line
		li $v0, 4
		la $a0, nextline
		syscall
		
		j final
		
	NumberOfOccurrences:		
		# Store $s0 on stack
		addi $sp, $sp, -4
		sw $s0, 0($sp)
		
		# Creating mask
		addi $s0, $zero, 1
		
		# Store $s1 on stack
		addi $sp, $sp, -4
		sw $s1, 0($sp)
		
		add $s1, $zero, $zero # $s1 = counter, counter = 0
		
		# Store $s2 on stack
		addi $sp, $sp, -4
		sw $s2, 0($sp) 
		
		add $s2, $zero, $zero # $s2 = 0, $s2 = result
		
		# Store $s3 on stack
		addi $sp, $sp, -4
		sw $s3, 0($sp) 
		
		add $s3, $zero, $zero # andAfter
		
		for:
			beq $s1, $a2, forFinished
			
			sll $s0, $s0, 1
			
			addi $s1, $s1, 1
			j for
		
		forFinished:
			addi $s0, $s0, -1
		
		for2:
			beq $a1, 0, for2Finished
			
			and $s3, $a1, $s0
			
			beq $a0, $s3, if
			j else
			
			if:
				addi $s2, $s2, 1
				srlv $a1, $a1, $a2
				j for2Cont
			
			else:
				srl $a1, $a1, 4
				j for2Cont
		
		for2Cont:														
			j for2	
			
		for2Finished:
			add $v0, $zero, $s2
			
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
		
		
			
		
# End of Part 4 #
