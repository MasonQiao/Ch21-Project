;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname posn-util) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require picturing-programs)
(provide (all-defined-out))

(define (posn=? posn1 posn2) (and (= (posn-x posn1) (posn-x posn2)) (= (posn-y posn1) (posn-y posn2))))
(define (posn-add posn1 posn2) (make-posn (+ (posn-x posn1) (posn-x posn2)) (+ (posn-y posn1) (posn-y posn2))))
(define (posn-sub posn1 posn2) (make-posn (- (posn-x posn1) (posn-x posn2)) (- (posn-y posn1) (posn-y posn2))))
(define (posn-scale n posn) (make-posn (* n (posn-x posn)) (* n (posn-y posn))))
(define (posn-distance posn1 posn2) (sqrt (+ (expt (abs (- (posn-x posn1) (posn-x posn2))) 2) (expt (abs (- (posn-y posn1) (posn-y posn2))) 2))))
(define (place-image/posn img posn bg) (place-image img (posn-x posn) (posn-y posn) bg))
(define (contains? posn x1 y1 x2 y2) (and (and (>= (posn-x posn) x1) (<= (posn-x posn) x2)) (and (>= (posn-y posn) y1) (<= (posn-y posn) y2))))