(define (domain campus-cleaning)
  (:requirements :strips :typing)
  (:types
    robot
    location
  )

  (:predicates
    ;; robot position
    (at ?r - robot ?l - location)

    ;; map connectivity (undirected will be given in problem)
    (connected ?from - location ?to - location)

    ;; cleanliness status
    (dirty ?l - location)
    (swept ?l - location)
    (mopped ?l - location)

    ;; trash status
    (trash-at ?l - location)
    (carrying-trash ?r - robot)
  )

  ;; MOVE(from -> to)
  (:action move
    :parameters (?r - robot ?from - location ?to - location)
    :precondition (and
      (at ?r ?from)
      (connected ?from ?to)
    )
    :effect (and
      (not (at ?r ?from))
      (at ?r ?to)
    )
  )

  ;; SWEEP(location)
  (:action sweep
    :parameters (?r - robot ?loc - location)
    :precondition (and
      (at ?r ?loc)
      (dirty ?loc)
    )
    :effect (and
      (not (dirty ?loc))
      (swept ?loc)
    )
  )

  ;; MOP(location)
  (:action mop
    :parameters (?r - robot ?loc - location)
    :precondition (and
      (at ?r ?loc)
      (swept ?loc)
    )
    :effect (and
      (mopped ?loc)
      ;; optional: (not (swept ?loc))
    )
  )

  ;; PICK-TRASH(location)
  (:action pick-trash
    :parameters (?r - robot ?loc - location)
    :precondition (and
      (at ?r ?loc)
      (trash-at ?loc)
      (not (carrying-trash ?r))
    )
    :effect (and
      (carrying-trash ?r)
      (not (trash-at ?loc))
    )
  )

  ;; DROP-TRASH(dustbin)
  (:action drop-trash
    :parameters (?r - robot ?bin - location)
    :precondition (and
      (at ?r ?bin)
      (carrying-trash ?r)
    )
    :effect (and
      (not (carrying-trash ?r))
      ;; you can add a bookkeeping predicate if you want,
      ;; but it's not needed for this assignment
    )
  )
)

