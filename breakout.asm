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
# bricks: .space 

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
    #setting up the basic brick colors
    li $t1 , 0xea2014 #$t1 = red
    li $t2 , 0x4F6F23 #$t2 = green
    li $t3 , 0xFBB533 #$t3 = orange
    li $t9 , 0x000000 #black
    lw $t4, ADDR_DSPL #load in the address to the display
    
    li $t5, 0 # the first position to start writing in pixels
    
brick_loop: bge $t5, 1280, game_loop #while 0 < 
    addu $t7, $t4, $t5 #offset display address by t5 and store the offset in t7
    li $t8, 20 # every third pixel drawn needs to be empty 
    divu $t5, $t8 # division for the same
    mfhi $t0
    blt $t5, 256, brick_reds
    blt $t5, 512, fill_black
    blt $t5, 768, brick_oranges
    blt $t5, 1024, fill_black
    blt $t5, 1280, brick_greens
    
brick_reds:
    beq $t0, 16, fill_black
    sw $t1, 0($t7) # set pixel in t7 to red
    addi $t5, $t5, 4
    j brick_loop
    
brick_oranges:
    beq $t0, 8, fill_black
    sw $t3, 0($t7) # set pixel in t7 to red
    addi $t5, $t5, 4
    j brick_loop

brick_greens:
    beq $t0, 0, fill_black
    sw $t2, 0($t7) # set pixel in t7 to red
    addi $t5, $t5, 4
    j brick_loop
    
fill_black:
    sw $t8, 0($t7)
    addi $t5, $t5, 4
    j brick_loop

game_loop:
	# 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (paddle, ball)
	# 3. Draw the screen
	# 4. Sleep

    #5. Go back to 1
    # b game_loop
