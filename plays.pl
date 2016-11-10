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

moveBot(1, Player, Board, NewBoard) :-
	evaluateBestPawn(Player,N),
	auxMoveBot(Player,N,Board,AuxBoard),
	(checkBotWin(Player, N) ; auxMoveBot(Player,N,AuxBoard,NewBoard)).


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



iterateWallList([],Player,Board,NewBoard) :- %ver cruzados tambem
	 randomWall(X, Y, O),
	 iterateWallList([[X,Y,O]],Player,Board,NewBoard).

iterateWallList([[X,Y,O] | _], Player, Board, NewBoard) :-
	placeWall(Player, X, Y, O, Board, NewBoard).

iterateWallList([[_,_,_] | Res], Player, Board, NewBoard) :-
	iterateWallList(Res,Player,Board,NewBoard).




handleWall(Player, Board, NewBoard) :-
	hasWalls(Player), !,
	repeat,
		once(getWallCoords(X, Y, O)),		% posicionar a parede
	placeWall(Player, X, Y, O, Board, NewBoard). 	%ver se o numero de paredes for 0 não perguntar as coordenadas

handleWall(_, Board, Board) :-
	true.



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


auxMoveBot(Player,N,Board,NewBoard) :-
	evaluateBestDirection(Player,N,Directions),
	moveOneSpaceBot([Player,N],Directions,Board,NewBoard).


moveOneSpaceBot(Pawn,Directions,Board,NewBoard) :-
	iterateDirectionList(Directions,X,Y,Pawn,Board),
	moveOneSpace(Pawn, X, Y, Board, NewBoard),
	displayBoard(NewBoard).

iterateDirectionList([[_|D] | _], X, Y, Pawn, Board) :-
	convertDirection(D,X,Y),
	validPosition(Pawn, Board, X, Y), !.

iterateDirectionList([[_|_] | Res], X, Y, Pawn, Board) :-
	iterateDirectionList(Res,X,Y,Pawn,Board).


moveOneSpaceHuman(Pawn,Board,NewBoard) :-
	repeat, %verificar colisoes
		once(getMovCoords(X,Y)),
	validPosition(Pawn, Board, X, Y),
	moveOneSpace(Pawn, X, Y, Board, NewBoard),
	displayBoard(NewBoard).



%posicao da parede que tem que ser atravessada para passar para a proxima posição
% x,y é o offset px,py posicao do jogador wx, wy é o retorno com as coordenadas da parede
wallCoords(X,Y,Px,Py,Wx,Wy) :-
	(X =:= 0 , Wx is round(Px/2) , Wy is Py + Y);
	(Y =:= 0 , Wx is Px + X , Wy is Py).

checkWallColision([_ | [placed | _ ]]) :-
					write('----There is a wall in the way you have to choose another path!----'),nl,
					fail.

checkWallColision([_ | [empty | _]]) :-
					true.



hasWalls(Player) :-
	wallNumber(Player, H, V),
	(H =\= 0 ; V =\= 0).



placeWall(Player, _, _, 'h', _, _) :-
		wallNumber(Player, 0, _), !,
		write('---- You\'re out of horizontal walls ----'), nl,
		fail.


placeWall(Player, _, _, 'v', _, _) :-
		wallNumber(Player, _, 0), !,
		write('---- You\'re out of vertical walls ----'), nl,
		fail.


placeWall(Player,X, Y,'h',Board, NewBoard) :-
		checkWallCoords(X, Y,'h',Board),
		retract(wallNumber(Player, H, V)),
		Nh is H - 1,
		assert(wallNumber(Player, Nh, V)),
		Nx is round(X/2),
    setBoardCell(Nx, Y, [horizontal, placed], Board, AuxBoard),
  	Nx2 is Nx + 1,
  	setBoardCell(Nx2, Y, [horizontal, placed], AuxBoard, NewBoard).

placeWall(Player,X, Y,'v',Board, NewBoard) :-
		checkWallCoords(X, Y,'v',Board),
		retract(wallNumber(Player, H, V)),
		Nv is V - 1,
		assert(wallNumber(Player, H, Nv)),
    setBoardCell(X, Y, [vertical, placed], Board, AuxBoard),
  	Ny is Y + 2,
  	setBoardCell(X, Ny, [vertical, placed], AuxBoard, NewBoard).


checkWallCoords(X, Y,'v',Board) :-
		X mod 2 =:= 1,
		Y mod 2 =:= 0,
		X < 20, X > 0,
		Y < 25, Y >= 0,
		noWallPlaced(Board, X, Y, 'v'),
		Cx is X - 1,
		Cy is Y + 1,
		noWallPlaced(Board, Cx, Cy, 'h').



checkWallCoords(X, Y,'h',Board) :-
		X mod 2 =:= 0,
		Y mod 2 =:= 1,
		X >= 0, X < 19,
		Y > 0, Y < 26,
		noWallPlaced(Board, X, Y, 'h'),write('ola1'),
		Cx is X + 1,
		Cy is Y - 1,
		noWallPlaced(Board, Cx, Cy, 'v'), write('ola2').


checkWallCoords(_,_,_,_) :-
		write('---- Invalid wall coordenates ----'),nl,
		fail.

noWallPlaced(Board, X, Y, 'h') :-
	Nx is round(X/2),
	elementCoords(Board, Nx, Y, Elem1),
	Nx2 is Nx + 1,
	elementCoords(Board, Nx2, Y, Elem2),
	(Elem1 = [_, empty] ; Elem2 = [_, empty]).


noWallPlaced(Board, X, Y, 'v') :-
	elementCoords(Board, X, Y, Elem1),
	Ny is Y + 2,
	elementCoords(Board, X, Ny, Elem2),
	(Elem1 = [_, empty] ; Elem2 = [_, empty]).
