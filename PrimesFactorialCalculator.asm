.data
	welcomeMessage: .asciiz "Welcome to the MIPS calculator\n"
	newLine: .asciiz "\n"
	promptUserSelection: .asciiz "\nSelect an option:\n[1]isPrime?\t[2]Factorial\t[3]Exit\n"
	messageIsPrime: .asciiz "-------\nisPrime?\n-------\n"
	messageFactorial: .asciiz "-------\nFactorial\n-------\n"
	messageExit: .asciiz "Exit.\n"
	promptUserIntegerInput: .asciiz "Please enter an integer: "
	answerMessageIsPrime: .asciiz " is a prime number."
	answerMessageNotIsPrime: .asciiz " is NOT a prime number."
	answerMessageFactorial: .asciiz "Factorial of "
	answerMessageIs: .asciiz " is "
.text
	# Initialise menu option in $s4, $s5, $s6
	addi $s4, $zero, 1
	addi $s5, $zero, 2
	addi $s6, $zero, 3
	li $v0, 4
	la $a0, welcomeMessage
	syscall
	
main:
	# Ask for calculation type
	li $v0, 4
	la $a0, promptUserSelection
	syscall
	
	# User input selection
	li $v0, 5
	syscall
	
	# move selection into register $s0
	move $s0, $v0
	
	beq $s0, $s4, IsPrimeSelected
	beq $s0, $s5, FactorialSelected
	beq $s0, $s6, ExitSelected
	
	j main

IsPrimeSelected:
	jal IsPrimeProgram
	j main
FactorialSelected:
	jal FactorialProgram
	j main
ExitSelected:
	jal Exit

IsPrimeProgram:
	li $v0, 4
	la $a0, messageIsPrime
	syscall
	li $v0, 4
	la $a0, promptUserIntegerInput
	syscall
	# User input selection
	li $v0, 5
	syscall
	
	# Initialise convention cases for values 0, 1, and 2:
	addi $t5, $zero, 0
	addi $t6, $zero, 1
	addi $t7, $zero, 2
	
	move $t0, $v0 # move the user input into register $t0
	addi $t1, $t0, -1 # Initialise the divisor as 1 less than the user input
	addi $t2, $t0, 0 # Temporarily store original user input in $t2 for referencing
	
	# Check convention cases if user inputs 0, 1 or 2
	beq $t0, $t5, falseIsPrime
	beq $t0, $t6, falseIsPrime
	beq $t0, $t7, trueIsPrime
	
	isPrimeLoop:
		div $t0, $t1
		mfhi $t3
		beqz $t3, falseIsPrime
		sub $t1, $t1, 1
		bgt $t1, $t6, isPrimeLoop
		j trueIsPrime

	falseIsPrime:
		# print false result of IsPrime?
		li $v0, 1
		move $a0, $t2
		syscall
		li $v0, 4
		la $a0, answerMessageNotIsPrime
		syscall
		li $v0, 4
		la $a0, newLine
		syscall
		j endIsPrime
	
	trueIsPrime:
		# print false result of IsPrime?
		li $v0, 1
		move $a0, $t2
		syscall
		li $v0, 4
		la $a0, answerMessageIsPrime
		syscall
		li $v0, 4
		la $a0, newLine
		syscall
		j endIsPrime

	endIsPrime:
		jr $ra
	
FactorialProgram:
	li $v0, 4
	la $a0, messageFactorial
	syscall
	li $v0, 4
	la $a0, promptUserIntegerInput
	syscall
	
	# User input selection
	li $v0, 5
	syscall
	
	move $t0, $v0 # move the user input into register $t0
	addi $t2, $t0, 0 # Temporarily store original user input in $t2 for referencing
	
	# Initialise the result in $t1 with value 1 - this will catch the 0! case
	addi $t1, $zero, 1
	factorialLoop:
		beqz $t0, terminateFactorialLoop
		mul $t1, $t1, $t0
		sub $t0, $t0, 1
		bgtz $t0, factorialLoop
		
	terminateFactorialLoop:
	# Now print result of factorial:
	li $v0, 4
	la $a0, answerMessageFactorial
	syscall
	li $v0, 1
	move $a0, $t2
	syscall
	li $v0, 4
	la $a0, answerMessageIs
	syscall
	li $v0, 1
	move $a0, $t1
	syscall
	li $v0, 4
	la $a0, newLine
	syscall

	jr $ra
		
Exit:
	li $v0, 4
	la $a0, messageExit
	syscall
		
	li $v0, 10
	syscall
