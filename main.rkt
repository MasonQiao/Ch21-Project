#|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
HOW TO PLAY

SPACEBAR - JUMP
HOLD SPACEBAR - JUMP CONSECUTIVELY
MOUSE BUTTON-DOWN - INSTANTLY BEAT THE LEVEL (HACKS)

IF THE PLAYER ICON TOUCHES A SPIKE, YOU LOSE
IF THE PLAYER REACHES THE END, A COMPLETION SCREEN APPEARS (YOU WIN)

RESTART THE PROGRAM TO PLAY AGAIN
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CODE SUMMARY
Our group (Yuhan and Mason) made a basic clone of Geometry Dash in Racket.
In our program, we have a custom structure called player_object that holds the x and y coordinates of the player, as well as the x and y velocities (used when the player jumps).
We also have a floor, which is the height of the platform the player is on. We wanted to make platforms you could jump on, but unfortunately it is too much work for a short period of time.

The functionality of our program relies on the (get-pixel-color ...) function, which allows us to detect a spike just based on a specific color.
When the player's hitbox, which are 8 evenly spaced points on the edge of a circle, touches this color, the game ends and the player dies.
A helper function is used to check the color of a given location, and returns whether it should kill the player.

The physics of the player jump is the exact same physics used in real geometry dash, with the velocity changing every tick.
When the player presses the space to jump, the y velocity is changed to 
When the player is in the air jumping, to -194. It is negative because we place the image at positive coordinates, and going up means decreasing y.
On every tick, we subtract 87.6 from the velocity to slow it down, creating a realistic jumping effect in a parabola shape.
Also, in order to limit the player from gaining too much momentum when falling off a high place, when y velocity > 260, we stop changing the velocity.

The player moves every tick based on the velocity of the x and y, as we add the player's x to the x velocity, and y to y velocity.
The tick handler also is where the y velocity of the jump height is changed, with the help of the jump-physics helper function, using the physics explained.
This handler is also where the player stops when the LEVEL COMPLETE screen is reached, as the player_object model is changed to the center of the screen
The Y and X velocities of the player are also set to 0, so that the player will not move/glitch out of the level.

The draw handler places our icon, the circle, onto the screen at a specific location. To create the effect of having the icon x location not move
and also to bypass the big-bang 2000 pixel width limit, we crop the level's image based on the x position of the player, which makes a set screen size for the game.

The death? function helps determine when to stop the program. Working with a check-with in the big-bang, it returns false when the player should die/stop,
which, in particular, is when either the hitbox of the player hits the spike color, or when the end screen coordinates are reached.

The key handler is where the space bar jump inputs are detected, and we chose to use a key to jump instead of a mouse input because keys allow you
to hold down the button and jump multiple times in a row. The key handler is also where the y velocity is initially changed in order to activate the jump physics.

Our mouse handler detects if the mouse button is pressed down, which then instantly places the player icon to the very end of the level, at the end screen.

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|#

(require picturing-programs)

(define-struct player_object (xpos ypos xv yv f))
;player_object is a custom structure that keeps track of the x and y coordinates of the player, as well as the x y velocities and floor height.
;Inventory
;xpos - int 1955
;ypos - int 400
;xv - int 100
;yv - int -194
;f - int 0

;"make-player_object : int(xpos) int(ypos) int(xv) int(yv) int(floor) -> player_object"


;Images to make level
(define open-screen (scale 0.34 (bitmap/url "https://raw.githubusercontent.com/MasonQiao/Ch21-Project/main/Drawing-262.sketchpad.png")))

(define spike (scale 0.36 (bitmap/url "https://raw.githubusercontent.com/MasonQiao/Ch21-Project/main/Drawing-259.sketchpad.png?")))

(define end-screen (scale 0.36 (bitmap/url "https://raw.githubusercontent.com/MasonQiao/Ch21-Project/main/Drawing-261.sketchpad.png")))

;Level assembled
(define spikes (beside open-screen spike spike spike spike end-screen))


;Floor helper function (checks if player is on the ground)
(define (floor? m)  (>= (player_object-ypos m) (player_object-f m)))

;Tick Helper Functions
(define (y-loc m)
  (if (and (> (player_object-yv m) 0) (> (+ (player_object-f m) (* -1 (player_object-yv m))) (player_object-ypos m))) (player_object-f m) (+ (player_object-ypos m) (player_object-yv m))))

(define (jump-physics m)
  (if (< (player_object-yv m) 260) (+ (player_object-yv m) 87.6) (player_object-yv m)))

;Tick Handler
(define (cube-tick m)
  (cond [(and (floor? m) (>= (player_object-xpos m) 11000)) (make-player_object 10900 350 0 0 (player_object-f m))]
        [(floor? m) (make-player_object (+ (player_object-xpos m) (player_object-xv m)) (player_object-f m) (player_object-xv m) 0 (player_object-f m))]
        [else (make-player_object
               (+ (player_object-xpos m) (player_object-xv m))
               (y-loc m)
               (player_object-xv m)
               (jump-physics m)
               (player_object-f m))]))

;Draw Handler (places icon on level)
(define (dh1 m) (place-image (circle 50 "solid" "red") 955 452 (crop (- (player_object-xpos m) 900) (- (player_object-ypos m) 450) 1800 900 spikes)))


;Key Handler (jump inputs and velocity change)
(define (cube-key m key)
  (if (and (key=? key " ") (floor? m)) (make-player_object (player_object-xpos m) (- (player_object-ypos m) 1) (player_object-xv m) -194 (player_object-f m)) m))


;Mouse Handler (click mouse to instantly beat level)
(define (cube-mouse m x y event)
  (cond [(mouse=? "button-down" event) (make-player_object 10900 350 100 0 (player_object-f m))]
        [else m])) 

;Check Pixel Helper function (checks if a pixel is the spike color)
(define (check-pixel m x y)
  (cond [(equal? (get-pixel-color (floor (+ x (player_object-xpos m))) (floor (+ y (- (player_object-ypos m) (player_object-yv m)))) spikes) (make-color 255 136 136 255)) true]
        [else false]))

;Check-with function (checks if the program should end)
(define (death? m)
  (cond [(equal? m (make-player_object 11000 350 0 0 (player_object-f m))) false]
        [(or (check-pixel m 50 0)
             (check-pixel m -50 0)
             (check-pixel m 0 50)
             (check-pixel m 0 -50)
             (check-pixel m 35 35)
             (check-pixel m 35 -35)
             (check-pixel m -35 35)
             (check-pixel m -35 -35)) false]
        [else true]))


 
;Big-bang (animation)
(big-bang (make-player_object 0 400 100 300 350)
  (on-draw dh1)
  (on-tick cube-tick 0.067)
  (on-key cube-key)
  (on-mouse cube-mouse)
  (check-with death?))
