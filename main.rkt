(require picturing-programs)

;1 unit is one block, a speed of 2.6, means 2.6 blocks per tick

(define-struct player_object (xpos ypos xv yv f))

#|
(make-player_object
 (player_object-xpos m)
 (player_object-ypos m)
 (player_object-xv m)
 (player_object-yv m)
 (player_object-f m)
|#

;(define (dh1 m) (crop-top (place-image (circle 50 "solid" "red") (+ (player_object-xpos m) 140) (- 700 (player_object-ypos m)) (rectangle 500 1000 "solid" "transparent")) 150))

(define (dh1 m) (place-image (circle 50 "solid" "red") 900 450 (crop (- (player_object-xpos m) 900) (- (player_object-ypos m) 450) 1800 900 spike)))

(define (cube-tick m) 
  (cond [(floor? m) (make-player_object  (+ (player_object-xpos m) (player_object-xv m)) (player_object-f m) (player_object-xv m) 0 (player_object-f m))]
        [else (make-player_object
               (+ (player_object-xpos m) (player_object-xv m))
               (if (and (<= (+ (player_object-f m) (* -1 (player_object-yv m))) (player_object-ypos m)) (< (player_object-yv m) 0)) (player_object-f m) (- (player_object-ypos m) (player_object-yv m)))
               (player_object-xv m)
               (if (> (player_object-yv m) -260) (- (player_object-yv m) -87.6) (player_object-yv m))
               (player_object-f m))]))

(define (cube-key m key)
  (if (and (key=? key " ") (floor? m)) (make-player_object (player_object-xpos m) (+ (player_object-ypos m) 1) (player_object-xv m) 194 (player_object-f m)) m))

(define (floor? m)  (<= (player_object-ypos m) (player_object-f m)))

(define spike (scale 0.83 (bitmap/url "https://raw.githubusercontent.com/MasonQiao/Ch21-Project/main/untitled.png")))
(define (death? m)
  (cond [(or (equal? (get-pixel-color (floor (+ 50 (player_object-xpos m))) (floor (+ 50 (player_object-ypos m))) spike) (make-color 255 136 136 255))
             (equal? (get-pixel-color (floor (+ 50 (player_object-xpos m))) (floor (+ -50 (player_object-ypos m))) spike) (make-color 255 136 136 255))
             (equal? (get-pixel-color (floor (+ -50 (player_object-xpos m))) (floor (+ -50 (player_object-ypos m))) spike) (make-color 255 136 136 255))
             (equal? (get-pixel-color (floor (+ -50 (player_object-xpos m))) (floor (+ 50 (player_object-ypos m))) spike) (make-color 255 136 136 255))) false]
        [else true]))

 

(big-bang (make-player_object 0 400 100 300 450)
  (on-draw dh1)
  (on-tick cube-tick 0.67)
  (on-key cube-key)
  #;(check-with death?))

;(square 20 "solid" (make-color 255 136 136 255))
;(crop-left (crop-top spike 300) 250)
;(get-pixel-color 250 300 spike)
