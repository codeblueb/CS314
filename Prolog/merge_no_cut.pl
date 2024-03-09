% merge(L1, L2, Merged) - L1 and L2 are ordered lists of 
%  numbers.  Merged is a merged list of all the numbers in 
%  both lists
merge([ ], L, L).
merge(L, [ ], L).
merge([H1 | T1], [H2 | T2], [H1 | T3]):-
	H1<H2, merge(T1, [H2 | T2], T3).
merge([H1 | T1], [H2 | T2], [H2 | T3]):-
	H2=<H1, merge(T2, [H1 | T1], T3).

% split(L, LA, LB) - L is a list of numbers, LA and LB together
%     hold the same numbers as L, and length(LA) is within 1 of 
%     length(LB)
split([ ],[ ], [ ]).
split([A], [A], [ ]).
split([A | [B | T] ], [A | T1], [B | T2]):- split(T, T1, T2).

% msort(L, LS) - L is a list of numbers. LS is a sorted
%     version of L
msort([ ], [ ]).
msort([A], [A]).
msort(L, S):-
	split(L, L1, L2),
	msort(L1, L1S),
	msort(L2, L2S),
	reportMerge(L1S, L2S),
	merge(L1S, L2S, S).

reportMerge(L1, L2):- write(merge),
		      write([L1, L2]),
        	      nl.

