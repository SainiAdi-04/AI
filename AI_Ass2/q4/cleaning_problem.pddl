(define (problem campus-cleaning-instance)
  (:domain campus-cleaning)

  (:objects
    robot1 - robot
    classroom cafeteria dustbin - location
  )

  (:init
    ;; robot start location
    (at robot1 classroom)

    ;; map layout: Classroom ↔ Cafeteria ↔ Dustbin
    (connected classroom cafeteria)
    (connected cafeteria classroom)
    (connected cafeteria dustbin)
    (connected dustbin cafeteria)

    ;; initial cleanliness
    (dirty classroom)
    (dirty cafeteria)

    ;; initial trash
    (trash-at classroom)
    (trash-at cafeteria)
  )

  (:goal
    (and
      (mopped classroom)
      (mopped cafeteria)
      (not (carrying-trash robot1))
      (not (trash-at classroom))
      (not (trash-at cafeteria))
    )
  )
)

