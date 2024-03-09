% prolog in prolog

:- op(1150,xfy,'if'),
	op(1100,xfy,'or'),
	op(1000,xfy,'and'),
	op(900,fy,'~').

% true succeeds.
demo(true) :- !.

% false fails.
demo(false) :- !, fail.

% conjunction:
demo((P and Q)) :- !, demo(P), demo(Q).

% disjunction:
demo((P or Q)) :- demo(P).
demo((P or Q)) :- demo(Q).

% negation:
demo(~P) :- demo(P), !, fail.
demo(~P) :- !.

% apply a rule:
demo(P) :- (P if Q), demo(Q).

