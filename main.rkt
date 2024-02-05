(require picturing-programs)
(require "posn-util.rkt")

;1 unit is one block, a speed of 2.6, means 2.6 blocks per tick

(define-struct player_object (xpos ypos xv yv))

(define (cube-tick m)
  (cond [(floor? m) (make-player_object (+ xpos xv) ypos xv 0)]
        [else (make-player_object
               (+ xpos xv)
               (+ ypos yv)
               xv
               (if (> yv 2.6) (+ yv -0.876) yv))]))

(define (cube-mouse m x y event)
  (if (mouse=? event "button-down") (make-player_object xpos ypos xv 1.94) m))
