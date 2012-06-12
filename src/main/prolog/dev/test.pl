var1(1).

test(X, R, I) :-
	W = 3,
	R is (X + 1 + W),
	I is infinity.
	
max(A, B, R ) :-
	(A >= B, R is A); ( A < B, R is B).