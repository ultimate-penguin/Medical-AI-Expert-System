(defun state-transition-prob(state action)
    (cond 
          ((and (equal action 'FM) (equal state 'Flu)) 
            (list 0.1 0.3 0.6);; flu,allergy ,healthy
          )
           ((and (equal action 'FM) (equal state 'Allergy)) 
            (list 0 0.99 0.01);; flu,allergy ,healthy
          )
           ((and (equal action 'AM) (equal state 'Flu)) 
            (list 0.9 0 0.1);; flu,allergy ,healthy
          )
           ((and (equal action 'AM) (equal state 'Allergy)) 
            (list 0.15 0.05 0.8);; flu,allergy ,healthy
          )
          
    )

)
(defun transition2(state)
    (cond ((equal state 'Flu) (list 0.5 0.15 0.35))
          ((equal state 'Allergy) (list 0.075 0.52 0.405));; flu,allergy ,healthy
    
    )
)
(defun obv-prob(obv)
    (cond
        ((equal obv 'runny-nose) (list 0.2 0.8 0))  ;;flu,allergy,healthy
        ((equal obv 'fever) (list 0.7 0.1 0))
        ((equal obv 'headache) (list 0.1 0.1 0))
    )
)
(defun normalize(prior)
    (let ((a (/ 1 (reduce #'+ prior))))
        (mapcar (lambda (x) (* x a)) prior)
    
    )
)
;;prior = (Flu,Allergy,Healthy)
;;(0.6,0.4,0)
(defparameter *prior* (list 0.6 0.4 0))
(defun prior-update(prior obv)
    (let* ((p-e-given-xt (obv-prob obv))
          (flu-state (mapcar (lambda(x) (* x (first prior))) (transition2 'Flu)))
          (all-state (mapcar (lambda(x) (* x (second prior))) (transition2 'Allergy)))
          (sum-xt-1 (mapcar #'+  flu-state all-state))
          (new-prior (normalize (mapcar #'* sum-xt-1 p-e-given-xt)))
        )
        (return-from prior-update new-prior)
    )
)
(defun state-estimate(prior obv)
    (let* ((new-prior (prior-update prior obv))
           (maxval (reduce #'max new-prior))
           (name (list 'Flu 'Allergy 'Healthy))
           (state nil)
    
           )
           (dotimes ( i 3)
                (when (= (nth i new-prior) maxval) (setf state (nth i name) ))
           
           )
           (setf *prior* new-prior)
           state
       
    
    
    )

)
(defparameter phi 0.1)
(defparameter *depth* 10)
(defun reward(state)
    (cond ((equal state 'Flu) -1)
          ((equal state 'Allergy) -0.5)
          (t 1)
          
    )
)
(defun policy (u-flu u-all depth)
    (when (= depth 1) (return-from policy (list u-flu u-all 1)))
    (let* ((u-healthy 1)
           (u-list (list u-flu u-all u-healthy))
           (e-flu-am (reduce #'+ (mapcar #'* u-list (state-transition-prob 'Flu 'AM))))
           (e-flu-fm (reduce #'+ (mapcar #'* u-list (state-transition-prob 'Flu 'FM))))
           (new-u-flu (+ (reward 'Flu) (* phi (max e-flu-am e-flu-fm))))
           (e-all-am (reduce #'+ (mapcar #'* u-list (state-transition-prob 'Allergy 'AM))))
           (e-all-fm (reduce #'+ (mapcar #'* u-list (state-transition-prob 'Allergy 'FM))))
           (new-u-all (+ (reward 'Allergy) (* phi (max e-all-am e-all-fm))))
        )
        (policy new-u-flu new-u-all (- depth 1))
         
    
    )
)
(defun best-action(state u)
    (let((am (reduce #'+ (mapcar #'* u (state-transition-prob state 'AM))))
         (fm (reduce #'+ (mapcar #'* u (state-transition-prob state 'FM))))
        )
        (if (> fm am) 'FM 'AM)

    )
)

(defun generate-symptom(state)
    (let ((rnd (random 1.0)))
         (when (equal state 'Flu) 
               (cond ((< rnd 0.2) (return-from generate-symptom 'runny-nose))
                     ((< rnd 0.9) (return-from generate-symptom 'fever))
                     (t (return-from generate-symptom 'headache))
                )
         )
         (when (equal state 'Allergy) 
               (cond ((< rnd 0.8) 'runny-nose)
                     ((< rnd 0.9) 'fever)
                     (t 'headache)
                )
         )
    
    
    )
)


(defun state-update (real-state action)
    (let*((prob (state-transition-prob real-state action) )
          (start (car prob))
          (acc (+ start (second prob)))
          (rnd (random 1.0))
    
    
        )
        (cond ((< rnd start) 'Flu)
              ((< rnd acc) 'Allergy)
              (t 'Healthy)
        
        )


    )
)
(defparameter current-state 'Flu)
(defun env(action)
    (setf current-state (state-update current-state action))
    (when (equal current-state 'Healthy) (return-from env nil))
    (generate-symptom current-state)
)
(defun agent(symptom)
    (when (equal symptom nil) (return-from agent 'Healthy))
    (let*( (believe-state (state-estimate *prior* symptom))
            (u (policy 1 1 *depth*))
            (action (best-action believe-state u))
            


         )
         (format t "symptom:~a estimated state:~a actual state:~a action:~a~%" symptom believe-state current-state action)
         (agent (env action))


    )

)
(defun init-agent()
    (setf current-state 'Flu)
    
    (agent (generate-symptom current-state))
    
)
    
   