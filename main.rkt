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

(define (dh1 m) (crop-top (place-image (circle 50 "solid" "red") (+ (player_object-xpos m) 140) (- 700 (player_object-ypos m)) (rectangle 500 1000 "solid" "transparent")) 150))

(define (cube-tick m)
  (cond [(floor? m) (make-player_object  (player_object-xpos m) 0 (player_object-xv m) 0 (player_object-f m))]
        [else (make-player_object
               (player_object-xpos m)
               (if (> (+ (player_object-f m) (* -1 (player_object-yv m))) (player_object-ypos m)) (player_object-f m) (+ (player_object-ypos m) (player_object-yv m)))
               (player_object-xv m)
               (if (> (player_object-yv m) -260) (+ (player_object-yv m) -87.6) (player_object-yv m))
               (player_object-f m))]))

(define (cube-key m key)
  (if (and (key=? key ".") (floor? m)) (make-player_object (player_object-xpos m) (+ (player_object-ypos m) 0.01) (player_object-xv m) 194 (player_object-f m)) m))

(define (floor? m)  (<= (player_object-ypos m) (player_object-f m)))


(big-bang (make-player_object 0 400 5 0 0)
  (on-draw dh1)
  (on-tick cube-tick 0.067)
  (on-key cube-key))
