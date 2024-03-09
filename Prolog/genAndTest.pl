% generate and test to find the integer square root of 50
introot(X, N) :- gen(N), test(N, X).

introotcut(X, N) :- gen(N), test(N, X),!.

gen(1). 
gen(N):-gen(N1), N is N1+1.

test(N, X):- S is N*N, S=<X, S1 is (N+1)*(N+1), S1>X.
