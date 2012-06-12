%%%%%%%%%%%%%%%%%%%%
% Tree for moves
%%

%make nodes, edges dynamically for assert
:- dynamic node/1.
:- dynamic edge/2.

node([0,0]). %A node is a list [from, to, Heuristic]

dummyTree :-
	addNode([0,0], [0,1]),addNode([0,0], [0,2]),
	addNode([0,1], [1,2]),addNode([1,2], [2,2]).

addNode(Parent, Node) :-
	assert(node(Node)),
	assert(edge(node(Parent), node(Node))).

removeNode(Node) :-
	(   edge(node(Node), node(X)) ->
	removeNode(X);
	!
	),
	retract(edge(_, node(Node))),
	retract(node(Node)).

isLeaf(Node) :-
	edge(_, node(Node)),
	\+ edge(node(Node), _).

%%%%%%%%%%%%%
% The alpha-beta-algorithm
%%
alphabeta(Node, Depth, _, _, _, R):-
	isLeaf(Node),
	R is evaluate(Node, R).
alphabeta(Node, Depth, Alpha, Beta, 0, R):-
	edge(node(Node), node(X)),
	D is Depth-1,
	alphabeta(X, D, Alpha, Beta, 1, R),
	max(Alpha, R, Alpha),
	(   Alpha >= Beta -> !).
alphabeta(Node, Depth, Alpha, Beta, 1, R):-
	edge(node(Node), node(X)),
	D is Depth-1,
	alphabeta(X, D, Alpha, Beta, 0, R),
	min(Beta, R, Beta),
	(   Alpha >= Beta -> !),
	R is Beta.

max(X, Y, X) :- X >= Y,!.
max(X, Y, Y) :- X < Y.

min(X, Y, X) :- X =< Y,!.
min(X, Y, Y) :- X > Y.

%%%%%%%%%%%%%%
% evaluation of a position
%%%%
%
evaluate([F,T], R):-
	F1 is F+1,
	evaluate(F1,R).
evaluate(F,F).
%%%%%%%%%%%%%%
% generate moves
%%%















