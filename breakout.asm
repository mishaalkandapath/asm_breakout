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
    
brick_loop: bge $t5, 2816, draw_paddle #while 0 < 
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
    addi $t7, $t4, 14452
    sw $t1, 0($t7)
    sw $t1, 4($t7)
    sw $t1, 8($t7)
    sw $t1, 12($t7)
    
##FILLING IN ROWS ENDS###

game_loop:
	# 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (paddle, ball)
	# 3. Draw the screen
	# 4. Sleep

    #5. Go back to 1
    # b game_loop
