:- use_module(library(lists)).
:- use_module(library(samsort)).
:- use_module(library(random)).
:- ensure_loaded('board/init.pl').
:- ensure_loaded('board/display.pl').
:- ensure_loaded('board/logic.pl').
:- ensure_loaded('plays.pl').
:- ensure_loaded('ai.pl').
:- use_module(library(system)).
:- now(Timestamp),
   setrand(Timestamp).

%jogo humano vs humano
game(M) :-
		%inicializacoes
		board(X),
			repeat,
				once(retract(board(BoardInit))),
				once(displayBoard(BoardInit)),
				once(retract(currentPlayer(P))),
			 	once(play(M,P, BoardInit, BoardEnd)),
				once(changeCurrentPlayer(P)),
				once(assert(board(BoardEnd))),
			checkEnd,
		once(retract(board(Board))),
		once(assert(board(X))).% esta a guardar o board inicial para podermos executar outra vez no sictus é tambem preciso guardar as posições originais e tirar as antigas assim como numero de paredes .. fazer predicado !


changeCurrentPlayer(P):-
	(P = orange , assert(currentPlayer(yellow)));
	(P = yellow , assert(currentPlayer(orange))).

checkEnd :-
		(position([orange | _],X,Y) , ((X =:= 6 ; X =:= 14) , Y =:= 20) , winMessage(orange));
		(position([yellow | _],X,Y) , ((X =:= 6 ; X =:= 14) , Y =:= 6) , winMessage(yellow)).


winMessage(Player) :-
		format('------------------------------------- ~n',[]),
		format('--------___________________---------- ~n',[]),
		format('-------|   You Win ~s  |-------- ~n',[Player]),
		format('-------|  Congratulations  |--------- ~n',[]),
		format('-------|___________________|--------- ~n',[]),
		format('------------------------------------- ~n',[]).
