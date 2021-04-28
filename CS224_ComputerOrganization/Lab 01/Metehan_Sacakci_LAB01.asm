# Metehan Sacakci - 21802788
.data
	array: .word 1, 5, 5, 1, 4, 5, 1
	arrsize: .word 7
	
	positive: .asciiz "The above array is symmetric" 
	negative: .asciiz "The above array is not symmetric" 

# int result; -> $s0 = result
# int i; -> $s1 = i
# int size -> $s2 = size
# int $s3 = size - 1 - i
# int firstElement -> $t0 = firstElement
# int second element -> $t1 = secondElement

.text
	addi $s0, $zero, 1 # result = 1
	addi $s1, $zero, 0 # i = 0
	lw $s2, arrsize # size = arrsize
	
	la $t0, array # array base address = $t0
	
	la $t1, array # array end base address = $t1
	
	sub $s3, $s2, $s1 # s3 = size - i
	sub $s3, $s3, 1 # s3 = size - i - 1
	sll $s3, $s3, 2 # s3 = 4*(size -i - 1)
	
	add $t1, $t1, $s3
	
	#la $t1, array

	# for ( i = arrsize - 1)
	
	for:
	  beq $s1, $s2, done  # i == size brench to done
	  
	  lw $t2, ($t0) # $t2 = array[i]
	  lw $t3, ($t1) # $t3 = array[size - i - 1]
	  
	  bne $t2, $t3, if
	  j forCont
	  if:
	    add $s0, $zero, $zero # result = 0
	    j forCont
	
	forCont:  	 	 	   	 	 	 
	  addi $t0, $t0, 4 # array + 4	  
	  addi $t1, $t1, -4 # arrayEnd - 4 
	  addi $s1, $s1, 1 # i = i + 1
	  j for
	  
	done:
	  bne $s0, $zero, positiveResult
	  
	  j negativeResult
	  positiveResult:
	    la $a0, positive
	    li $v0, 4
	    syscall
	    j final
	    
	  beq $s0, $zero, negativeResult
	  	  
	  negativeResult:
	    la $a0, negative
	    li $v0, 4
	    syscall
	    j final
	    
	final:    
