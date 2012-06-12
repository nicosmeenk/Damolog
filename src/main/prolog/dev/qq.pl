
% Initializing that the first player moves first.
init_next_to_move :-
        retractall(next_to_move(_, _)),
        assert(next_to_move(0, first)), !.
init_next_to_move :-
        assert(next_to_move(0, first)), !.
        
% Getting the other player to move.
other_player(first, second).
other_player(second, first).

% Getting the color of the player.
player_color(first, Color) :-
        color_first(Color).

player_color(second, Color) :-
        color_second(Color).

% Round a real number.
round(X, RoundX) :-
        A is X - X // 1,
        A >= 0.5, !,
        RoundX is X // 1 + 1.
round(X, RoundX) :-
        RoundX is X // 1.


% The size of a single hex.
board_hex_size(30).

% The size of the selection hex.
sel_hex_size(SSize) :-
        board_hex_size(BSize),
        SSize is BSize - 2.

% Getting the size of the game window.
calc_window_size(WindowWidth, WindowHeight) :-
        board_size(BSize),
        board_hex_size(HSize),
        WW is 2 * BSize * 3 * HSize / 2,
        round(WW, WindowWidth),
        sqrt3(Sqrt3),
        WH is (2 * BSize - 1) * Sqrt3 * HSize + HSize,
        round(WH, WindowHeight).

% The main Predicate of the game.
% Starts the game.
show_hex :-
        DStyle = [ws_caption,ws_border,dlg_ownedbyprolog],
        CStyle = [ws_child,ws_visible],
        show_options,                           % Shows the options window.
        init_next_to_move,
        calc_window_size(WindowWidth, WindowHeight),
        DialogHeight is WindowHeight + 70,
        wdcreate(hex, `Prolog - Hexxagon`, 100, 100, WindowWidth, DialogHeight, DStyle),
        wccreate((hex,1), grafix, ``, 0, 0, WindowWidth, WindowHeight, CStyle),
        wgfxmap((hex, 1), 1, 1, 1, 1),
        wsize((hex, 1), X, Y, X1, Y1),
        window_handler(hex, hex_handler),
        insert_all_hex(HexList),
        ButtonY is WindowHeight + 5,
        ButtonWidth is WindowWidth - 25,
        wccreate((hex, 3), button, `End Game`, 10, ButtonY, ButtonWidth, 26, CStyle),
        change_colors,
        show_dialog(hex),
        retractall(hex(_, X, Y, State)),
        check_starting_player.

% If computer plays first, make a move.
check_starting_player :-
        firstPlayer(computer),  
        play_best_move.

% Delete the 'Index' position by retracting all its hexes.
retract_pos(Index) :-
        retractall(next_to_move(Index, _)),
        retractall(hex(Index, _, _, _)), !.
retract_pos(_) :- !.

% Converts position 'Index' to a list of hexes.
pos_to_list(Index, pos(NextToMove, Val, LPos), Val) :-
        next_to_move(Index, NextToMove),
        findall(hex(X, Y, State), hex(Index, X, Y, State), LPos).

% Converts a list to a position 'Index'
list_to_pos(pos(NextToMove, _, LPos), Index) :-
        retract_pos(Index),
        assert(next_to_move(Index, NextToMove)),
        assert_pos_rec(LPos, Index).

% The recursive implemetation of the 'list_to_pos' predicate.
assert_pos_rec([], _).

assert_pos_rec([hex(X, Y, State) | LPos], Index) :-
        assert(hex(Index, X, Y, State)),
        assert_pos_rec(LPos, Index).

% Checking that the hex (X, Y) is valid in the position 'Index'
is_valid_hex(Index, X, Y) :-
        hex(Index, X, Y, State),
        not State = none.

% Initializing the game board according to the selected size.
change_colors :-
        board_size(3),
        change_hex_state(0, 3, 1, first),
        change_hex_state(0, 3, 9, second),
        change_hex_state(0, 3, 5, none), !.

change_colors :-
        board_size(5),
        change_hex_state(0, 5, 1, first),
        change_hex_state(0, 9, 13, first),
        change_hex_state(0, 1, 13, first),
        change_hex_state(0, 9, 5, second),
        change_hex_state(0, 5, 17, second),
        change_hex_state(0, 1, 5, second),
        change_hex_state(0, 4, 8, none),
        change_hex_state(0, 6, 8, none),
        change_hex_state(0, 5, 11, none), !.

change_colors :-
        board_size(7),
        change_hex_state(0, 7, 1, first),
        change_hex_state(0, 1, 19, first),
        change_hex_state(0, 13, 19, first),
        change_hex_state(0, 1, 7, second),
        change_hex_state(0, 13, 7, second),
        change_hex_state(0, 7, 25, second),
        change_hex_state(0, 7, 5, none),
        change_hex_state(0, 6, 6, none),
        change_hex_state(0, 8, 6, none),
        change_hex_state(0, 3, 9, none),
        change_hex_state(0, 3, 11, none),
        change_hex_state(0, 4, 8, none),
        change_hex_state(0, 11, 9, none),
        change_hex_state(0, 11, 11, none),
        change_hex_state(0, 10, 8, none),
        change_hex_state(0, 3, 17, none),
        change_hex_state(0, 3, 15, none),
        change_hex_state(0, 4, 18, none),
        change_hex_state(0, 11, 17, none),
        change_hex_state(0, 11, 15, none),
        change_hex_state(0, 10, 18, none),
        change_hex_state(0, 7, 21, none),
        change_hex_state(0, 6, 20, none),
        change_hex_state(0, 8, 20, none),
        change_hex_state(0, 7, 13, none), !.

% Changing a state of the hex (X, Y) in the position 'Index'
change_hex_state(Index, X, Y, NewState) :-
        is_valid_hex(Index, X, Y), !,
        retract(hex(Index, X, Y, _)),
        assert(hex(Index, X, Y, NewState)), !.  
change_hex_state(Index, X, Y, NewState).

% Removing selectd hex from.
retract_selected_hex :-
        retractall(selected_hex(_, _)), !.
retract_selected_hex.

% Changing the selection of a single hex.
change_selected_hex(X, Y) :-
        selected_hex(X, Y), !,          % if the hex was already selected, remove the selection.
        retract_selected_hex.

change_selected_hex(X, Y) :-
        retract_selected_hex,
        is_valid_hex(0, X, Y), !,
        assert(selected_hex(X, Y)).     % selecting the new hex.
change_selected_hex(X, Y).

% Creating a list of commands to draw all the board.
create_board_commands(Commands) :-
        color_border(CBorder),
        color(CBorder, [CBorderR, CBorderG, CBorderB]),
        color_none(CNone),
        color(CNone, [CNoneR, CNoneG, CNoneB]),
        color_empty(CEmpty),
        color(CEmpty, [CEmptyR, CEmptyG, CEmptyB]),
        color_first(CFirst),
        color(CFirst, [CFirstR, CFirstG, CFirstB]),
        color_second(CSecond),
        color(CSecond, [CSecondR, CSecondG, CSecondB]),
        color_selected_hex(CSelHex),
        color(CSelHex, [CSelHexR, CCSelHexG, CCSelHexB]),
        color_close_neighbour(CCloseNeighbour),
        color(CCloseNeighbour, [CCloseNeighbourR, CCloseNeighbourG, CCloseNeighbourB]),
        color_far_neighbour(CFarNeighbour),
        color(CFarNeighbour, [CFarNeighbourR, CFarNeighbourG, CFarNeighbourB]),
        findall(LHex, (hex(0, HX, HY, _), draw_single_hex(HX, HY, LHex)), LBorders),
        findall(LFill, (hex(0, HX, HY, empty), fill_single_hex(HX, HY, LFill)), LEmpty),
        findall(LFill, (hex(0, HX, HY, none), fill_single_hex(HX, HY, LFill)), LNone),
        findall(LFill, (hex(0, HX, HY, first), fill_single_hex(HX, HY, LFill)), LFirst),
        findall(LFill, (hex(0, HX, HY, second), fill_single_hex(HX, HY, LFill)), LSecond),
        append([pen(CBorderR, CBorderG, CBorderB, 2)], LBorders, LAfterBorders),
        append(LAfterBorders, [brsh(CNoneR, CNoneG, CNoneB, 0), fill(1, 1, CBorderR, CBorderG, CBorderB)], LAfterBackground),
        append(LAfterBackground, [brsh(CEmptyR, CEmptyG, CEmptyB, 0)], LAfterEmptyBrush),
        append(LAfterEmptyBrush, LEmpty, LAfterEmpty),
        append(LAfterEmpty, [brsh(CNoneR, CNoneG, CNoneB, 0)], LAfterNoneBrush),
        append(LAfterNoneBrush, LNone, LAfterNone),
        append(LAfterNone, [brsh(CFirstR, CFirstG, CFirstB, 0)], LAfterFirstBrush),
        append(LAfterFirstBrush, LFirst, LAfterFirst),
        append(LAfterFirst, [brsh(CSecondR, CSecondG, CSecondB, 0)], LAfterSecondBrush),
        append(LAfterSecondBrush, LSecond, LAfterSecond),
        (
                selected_hex(SX, SY), !,
                sel_hex_size(SSize),
                findall(LHex, draw_single_hex(SX, SY, SSize, LHex), LSelHex),
                findall(LHex, (close_neighbour_hex(0, SX, SY, X, Y, empty), draw_single_hex(X, Y, SSize, LHex)), LCloseNeighbour),
                findall(LHex, (far_neighbour_hex(0, SX, SY, X, Y, empty), draw_single_hex(X, Y, SSize, LHex)), LFarNeighbour),
                append(LAfterSecond, [pen(CFarNeighbourR, CFarNeighbourG, CFarNeighbourB, 2)], LAfterFarPen),
                append(LAfterFarPen, LFarNeighbour, LAfterFar),
                append(LAfterFar, [pen(CCloseNeighbourR, CCloseNeighbourG, CCloseNeighbourB, 2)], LAfterClosePen),
                append(LAfterClosePen, LCloseNeighbour, LAfterClose),
                append(LAfterClose, [pen(CSelHexR, CCSelHexG, CCSelHexB, 2)], LAfterSelectedPen),
                append(LAfterSelectedPen, LSelHex, List)
                ;
                List = LAfterSecond
        ),
        create_metadata_list(LMetadata),
        append(List, LMetadata, Commands).

% Creates a list of commands to draw the metadata (score, next player to move, ...)
create_metadata_list(LMetadata) :-
        board_hex_size(HSize1),
        HSize is HSize1 - 2,
        color_border(CBorder),
        color(CBorder, [CBorderR, CBorderG, CBorderB]),
        color_first(CFirst),
        color(CFirst, [CFirstR, CFirstG, CFirstB]),
        color_second(CSecond),
        color(CSecond, [CSecondR, CSecondG, CSecondB]),
        color_empty(CEmpty),
        color(CEmpty, [CEmptyR, CEmptyG, CEmptyB]),
        color_text(CText),
        color(CText, [CTextR, CTextG, CTextB]),
        warea((hex, 1), XL, YT, W, H),
        DisFromBorderFirst is HSize + 5,
        draw_single_hex_lines(DisFromBorderFirst, DisFromBorderFirst, HSize, LinesFirst),
        DisFromBorderSecond is W - HSize - 5,
        draw_single_hex_lines(DisFromBorderSecond, DisFromBorderFirst, HSize, LinesSecond),
        DisFromBorderEmpty is H - HSize - 5,
        draw_single_hex_lines(DisFromBorderFirst, DisFromBorderEmpty, HSize, LinesEmpty),
        draw_single_hex_lines(DisFromBorderSecond, DisFromBorderEmpty, HSize, LinesTurn),
        next_to_move(0, NextToMove),
        player_color(NextToMove, CNextToMove),
        color(CNextToMove, [CNextToMoveR, CNextToMoveG, CNextToMoveB]),
        DisFromBorderFirstText is DisFromBorderFirst - 6,
        DisFromBorderSecondText is DisFromBorderSecond - 6,
        DisFromBorderEmptyText is DisFromBorderEmpty - 6,
        findall(_, hex(0, _, _, first), LFirstCount),
        findall(_, hex(0, _, _, second), LSecondCount),
        findall(_, hex(0, _, _, empty), LEmptyCount),
        length(LFirstCount, FirstCount),
        length(LSecondCount, SecondCount),
        length(LEmptyCount, EmptyCount),
        number_string(FirstCount, FirstCountStr),
        number_string(SecondCount, SecondCountStr),
        number_string(EmptyCount, EmptyCountStr),
        DisNextTurnText is DisFromBorderSecond - 15,
                position_value(0, Val),
                number_string(Val, ValStr),
        LMetadata = [fore(CTextR, CTextG, CTextB),
                     pen(CBorderR, CBorderG, CBorderB, 2),
                     LinesFirst,
                     LinesSecond,
                     LinesEmpty,
                     LinesTurn,
                     brsh(CFirstR, CFirstG, CFirstB, 0),
                     fill(DisFromBorderFirst, DisFromBorderFirst, CBorderR, CBorderG, CBorderB),
                     back(CFirstR, CFirstG, CFirstB),
                     text(DisFromBorderFirstText, DisFromBorderFirstText, FirstCountStr),
                     brsh(CSecondR, CSecondG, CSecondB, 0),
                     fill(DisFromBorderSecond, DisFromBorderFirst, CBorderR, CBorderG, CBorderB),
                     back(CSecondR, CSecondG, CSecondB),
                     text(DisFromBorderSecondText, DisFromBorderFirstText, SecondCountStr),
                     brsh(CEmptyR, CEmptyG, CEmptyB, 0),
                     fill(DisFromBorderFirst, DisFromBorderEmpty, CBorderR, CBorderG, CBorderB),
                     back(CEmptyR, CEmptyG, CEmptyB),
                     text(DisFromBorderFirstText, DisFromBorderEmptyText, EmptyCountStr),
                     brsh(CNextToMoveR, CNextToMoveG, CNextToMoveB, 0),
                     fill(DisFromBorderSecond, DisFromBorderEmpty, CBorderR, CBorderG, CBorderB),
                     back(CNextToMoveR, CNextToMoveG, CNextToMoveB),
                     text(DisNextTurnText, DisFromBorderEmptyText, `Next`)].
        
% Getting all close neighbours of a cell.
close_neighbour_hex(Index, X, Y, NX, NY, State) :-
        (NX is X,     NY is Y + 2, hex(Index, NX, NY, State));
        (NX is X + 1, NY is Y + 1, hex(Index, NX, NY, State));
        (NX is X + 1, NY is Y - 1, hex(Index, NX, NY, State));
        (NX is X,     NY is Y - 2, hex(Index, NX, NY, State));
        (NX is X - 1, NY is Y - 1, hex(Index, NX, NY, State));
        (NX is X - 1, NY is Y + 1, hex(Index, NX, NY, State)).

% Getting all far neighbours of a cell.
far_neighbour_hex(Index, X, Y, NX, NY, State) :-
        (NX is X,     NY is Y + 4, hex(Index, NX, NY, State));
        (NX is X + 1, NY is Y + 3, hex(Index, NX, NY, State));
        (NX is X + 2, NY is Y + 2, hex(Index, NX, NY, State));
        (NX is X + 2, NY is Y,     hex(Index, NX, NY, State));
        (NX is X + 2, NY is Y - 2, hex(Index, NX, NY, State));
        (NX is X + 1, NY is Y - 3, hex(Index, NX, NY, State));
        (NX is X,     NY is Y - 4, hex(Index, NX, NY, State));
        (NX is X - 1, NY is Y - 3, hex(Index, NX, NY, State));
        (NX is X - 2, NY is Y - 2, hex(Index, NX, NY, State));
        (NX is X - 2, NY is Y,     hex(Index, NX, NY, State));
        (NX is X - 2, NY is Y + 2, hex(Index, NX, NY, State));
        (NX is X - 1, NY is Y + 3, hex(Index, NX, NY, State)).

% Making a move on pos 'Index' from hex (FX, FY) to hex (TX, TY).
make_move(Index, FX, FY, TX, TY) :-
        close_neighbour_hex(Index, FX, FY, TX, TY, empty),
        revert_hexes_after_move(Index, TX, TY), !.

make_move(Index, FX, FY, TX, TY) :-
        far_neighbour_hex(Index, FX, FY, TX, TY, empty),
        change_hex_state(Index, FX, FY, empty),
        revert_hexes_after_move(Index, TX, TY), !.

make_move(Index, FX, FY, TX, TY).

% Reverts all neighbour hexes after the move.
revert_hexes_after_move(Index, TX, TY):-
        next_to_move(Index, NextToMove),
        change_hex_state(Index, TX, TY, NextToMove),
        other_player(NextToMove, OtherPlayer),
        findall(pos(X, Y), close_neighbour_hex(Index, TX, TY, X, Y, OtherPlayer), LHexes),
        revert_hex_list(Index, LHexes, NextToMove),
        change_next_to_move(Index).

% Reverts all hexes in the list.
revert_hex_list(_, [], _) :- !.

revert_hex_list(Index, [pos(X, Y) | LHexes], NextToMove) :-
        change_hex_state(Index, X, Y, NextToMove),      
        revert_hex_list(Index, LHexes, NextToMove).

% Changing the next player to move.
change_next_to_move(Index) :-
        next_to_move(Index, NextToMove),
        other_player(NextToMove, OtherPlayer),
        retract(next_to_move(Index, NextToMove)),
        assert(next_to_move(Index, OtherPlayer)), !.

% Get all legal moves in the position 'Index'.
get_all_moves(Index, Player, LMoves) :-
        get_all_far_moves(Index, Player, LFar),
        get_all_close_moves(Index, Player, LClose),
        append(LClose, LFar, LMoves), !.

get_all_moves(_, _, []).

% Get the list of moves sorted by its position value.
get_all_moves_sorted(Index, Player, LSortedMoves) :-
        get_all_moves(Index, Player, LAllMoves),
        length(LAllMoves, Len),
        Len > 0,
        sort(LAllMoves, LSortedMovesReversed),
        reverse(LSortedMovesReversed, LSortedMoves).

% Getting all far moves of the position.
get_all_far_moves(Index, Player, LMoves) :-
        findall([Result, move(Index, FX, FY, TX, TY)], (hex(Index, FX, FY, Player),     %***
                                                      far_neighbour_hex(Index, FX, FY, TX, TY, empty),
                                                      calc_move_value(Index, TX, TY, Result, far)), LMoves), !.

get_all_far_moves(_, _, []).

% Getting all close moves of the position.
get_all_close_moves(Index, Player, LMoves) :-
        setof(pos(Index, X, Y), X1 ^ Y1 ^ (hex(Index, X, Y, empty),
                           close_neighbour_hex(Index, X, Y, X1, Y1, Player)), LPos),
        create_close_moves(LPos, Player, LMoves), !.

get_all_close_moves(_, _, []).

% creating a list of close moves from a list of all close neighbours.
% we need it because close moves can be duplicated - two different close moves will lead to the same position.
create_close_moves([], _, []).

create_close_moves([pos(Index, X, Y) | LPos], Player, [[Result, move(Index, FX, FY, TX, TY)] | LMoves]) :-      %***
        get_one_close_neighbour(Index, X, Y, Player, [Result, move(Index, FX, FY, TX, TY)]),                                                                    %***
        calc_move_value(Index, TX, TY, Result, close),
        create_close_moves(LPos, Player, LMoves).       

% Getting one close neighbour of a cell.
get_one_close_neighbour(Index, TX, TY, Player, [_, move(Index, FX, FY, TX, TY)]) :-                     %***
        !, close_neighbour_hex(Index, TX, TY, FX, FY, Player).

% Calculating the value of the move
calc_move_value(Index, TX, TY, Result, close) :-
        count_neighbours(Index, TX, TY, Count),
        Result is Count * 2 + 1, !.

calc_move_value(Index, TX, TY, Result, far) :-
        count_neighbours(Index, TX, TY, Count),
        Result is Count * 2, !.
        
% Count the number of close neighbours.
count_neighbours(Index, TX, TY, Count) :-
        next_to_move(Index, NextToMove),
        other_player(NextToMove, OtherPlayer),
        findall(_, close_neighbour_hex(Index, TX, TY, _, _, OtherPlayer), LHex),
        length(LHex, Count).

% Checking if a player has legal moves in the position 'Index'. 
has_moves(Index, Player) :-
        hex(Index, FX, FY, Player),
        far_neighbour_hex(Index, FX, FY, TX, TY, empty), !.

has_moves(Index, Player) :-
        hex(Index, FX, FY, Player),
        close_neighbour_hex(Index, FX, FY, TX, TY, empty), !.

% Count the number of hexes belongs to the players and empty.
calc_position_hex(Index, NextToMoveCount, OtherPlayerCount, EmptyCount) :-
        next_to_move(0, NextToMove),
        other_player(NextToMove, OtherPlayer),
        findall(_, hex(Index, _, _, NextToMove), LNextToMove),
        length(LNextToMove, NextToMoveCount),
        findall(_, hex(Index, _, _, OtherPlayer), LOtherPlayer),
        length(LOtherPlayer, OtherPlayerCount),
        findall(_, hex(Index, _, _, empty), LEmpty),
        length(LEmpty, EmptyCount).

% Getting the value of the position 'Index'.
position_value(Index, Val) :-
        calc_position_hex(Index, NextToMoveCount, OtherPlayerCount, EmptyCount),
        position_value_inner(Index, NextToMoveCount, OtherPlayerCount, EmptyCount, Val).

% An inner predicate to count the position value.
% It takes into consideration an end game position or a position when one of the players has no legal moves.
position_value_inner(Index, NextToMoveCount, OtherPlayerCount, 0 /*EmptyCount*/, Val) :-
        calc_end_game_val(NextToMoveCount, OtherPlayerCount, Val), !.

position_value_inner(Index, NextToMoveCount, OtherPlayerCount, EmptyCount, Val) :-
        next_to_move(0, NextToMove),
        not has_moves(Index, NextToMove),               % the next player to move has no moves.
        OtherPlayerCountNew is OtherPlayerCount + EmptyCount,
        calc_end_game_val(NextToMoveCount, OtherPlayerCountNew, Val), !.

position_value_inner(Index, NextToMoveCount, OtherPlayerCount, EmptyCount, Val) :-
        next_to_move(0, NextToMove),
        other_player(NextToMove, OtherPlayer),
        not has_moves(Index, OtherPlayer),              % the other player to move has no moves.
        NextToMoveCountNew is NextToMoveCount + EmptyCount,
        calc_end_game_val(NextToMoveCountNew, OtherPlayerCount, Val), !.

position_value_inner(Index, NextToMoveCount, OtherPlayerCount, EmptyCount, Val) :-
        Val is NextToMoveCount - OtherPlayerCount, !.

% The next to move player won.
calc_end_game_val(ValNext, ValOther, Val) :-
        ValNext > ValOther,
        infinity(Inf),
        Val is Inf + ValNext - ValOther, !.

% The next to move player lost.
calc_end_game_val(ValNext, ValOther, Val) :-
        ValNext < ValOther,
        infinity(Inf),
        Val is -Inf + ValNext - ValOther, !.

% a tie game.
calc_end_game_val(Count, Count, 0).

% Getting the square root of 3.
sqrt3(1.7320508075688772935274463415059).

hex_handler(hex, msg_close, Data, close).

% 'End Game' button handler.
hex_handler((hex, 3), msg_button, _, close) :-
        msgbox(`Hexxagon`, `Are you sure you want to end this game?`, 36, Ans ),
        Ans = 6,        % Yes pressed.
        show_score,
        wclose(hex),
        show_hex.

hex_handler(Win, Msg ,Data, Result) :-
        hex_handler(Win, Msg, Data).

hex_handler((hex, 1), msg_paint, _) :-
        refresh_board.

% Redrawing the game board.
refresh_board :-
        create_board_commands(Commands),
        wgfx((hex, 1), Commands).

% Displaying the score message.
show_score :-
        score_msg(Msg),
        msgbox('Game Over', Msg, 0, _). 
        
% Getting the data for the score message.
score_msg(Msg) :-
        findall(_, hex(0, _, _, first), LFirstCount),
        findall(_, hex(0, _, _, second), LSecondCount),
        length(LFirstCount, FirstCount),
        length(LSecondCount, SecondCount),
        check_winner(FirstCount, SecondCount, Msg).

% Checking for the winner of the game.
check_winner(Count, Count, Msg) :-
        number_string(Count, CountStr),
        cat([`A tie game, `, CountStr, ` : `, CountStr, `.`], Msg, _), !.

check_winner(FirstCount, SecondCount, Msg) :-
        FirstCount > SecondCount, !,
        number_string(FirstCount, FirstCountStr),
        number_string(SecondCount, SecondCountStr),
        color_first(Color),
        atom_string(Color, ColorStr),
        cat([`The `, ColorStr, ` player won, `, FirstCountStr, ` : `, SecondCountStr, `.`], Msg, _).

check_winner(FirstCount, SecondCount, Msg) :-
        number_string(FirstCount, FirstCountStr),
        number_string(SecondCount, SecondCountStr),
        color_second(Color),
        atom_string(Color, ColorStr),
        cat([`The `, ColorStr, ` player won, `, SecondCountStr, ` : `, FirstCountStr, `.`], Msg, _).

% Playing the best move using the alphabeta algorithm.
play_best_move :-
        position_value(0, PosVal),
        pos_to_list(0, CurrPos, PosVal),
        start_infinity(Inf),
        MInf is -Inf,
        gameLevel(GameLevel),
        alphabeta(CurrPos, MInf, Inf, GoodPos, Val, GameLevel),
        retract_pos(0),
        list_to_pos(GoodPos, 0),
        refresh_board,
        can_player_move.

% Game board click handler.
hex_handler((hex ,1), msg_leftup, (X, Y)) :-
        handle_hex_click(X, Y).

% Handling a click on a single hex.
handle_hex_click(ClickX, ClickY) :-
        selected_hex(SX, SY),
        is_click_inside(ClickX, ClickY, SX, SY),
        change_selected_hex(SX, SY),
        wgfxpnt((hex, 1)), !.

handle_hex_click(ClickX, ClickY) :-
        selected_hex(SX, SY),
        is_click_inside_neghbour(ClickX, ClickY, SX, SY, HX, HY),
        change_selected_hex(SX, SY),
        make_move(0, SX, SY, HX, HY),
        refresh_board,
        can_player_move.



% no hex selected yet.
handle_hex_click(ClickX, ClickY) :-     
        get_clicked_hex(ClickX, ClickY, HX, HY), !,
        change_selected_hex(HX, HY),
        wgfxpnt((hex, 1)).

% Playing the next best move.
play_next :-
        next_to_move(0, Player),
        player_check(Player, computer),
        play_best_move, !.
        
play_next.

% Checking if a player can move.        
can_player_move :-
        findall(_, hex(0, _, _, empty), []),
        show_score,
        ask_to_play_again, !.   


can_player_move :-
        next_to_move(0, Player),
        not has_moves(0, Player), !,
        player_color(Player, Color),
        atom_string(Color, ColorStr),
        cat([`The `, ColorStr, ` player has no moves.`], Msg, _),
        msgbox(`Game Over`, Msg, 0, _),
        other_player(Player, OtherPlayer),
        update_empty_hex_to_winner(OtherPlayer),
        refresh_board,
        show_score,
        ask_to_play_again, !.

can_player_move :-
        play_next.

% asking the player if he wants to play another game.
ask_to_play_again :-
        wclose(hex),
        msgbox(`Play Again`, `Do you want to play another game ?`, 36, Ans),    
        Ans = 7.        % No pressed.

ask_to_play_again :-
        show_hex.

ask_to_play_again.

% Reverts all empty hexes to the winners player (because the other player has no moves)
update_empty_hex_to_winner(Player) :-
        findall(hex(0, X, Y, empty), hex(0, X, Y, empty), L),
        update_empty_hex_to_winner_list(L, Player).

% The recursive implementation of the 'update_empty_hex_to_winner' predicate.
update_empty_hex_to_winner_list([], _).

update_empty_hex_to_winner_list([hex(0, X, Y, empty) | L], Player) :-
        retract(hex(0, X, Y, empty)),
        assert(hex(0, X, Y, Player)),
        update_empty_hex_to_winner_list(L, Player).

% Checking if a click is inside a neighbour.
is_click_inside_neghbour(ClickX, ClickY, SX, SY, HX, HY) :-
        is_click_inside_close_neghbour(ClickX, ClickY, SX, SY, HX, HY), !.

is_click_inside_neghbour(ClickX, ClickY, SX, SY, HX, HY) :-
        is_click_inside_far_neghbour(ClickX, ClickY, SX, SY, HX, HY), !.

% Checking if a click is inside a close neighbour.
is_click_inside_close_neghbour(ClickX, ClickY, SX, SY, HX, HY) :-
        close_neighbour_hex(0, SX, SY, HX, HY, empty),
        is_click_inside(ClickX, ClickY, HX, HY).
                                
% Checking if a click is inside a far neighbour.
is_click_inside_far_neghbour(ClickX, ClickY, SX, SY, HX, HY) :-
        far_neighbour_hex(0, SX, SY, HX, HY, empty),
        is_click_inside(ClickX, ClickY, HX, HY).

% Getting the hex that was clicked by the mouse.
get_clicked_hex(ClickX, ClickY, HX, HY) :-
        next_to_move(0, NextToMove),
        hex(0, HX, HY, NextToMove),
        is_click_inside(ClickX, ClickY, HX, HY).

% Checking if a click is inside the hex (HX, HY)
is_click_inside(ClickX, ClickY, HX, HY) :-
        warea((hex, 1), XL, YT, W, H),
        board_hex_size(HSide),
        calc_hex_pos(HX, HY, HSide, X, Y),
        NewHSide is HSide - 3,
        RevClickY is H - ClickY,
        check_bottom_line(Y, NewHSide, RevClickY),
        check_top_line(Y, NewHSide, RevClickY),
        check_bottom_right_line(X, Y, NewHSide, ClickX, RevClickY),
        check_bottom_left_line(X, Y, NewHSide, ClickX, RevClickY),
        check_top_right_line(X, Y, NewHSide, ClickX, RevClickY),
        check_top_left_line(X, Y, NewHSide, ClickX, RevClickY).


% Checking each of the 6 lines of the hex if the click is on the right side of the line.
check_top_left_line(X, Y, NewHSide, ClickX, ClickY) :-
        sqrt3(Sqrt3),   
        TX is X - NewHSide,
        TY is Y,
        M is Sqrt3,
        NY is M * (ClickX - TX) + TY,
        NY > ClickY.

check_top_right_line(X, Y, NewHSide, ClickX, ClickY) :-
        sqrt3(Sqrt3),   
        TX is X + NewHSide,
        TY is Y,
        M is -Sqrt3,
        NY is M * (ClickX - TX) + TY,
        NY > ClickY.


check_bottom_left_line(X, Y, NewHSide, ClickX, ClickY) :-
        sqrt3(Sqrt3),   
        TX is X - NewHSide,
        TY is Y,
        M is -Sqrt3,
        NY is M * (ClickX - TX) + TY,
        NY < ClickY.

check_bottom_right_line(X, Y, NewHSide, ClickX, ClickY) :-
        sqrt3(Sqrt3),   
        TX is X + NewHSide,
        TY is Y,
        M is Sqrt3,
        NY is M * (ClickX - TX) + TY,
        NY < ClickY.

check_bottom_line(Y, NewHexSideSize, ClickY) :-
        sqrt3(Sqrt3),
        TY is Y - (NewHexSideSize * Sqrt3) / 2,
        ClickY > TY.

check_top_line(Y, NewHexSideSize, ClickY) :-
        sqrt3(Sqrt3),
        TY is Y + (NewHexSideSize * Sqrt3) / 2,
        ClickY < TY.

% Fill sing hex with color.
fill_single_hex(HX, HY, fill(X, RevY, CBorderR, CBorderG, CBorderB)) :-
        color_border(CBorder),
        color(CBorder, [CBorderR, CBorderG, CBorderB]),
        board_hex_size(BSize),
        calc_hex_pos(HX, HY, BSize, TX, TY),
        warea((hex, 1), XL, YT, W, H),
        TRevY is H - TY,
        round(TX, X),
        round(TRevY, RevY).
        
% Draws a single hex.
draw_single_hex(HX, HY, LHex) :-
        board_hex_size(BSize),
        draw_single_hex(HX, HY, BSize, LHex).

draw_single_hex(HX, HY, SSize, LHex) :-
        warea((hex, 1), XL, YT, W, H),
        board_hex_size(BSize),
        calc_hex_pos(HX, HY, BSize, X, Y),
        RevY is H - Y,
        draw_single_hex_lines(X, RevY, SSize, LHex).

% Draws the lines of a single hex.
draw_single_hex_lines(X, Y, A,
                        line(X1, Y1, X2, Y2, X3, Y3, X4, Y4, X5, Y5, X6, Y6, X1, Y1)) :-
        sqrt3(Sqrt3),
        TX1 is X - A / 2,
        TY1 is Y + (A * Sqrt3) / 2,
        TX2 is X + A / 2,
        TY2 is Y + (A * Sqrt3) / 2,
        TX3 is X + A,
        TY3 is Y,
        TX4 is X + A / 2,
        TY4 is Y - (A * Sqrt3) / 2,
        TX5 is X - A / 2,
        TY5 is Y - (A * Sqrt3) / 2,
        TX6 is X - A,
        TY6 is Y,
        round(TX1, X1),
        round(TY1, Y1),
        round(TX2, X2),
        round(TY2, Y2),
        round(TX3, X3),
        round(TY3, Y3),
        round(TX4, X4),
        round(TY4, Y4),
        round(TX5, X5),
        round(TY5, Y5),
        round(TX6, X6),
        round(TY6, Y6).
        
% Get the real coordinates of a single hex.
calc_hex_pos(HX, HY, A, X, Y) :-
        sqrt3(Sqrt3),
        X is HX * A * 3 / 2,
        Y is (HY * A * Sqrt3 + A) / 2.


% inserts all hex line for a single sum.
insert_single_sum_hex(S, Min, Max, L, NewL) :-
        B is S - Min,
        insert_single_sum_hex_rec(Min, B, Min, Max, L, NewL).
        
% the recursive implementation for the 'insert_single_sum_hex' predicate.
insert_single_sum_hex_rec(Max, B, Min, Max, Tail, [hex(Max, B) | Tail]) :- 
        assert(hex(0, Max, B, empty)), !.

insert_single_sum_hex_rec(A, B, Min, Max, Tail, L) :-
        A1 is A + 1,
        B1 is B - 1,
        assert(hex(0, A, B, empty)),
        insert_single_sum_hex_rec(A1, B1, Min, Max, [hex(A, B) | Tail], L).

% inserts all hexes into the game.
insert_all_hex(L) :-
        retractall(hex(_, X, Y, State)),
        retractall(selected_hex(_, _)),
        board_size(Size),
        RowsNum is 2 * Size - 1,
        insert_all_hex_rec(1, RowsNum, [], L).
                
% The recursive implementation for the 'insert_all_hex' predicate.
insert_all_hex_rec(Row, Row, L, NewL) :-
        board_size(Size),
        Sum is 2 * Row + Size - 1,
        calc_min(Row, Size, Min),
        calc_max(Row, Size, Max),
        insert_single_sum_hex(Sum, Min, Max, L, NewL),
        !.

insert_all_hex_rec(Row, RowsNum, L, NewL) :-
        board_size(Size),
        Sum is 2 * Row + Size - 1,
        calc_min(Row, Size, Min),
        calc_max(Row, Size, Max),
        insert_single_sum_hex(Sum, Min, Max, L, NewL1),
        NextRow is Row + 1,
        insert_all_hex_rec(NextRow, RowsNum, NewL1, NewL).

% Calculating the starting hex for a row.
calc_min(Row, BoardSize, 1) :-
        Row =< BoardSize, !.
calc_min(Row, BoardSize, Min) :-
        Min is Row - BoardSize + 1.

% Calculating the ending hex for a row.
calc_max(Row, BoardSize, Max) :-
        Row =< BoardSize, !,
        Max is Row + BoardSize - 1.

calc_max(Row, BoardSize, Max) :-
        Max is 2 * BoardSize - 1.
