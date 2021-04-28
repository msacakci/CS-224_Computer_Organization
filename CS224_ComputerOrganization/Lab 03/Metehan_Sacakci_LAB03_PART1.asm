# PART 1 #

# Metehan Sacakci - 21802788

.data
	welcomeMessage: .asciiz "-Welcome to the Lab 3 and Part1-\n\n"
	
	totalAddInstructions: .asciiz "Total \"add\" instruction(s): "
	totalLwInstructions: .asciiz "Total \"lw\" instruction(s): "
	totalInstructions: .asciiz "Total both \"add\" and \"lw\" instruction(s): "

	displayInstructionCounterforMain: .asciiz "\nThe results of the InstructionCounter subprogram for the main can be found below:\n\n"
	displayInstructionCounterforMainEnd: .asciiz "\nThe InstructionCounter subprogram for the main is ENDED."
	
	displayInstructionCounterforInstructionCounter: .asciiz "\nThe results of the InstructionCounter subprogram for the InstructionCounter can be found below:\n\n"
	displayInstructionCounterforInstructionCounterEnd: .asciiz "\nThe InstructionCounter subprogram for the InstructionCounter is ENDED."

	newLine: .asciiz "\n"
	line: .asciiz "----------------------------------------"
	
.text	
	initial:
		li $v0, 4
		la $a0, welcomeMessage
		syscall
		
	main:
		# For main,
		# $s0 carries the number of add instruction(s) which is/are counted on the InstructionCounter
		# $s1 carries the number of lw instruction(s) which is/are counted on the InstructionCounter
		# $s2 carries the number of both add lw instrucion(s) which is/are counted on the InstructionCounter.
		
		# Print displayInstructionCounterforMain
		li $v0, 4
		la $a0, displayInstructionCounterforMain
		syscall
		
		# Setting parameters to count the instruction in the main
		la $a0, main 
		la $a1, mainEnd
		
		jal InstructionCounter 
		
		add $s0, $zero, $v0
		add $s1, $zero, $v1
		add $s2, $s0, $s1
		
		# Print displayInstructionCounterforMainEnd
		li $v0, 4
		la $a0, displayInstructionCounterforMainEnd
		syscall
		
		# Twice New Line
		li $v0, 4
		la $a0, newLine
		syscall
		li $v0, 4
		la $a0, newLine
		syscall
		
		# Line
		li $v0, 4
		la $a0, line
		syscall
		
		# Twice New Line
		li $v0, 4
		la $a0, newLine
		syscall
		li $v0, 4
		la $a0, newLine
		syscall
		
		# Print displayInstructionCounterforInstructionCounter
		li $v0, 4
		la $a0, displayInstructionCounterforInstructionCounter
		syscall
		
		# Setting parameters to count the instruction in the InstructionCounter
		la $a0, InstructionCounter 
		la $a1, lastInstructionOfSubProgram
		
		jal InstructionCounter 
		
		add $s0, $zero, $v0
		add $s1, $zero, $v1
		add $s2, $s0, $s1
	
		# Print displayInstructionCounterforInstructionCounterEnd
		li $v0, 4
		la $a0, displayInstructionCounterforInstructionCounterEnd
		syscall
	
	
	mainEnd:	
		j final
	
	
	InstructionCounter:
		# Store $s0 on stack
		addi $sp, $sp, -4
		sw $s0, 0($sp)
	
		add $s0, $zero, $a0 # First address
		
		# Store $s1 on stack
		addi $sp, $sp, -4
		sw $s1, 0($sp)
	
		add $s1, $zero, $a1 # Last address
		
		# Store $s2 on stack
		addi $sp, $sp, -4
		sw $s2, 0($sp)
		
		# Store $s3 on stack
		addi $sp, $sp, -4
		sw $s3, 0($sp)
		
		add $s3, $zero, $zero # s3 add counter
		
		# Store $s4 on stack
		addi $sp, $sp, -4
		sw $s4, 0($sp)
		
		add $s4, $zero, $zero # s4 lw counter
		
		# Store $s6 on stack
		addi $sp, $sp, -4
		sw $s6, 0($sp)
		
		add $s6, $zero, $zero # $s6 function
		
		for:
			beq $s0, $s1, forEnd
			
			lw $s2, 0($s0)
			
			# Creating mask  # $s6 = 111111 (6 bits)
			addi $s6, $zero, 63
			
			# $s6 = function
			and $s6, $s2, $s6
			
			# Getting opcode
			srl $s2, $s2, 26		
					
			# if opcode == 000000 (0), to count add instruction
			beq $s2, 0, foundAdd
			
			j forCont
			foundAdd:
				# if function == 100000
				beq $s6, 32, increaseAddCounter
				j forCont
				increaseAddCounter:				
					addi $s3, $s3, 1
					j forCont
				j forCont	
				
		forCont:		
			
			# if opcode == 100011 (35), to count lw instruction
			beq $s2, 35, foundLw
			j forCont2
			
			foundLw:
				addi $s4, $s4, 1
				j forCont2
			
		forCont2:					
			addi $s0, $s0, 4
			j for
			
		forEnd:
			# Show total add instruction
			li $v0, 4
			la $a0, totalAddInstructions
			syscall
			
			li $v0, 1
			add $a0, $zero, $s3
			syscall
			
			# New Line
			li $v0, 4
			la $a0, newLine
			syscall
			
			# Show total lw instruction
			li $v0, 4
			la $a0, totalLwInstructions
			syscall
			
			li $v0, 1
			add $a0, $zero, $s4
			syscall
			
			# New Line
			li $v0, 4
			la $a0, newLine
			syscall
			
			# Total both add and lw instruction
			
			# Store $s5 on stack
			addi $sp, $sp, -4
			sw $s5, 0($sp)
			
			add $s5, $s4, $s3
			
			li $v0, 4
			la $a0, totalInstructions
			syscall
			
			li $v0, 1
			add $a0, $zero, $s5
			syscall
			
			# New Line
			li $v0, 4
			la $a0, newLine
			syscall
			
			# $v0 = total add instruction(s)
			add $v0, $zero, $s3
			
			# $v1 = total lw instruction(s)
			add $v1, $zero, $s4
			
			# Restore $s5 from stack
			lw $s5, 0($sp)
			addi $sp, $sp, 4
			
			# Restore $s6 from stack
			lw $s6, 0($sp)
			addi $sp, $sp, 4
			
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
	lastInstructionOfSubProgram:	
			jr $ra
	
			
	final:
		li $v0, 10
		syscall

# End of PART 1 #