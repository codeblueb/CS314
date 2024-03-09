% parent(X, Y):  Y is X's parent
parent(bob, ann).
parent(chuck, bob).
parent(bob, al).
parent(chuck, barbara).
parent(barbara, arthur).
parent(barbara, abby).

% anc_bad(X, Y): Y is X's ancestor.  Gives infinite recursion
anc_bad(X, Y):- anc_bad(X, Z), parent(Z, Y).
anc_bad(X, Y):- parent(X, Y).

% anc_good(X, Y):  Y is X's ancestor.  This order works.
anc_good(X, Y):- parent(Z, Y), anc_good(X, Z).
anc_good(X, Y):- parent(X, Y).
