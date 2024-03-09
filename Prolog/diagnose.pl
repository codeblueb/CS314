diagnosis(P, Diseases):-bagof(D, (disease(D), hasDisease(P, D)),Diseases).

disease(commonCold).
disease(flu).
disease(colic).

hasDisease(P, commonCold):- 
  symptom(P, fever), symptom(P, congestion), \+hypocondriac(P).

hasDisease(P, flu):- symptom(P, fever), symptom(P, vomiting).

hasDisease(P, colic):- 
  infant(P), symptom(P, tummyPain), \+symptom(P, vomiting).

hypocondriac(P):- askNum(['visits in last 6 months '], T), T>10.

infant(P):-askNum(['age in months '], M), M<6.

symptom(P, Symptom):-askyn(P, Symptom).

askyn(P, Symptom):-msg(['does ',P, ' have ', Symptom]), read(Ans),!,Ans=='y'.

askNum(M, N):-msg(M), read(N).

msg([]) :- !.
msg([X|L]) :- msg(X),msg(L), !.
msg(nl) :- nl, !.
msg(X) :- write(X), !.




