/************************************************************************
** This creates a dialog for choosing options for hexxagon: board size,
** who will start the game (computer or human) and depth of search in
** game tree.
************************************************************************/
show_options :-
        retractAllValues,
        DStyle = [ws_caption, ws_border, dlg_ownedbyprolog, ws_sysmenu],
        CStyle = [ws_child, ws_visible],
        wdcreate(options, `Wellcome to prolog Hexxagon !!!`, 300, 150, 300, 315, DStyle),
        wccreate((options, 10), button, ` Board Size `, 20, 10, 120, 110, [bs_groupbox | CStyle]),
        wndhdl((options, 10), GroupHandleSize),
        wccreate((GroupHandleSize, 1), button, `Small`, 20, 20, 80, 18, [bs_autoradiobutton | CStyle]),
        wccreate((GroupHandleSize, 2), button, `Medium`, 20, 50, 80, 18, [bs_autoradiobutton | CStyle]),
        wccreate((GroupHandleSize, 3), button, `Large`, 20, 80, 80, 18, [bs_autoradiobutton | CStyle]),
        wbtnsel((GroupHandleSize, 2), 1),
        wccreate((options, 11), button, ` Game Level `, 160, 10, 120, 110, [bs_groupbox | CStyle]),
        wndhdl((options, 11), GroupHandleLevel),
        wccreate((GroupHandleLevel, 1), button, `Easy`, 20, 20, 80, 18, [bs_autoradiobutton | CStyle]),
        wccreate((GroupHandleLevel, 2), button, `Medium`, 20, 50, 80, 18, [bs_autoradiobutton | CStyle]),
        wccreate((GroupHandleLevel, 3), button, `Hard`, 20, 80, 80, 18, [bs_autoradiobutton | CStyle]),
        wbtnsel((GroupHandleLevel, 2), 1),
        wccreate((options, 12), button, ` First player `, 20, 130, 260, 50, [bs_groupbox | CStyle]),
        wndhdl((options, 12), GroupHandleFirstPlayer),
        wccreate((GroupHandleFirstPlayer, 1), button, `Human`, 20, 20, 80, 18, [bs_autoradiobutton | CStyle]),
        wccreate((GroupHandleFirstPlayer, 2), button, `Computer`, 140, 20, 80, 18, [bs_autoradiobutton | CStyle]),
        wbtnsel((GroupHandleFirstPlayer, 1), 1),
        wccreate((options, 13), button, ` Second player `, 20, 190, 260, 50, [bs_groupbox | CStyle]),
        wndhdl((options, 13), GroupHandleSecondPlayer),
        wccreate((GroupHandleSecondPlayer, 1), button, `Human`, 20, 20, 80, 18, [bs_autoradiobutton | CStyle]),
        wccreate((GroupHandleSecondPlayer, 2), button, `Computer`, 140, 20, 80, 18, [bs_autoradiobutton | CStyle]),
        wbtnsel((GroupHandleSecondPlayer, 2), 1),
        wccreate((options, 14), button, `Exit`, 175, 250, 75, 25, CStyle),
        wccreate((options, 15), button, `Start game`, 50, 250, 75, 25, CStyle),
        window_handler(options, options_handler),
        call_dialog(options, Result).

% on a close message close the dialog by binding the fourth argument
options_handler(options, msg_close, Data, close).

% for all other messages do not close the dialog

% I added handler for the new exit button.
options_handler((options, 14), msg_button, _, close).

options_handler((options, 15), msg_button, _, close) :-
        getDlgValues.

options_handler((options, 15), msg_button, _, _).

options_handler(Window, Message, Data, Result) :-
        window_handler(Window, Message, Data, Result).

% getting the board size that was selected in the dialog.
getBoardSize :-
        wndhdl((options, 10), GroupHandleSize),
        wbtnsel((GroupHandleSize, 1), Checked),
        Checked = 1, !,
        assert(board_size(3)).

getBoardSize :-
        wndhdl((options, 10), GroupHandleSize),
        wbtnsel((GroupHandleSize, 2), Checked),
        Checked = 1, !,
        assert(board_size(5)).

getBoardSize :-
        wndhdl((options, 10), GroupHandleSize),
        wbtnsel((GroupHandleSize, 3), Checked),
        Checked = 1, !,
        assert(board_size(7)).

% Getting the game level that was selected in the dialog.
getLevel :-
        wndhdl((options, 11), GroupHandleLevel),
        wbtnsel((GroupHandleLevel, 1), Checked),
        Checked = 1, !,
        assert(gameLevel(1)).

getLevel :-
        wndhdl((options, 11), GroupHandleLevel),
        wbtnsel((GroupHandleLevel, 2), Checked),
        Checked = 1, !,
        assert(gameLevel(2)).

getLevel :-
        wndhdl((options, 11), GroupHandleLevel),
        wbtnsel((GroupHandleLevel, 3), Checked),
        Checked = 1, !,
        assert(gameLevel(3)).

% Getting the first player (Human, computer)
getFirstPlayer :-
        wndhdl((options, 12), GroupHandleFirstPlayer),
        wbtnsel((GroupHandleFirstPlayer, 1), Checked),
        Checked = 1, !,
        assert(firstPlayer(human)).

getFirstPlayer :-
        wndhdl((options, 12), GroupHandleFirstPlayer),
        wbtnsel((GroupHandleFirstPlayer, 2), Checked),
        Checked = 1, !,
        assert(firstPlayer(computer)).


% Getting the second player (Human, computer)
getSecondPlayer :-
        wndhdl((options, 13), GroupHandleSecondPlayer),
        wbtnsel((GroupHandleSecondPlayer, 1), Checked),
        Checked = 1, !,
        assert(secondPlayer(human)).

getSecondPlayer :-
        wndhdl((options, 13), GroupHandleSecondPlayer),
        wbtnsel((GroupHandleSecondPlayer, 2), Checked),
        Checked = 1, !,
        assert(secondPlayer(computer)).


% Getting the status of the player
player_check(first, Status) :-
        firstPlayer(Status).

player_check(second, Status) :-
        secondPlayer(Status).

% Getting the values from the dialog.
getDlgValues :-
        retractAllValues,
        getBoardSize,
        getLevel,
        getFirstPlayer,
        getSecondPlayer,
        checkTwoComputers, !.

% Checking that not both of the players are computers
checkTwoComputers :-
        findHumanPlayer.

checkTwoComputers :-
        msgbox('Hexxagon', 'At least one of the players has to be human.', 0, _),
        fail.

% Looking for human player.
findHumanPlayer :-
        firstPlayer(human).

findHumanPlayer :-
        secondPlayer(human).

% Removing all values of the game that are suppose to be selected in the options dialog.
retractAllValues :-
        retractBoardSize,
        retractLevel,
        retractFirstPlayer,
        retractSecondPlayer, !.

retractBoardSize :-
        retractall(board_size(_)).
retractBoardSize.

retractLevel :-
        retractall(gameLevel(_)).
retractLevel.

retractFirstPlayer :-
        retractall(firstPlayer(_)).
retractFirstPlayer.

retractSecondPlayer :-
        retractall(secondPlayer(_)).
retractSecondPlayer.

