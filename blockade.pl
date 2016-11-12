:- use_module(library(lists)).
:- use_module(library(samsort)).
:- use_module(library(random)).
:- use_module(library(system)).
:- ensure_loaded('board/init.pl').
:- ensure_loaded('board/display.pl').
:- ensure_loaded('board/logic.pl').
:- ensure_loaded('plays.pl').
:- ensure_loaded('ai.pl').
:- ensure_loaded('menus.pl').

%numeros random com seed diferente
:- now(Timestamp),
   setrand(Timestamp).

%inicializacoes
initGame(X):-
  initGraph,
  board(X).


%fim
 finalize(X):-
   retract(board(_)),
   assert(board(X)),
   retractall(edge(_)),
   retractall(vertex(_)),
   retract(graph(_)),
   retractall(wallNumber(_,_,_)),
   assert(wallNumber(orange,9,9)),
   assert(wallNumber(yellow,9,9)),
   retractall(position(_,_,_)),
   assert(position([orange, 1], 6, 6)),
   assert(position([orange, 2], 14, 6)),
   assert(position([yellow, 1], 6, 20)),
   assert(position([yellow, 2], 14, 20)),
   retract(currentPlayer(_)),
   assert(currentPlayer(orange)).



game(M) :-

    initGame(X),
			repeat,
				once(retract(board(BoardInit))),
				once(displayBoard(BoardInit)),
				once(retract(currentPlayer(P))),
			 	once(play(M, 1, P, BoardInit, BoardEnd)),
				once(changeCurrentPlayer(P)),
				once(assert(board(BoardEnd))),
			checkEnd,!,
     waitInput,
	   finalize(X),
     blockade.


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
