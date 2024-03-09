%%%
%%% N QUEENS PROBLEM
%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% AUXILIARIES
%%%

%%% int_leq(-I, +M) I is an integer  such that 1 =< I =< M
%%% needs to generate I so cannot just test 1 =< I, I =< M
int_leq(1, M):- M>0.
int_leq(I, M):- M>1, M1 is M-1, int_leq(I1, M1), I is I1+1.

%%% an incorrect version of above - after M succeeds it
%%%      infinite loops instead of failing.  Note lack of M<1 in last clause.
badIle(1,_).
badIle(I, M):- M1 is M-1, badIle(I1, M1), I is I1+1, I =< M.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% N QUEENS AUXILIARIES
%%%

%%% The number of queens/size of board
queen_no(4).

%%% R is a rank (a column of squares) on the board
rank(R):- queen_no(N), int_leq(R, N).

%%% F is a file (a ros of squares) on the board
file(F):- queen_no(N), int_leq(F, N).

%%% attacks([R1,F1],[R2,F2]):
%%%   does a queen on the square at rank R1, file F1 attack the square
%%%   rank R2, file F2 or vice versa.
%%%
attacks([R,_],[R,_]).
attacks([_,F],[_,F]).
attacks([R1,F1],[R2,F2]):- diagonal([R1,F1],[R2,F2]).

%%% Are two squares on the same diagonal?
diagonal([X,Y],[X,Y]).
diagonal([X1,Y1],[X2,Y2]):- N is Y2-Y1, D is X2-X1, Q is N/D, Q =:= 1.
diagonal([X1,Y1],[X2,Y2]):- N is Y2-Y1, D is X2-X1, Q is N/D, Q =:= -1.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% N QUEENS SOLUTION
%%%

%%% placement(N, L): L is a list of positions on an NxN chess board
placement(0,[ ]).
placement(N, [[R,F]|P]):- N>0, rank(R), file(F), N1 is N-1, placement(N1, P).

%%% ok_place(L): L is a placement where no queen attacks any other queen
ok_place([ ]).
ok_place([P1 | Rest_ps]):- no_attacks(P1,Rest_ps), ok_place(Rest_ps).

%%% no_attacks([R,F], L): a queen at square [R,F] doesn't attack any square
%%%    in list L
no_attacks(_,[ ]).
no_attacks([R,F],[[R2,F2]|P]):- not(attacks([R,F],[R2,F2])),
				no_attacks([R,F],P).

%%% Place N queens (on an NxN board)
queens(P):- queen_no(N), placement(N, P), ok_place(P).
