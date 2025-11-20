% ================================================================
% greek_philosopher.pl
% Resolution Refutation Proof: "Socrates is mortal"
%
% Facts (English):
%   1. All men are mortal.
%   2. All Greeks are men.
%   3. All philosophers are thinkers.
%   4. Socrates is a Greek and a philosopher.
%
% Goal:
%   Prove: Socrates is mortal.
%
% Method:
%   Resolution refutation in First-Order Predicate Logic (FOL).
% ================================================================

% ------------------------------------------------
% Step 1: Predicate logic representation (FOL)
% ------------------------------------------------
% We choose the following predicates:
%   man(X)         : X is a man
%   mortal(X)      : X is mortal
%   greek(X)       : X is Greek
%   philosopher(X) : X is a philosopher
%   thinker(X)     : X is a thinker
%
% FOL formulas:
%
%   (1) ∀x ( man(x) → mortal(x) )
%   (2) ∀x ( greek(x) → man(x) )
%   (3) ∀x ( philosopher(x) → thinker(x) )
%   (4a) greek(socrates)
%   (4b) philosopher(socrates)
%
%   Goal: mortal(socrates)

fol_formula(1, all(X, imp(man(X), mortal(X)))).
fol_formula(2, all(X, imp(greek(X), man(X)))).
fol_formula(3, all(X, imp(philosopher(X), thinker(X)))).
fol_formula(4, greek(socrates)).
fol_formula(5, philosopher(socrates)).
fol_goal( g1, mortal(socrates) ).

% ------------------------------------------------
% Step 2: Negation of goal
% ------------------------------------------------
% For refutation, we add the negation of the goal:
%
%   ¬ mortal(socrates)
%
% and try to derive a contradiction (empty clause ⊥).

negated_goal(ng1, neg(mortal(socrates))).

% ------------------------------------------------
% Step 3: Implication removal
% ------------------------------------------------
% Using equivalence: (P → Q) ≡ (¬P ∨ Q)
%
%   (1) ∀x (¬man(x) ∨ mortal(x))
%   (2) ∀x (¬greek(x) ∨ man(x))
%   (3) ∀x (¬philosopher(x) ∨ thinker(x))
%   (4a) greek(socrates)
%   (4b) philosopher(socrates)
%   (¬Goal) ¬mortal(socrates)

imp_free(1, all(X, or(neg(man(X)), mortal(X)))).
imp_free(2, all(X, or(neg(greek(X)), man(X)))).
imp_free(3, all(X, or(neg(philosopher(X)), thinker(X)))).
imp_free(4, greek(socrates)).
imp_free(5, philosopher(socrates)).
imp_free_goal(ng1, neg(mortal(socrates))).

% ------------------------------------------------
% Step 4: Negation movement
% ------------------------------------------------
% Move negation inward using De Morgan’s laws and
% double negation. Our formulas are already in a
% simple form: neg only appears directly in front
% of atomic predicates (man, greek, philosopher,
% mortal).
%
% So there is no further change in this step.

neg_moved(1, all(X, or(neg(man(X)), mortal(X)))).
neg_moved(2, all(X, or(neg(greek(X)), man(X)))).
neg_moved(3, all(X, or(neg(philosopher(X)), thinker(X)))).
neg_moved(4, greek(socrates)).
neg_moved(5, philosopher(socrates)).
neg_moved_goal(ng1, neg(mortal(socrates))).

% ------------------------------------------------
% Step 5: Standardization (rename bound variables)
% ------------------------------------------------
% Every universally quantified variable should have
% its own unique name. Here each formula already uses
% its own variable x, but we can make that explicit:
%
%   (1) ∀x1 (¬man(x1) ∨ mortal(x1))
%   (2) ∀x2 (¬greek(x2) ∨ man(x2))
%   (3) ∀x3 (¬philosopher(x3) ∨ thinker(x3))
%
% For Prolog representation, we just keep distinct
% variable symbols.

standardized(1, all(X1, or(neg(man(X1)), mortal(X1)))).
standardized(2, all(X2, or(neg(greek(X2)), man(X2)))).
standardized(3, all(X3, or(neg(philosopher(X3)), thinker(X3)))).
standardized(4, greek(socrates)).
standardized(5, philosopher(socrates)).
standardized_goal(ng1, neg(mortal(socrates))).

% ------------------------------------------------
% Step 6: Skolemization
% ------------------------------------------------
% We eliminate existential quantifiers by introducing
% Skolem constants/functions. In this particular
% problem, ALL quantifiers are universal in the
% implications, and our ground facts are already
% constant terms (socrates).
%
% So Skolemization is trivial; we simply drop the
% universal quantifiers:
%
%   (1)  ¬man(X1) ∨ mortal(X1)
%   (2)  ¬greek(X2) ∨ man(X2)
%   (3)  ¬philosopher(X3) ∨ thinker(X3)
%   (4)  greek(socrates)
%   (5)  philosopher(socrates)
%   (NG) ¬mortal(socrates)

skolem(1, or(neg(man(X1)), mortal(X1))).
skolem(2, or(neg(greek(X2)), man(X2))).
skolem(3, or(neg(philosopher(X3)), thinker(X3))).
skolem(4, greek(socrates)).
skolem(5, philosopher(socrates)).
skolem_goal(ng1, neg(mortal(socrates))).

% ------------------------------------------------
% Step 7: CNF clauses
% ------------------------------------------------
% We now convert formulas to Conjunctive Normal Form
% and represent each clause as a list of literals.
%
% Literals are represented as:
%   pos(Term)  for positive literal
%   neg(Term)  for negated literal
%
% Clauses:
%   C1:  ¬man(X) ∨ mortal(X)
%   C2:  ¬greek(X) ∨ man(X)
%   C3:  ¬philosopher(X) ∨ thinker(X)
%   C4:  greek(socrates)
%   C5:  philosopher(socrates)
%   C6:  ¬mortal(socrates)    (negated goal)

cnf(c1, [neg(man(X)),        pos(mortal(X))]).
cnf(c2, [neg(greek(X)),      pos(man(X))]).
cnf(c3, [neg(philosopher(X)),pos(thinker(X))]).
cnf(c4, [pos(greek(socrates))]).
cnf(c5, [pos(philosopher(socrates))]).
cnf(c6, [neg(mortal(socrates))]).  % Negated goal

% Utility: list all clauses
list_clauses :-
    cnf(Id, Clause),
    write(Id), write(' : '), writeln(Clause),
    fail.
list_clauses.

% ------------------------------------------------
% Step 8: Resolution implementation and execution
% ------------------------------------------------
% We now implement a small resolution engine that:
%   - Picks two clauses
%   - Selects complementary literals
%   - Unifies them
%   - Produces a resolvent
%
% If we derive the empty clause [], we have a
% contradiction and thus the original goal follows.

% Complementary literals:
complementary(neg(P), pos(Q)) :- P = Q.
complementary(pos(P), neg(Q)) :- P = Q.

% Remove first occurrence of an element from a list
remove_one(X, [X|Xs], Xs) :- !.
remove_one(X, [Y|Ys], [Y|Zs]) :-
    remove_one(X, Ys, Zs).

% Resolution of two clauses (just one resolvent)
resolve_two(Clause1, Clause2, Resolvent) :-
    % Standardize apart: copy both clauses so that
    % variables do not clash
    copy_term((Clause1, Clause2), (C1, C2)),
    member(L1, C1),
    member(L2, C2),
    complementary(L1, L2),
    remove_one(L1, C1, Rest1),
    remove_one(L2, C2, Rest2),
    append(Rest1, Rest2, Resolvent),
    !.  % just one resolvent for this simple demo

% Pretty printing of resolution step
print_resolution_step(Id1, Clause1, Id2, Clause2, Resolvent) :-
    write('Resolve '), write(Id1), write(': '), write(Clause1),
    write('  WITH  '), write(Id2), write(': '), write(Clause2), nl,
    write('  => Resolvent: '), writeln(Resolvent), nl.

% A specific resolution proof for this problem:
%
%   C2:  ¬greek(X) ∨ man(X)
%   C4:  greek(socrates)
%   ------------------------  (R1)
%        man(socrates)
%
%   C1:  ¬man(X) ∨ mortal(X)
%   R1:  man(socrates)
%   ------------------------  (R2)
%        mortal(socrates)
%
%   R2:  mortal(socrates)
%   C6:  ¬mortal(socrates)
%   ------------------------  (⊥)
%        []   (empty clause)

run_resolution_proof :-
    writeln('===== CNF CLAUSES ====='),
    list_clauses,
    writeln('========================'), nl,

    % Step 1: Resolve C2 and C4 -> R1
    cnf(c2, C2),
    cnf(c4, C4),
    resolve_two(C2, C4, R1),
    print_resolution_step(c2, C2, c4, C4, R1),

    % Step 2: Resolve C1 and R1 -> R2
    cnf(c1, C1),
    resolve_two(C1, R1, R2),
    print_resolution_step(c1, C1, r1, R1, R2),

    % Step 3: Resolve R2 and C6 -> []
    cnf(c6, C6),
    resolve_two(R2, C6, R3),
    print_resolution_step(r2, R2, c6, C6, R3),

    ( R3 == [] ->
        writeln('*** Empty clause derived: CONTRADICTION.'),
        writeln('*** Therefore, the original goal mortal(socrates) is proved.')
    ;
        writeln('Resolution did not derive empty clause.')
    ).

% ------------------------------------------------
% Convenience entry point
% ------------------------------------------------
% To run the full resolution refutation, load this file
% in your Prolog system (e.g., SWI-Prolog) and query:
%
%   ?- run_resolution_proof.
%
% Then take a screenshot of the final output showing
% the empty clause [] and the message that the goal is proved.
% ------------------------------------------------

