# Metehan Sacakci - 21802788
.data
	message1: .asciiz "Memory Address  Array Element\nPosition (hex)  Value (int)\n=============   ===========\n"
	message2: .asciiz "\nMax: "
	message3: .asciiz "\nMin: "
	message4: .asciiz "\nAverage: "
	empty: .asciiz "           "
	empty2: .asciiz "\n"
	array: .word 30, 82, 105, 2, 3, 3, 2, 9
	arraysize: .word 8
.text
	#Printing message 1
	li $v0, 4
	la $a0, message1
	syscall
	
	# t0 = array address
	# t1 = array size
	# t2 = index
	# s0 = maxValue
	# s1 = minValue
	# s2 = average
	# t4 = bool result 
	
	la $t0, array # $t0 = array base address
	
	lw $t3, ($t0) # $t3 = array[ address]
	lw $s0, ($t0) # maxValue = array[ address]
	lw $s1, ($t0) # minValue = array[ address]
	
	lw $t1, arraysize # $t1 = array size
	
	addi $t2, $zero, 0 # i = 0
	
	for:
	  beq $t2, $t1, arrayFinished
	  
	  # Check max
	  slt $t4, $s0, $t3
	  bne $t4, $zero, updateMax 
	  
	forCont:
	
	  # Check min
	  slt $t5, $t3, $s1
	  bne $t5, $zero, updateMin
	
	forCont2:
	
	  # Display element address
	  li $v0, 34                  
	  move $a0, $t0
	  syscall
	  
	  # Put space
	  li $v0, 4
	  la $a0, empty
	  syscall

	  # Display element's value
	  li $v0, 1
	  move $a0, $t3
	  syscall
	  
	  # Skip to next line
	  li $v0, 4
	  la $a0, empty2
	  syscall
	  
	  # To calculate average, sum of the all elements is needed
	  add $s2, $s2, $t3	                                                                                                                      
	  	                                                                                                                      	                                                                                                                      	                                                                                                                      
	  addi $t0, $t0, 4 # address = address + 4
	  lw $t3, ($t0)
	  addi $t2, $t2, 1 # i = i + 1
	  j for
	  
	updateMax:
	  add $s0, $zero, $t3
	  j forCont
	
	updateMin:
	  add $s1, $zero, $t3    
	  j forCont2
	  	  	    	  	  	  	    	  	  
	arrayFinished:
	
	  # s2 = average
	  div $s2, $t1
	  mflo $s2
	  
	  #Print average
	  li $v0, 4
	  la $a0, message4
	  syscall
	  
	  li $v0, 1
	  move $a0, $s2
	  syscall 
	  
	  # Print max element
	  li $v0, 4
	  la $a0, message2
	  syscall
	  
	  li $v0, 1
	  move $a0, $s0
	  syscall
	  
	  # Print min element
	  li $v0, 4
	  la $a0, message3
	  syscall
	  
	  li $v0, 1
	  move $a0, $s1
	  syscall
	            
