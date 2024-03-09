% add(L1, E, L2) - list L2 is L1 with element E added in some position. 
%   e.g. add([a, c],b,[a, b, c]). is true, as is add([a,c], b, [b, a, c])
add(T, E, [E | T]).  % add as car
add([H | T1], E, [H | T]):- add(T1, E, T). % add in cdr

% permutation(L1, L2) - list L2 is a permutation of L1
permutation([], []):-!.
permutation([H | T], L2):-permutation(T, TP), add(TP, H, L2).

% inOrder(L) - list L is in  numerical order
inOrder([_]):-!.
inOrder([H , H1 | T]):- H < H1, inOrder([H1|T]), !.

% sorted(L, L1) - L1 is a sorted version of L,  a list of numbers
%    This algorithm is worse than O(n * n!), so bad it serves as a warning
%    about how poorly a prolog program can perform
%    See merge.pl for a O(n log n) sort in prolog
sorted(L, L1):- permutation(L, L1), inOrder(L1), !.
