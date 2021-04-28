# Part 3 #

# Metehan Sacakci - 21802788

.data
	array: .word 101, 56, 10, 56, 101
	arraySize: .word 5
	
	welcomeMessage: .asciiz "Welcome to the Lab 02 - Part 3!\n\n"
	possibleOperations: .asciiz "\nPlease select one of the operation that are given below with entering one of their numbers:\n1 - Print the array\n2 - Check Symmetric\n3 - Find minimum and maximum value\n4 - Dynamic Array Allocation\n5 - Print the dynamic array\n6 - Check Symmetric for Dynamic Array\n7 - Find minimum and maximum of Dynamic Array\n8 - Quit\n\n"
	
	arrayElementsMessage: .asciiz "\nMemory Address  Array Element\nPosition (hex)  Value (int)\n=============   ===========\n"
	
	empty: .asciiz "           "
	empty2: .asciiz "\n"
	
	positiveSymmetry: .asciiz "\nThe array is symmetric\n" 
	negativeSymmetry: .asciiz "\nThe array is not symmetric\n" 
	
	maxMessage: .asciiz "\nMax: "
	minMessage: .asciiz "\nMin: "
	
	requestArraySize: .asciiz "\nPlease enter the size of the dynamic array:\n"
	requestArrayElements: .asciiz "\nEnter the elements one by one until you see the message, OK:\n"
	okMessage: .asciiz "\nOK!\n"
	
	emptyArrayMessage: .asciiz "\nWarning: At this point, consider that there is not a defined array with its size bigger than 0!\n"
.text
	initialStage:
		li $v0, 4
		la $a0, welcomeMessage
		syscall
	
	main:
		#For main,
		# $s0 register contains the results of the subprogram "CheckSymmetric"
		# $s1 and $s2 registers contain the results of the subprogram "FindMinMax" as Min value, Max value respectively
		# $s3 register contains the base address of the dynamic array
		# $s4 register contains the size of the dynamic array
		# $s5 register contains the results of the subprogram "CheckSymmetric" for dynamic array
		# $s6 and $s7 registers contain the results of the subprogram "FindMinMax" as Min value, Max value respectively for dynamic array
	
		# Print possible operations
		li $v0, 4
		la $a0, possibleOperations
		syscall
		
		# Get wanted operation from the user
		li $v0, 5
		syscall
		
		# if (Answer == 1)
		# go to the PrintArray
		beq $v0, 1, callPrintArray
		
		# if (Answer == 2)
		# go to the CheckSymmetric
		beq $v0, 2, callCheckSymmetric
		
		# if (Answer == 3)
		# go to the FindMinMax
		beq $v0, 3, callFindMinMax
		
		# if (Answer == 4)
		# go to the getArray
		beq $v0, 4, callGetArray 
		
		# if (Answer == 5)
		# go to the PrintArray as dynamic array
		beq $v0, 5, callPrintArrayDynamic 
		
		# if (Answer == 6)
		# go to the CheckSymmetric as dynamic array
		beq $v0, 6, callCheckSymmetricDynamic
		
		# if (Answer == 7)
		# go to the FindMinMax as dynamic array
		beq $v0, 7, callFindMinMaxDynamic
		
		j final
		
	callPrintArray:	
		# Setting parameters
		la $a0, array
		lw $a1, arraySize
		
		beq $a1, 0, emptyArray		
		
		jal PrintArray
		
		j main
		
	callPrintArrayDynamic:
		# Setting parameters
		add $a0, $zero, $s3
		add $a1, $zero, $s4

		beq $a1, 0, emptyArray				
		
		jal PrintArray
		
		j main
							
	PrintArray:
		# $s0 -> currentAddress
		# $s1 -> array[currentAddress]
		# $s2 -> index
		# $s3 -> arraySize
		
		# Saving $s0 to stack
		addi $sp, $sp, -4
		sw $s0, 0($sp)
				
		add $s0, $a0, $zero # currentAddress = baseAddress
		
		# Saving $s1 to stack
		addi $sp, $sp, -4
		sw $s1, 0($sp)
		
		lw $s1, ($s0) # $s1 = array[currentAddress]
		
		# Saving $s3 to stack
		addi $sp, $sp, -4
		sw $s3, 0($sp)
		
		add $s3, $a1, $zero # size = size (from parameter)
		
		# Saving $s2 to stack
		addi $sp, $sp, -4
		sw $s2, 0($sp)
		
		add $s2, $zero, $zero # index = 0
		
		#Print the headings
		li $v0, 4
		la $a0, arrayElementsMessage
		syscall
		
		for:
			beq $s2, $s3, PrintArrayEnd
		
			#Print the Element's address
			li $v0, 34
			move $a0, $s0
			syscall
		
			#Print space
			li $v0, 4
			la $a0, empty
			syscall
		
			#Print the Element's value
			li $v0, 1
			move $a0, $s1
			syscall
		
			#Skip to next line
			li $v0, 4
			la $a0, empty2
			syscall
		
			addi $s2, $s2, 1 # index = index + 1
			addi $s0, $s0, 4 # address = address + 4
			lw $s1, ($s0) # $s1 = array[currentAddress]
			j for
	
		PrintArrayEnd:
			
			# Restore $s2 from stack
			lw $s2, 0($sp)
			addi $sp, $sp, 4
			
			# Restore $s3 from stack
			lw $s3, 0($sp)
			addi $sp, $sp, 4
			
			# Restore $s1 from stack
			lw $s1, 0($sp)
			addi $sp, $sp, 4
			
			# Restore $s0 from stack
			lw $s0, 0($sp)
			addi $sp, $sp, 4
		
			jr $ra	
	
	callCheckSymmetric:
		# Setting parameters
		la $a0, array
		lw $a1, arraySize
		
		beq $a1, 0, emptyArray
				
		jal CheckSymmetric
		
		# $s0 carries to return value of CheckSymmetric
		add $s0, $v0, $zero
		
		j main
	
	callCheckSymmetricDynamic:
		# Setting parameters
		add $a0, $s3, $zero
		add $a1, $s4, $zero

		beq $a1, 0, emptyArray				
		
		jal CheckSymmetric
		
		# $s5 carries to return value of CheckSymmetric
		add $s5, $v0, $zero
		

		
		j main		
	
	CheckSymmetric:
		# int result; -> $s0 = result
		# int i; -> $s1 = i
		# int size -> $s2 = size
		# int $s3 = size - 1 - i
		# int firstElement -> $s4 = firstElementAddress
		# int second element -> $s5 = secondElementAddress
		
		# Saving $s0 to stack
		addi $sp, $sp, -4
		sw $s0, 0($sp)
		
		addi $s0, $zero, 1 # result = 1
		
		# Saving $s1 to stack
		addi $sp, $sp, -4
		sw $s1, 0($sp)
		
		addi $s1, $zero, 0 # i = 0
		
		# Saving $s2 to stack
		addi $sp, $sp, -4
		sw $s2, 0($sp)
		
		move $s2, $a1 # size = arrsize
		
		# Saving $s4 to stack
		addi $sp, $sp, -4
		sw $s4, 0($sp)
	
		move $s4, $a0 # array base address = $s4
	
		# Saving $s5 to stack
		addi $sp, $sp, -4
		sw $s5, 0($sp)
	
		move $s5, $a0 # array end base address = $s5
	
		# Saving $s3 to stack
		addi $sp, $sp, -4
		sw $s3, 0($sp)
	
		sub $s3, $s2, $s1 # s3 = size - i
		sub $s3, $s3, 1 # s3 = size - i - 1
		sll $s3, $s3, 2 # s3 = 4*(size -i - 1)
	
		add $s5, $s5, $s3
		
		# Saving $s6 to stack
		addi $sp, $sp, -4
		sw $s6, 0($sp)
		
		# Saving $s7 to stack
		addi $sp, $sp, -4
		sw $s7, 0($sp)
		
		for2:
	  		beq $s1, $s2, CheckSymmetricEnd  # i == size brench to done
	  
	  		lw $s6, 0($s4) # $s6 = array[i]
	  		lw $s7, 0($s5) # $s7 = array[size - i - 1]
	  
	  		bne $s6, $s7, if
	  		j for2Cont
	  		if:
	    			add $s0, $zero, $zero # result = 0
	    			j for2Cont
	
		for2Cont:  	 	 	   	 	 	 
	  		addi $s4, $s4, 4 # array + 4	  
	  		addi $s5, $s5, -4 # arrayEnd - 4 
	  		addi $s1, $s1, 1 # i = i + 1
	  		j for2
	  		
	CheckSymmetricEnd:		
		# Restore $s7 from stack
		lw $s7, 0($sp)
		addi $sp, $sp, 4
		
		# Restore $s6 from stack
		lw $s6, 0($sp)
		addi $sp, $sp, 4
		
		# Restore $s3 from stack
		lw $s3, 0($sp)
		addi $sp, $sp, 4
		
		# Restore $s5 from stack
		lw $s5, 0($sp)
		addi $sp, $sp, 4
		
		# Restore $s4 from stack
		lw $s4, 0($sp)
		addi $sp, $sp, 4
		
		# Restore $s2 from stack
		lw $s2, 0($sp)
		addi $sp, $sp, 4
		
		# Restore $s1 from stack
		lw $s1, 0($sp)
		addi $sp, $sp, 4		
	
		bne $s0, $zero, positiveResult
	  
	  	j negativeResult
	  	positiveResult:
	  		# Restore $s0 from stack
			lw $s0, 0($sp)
			addi $sp, $sp, 4
	  	
	    		la $a0, positiveSymmetry
	    		li $v0, 4
	    		syscall
	    		
	    		addi $v0, $zero, 1
	   		jr $ra
	    
	  	beq $s0, $zero, negativeResult
	  	  
	  	negativeResult:
	  		# Restore $s0 from stack
			lw $s0, 0($sp)
			addi $sp, $sp, 4
		
	    		la $a0, negativeSymmetry
	   		li $v0, 4
	    		syscall
	    		
	    		add $v0, $zero, $zero
	    		jr $ra	
	callFindMinMax:	
		# Setting parameters
		la $a0, array
		lw $a1, arraySize

		beq $a1, 0, emptyArray
				
		jal FindMinMax
		
		# Saving the results on $s1 and $s2 register as min value, max value, respectively
		add $s1, $v0, $zero
		add $s2, $v1, $zero
		
		j main
		
	callFindMinMaxDynamic:
		# Setting parameters
		move $a0, $s3
		move $a1, $s4

		beq $a1, 0, emptyArray
						
		jal FindMinMax
		
		# Saving the results on $s1 and $s2 register as min value, max value, respectively
		add $s6, $v0, $zero
		add $s7, $v1, $zero
		
		j main
	
	FindMinMax:		
		# $s0 -> currentAddress
		# $s1 -> array[currentAddress]
		# $s2 -> index
		# $s3 -> arraySize
		# $s4 -> bool result
		# $v0, $s5 -> min value
		# $v1, $s6 -> max value
		
		# Saving $s0 to stack
		addi $sp, $sp, -4
		sw $s0, 0($sp)
				
		add $s0, $a0, $zero # currentAddress = baseAddress
		
		# Saving $s1 to stack
		addi $sp, $sp, -4
		sw $s1, 0($sp)
		
		lw $s1, ($s0) # $s1 = array[currentAddress]
		
		# Saving $s3 to stack
		addi $sp, $sp, -4
		sw $s3, 0($sp)
		
		add $s3, $a1, $zero # size = size (from parameter)
		
		# Saving $s2 to stack
		addi $sp, $sp, -4
		sw $s2, 0($sp)
		
		add $s2, $zero, $zero # index = 0
		
		# Saving $s4 to stack
		addi $sp, $sp, -4
		sw $s4, 0($sp)
		
		# Saving $s5 to stack
		addi $sp, $sp, -4
		sw $s5, 0($sp)
		
		lw $s5, ($s0)
		
		# Saving $s6 to stack
		addi $sp, $sp, -4
		sw $s6, 0($sp)
		
		lw $s6, ($s0)
		
		for3:
			beq $s2, $s3, FindMinMaxEnd
		
			# Check max
	  		slt $s4, $s6, $s1
	  		bne $s4, $zero, updateMax 
	  		j for3cont
	  	
	  		updateMax:
	  			add $s6, $zero, $s1
	  			j for3cont
		
		for3cont:
			# Check min
	  		slt $s4, $s1, $s5
	  		bne $s4, $zero, updateMin
			j for3cont2
			updateMin:
				add $s5, $zero, $s1
				j for3cont2
		
		for3cont2:				
			addi $s2, $s2, 1 # index = index + 1
			addi $s0, $s0, 4 # address = address + 4
			lw $s1, ($s0) # $s1 = array[currentAddress]
			j for3
			
	FindMinMaxEnd:
		# Printing min value
		li $v0, 4
		la $a0, minMessage
		syscall
		
		li $v0, 1
		move $a0, $s5
		syscall
		
		# Printing max value
		li $v0, 4
		la $a0, maxMessage
		syscall
		
		li $v0, 1
		move $a0, $s6
		syscall
		
		# Returned values: $v0 = minValue, $v1 = maxValue
		move $v0, $s5
		move $v1, $s6
		
		# Restore $s6 from stack
		lw $s6, 0($sp)
		addi $sp, $sp, 4
			
		# Restore $s5 from stack
		lw $s5, 0($sp)
		addi $sp, $sp, 4
			
		# Restore $s4 from stack
		lw $s4, 0($sp)
		addi $sp, $sp, 4
			
		# Restore $s2 from stack
		lw $s2, 0($sp)
		addi $sp, $sp, 4
		
		# Restore $s3 from stack
		lw $s3, 0($sp)
		addi $sp, $sp, 4
		
		# Restore $s1 from stack
		lw $s1, 0($sp)
		addi $sp, $sp, 4
		
		# Restore $s0 from stack
		lw $s0, 0($sp)
		addi $sp, $sp, 4
			
		jr $ra		
		
	callGetArray:
		jal getArray
		
		j main
	getArray:
		# Request the size of the dynamic array from user
		li $v0, 4
		la $a0, requestArraySize
		syscall
		
		# Get requested size of the dynamic array
		li $v0, 5
		syscall
		
		# Store $s0 on stack
		addi $sp, $sp, -4
		sw $s0, 0($sp)
		
		# $s0 = dynamicArraySize
		move $s0, $v0
		
		# Size allocation on the heap. Note: Size must be multiplied with 4.
		li $v0, 9		
		sll $a0, $s0, 2
		syscall
		
		# Store $s1 on stack
		addi $sp, $sp, -4
		sw $s1, 0($sp)
		
		# $s1 = dynamic array base address
		move $s1, $v0
		
		#Ask user to enter elements of the dynamic array
		li $v0, 4
		la $a0, requestArrayElements
		syscall
		
		# Store $s2 on stack
		addi $sp, $sp, -4
		sw $s2, 0($sp)
		
		add $s2, $zero, $zero # $s2 = index, index = 0
		
		# Store $s3 on stack
		addi $sp, $sp, -4
		sw $s3, 0($sp)
		
		add $s3, $zero, $s1 # $s3 = current Address
		
		for4:
			beq $s2, $s0, for4Finished # (index != dynamicArraySize)
			
			# Get single element
			li $v0, 5
			syscall
			
			# Store element to the dynamic array
			sw $v0, 0($s3)
			
			addi $s2, $s2, 1 # index = index + 1
			addi $s3, $s3, 4 # current Address = current Address + 4
			j for4
		
		for4Finished:
			# Print "OK" message to show user to the all required elements are taken
			li $v0, 4
			la $a0, okMessage	
			syscall			
			
			# $v0 = beginning address of the dynamic array 
			add $v0, $s1, $zero
			
			# $v1 = the size of the dynamic array
			add $v1, $s0, $zero
			
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
			
			# Setting main saved registers
			add $s3, $zero, $v0
			add $s4, $zero, $v1
			
			# Another subProgram "PrintArray" will be used
			
			# Push return address of getArray to stack
			addi $sp, $sp, -4
			sw $ra, 0($sp)
			# Parameter setting
						
			move $a0, $v0
			move $a1, $v1
			jal PrintArray
			
			# Retrieve the return address of the getArray 
			lw $ra, 0($sp)
			addi $sp, $sp, 4
									
			jr $ra	
												
	emptyArray:
		# Print that there is no defined array
		li $v0, 4
		la $a0, emptyArrayMessage
		syscall
		j main														
																											
	final:
	
# End of Part 3 #	    																			    																			    																			    																			
