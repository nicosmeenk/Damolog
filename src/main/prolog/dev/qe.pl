% The alphabeta algorithm to choose the best move to play.

%alphabeta(Pos[], Alpha, Beta, 
alphabeta(Pos, _, _, _, Val, 0) :-
        staticval(Pos, Val), !.

alphabeta(Pos, Alpha, Beta, GoodPos, Val, Depth) :-
        moves(Pos ,PosList, Depth, LMoves), !,
        NewDepth is Depth - 1,
        boundedbest(PosList, Alpha, Beta, GoodPos, Val, NewDepth).

alphabeta(Pos, Alpha, Beta, GoodPos, Val, Depth) :-
      staticval(Pos, Val).

boundedbest([Pos | PosList], Alpha, Beta, GoodPos, GoodVal, Depth) :-
        alphabeta(Pos, Alpha, Beta, _, Val, Depth),
        goodenough(PosList, Alpha, Beta, Pos, Val, GoodPos, GoodVal, Depth).

goodenough([], _, _, Pos, Val, Pos, Val, _) :- !.               % No other candidate

goodenough(_, Alpha, Beta, Pos, Val, Pos, Val, _) :-
        min_to_move(Pos), Val > Beta, !;                        % Maximizer attained upper bound
        max_to_move(Pos), Val < Alpha, !.                       % Minimizer attained lower bound

goodenough(PosList, Alpha, Beta, Pos, Val, GoodPos, GoodVal, Depth) :-
        newbounds(Alpha, Beta, Pos, Val, NewAlpha, NewBeta),                    % Refine bounds  
        boundedbest(PosList, NewAlpha, NewBeta, Pos1, Val1, Depth),
        betterof(Pos, Val, Pos1, Val1, GoodPos, GoodVal).

newbounds(Alpha, Beta, Pos, Val, Val, Beta) :-
        min_to_move(Pos), Val > Alpha, !.                       % Maximizer increased lower bound 

newbounds(Alpha, Beta, Pos, Val, Alpha, Val) :-
        max_to_move(Pos), Val < Beta, !.                        % Minimizer decreased upper bound 

newbounds(Alpha, Beta, _, _, Alpha, Beta).                      % Otherwise bounds unchanged 

betterof(Pos, Val, Pos1, Val1, Pos, Val)  :-                    % Pos better than Pos1 
        min_to_move(Pos), Val > Val1, !;
        max_to_move(Pos), Val < Val1, !.

betterof(_, _, Pos1, Val1, Pos1, Val1).                         % Otherwise Pos1 better


% A large value to start the alphabeta algorithm with.
start_infinity(10000).

% A large value to mark an end of the game and a win position for one of the players.
infinity(1000).

% Statically evaluates a position for the alphabeta algorithm.
staticval(pos(_, Val, _), Val).

% The max to move player is the player to move next.
max_to_move(pos(NextToMove, _, _)) :-
        next_to_move(0, NextToMove).

% The min to move player is the other player.
min_to_move(Pos) :-
        not max_to_move(Pos).

% Getting a list of all possible moves for the alphabeta algorithm.
moves(Pos, PosList, Depth, LMoves) :-
        list_to_pos(Pos, 1),
        next_to_move(1, NextToMove),
        get_all_moves_sorted(1, NextToMove, LMoves),
        retract_pos(1),
        create_pos_list_from_moves_list(Pos, LMoves, PosList).

% Creates a position from every move possible for the player.
create_pos_list_from_moves_list(Pos, [[_, move(_, FX, FY, TX, TY)] | LMoves], [Pos1 | PosList]) :-
        list_to_pos(Pos, 2),
        make_move(2, FX, FY, TX, TY),
        position_value(2, Val),
        pos_to_list(2, Pos1, Val),
        retract_pos(2),
        create_pos_list_from_moves_list(Pos, LMoves, PosList), !.

create_pos_list_from_moves_list(_, [], []).
