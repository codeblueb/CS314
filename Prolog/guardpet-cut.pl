guardpet(A):- domesticated(A), write([A, domesticated]),
	      scary(A).
guardpet(killerbee).

gp1(A):- domesticated(A), !, write([A, domesticated]),
	 scary(A).
gp1(killerbee).

gp2(A):- domesticated(A), write([A, domesticated]),
	 scary(A), !.
gp2(killerbee).

gp3(A):- domesticated(A), write([A, domesticated]),
	 scaryc(A).  % uses scaryc, not scary
gp3(killerbee).

gp4(A):- domesticated(A), write([A, domesticated]),
	 scaryn(A).  % uses scaryn
gp4(killerbee).

domesticated(elephant).
domesticated(horse).
domesticated(cat).
domesticated(goldfish).
domesticated(dog).

scaryc(A):- large(A), write([A, largec]),!.
scaryc(A):- loud(A), write([A, loudc]).

scary(A):- large(A), write([A, large]).
scary(A):- loud(A), write([A, loud]).

scaryn(A):- large(A), write([A, large]).
scaryn(A):- \+large(A), loud(A), write([A, loud]).

loud(dog).
loud(elephant).

large(elephant).
large(horse).

demo(Pet):- member(Pet, [goldfish, dog, cat, killerbee]),gp1(Pet).


