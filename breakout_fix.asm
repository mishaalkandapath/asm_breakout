################ CSC258H1F Fall 2022 Assembly Final Project ##################
# This file contains our implementation of Breakout.
#
# Student 1: Mishaal Kandapath, 1007978137
######################## Bitmap Display Configuration ########################
# - Unit width in pixels:       TODO
# - Unit height in pixels:      TODO
# - Display width in pixels:    TODO
# - Display height in pixels:   TODO
# - Base Address for Display:   0x10008000 ($gp)
##############################################################################

    .data
##############################################################################
# Immutable Data
##############################################################################
# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL:
    .word 0x10008000
# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD:
    .word 0xffff0000
#store all the brick pixels
bricks: .space 1280

##############################################################################
# Mutable Data
##############################################################################

##############################################################################
# Code
##############################################################################
	.text
	.globl main

	# Run the Brick Breaker game.

main:
    # Initialize the game
    lw $t4, ADDR_DSPL #load in the address to the display
    la $t2, bricks #array of bricks
    
    li $t5, 0 # the first position to start writing in pixels
    
fill_background: #make the entire background black - resetting effectively.
    li $t1, 0x000000 #black
    beq $t5, 32768, re_init
    addu $t7, $t4, $t5 #offset display address by t5 and store the offset in t7
    sw $t1, 0($t7)
    addi $t5, $t5, 4
    j fill_background
    
re_init: li $t5, 0 # the first position to start writing in pixels

brick_loop: 
    bge $t5, 2816, draw_paddle #while 0 < 
    addu $t7, $t4, $t5 #offset display address by t5 and store the offset in t7
    li $t8, 20 # every third pixel drawn needs to be empty 
    divu $t5, $t8 # division for the same
    mfhi $t0 #get the value in remainder
    #draw the respective colors with alternating black rows
    blt $t5, 256, brick_reds
    blt $t5, 512, fill_black
    blt $t5, 768, brick_reds1
    blt $t5, 1024, fill_black
    blt $t5, 1280, brick_oranges
    blt $t5, 1536, fill_black
    blt $t5, 1792, brick_oranges1
    blt $t5, 2048, fill_black
    blt $t5, 2304, brick_greens
    blt $t5, 2560, fill_black
    blt $t5, 2816, brick_greens1

##FILLING IN ROWS ###
brick_reds:
    li $t1 , 0xea2014 #$t1 = red
    beq $t0, 16, fill_black
    sw $t1, 0($t7) # set pixel in t7 to red
    sw $t1, 0($t2) #load the pixel value into the brick array
    addi $t5, $t5, 4
    addi $t2, $t2, 4 #offset the array address
    j brick_loop
    
brick_reds1:
    li $t1 , 0xea2014 #$t1 = red
    beq $t0, 8, fill_black
    sw $t1, 0($t7) # set pixel in t7 to red
    sw $t1, 0($t2) #load the pixel value into the brick array
    addi $t5, $t5, 4
    addi $t2, $t2, 4 #offset the array address
    j brick_loop
    
brick_oranges:
    li $t1 , 0xFBB533 #$t3 = orange
    beq $t0, 0, fill_black
    sw $t1, 0($t7) # set pixel in t7 to red
    sw $t1, 0($t2) #load the pixel value into the brick array
    addi $t5, $t5, 4
    addi $t2, $t2, 4 #offset the array address
    j brick_loop
    
brick_oranges1:
    li $t1 , 0xFBB533 #$t3 = orange
    beq $t0, 12, fill_black
    sw $t1, 0($t7) # set pixel in t7 to red
    sw $t1, 0($t2) #load the pixel value into the brick array
    addi $t5, $t5, 4
    addi $t2, $t2, 4 #offset the array address
    j brick_loop

brick_greens:
    li $t1 , 0x4F6F23 #$t1 = green
    beq $t0, 4, fill_black
    sw $t1, 0($t7) # set pixel in t7 to red
    sw $t1, 0($t2) #load the pixel value into the brick array
    addi $t5, $t5, 4
    addi $t2, $t2, 4 #offset the array address
    j brick_loop
    
brick_greens1:
    li $t1 , 0x4F6F23 #$t1 = green
    beq $t0, 16, fill_black
    sw $t1, 0($t7) # set pixel in t7 to red
    sw $t1, 0($t2) #load the pixel value into the brick array
    addi $t5, $t5, 4
    addi $t2, $t2, 4 #offset the array address
    j brick_loop
    
fill_black:
    li $t1, 0x000000 #black
    sw $t1, 0($t7)
    sw $t1, 0($t2) #load the pixel value into the brick array
    addi $t5, $t5, 4
    addi $t2, $t2, 4 #offset the array address
    j brick_loop
    
draw_paddle:
    #drawing in the paddle in blue color
    li $t1, 0x00ffff #blue
    addiu $t7, $t4,31096
    sw $t1, 0($t7)
    sw $t1, 4($t7)
    sw $t1, 8($t7)
##FILLING IN ROWS ENDS###

interaction_setup:
    #after all the brick setup we have, every register except t2 and t4 ready for use for other operations
    #if the ball hits the left side of the paddle, it shud go in direction: -1 1
    #right side means 1, 1
    li $t1, 0xffffff #white
    #inititally it should just move in diretion 0 1
    addi $t6, $t4, 30844
    lw $s0, 0($t6) #position of left side of paddle
    lw $s1, 8($t6) # position of right side of paddle
    lw $s2, 4($t6) #position of middle paddle
    lw $s3, 30844($t4) #position of the ball is 1 row above the middle paddle
    lw $t1, 30844($t4) #draw the ball
    #initial x and y directions
    li $s4, 0 #x-dir
    li $s5, 1 #y-dir
    
    #setup keyboard
    lw $t0, ADDR_KBRD               # $t0 = base address for keyboard
    
 wait_for_keyboard:
    #take keyboard input to begin the game
    lw $t8, 0($t0)                  # Load first word from keyboard
    beq $t8, 1, move_ball_init      # If first word 1, key is pressed
    j wait_for_keyboard    

move_ball_init:
    #update the position of the ball:
    li $t1, 0x000000 #black
    sw $t1, 0($s3) #fill out the current position of the ball
    subiu $s3, $s3, 256 #move it a row up
    li $t1, 0xffffff #white
    sw $t1, 0($s3)
    
game_loop:
	# 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (paddle, ball)
	# 3. Draw the screen
	# 4. Sleep

    #5. Go back to 1
    # b game_loop
