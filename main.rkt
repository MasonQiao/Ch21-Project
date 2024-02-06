(require picturing-programs)

;1 unit is one block, a speed of 2.6, means 2.6 blocks per tick

(define-struct player_object (xpos ypos xv yv))

(define (dh1 m) (crop-top (place-image (circle 50 "solid" "red") (+ (player_object-xpos m) 140) (- 700 (player_object-ypos m)) (rectangle 500 1000 "solid" "transparent")) 150))

(define (cube-tick m)
  (cond [(floor? m) (make-player_object  (player_object-xpos m) 0 (player_object-xv m) 0)]
        [else (make-player_object
               (player_object-xpos m)
               (+ (player_object-ypos m) (player_object-yv m))
               (player_object-xv m)
                (if (> (player_object-yv m) -260) (+ (player_object-yv m) -87.6) (player_object-yv m)))]))

(define (cube-mouse m x y event)
  (if (and (mouse=? event "button-down") (floor? m)) (make-player_object (player_object-xpos m) (+ (player_object-ypos m) 0.01) (player_object-xv m) 194) m))

(define (floor? m)  (<= (player_object-ypos m) 0))


(big-bang (make-player_object 0 400 5 0)
  (on-draw dh1)
  (on-tick cube-tick 0.067)
  (on-mouse cube-mouse))
