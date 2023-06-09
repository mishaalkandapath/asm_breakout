################ CSC258H1F Fall 2022 Assembly Final Project ##################
# This file contains our implementation of Breakout.
#
# Student 1: Mishaal Kandapath, 1007978137
######################## Bitmap Display Configuration ########################
# - Unit width in pixels:       64
# - Unit height in pixels:      128
# - Display width in pixels:    1
# - Display height in pixels:   1
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
bricks: .space 3840

print_msg: .asciiz "\n\0"

#sound configs
beep: .byte 72
duration: .byte 100
volume: .byte 127
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
    li $s1, 0
    li $s2, 0 #the number of bricks broken
    lw $s7, ADDR_KBRD
    
fill_background: #make the entire background black - resetting effectively.
    li $t1, 0x000000 #black
    beq $t5, 32768, re_init
    addu $t7, $t4, $t5 #offset display address by t5 and store the offset in t7
    sw $t1, 0($t7)
    addi $t5, $t5, 4
    j fill_background
    
re_init: li $t5, 0 # the first position to start writing in pixels
#bricks are drawn after 20 rows of empty space
make_wall_left:
    li $t1, 0xffffff #white
    beq $t5, 32768, right_init
    addu $t7, $t4, $t5 #offset display address by t5 and store the offset in t7
    sw $t1, 0($t7) #set the wall to white
    addiu $t5, $t5, 252
    addu $t7, $t4, $t5 #offset display address by t5 and store the offset in t7
    sw $t1, 0($t7) #set the wall to white
    addiu $t5, $t5, 4
    j make_wall_left
    
right_init: 
    li $t5, 4864

change_brick_and_paddle_walls:
    addu $t7, $t4, $zero #offset display address by t5 and store the offset in t7
    li $t1, 0x00ffff #paddle blue
    sw $t1, 30976($t7)
    sw $t1, 31228($t7)

brick_loop: 
    bge $t5, 8704, draw_paddle #while 0 < 
    addu $t7, $t4, $t5 #offset display address by t5 and store the offset in t7
    li $t8, 20 # every third pixel drawn needs to be empty 
    divu $t5, $t8 # division for the same
    mfhi $t0 #get the value in remainder
    #draw the respective colors with alternating black rows
    blt $t5, 5120, brick_reds
    blt $t5, 5376, fill_black
    blt $t5, 5632, brick_reds1
    blt $t5, 5888, fill_black
    blt $t5, 6144, brick_oranges
    blt $t5, 6400, fill_black
    blt $t5, 6656, brick_oranges1
    blt $t5, 6912, fill_black
    blt $t5, 7168, brick_greens
    blt $t5, 7424, fill_black
    blt $t5, 7680, brick_greens1
    blt $t5, 7936, fill_black
    blt $t5, 8192, brick_yellow
    blt $t5, 8448, fill_black
    blt $t5, 8704, brick_yellow1

##FILLING IN ROWS ###
brick_reds:
    li $t1 , 0xea2014 #$t1 = red
    beq $t0, 0, fill_black
    sw $t1, 0($t7) # set pixel in t7 to red
    sw $t1, 0($t2) #load the pixel value into the brick array
    addi $t5, $t5, 4
    addi $t2, $t2, 4 #offset the array address
    li $a0, 10
    li $v0, 32
    syscall
    j brick_loop
    
brick_reds1:
    li $t1 , 0xea2014 #$t1 = red
    beq $t0, 12, fill_black
    sw $t1, 0($t7) # set pixel in t7 to red
    sw $t1, 0($t2) #load the pixel value into the brick array
    addi $t5, $t5, 4
    addi $t2, $t2, 4 #offset the array address
    li $a0, 5
    li $v0, 32
    syscall
    j brick_loop
    
brick_oranges:
    li $t1 , 0xFBB533 #$t1 = orange
    beq $t0, 4, fill_black
    sw $t1, 0($t7) # set pixel in t7 to red
    sw $t1, 0($t2) #load the pixel value into the brick array
    addi $t5, $t5, 4
    addi $t2, $t2, 4 #offset the array address
    li $a0, 5
    li $v0, 32
    syscall
    j brick_loop
    
brick_oranges1:
    li $t1 , 0xFBB533 #$t1 = orange
    beq $t0, 16, fill_black
    sw $t1, 0($t7) # set pixel in t7 to red
    sw $t1, 0($t2) #load the pixel value into the brick array
    addi $t5, $t5, 4
    addi $t2, $t2, 4 #offset the array address
    li $a0, 5
    li $v0, 32
    syscall
    j brick_loop

brick_greens:
    li $t1 , 0x4F6F23 #$t1 = green
    beq $t0, 8, fill_black
    sw $t1, 0($t7) # set pixel in t7 to red
    sw $t1, 0($t2) #load the pixel value into the brick array
    addi $t5, $t5, 4
    addi $t2, $t2, 4 #offset the array address
    li $a0, 5
    li $v0, 32
    syscall
    j brick_loop
    
brick_greens1:
    li $t1 , 0x4F6F23 #$t1 = green
    beq $t0, 0, fill_black
    sw $t1, 0($t7) # set pixel in t7 to red
    sw $t1, 0($t2) #load the pixel value into the brick array
    addi $t5, $t5, 4
    addi $t2, $t2, 4 #offset the array address
    li $a0, 5
    li $v0, 32
    syscall
    j brick_loop
    
brick_yellow:
    li $t1 , 0xFCEEAF #$t1 = green
    beq $t0, 12, fill_black
    sw $t1, 0($t7) # set pixel in t7 to red
    sw $t1, 0($t2) #load the pixel value into the brick array
    addi $t5, $t5, 4
    addi $t2, $t2, 4 #offset the array address
    li $a0, 5
    li $v0, 32
    syscall
    j brick_loop
    
brick_yellow1:
    li $t1 , 0xFCEEAF #$t1 = green
    beq $t0, 4, fill_black
    sw $t1, 0($t7) # set pixel in t7 to red
    sw $t1, 0($t2) #load the pixel value into the brick array
    addi $t5, $t5, 4
    addi $t2, $t2, 4 #offset the array address
    li $a0, 5
    li $v0, 32
    syscall
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
    li $t9, 0 #loop variable
    addiu $t7, $t4,31088
    sw $t1, 0($t7)
    li $a0, 5
    li $v0, 32
    syscall
    sw $t1, 4($t7)
    li $a0, 5
    li $v0, 32
    syscall
    sw $t1, 8($t7)
    li $a0, 5
    li $v0, 32
    syscall
    sw $t1, 12($t7)
    li $a0, 5
    li $v0, 32
    syscall
    sw $t1, 16($t7)
    li $a0, 5
    li $v0, 32
    syscall
    sw $t1, 20($t7)
    li $a0, 5
    li $v0, 32
    syscall
    sw $t1, 24($t7)
    li $a0, 5
    li $v0, 32
    syscall
##FILLING IN ROWS ENDS###

interaction_setup:
    #after all the brick setup we have, every register except t2 and t4 ready for use for other operations
    
    #set up the current  life:
    addiu $s1, $s1, 1
    li $t1, 0xffffff #white
    #inititally it should just move in diretion 0 1
    
    li $s0, 31088 #position of left side of paddle
    #draw and store the ball
    li $s3, 30844 #position of the ball is 1 row above the middle paddle
    sw $t1, 30844($t4) #draw the ball
    #initial x and y directions
    li $s4, 0 #x-dir
    li $s5, -1 #y-dir
    
    #resetting in the array:
    la $t2, bricks
    
    # # #setup keyboard
    # lw $s, ADDR_KBRD               # $t0 = base address for keyboard
    
 wait_for_keyboard_to_begin:
    #take keyboard input to begin the game
    lw $t8, 0($s7)                  # Load first word from keyboard
    beq $t8, 1, game_loop     # If first word 1, key is pressed
    j wait_for_keyboard_to_begin    
    
game_loop:
	# 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (paddle, ball)
	# 3. Draw the screen
	# 4. Sleep
    
# go through all the bricks in the array
# if the current direction is (0, 1) then check if ball is one row below any brick
#if the current direction is (1, 0), then check if the ball is one col to the left of any brick
#if the current direction is (-1, 0), then check if the ball is one col to the right of any brick 
#if the current direction is (0, -1), then check if the ball is one row above any brick
    #the next pixel value of this given current direction:
    li $t7, 4
    mult $s4, $t7
    mflo $t7
    add $t7, $t7, $s3
    
    li $t6, 256
    mult $s5, $t6
    mflo $t6
    add $t6, $t6, $t7 #t6 stores the new value of pixel
    
    #store t6 into the stack pointer or smthn:
    sw $t6, 0($sp)
    
    collision_check_above: beq $s5, -1, check_brick_above #check if the ball is below a brick
    collision_check_below: beq $s5, 1, check_brick_below #check if the ball is above a brick
    collision_check_right: beq $s4, 1, check_brick_right #ball is left of any brick
    collision_check_left:  beq $s4, -1, check_brick_left #ball is right of any brick
    collision_check_paddle: beq $s5, 1, check_collision_paddle #check if the ball is going to collide with the paddle
    collision_check_left_wall: 
        lw $t6, 0($sp)
        addi $t7, $zero, 256 #every value on the left wall is divisible by 256
        divu $t6, $t7
        mfhi $t7
        beq $t7, 0, collision_left_wall
    collision_check_right_wall: 
        addi $t7, $t6, 4 #every value on the right wall is divisible by 256 if i add a pixel to it
        addi $t5, $zero, 256
        divu $t7, $t5
        mfhi $t7
        beq $t7, 0, collision_right_wall
    collision_check_top_wall: 
        ble $t6, 4864, collision_top_wall  #top layer
    #check if the game should be ended:
    bgt $t6, 32768, another_life #check if you have another life 
    
score0:
    bgt $s2, 9, score1
    jal draw0
    j move_ball

score1:
    bgt $s2, 19, score2
    jal draw1
    j move_ball
    
score2:
    bgt $s2, 29, score3
    jal draw2
    j move_ball
    
score3:
    bgt $s2, 39, score4
    jal draw3
    j move_ball
    
score4:
    bgt $s2, 49, score5
    jal draw4
    j move_ball
    
score5:
    bgt $s2, 59, score6
    jal draw5
    j move_ball
    
score6:
    bgt $s2, 69, score7
    jal draw6
    j move_ball
    
score7:
    bgt $s2, 79, score8
    jal draw7
    j move_ball
    
score8:
    bgt $s2, 89, score9
    jal draw8
    j move_ball
    
score9:
    bgt $s2, 99, move_ball
    jal draw9
    
score10:
    jal draw10

#if we get here then there are no collisions, we can safely move the ball in specified direction:
move_ball:
    #move the real pos of ball back :
    lw $t6, 0($sp)
    #update the position of the ball:
    li $t1, 0x000000 #black
    addu $t7, $t4, $s3 #get the offset to the display to get to the ball
    sw $t1, 0($t7) #fill out the current position of the ball
    li $t1, 0xffffff #white
    addu $s3, $t6, $zero
    addu $t6, $t4, $t6 #get the offset to the display to get to the ball
    sw $t1, 0($t6)
    

#can also check for keyboard inputs to move the paddle:
movement_keyboard:
    #take keyboard input to move the paddle
    lw $t8, 0($s7)                  # Load first word from keyboard
    beq $t8, 1, receive_keyboard_in     # If first word 1, key is pressed
    j loop_again  
    
receive_keyboard_in:
    lw $a0, 4($s7)                  # Load second word from keyboard
   
    beq $a0, 'p', wait_for_keyboard_to_begin   
    beq $a0, 0x71, respond_to_Q     # Check if the key q was pressed
    beq $a0, 0x61, move_paddle_left     # Check if left was pressed
    beq $a0, 0x64, move_paddle_right #similarly for right
    
    
    j loop_again
    
move_paddle_left:
     beq $s0, 30976, movement_keyboard # cant move left no more
     addu $t7, $s0, $t4
     #move the paddle sections left by one
     
     #erase paddle
     li $t1, 0x000000 #black
     sw $t1, 0($t7)
     sw $t1, 4($t7)
     sw $t1, 8($t7)
     sw $t1, 12($t7)
     sw $t1, 16($t7)
     sw $t1, 20($t7)
     sw $t1, 24($t7)
     
     #redraw the paddle:
     subiu $s0, $s0, 8
     addu $t7, $s0, $t4 #new padlde position
     li $t1, 0x00ffff #cyan
     sw $t1, 0($t7)
     sw $t1, 4($t7)
     sw $t1, 8($t7)
     sw $t1, 12($t7)
     sw $t1, 16($t7)
     sw $t1, 20($t7)
     sw $t1, 24($t7)
     
     j loop_again
 
 move_paddle_right:
     beq $s0, 31200, movement_keyboard # cant move right no more
     addu $t7, $s0, $t4
     #move the paddle sections left by one
     
     #erase paddle
     li $t1, 0x000000 #black
     sw $t1, 0($t7)
     sw $t1, 4($t7)
     sw $t1, 8($t7)
     sw $t1, 12($t7)
     sw $t1, 16($t7)
     sw $t1, 20($t7)
     sw $t1, 24($t7)
     
     #redraw the paddle:
     addiu $s0, $s0, 8
     addu $t7, $s0, $t4 #new padlde position
     li $t1, 0x00ffff #cyan
     sw $t1, 0($t7)
     sw $t1, 4($t7)
     sw $t1, 8($t7)
     sw $t1, 12($t7)
     sw $t1, 16($t7)
     sw $t1, 20($t7)
     sw $t1, 24($t7)
     
     j loop_again
     
    
check_brick_above:
    #in this case the y direction is -1:
    #$t2 stores the address of the array
    
    addiu $t7, $t2, 3839 #the final index in the array
    blt $t6, 8704, may_collide_above
    
    j collision_check_below
 
may_collide_above:
     #the index of where it could collide is in t7
    subiu $t6, $t6, 4864 
    addu $t7, $t2, $t6 #offset the array memory address
    lw $t8, 0($t7) #load in the value stored
    bne $t8, 0x000000, collides_brick_above
    j collision_check_below

collides_brick_above:
    li $t1, 0x000000
    sw $t1, 0($t7)
    addu $t7, $t4, $t6
    addiu $t9, $t6, -4
    addiu $t7, $t7, 4864
    sw $t1, 0($t7) #load the pixel value onto the screen
    
    #delete any remaining pixels in the brick
    addiu $t6, $t6, 4
    jal delete_brick_right
    addiu $t6, $t9, 0
    jal delete_brick_left
    
    neg $s5, $s5
    addiu $s2, $s2, 1
    j movement_keyboard
 
check_brick_below:
    #in this case the y direction is -1:
    #$t2 stores the address of the array
    addiu $t7, $t2, 3839 #the final index in the array 
    blt $t6, 8704, may_collide_below
    
    j collision_check_right
    
may_collide_below:
    #the index of where it could collide is in t7
     subiu $t6, $t6, 4864 
    addu $t7, $t2, $t6 #offset the array memory address
    lw $t8, 0($t7) #load in the value stored
    bne $t8, 0x000000, collides_brick_below
    j collision_check_right
    
collides_brick_below:
    li $t1, 0x000000
    sw $t1, 0($t7)
    addu $t7, $t4, $t6
    addiu $t9, $t6, -4
    addiu $t7, $t7, 4864
    sw $t1, 0($t7) #load the pixel value onto the screen
    
    #delete any remaining pixels in the brick
    addiu $t6, $t6, 4
    jal delete_brick_right
    addiu $t6, $t9, 0
    addiu $s2, $s2, 1
    jal delete_brick_left
    
    
    neg $s5, $s5
    j movement_keyboard

check_brick_left:
    #in this case the x direction is -1:
    #$t2 stores the address of the array
    addiu $t7, $t2, 3839 #the final index in the array 
    blt $t6, 8704, may_collide_left
    
    j collision_check_paddle
    
may_collide_left:
    #the index of where it could collide is in t7
     subiu $t6, $t6, 4864 
    addu $t7, $t2, $t6 #offset the array memory address
    lw $t8, 0($t7) #load in the value stored
    bne $t8, 0x000000, collides_brick_left
    j collision_check_paddle
    
collides_brick_left:
    li $t1, 0x000000 
    sw $t1, 0($t7)
    addu $t7, $t4, $t6
    addiu $t9, $t6, -4
    addiu $t7, $t7, 4864
    sw $t1, 0($t7) #load the pixel value onto the screen
    
    #delete any remaining pixels in the brick
    addiu $t6, $t6, 4
    jal delete_brick_right
    addiu $t6, $t9, 0
    jal delete_brick_left
    
    neg $s4, $s4 
    addiu $s2, $s2, 1
    j movement_keyboard
    
check_brick_right:
    #in this case the x direction is 1:
    #$t2 stores the address of the array
    addiu $t7, $t2, 3839 #the final index in the array 
    blt $t6, 8704, may_collide_right
    
    j collision_check_left
    
may_collide_right:
    #the index of where it could collide is in t7
     subiu $t6, $t6, 4864 
    addu $t7, $t2, $t6 #offset the array memory address
    lw $t8, 0($t7) #load in the value stored
    bne $t8, 0x000000, collides_brick_right
    j collision_check_left
    
collides_brick_right:
    li $t1, 0x000000 
    sw $t1, 0($t7)
    addu $t7, $t4, $t6
    addiu $t9, $t6, -4
    addiu $t7, $t7, 4864
    sw $t1, 0($t7) #load the pixel value onto the screen
    
    #delete any remaining pixels in the brick
    addiu $t6, $t6, 4
    jal delete_brick_right
    addiu $t6, $t9, 0
    jal delete_brick_left
    
    neg $s4, $s4 
    addiu $s2, $s2, 1
    j movement_keyboard
    
delete_brick_right:
    #keep going right from current t6 value , currently storing array index. 
    #make_sure it doesnt exceed the row:
    li $t1, 0x000000
    divu $t7, $t6, 256
    mfhi $t7
    beq $t7, 0, end_deleting 
    addu $t7, $t2, $t6 #offset the array memory address
    lw $t8, 0($t7) #load in the value stored
    beq $t8, 0x000000, end_deleting
    sw $t1, 0($t7) #remove that pixel from the array
    addiu $t6, $t6, 4864
    addu $t7, $t4, $t6 #offset the display memory address
    sw $t1, 0($t7) #remove that pixel from the array
    subiu $t6, $t6, 4864
    addi $t6, $t6, 4
    j delete_brick_right
    
delete_brick_left:
    #keep going right from current t6 value , currently storing array index. 
    #make_sure it doesnt exceed the row:
    li $t1, 0x000000
    addiu $t7, $t6, 4
    divu $t7, $t6, 256
    mfhi $t7
    beq $t7, 0, end_deleting 
    addu $t7, $t2, $t6 #offset the array memory address
    lw $t8, 0($t7) #load in the value stored
    beq $t8, 0x000000, end_deleting
    sw $t1, 0($t7) #remove that pixel from the array
    addiu $t6, $t6, 4864
    addu $t7, $t4, $t6 #offset the display memory address
    sw $t1, 0($t7) #remove that pixel from the array
    subiu $t6, $t6, 4864 #change  it back into an array index
    subiu $t6, $t6, 4
    j delete_brick_left
    
end_deleting:
    jr $ra

check_collision_paddle:
    #in this case the y direction of the ball is -1 with some x direction
    #s0 - s2 store offsets in memory of paddle
    addu $t7, $t4, $s0 #getting the address of the left paddle
    
    bgt $s0, $t6, collision_check_left_wall
    addiu $t9, $s0, 24
    blt $t9, $t6, collision_check_left_wall
    addiu $t9, $s0, 12
    blt $t6, $t9, may_collide_paddle_left
    beq $t6, $t9, may_collide_paddle_middle
    j may_collide_paddle_right
    
may_collide_paddle_middle:
    neg $s4, $s4
    neg $s5, $s5
    j movement_keyboard
    
may_collide_paddle_left:
    li $s5, -1
    li $s4, -1
    j movement_keyboard
    
may_collide_paddle_right:
    li $s5, -1
    li $s4, 1
    j movement_keyboard
    
collision_top_wall:
    neg $s5, $s5 #negative y direction
    j movement_keyboard
    
collision_right_wall:
    neg $s4, $s4
    j movement_keyboard
    
collision_left_wall:
    neg $s4, $s4
    j movement_keyboard

#5. Go back to 1
loop_again:    
    li $a0, 10
    li $v0, 32
    syscall
    j game_loop
    
another_life:
    #ready to redraw the paddle:
    beq $s1, 3, respond_to_Q #quit, maxed out on lives:
    li $t1, 0x000000
    addu $t7, $t4, $s0
    sw $t1, 0($t7)
    sw $t1, 4($t7)
    sw $t1, 8($t7)
    sw $t1, 12($t7)
    sw $t1, 16($t7)
    sw $t1, 20($t7)
    sw $t1, 24($t7)
    
    j draw_paddle

respond_to_Q:
    li $v0,31
    la $a0,beep
    
    la $a1,duration
    lw $a1, 0($a1)
    
	li $v0, 10                      # Quit gracefully
	syscall
	
#section drawing scores for scoreboard:
#scores are from 0-10, incrementing every 10 bricks, last one requires some extra brick - yea difficulty
#scores are drawn in the 6th row, at column index 5 (i.e the 6th pixel on the 10th row forms the left most)
erase_all:
    #offset the display by 9 rows and 6 columsn = 2310
    li $t1, 0x000000
    addiu $t7, $t4, 1304
    sw $t1, 0($t7)
    sw $t1, 4($t7)
    sw $t1, 8($t7)
    sw $t1, 12($t7)
    sw $t1, 16($t7)
    sw $t1, 20($t7)
    sw $t1, 24($t7)
    addiu $t7, $t4, 1328
    sw $t1, 0($t7)
    sw $t1, 256($t7)
    sw $t1, 512($t7)
    sw $t1, 768($t7)
    sw $t1, 1024($t7)
    sw $t1, 1280($t7)
    sw $t1, 1536($t7)
    addiu $t7, $t4, 2864
    sw $t1, 0($t7)
    sw $t1, 256($t7)
    sw $t1, 512($t7)
    sw $t1, 768($t7)
    sw $t1, 1024($t7)
    sw $t1, 1280($t7)
    sw $t1, 1536($t7)
    addiu $t7, $t4, 2840
    sw $t1, 0($t7)
    sw $t1, 256($t7)
    sw $t1, 512($t7)
    sw $t1, 768($t7)
    sw $t1, 1024($t7)
    sw $t1, 1280($t7)
    sw $t1, 1536($t7)
    addiu $t7, $t4, 4376
    sw $t1, 0($t7)
    sw $t1, 4($t7)
    sw $t1, 8($t7)
    sw $t1, 12($t7)
    sw $t1, 16($t7)
    sw $t1, 20($t7)
    sw $t1, 24($t7)
    addiu $t7, $t4, 1304
    sw $t1, 0($t7)
    sw $t1, 256($t7)
    sw $t1, 512($t7)
    sw $t1, 768($t7)
    sw $t1, 1024($t7)
    sw $t1, 1280($t7)
    sw $t1, 1536($t7)
    addiu $t7, $t4, 2840
    sw $t1, 0($t7)
    sw $t1, 4($t7)
    sw $t1, 8($t7)
    sw $t1, 12($t7)
    sw $t1, 16($t7)
    sw $t1, 20($t7)
    sw $t1, 24($t7)
    jr $ra

draw_segment_0:
    #offset the display by 9 rows and 6 columsn = 2310
    li $t1, 0xffffff
    addu $t7, $t4, $a0
    sw $t1, 0($t7)
    sw $t1, 4($t7)
    sw $t1, 8($t7)
    sw $t1, 12($t7)
    sw $t1, 16($t7)
    sw $t1, 20($t7)
    sw $t1, 24($t7)
    jr $ra
    
draw_segment_1:
    li $t1, 0xffffff
    addu $t7, $t4, $a0
    sw $t1, 0($t7)
    sw $t1, 256($t7)
    sw $t1, 512($t7)
    sw $t1, 768($t7)
    sw $t1, 1024($t7)
    sw $t1, 1280($t7)
    sw $t1, 1536($t7)
    jr $ra
    
draw_segment_2:
    li $t1, 0xffffff
    addu $t7, $t4, $a0
    sw $t1, 0($t7)
    sw $t1, 256($t7)
    sw $t1, 512($t7)
    sw $t1, 768($t7)
    sw $t1, 1024($t7)
    sw $t1, 1280($t7)
    sw $t1, 1536($t7)
    jr $ra
    
draw_segment_4:
    li $t1, 0xffffff
    addu $t7, $t4, $a0
    sw $t1, 0($t7)
    sw $t1, 256($t7)
    sw $t1, 512($t7)
    sw $t1, 768($t7)
    sw $t1, 1024($t7)
    sw $t1, 1280($t7)
    sw $t1, 1536($t7)
    jr $ra

draw_segment_3:
    li $t1, 0xffffff
    addu $t7, $t4, $a0
    sw $t1, 0($t7)
    sw $t1, 4($t7)
    sw $t1, 8($t7)
    sw $t1, 12($t7)
    sw $t1, 16($t7)
    sw $t1, 20($t7)
    sw $t1, 24($t7)
    jr $ra

draw_segment_5:
    li $t1, 0xffffff
    addu $t7, $t4, $a0
    sw $t1, 0($t7)
    sw $t1, 256($t7)
    sw $t1, 512($t7)
    sw $t1, 768($t7)
    sw $t1, 1024($t7)
    sw $t1, 1280($t7)
    sw $t1, 1536($t7)
    jr $ra
    
draw_segment_6:
    li $t1, 0xffffff
    addu $t7, $t4, $a0
    sw $t1, 0($t7)
    sw $t1, 4($t7)
    sw $t1, 8($t7)
    sw $t1, 12($t7)
    sw $t1, 16($t7)
    sw $t1, 20($t7)
    sw $t1, 24($t7)
    jr $ra
draw0:
    subiu $sp, $sp, 4 #move the stack pointer up
    sw $ra, 0($sp)
    jal erase_all
    lw $a0, 1304
    jal draw_segment_0
    lw $a0, 1328
    jal draw_segment_1
    lw $a0, 2864
    jal draw_segment_2
    lw $a0, 2840
    jal draw_segment_3
    lw $a0, 4376
    jal draw_segment_4
    lw $a0, 1304
    jal draw_segment_5
    lw $ra, 0($sp)
    addiu $sp, $sp, 4 #move the stack pointer back down
    jr $ra

draw1:
    subiu $sp, $sp, 4 #move the stack pointer up
    sw $ra, 0($sp)
    jal erase_all
    lw $a0, 1328
    jal draw_segment_1
    lw $a0, 2864
    jal draw_segment_2
    lw $ra, 0($sp)
    addiu $sp, $sp, 4 #move the stack pointer back down
    jr $ra

draw2:
    subiu $sp, $sp, 4 #move the stack pointer up
    sw $ra, 0($sp)
    jal erase_all
    lw $a0, 1304
    jal draw_segment_0
    lw $a0, 1328
    jal draw_segment_1
    lw $a0, 2840
    jal draw_segment_6
    lw $a0, 2840
    jal draw_segment_3
    lw $a0, 4376
    jal draw_segment_4
    lw $ra, 0($sp)
    addiu $sp, $sp, 4 #move the stack pointer back down
    jr $ra

draw3:
    subiu $sp, $sp, 4 #move the stack pointer up
    sw $ra, 0($sp)
    jal erase_all
     lw $a0, 1304
    jal draw_segment_0
    lw $a0, 2840
    jal draw_segment_3
    lw $a0, 1328
    jal draw_segment_1
    lw $a0, 2864
    jal draw_segment_2
    lw $a0, 2840
    jal draw_segment_6
    lw $ra, 0($sp)
    addiu $sp, $sp, 4 #move the stack pointer back down
    jr $ra
    
draw4:
    subiu $sp, $sp, 4 #move the stack pointer up
    sw $ra, 0($sp)
    jal erase_all
    lw $a0, 1328
    jal draw_segment_1
    lw $a0, 2840
    jal draw_segment_6
    lw $a0, 1304
    jal draw_segment_5
    lw $a0, 2864
    jal draw_segment_2
    lw $ra, 0($sp)
    addiu $sp, $sp, 4 #move the stack pointer back down
    jr $ra

draw5:
    subiu $sp, $sp, 4 #move the stack pointer up
    sw $ra, 0($sp)
    jal erase_all
    lw $a0, 1304
    jal draw_segment_0
    lw $a0, 1304
    jal draw_segment_5
    lw $a0, 2840
    jal draw_segment_6
    lw $a0, 2864
    jal draw_segment_2
     lw $a0, 2840
    jal draw_segment_3
    lw $ra, 0($sp)
    addiu $sp, $sp, 4 #move the stack pointer back down
    jr $ra
    
draw6:
    subiu $sp, $sp, 4 #move the stack pointer up
    sw $ra, 0($sp)
    jal erase_all
    lw $a0, 2840
    jal draw_segment_6
    lw $a0, 2864
    jal draw_segment_2
    lw $a0, 2840
    jal draw_segment_3
    lw $a0, 4376
    jal draw_segment_4
    lw $a0, 1304
    jal draw_segment_0
    lw $a0, 1304
    jal draw_segment_5
    lw $ra, 0($sp)
    addiu $sp, $sp, 4 #move the stack pointer back down
    jr $ra

draw7:
    subiu $sp, $sp, 4 #move the stack pointer up
    sw $ra, 0($sp)
    jal erase_all
    lw $a0, 1304
    jal draw_segment_0
    lw $a0, 1328
    jal draw_segment_1
    lw $a0, 2864
    jal draw_segment_2
    lw $ra, 0($sp)
    addiu $sp, $sp, 4 #move the stack pointer back down
    jr $ra

draw8:
    subiu $sp, $sp, 4 #move the stack pointer up
    sw $ra, 0($sp)
    jal erase_all
    lw $a0, 1304
    jal draw_segment_0
    lw $a0, 1328
    jal draw_segment_1
    lw $a0, 2864
    jal draw_segment_2
     lw $a0, 2840
    jal draw_segment_3
    lw $a0, 4376
    jal draw_segment_4
    lw $a0, 1304
    jal draw_segment_5
    lw $a0, 2840
    jal draw_segment_6
    lw $ra, 0($sp)
    addiu $sp, $sp, 4 #move the stack pointer back down
    jr $ra
    
draw9:
    subiu $sp, $sp, 4 #move the stack pointer up
    sw $ra, 0($sp)
    jal erase_all
    lw $a0, 1304
    jal draw_segment_0
    lw $a0, 1328
    jal draw_segment_1
    lw $a0, 2864
    jal draw_segment_2
    lw $a0, 1304
    jal draw_segment_5
    lw $a0, 2840
    jal draw_segment_6
    lw $ra, 0($sp)
    addiu $sp, $sp, 4 #move the stack pointer back down
    jr $ra
    
draw10:
    #draw a crown:
    subiu $sp, $sp, 4 #move the stack pointer up
    sw $ra, 0($sp)
    jal erase_all
    lw $a0, 1328
    jal draw_segment_1
    lw $a0, 2864
    jal draw_segment_2
    #thats the end of 1
    li $a0, 2868 #new start location for segment 0
    jal draw_segment_0
    li $a0, 2892 #new start location for segment 1
    jal draw_segment_1
    li $a0, 4428
    jal draw_segment_2
    li $a0, 5940
    jal draw_segment_3
    li $a0, 4404 
    jal draw_segment_4
    li $a0, 2868 
    jal draw_segment_5
    j respond_to_Q #end the game
    
    
    
    
move_ball_init:
    #update the position of the ball:
    li $t1, 0x000000 #black
    addu $t6, $t4, $s3 #get the offset to the display to get to the ball
    sw $t1, 0($t6) #fill out the current position of the ball
    subiu $s3, $s3, 256 #move it a row up
    addu $t6, $t4, $s3 #get new ball position
    li $t1, 0xffffff #white
    sw $t1, 0($t6)
    sw $t1, -1796($t7)