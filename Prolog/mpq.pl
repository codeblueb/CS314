% MPQ

:- op(1150,xfy,'if'),
   op(1150,xfy,'since'),
   op(1100,xfy,'or'),
   op(1000,xfy,'and'),
   op(900,fy,'~').

% another demo/1 rule:
demo(P) :- askable(P), !, ask(P).

% note: don't fall through to prolog until AFTER asking questions.
% fall through to prolog:
% note \+/1 instead of not/1
demo(P) :- \+((P if _)), P.

% if 'macro':
if(P,Q,R) :- P, !, Q.
if(P,Q,R) :- R.

% remember a previous answer.
ask(P) :- answer(P,A), !, A=true.

% ask questions and remember the result.

:- dynamic answer/2.
ask(P) :-
	if(ask1(P),Answer=true,Answer=false),
	assert(answer(P,Answer)),
	!,
	Answer=true.

% if we know a special way to ask, then use it.
ask1(P) :- toAsk(P,Method), !, Method.

% the default way to ask if no toAsk method.
ask1(P) :- askYesNo(['is ',P,' true?']).

%askYesNo(X) asks a yes/no question Q.
askYesNo(Q) :- msg(Q), getYesNo.

% getYesNo gets a valid yes/no answer
%   getyesno succeeds if the answer is positive and fails if negative.
getYesNo :- read(Answer), checkYesNo(Answer).

% interprets a legal response or reasks.
checkYesNo(A) :- member(A,[yes,y,yup,yeh]), !.
checkYesNo(A) :- member(A,[no,n,nope]), !, fail.
checkYesNo(A) :- msg('Enter "yes" or "no".'), getYesNo.

% note: msg/1 not built-into Quintas Prolog!
msg([]) :- !.
msg([X|L]) :- msg(X),msg(L), !.
msg(nl) :- nl, !.
msg(X) :- write(X), !.

%handout, p.7 stuff:

diagnosis(P,Diseases) :-
	bagof(D,(disease(D),demo(hasDisease(P,D))),Diseases).

% these are all the diseases
disease(commonCold).
disease(flu).
disease(colic).

% diagnostic rules.
foo(a,b).

hasDisease(P,commonCold) if
	symptom(P,fever) and 
	symptom(P,congestion) and
	~(hypocondriac(P)).

hasDisease(P,flu) if
	symptom(P,vomiting) and
	symptom(P,fever).

hasDisease(P,colic) if
	infant(P) and
	symptom(P,abdominalPain) and
	~(symptom(P,vomiting)).

% interaction support.

askable(symptom(_,_)).
askable(hypocondriac(_)).
askable(infant(_)).

toAsk(symptom(P,S),
	askYesNo(['does ',P,' show any signs of ',S,'? '])).

toAsk(hypocondriac(P),
	askYesNo(['is ',P,' a hypocondriac? '])).

toAsk(infant(P),
	askYesNo(['is ',P,' less than one year old? '])).
