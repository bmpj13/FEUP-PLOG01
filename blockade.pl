:- use_module(library(lists)).
:- ensure_loaded('board/init.pl').
:- ensure_loaded('board/display.pl').
:- ensure_loaded('player.pl').


%jogo

game :-
		repeat,
			once(retract(board(BoardInit))),
			once(play(orange, BoardInit, BoardIntermediate)),
			once(displayBoard(BoardIntermediate)), %não se devia ter que por ONCE ????
			once(play(yellow, BoardIntermediate, BoardEnd)),
			once(displayBoard(BoardEnd)),
			once(assert(board(BoardEnd))),
			fail.
