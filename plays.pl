:- ensure_loaded('cli.pl').
:- ensure_loaded('board/logic.pl').


play(M, L, Player, Board, NewBoard) :-
	(M =:= 1, playHuman(Player, Board, NewBoard));
	(M =:= 2, Player = orange , playHuman(Player,Board,NewBoard));
	(M =:= 2, Player = yellow , playBot(L, Player,Board,NewBoard));
	(M =:= 3, playBot(L, Player, Board, NewBoard)).



playHuman(Player, Board, NewBoard) :-
	format('--------------Its your turn ~s ----------- ~n',[Player]),
	getPawnNumber(N),
	moveHuman([Player, N], Board, AuxBoard),
	handleWall(Player, AuxBoard, NewBoard).

playBot(L, Player,Board,NewBoard):-
	moveBot(L, Player, Board, AuxBoard),
	handleWallBot(L, Player, AuxBoard, NewBoard).



moveHuman(Pawn, Board, NewBoard) :-
	moveOneSpaceHuman(Pawn,Board,AuxBoard),
	moveOneSpaceHuman(Pawn,AuxBoard,NewBoard).



handleWall(Player, Board, NewBoard) :-
	hasWalls(Player), !,
	repeat,
		once(getWallCoords(X, Y, O)),		% posicionar a parede
	placeWall(Player, X, Y, O, Board, NewBoard). 	%ver se o numero de paredes for 0 não perguntar as coordenadas

handleWall(_, Board, Board) :-
	true.


moveOneSpaceHuman(Pawn,Board,NewBoard) :-
	repeat, %verificar colisoes
		once(getMovCoords(X,Y)),
	validPosition(Pawn, Board, X, Y),
	moveOneSpace(Pawn, X, Y, Board, NewBoard),
	displayBoard(NewBoard).



moveBot(1, Player, Board, NewBoard) :-
	evaluateBestPawn(Player,N),
	auxMoveBot(Player,N,Board,AuxBoard),
	(
		(checkBotWin(Player, N), NewBoard = AuxBoard) ;
		auxMoveBot(Player,N,AuxBoard,NewBoard)
	).


moveBot(2, Player, Board, NewBoard) :-
	random_member(N, [1, 2]),
	Pawn = [Player, N],
	moveOneSpaceRandom(Pawn, Board, AuxBoard),
	moveOneSpaceRandom(Pawn, AuxBoard, NewBoard).



handleWallBot(1, Player, Board, NewBoard) :-
	hasWalls(Player), !,
	evaluateBestWall(Player,Walls),
	iterateWallList(Walls,Player,Board,NewBoard).


handleWallBot(2, Player, Board, NewBoard) :-
	hasWalls(Player), !,
	repeat,
		once(randomWall(X, Y, O)),
	placeWall(Player, X, Y, O, Board, NewBoard).


handleWallBot(_, _, Board, Board) :-
	true.



auxMoveBot(Player,N,Board,NewBoard) :-
	evaluateBestDirectionPro(Player, N, [X,Y]),
	(
		(validPosition([Player,N], Board, X, Y),
		 moveOneSpaceBot([Player,N], [X,Y], Board, NewBoard)) ;
		(NewBoard = Board)
	).



moveOneSpaceBot(Pawn, [X,Y], Board,NewBoard) :-
	moveOneSpace(Pawn, X, Y, Board, NewBoard),
	displayBoard(NewBoard).



iterateWallList([],Player,Board,Board) :- %ver cruzados tambem
	 %randomWall(X, Y, O),
	 %iterateWallList([[X,Y,O]],Player,Board,NewBoard).
	 true.

iterateWallList([[X,Y,O] | _], Player, Board, NewBoard) :-
	placeWall(Player, X, Y, O, Board, NewBoard).

iterateWallList([[_,_,_] | Res], Player, Board, NewBoard) :-
	iterateWallList(Res,Player,Board,NewBoard).



moveOneSpaceRandom(Pawn, Board, NewBoard) :-
	repeat,
		randomMove(X, Y),
	validPosition(Pawn, Board, X, Y),
	moveOneSpace(Pawn, X, Y, Board, NewBoard).


randomMove(X, Y) :-
		random_member(X, [-1, 0, 1]),
		(
			(X =:= 0, random_member(Y, [-1, 0, 1])) ;
			(X =\= 0, Y is 0)
		).


randomWall(X, Y, O) :-
		random(0, 19, X),
 		random(0, 25, Y),
 		random_member(O, [h,v]).



checkBotWin(Player,N) :-
	position([Player,N], X, Y),
	targePosition([Player, 1], Tx1, Ty1),
	targePosition([Player, 2], Tx2, _),
	(X =:= Tx1 ; X =:= Tx2),
	 Y =:= Ty1.
