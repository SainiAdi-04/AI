(define (domain gripper)
  (:requirements :strips :typing)
  
  (:types
    room
    ball
    gripper
  )

  (:predicates
    (ROOM ?r - room)
    (BALL ?b - ball)
    (GRIPPER ?g - gripper)
    (at-robby ?r - room)
    (at-ball ?b - ball ?r - room)
    (free ?g - gripper)
    (carry ?g - gripper ?b - ball)
  )

  
  (:action move
    :parameters (?x - room ?y - room)
    :precondition (and
      (ROOM ?x)
      (ROOM ?y)
      (at-robby ?x)
    )
    :effect (and
      (at-robby ?y)
      (not (at-robby ?x))
    )
  )

  
  (:action pick-up
    :parameters (?b - ball ?r - room ?g - gripper)
    :precondition (and
      (BALL ?b)
      (ROOM ?r)
      (GRIPPER ?g)
      (at-ball ?b ?r)
      (at-robby ?r)
      (free ?g)
    )
    :effect (and
      (carry ?g ?b)
      (not (at-ball ?b ?r))
      (not (free ?g))
    )
  )

  
  (:action drop
    :parameters (?b - ball ?r - room ?g - gripper)
    :precondition (and
      (BALL ?b)
      (ROOM ?r)
      (GRIPPER ?g)
      (carry ?g ?b)
      (at-robby ?r)
    )
    :effect (and
      (at-ball ?b ?r)
      (free ?g)
      (not (carry ?g ?b))
    )
  )
)
