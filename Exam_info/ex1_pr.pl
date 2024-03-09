%% 0.A tv(sony)         tv(Sony)      ==> yes, Sony = sony
%% 0.B tv(Sony)         tv(Tv)        ==> yes, Tv = _??
%% 0.C bro(Bro, Bro)    brp(bob, X)   ==> yes, X = bob
%% 0.D eats(Cat, fish)  feeds(joe,X)  ==> error
%% 0.E last(a,[b,c]) 	last(X,[X|T]) ==> no

%% 1
smaller_of(N1, N2, L):-
	N1 =< N2,
	L is N1.

smaller_of(_, N2, L):-
	L is N2.

%% 2
square_all([H|[]], Results):-
	R is H * H,
	Results = [R].

square_all([H|T], Results):-
	R is H * H,
	square_all(T, Res_aux),
	append([R], Res_aux, Results).

%% 3
listSum(node(Num, []), Sum):-
	Sum is Num.

listSum(node(Num, Node), Sum):-
	listSum(Node, Sum_aux),
	Sum is Num + Sum_aux.

%% 4
bstNotFound([], Value).

bstNotFound([E, Rt, Lt], Value):-
	E == Value,
	!,fail.

bstNotFound([E, Rt, Lt], Value):-
	Value < E,!,
	bstNotFound(Rt, Value).

bstNotFound([E, Rt, Lt], Value):-
	bstNotFound(Lt, Value).
