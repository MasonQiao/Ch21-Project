(require picturing-programs)

;1 unit is one block, a speed of 2.6, means 2.6 blocks per tick

(define-struct player_object (xpos ypos xv yv))

(define (dh1 m) (place-image (circle 5 "solid" "red") (player_object-xpos m) (player_object-ypos m) (rectangle 500 500 "solid" "transparent")))

(define (cube-tick m)
  (cond [(floor? m) (make-player_object (+ (player_object-xpos xv)) (player_obejct-ypos m) (player_object-xv m) 0)]
        [else (make-player_object
               (+ (player_object-xpos m) (player_object-xv m))
               (+ (player_object-ypos m) (player_object-yv m))
               xv
               (if (> (player_object_yv m) 2.6) (+ (player_objecct-yv m) -0.876) (player_object-yv m)))]))

(define (cube-mouse m x y event)
  (if (and (mouse=? event "button-down") (floor? m)) (make-player_object (player_object-xpos m) (player_object-ypos m) (player_object-xv m) 1.94) m))

(define (floor? m)  (<= (player_object-ypos) 5))


(big-bang (make-player_object 0 0 5 0) (on-draw dh1) (on-tick cube-tick) (on-mouse cube-mouse))
