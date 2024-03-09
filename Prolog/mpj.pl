% mpj

:- op(1150,xfy,'if'),
   op(1150,xfy,'since'),
   op(1100,xfy,'or'),
   op(1000,xfy,'and'),
   op(900,fy,'~').

% this prints the justification.
demo(P) :- demo(P,J), ppj(J).

% true and false.
demo(true,true) :- !.
demo(false,nil) :- !, fail.

% conjunction
demo((P and Q),(Pj and Qj)) :-
	!,
	demo(P,Pj),
	demo(Q,Qj).

% disjunction
demo((P or Q),Pj) :- demo(P,Pj).
demo((P or Q),Qj) :- demo(Q,Qj).

% negation
demo((~P),_) :- demo(P,_), !, fail.
demo((~P),(~P)) :- !.

% apply a rule
demo(P,(P since (Rule and Qj))) :-
	(P if Q),
	copyTerm((P if Q),Rule),
	demo(Q,Qj).

% fall through to prolog
demo(P,prolog(P)) :- \+((P if _)),
	% the following on_exception simply calls the goal P, but if
	% P causes some error (e.g., if the underlying prolog has no
	% clauses at all for this goal), we simply fail instead
	% of stopping the prolog program.
	on_exception(Error,P,fail).

% pretty-prints a justification structure.
ppj(J) :- ppj1(J,0).

ppj1((P since (P if true) and true),In) :-
	!,
	nl,
	tab(In),
	write(P),
	write(' is a fact').

ppj1((P since Q),In) :-
	!,
	nl,
	tab(In),
	write(P),
	write(' since '),
	In2 is In+5,
	ppj1(Q,In2).

ppj1((P and Q),In) :-
	!,
	ppj1(P,In),
	ppj1(Q,In).

ppj1(P,In) :-
	nl,
	tab(In),
	write(P).

% T2 is a copyof term T1.
copyTerm(T1,T2) :-
	assert(temp(T1)),
	retract(temp(T2)).

% family data for MPJ

parent(adam,able) if true.
parent(adam,cain) if true.
parent(eve,able) if true.
parent(eve,cain) if true.
male(adam) if true.
female(eve) if true.
father(X,Y) if parent(X,Y) and male(X).
mother(X,Y) if parent(X,Y) and female(X).
sibling(X,Y) if
	father(Pa,X) and
	father(Pa,Y) and
	mother(Ma,X) and
	mother(Ma,Y) and
	~(X=Y).
