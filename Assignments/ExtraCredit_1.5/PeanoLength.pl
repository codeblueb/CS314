lstlength([], SIZE):- SIZE is 0.
lstlength([_|T], SIZE):- lstlength(T, SMALLER), SIZE is SMALLER+1.
decode(SIZE, 0).
decode(T,A):- decode(SMALLER, B), A is B+1.
encode(0,SIZE).
encode(A,SIZE):- A > 0, B is A-1, encode(B,SMALLER).
