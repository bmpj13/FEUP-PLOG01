:- ensure_loaded('cli.pl').



play(Player, Board, NewBoard) :-
		format('--------------Its your turn ~s ----------- ~n',[Player]),
		getPawnNumber(N),
		move([Player, N], Board, AuxBoard),
		handleWall(Player, AuxBoard, NewBoard).


handleWall(Player, Board, NewBoard) :-
	hasWalls(Player), !,
	repeat,
		once(getWallCoords(X, Y, O)),		% posicionar a parede
	placeWall(Player, X, Y, O, Board, NewBoard). 	%ver se o numero de paredes for 0 não perguntar as coordenadas

handleWall(Player, Board, Board) :-
	true.



move(Pawn, Board, NewBoard) :-
	moveOneSpace(Pawn, Board, AuxBoard),
	moveOneSpace(Pawn, AuxBoard, NewBoard).


moveOneSpace(Pawn, Board, NewBoard) :-%secalhar o move vai ter que ser uma posição de cada vez para verificar colisoes com paredes
		repeat, %verificar colisoes
			once(getMovCoords(X,Y)),
		validPosition(Pawn, Board, X, Y),
		targetCoords(Pawn, X, Y, Nx, Ny),
		retract(position(Pawn, Px, Py)),
    emptyPosition(Px,Py,Board,AuxBoard),
		assert(position(Pawn, Nx, Ny)),
    setBoardCell(Nx, Ny, Pawn, AuxBoard, NewBoard).



validPosition(Pawn, Board, 0, 0) :-
		true.

validPosition(Pawn, Board, X, Y) :-
		targetIsValid(Pawn, Board, X, Y), !,
		noWallBlocking(Pawn, Board, X, Y).


noWallBlocking(Pawn, Board, X, Y) :-
		position(Pawn, Px, Py),
		wallCoords(X,Y, Px,Py, Wx, Wy),
		elementCoords(Board, Wx, Wy, Elem),
		checkWall(Elem).


targetIsValid(Pawn, Board, X, Y) :-
		targetCoords(Pawn, X,Y, Tx,Ty), !,
		inBounds(Tx, Ty),
		elementCoords(Board, Tx, Ty, Elem),
		(Elem = square ; Elem = [orange, base] ; Elem = [yellow, base]).


targetIsValid(Pawn, Board, X, Y) :-
		write('---- There is a player in that position. Please choose another path. ----'), nl,
		fail.



targetCoords(Pawn, X, Y, Tx, Ty) :-
		position(Pawn, Px, Py),
		Tx is Px + X*2,
		Ty is Py + Y*2.



inBounds(Tx, Ty) :-
		Tx >= 0, Tx < 21,
		Ty >= 0, Ty < 27.

inBounds(Tx, Ty) :-
		write('---- Target coordinates are out of bounds! ----'), nl,
		fail.



%posicao da parede que tem que ser atravessada para passar para a proxima posição
% x,y é o offset px,py posicao do jogador wx, wy é o retorno com as coordenadas da parede
wallCoords(X,Y,Px,Py,Wx,Wy) :-
	(X =:= 0 , Wx is round(Px/2) , Wy is Py + Y);
	(Y =:= 0 , Wx is Px + X , Wy is Py).

checkWall([_ | [placed | _ ]]) :-
					write('----There is a wall in the way you have to choose another path!----'),nl,
					fail.

checkWall([_ | [empty | _]]) :-
					true.


emptyPosition(Px,Py,Board,NBoard) :-
	(((Px =:= 6 ; Px =:= 14) , Py =:= 6) , setBoardCell(Px, Py, [orange, base], Board, NBoard));
	(((Px =:= 6 ; Px =:= 14) , Py =:= 20) , setBoardCell(Px, Py, [yellow, base], Board, NBoard));
	(setBoardCell(Px, Py, square, Board, NBoard)).



hasWalls(Player) :-
	wallNumber(Player, H, V),
	(H =\= 0 ; V =\= 0).



placeWall(Player,X, Y,'h', Board, NewBoard) :-
		wallNumber(Player, 0, _), !,
		write('---- You\'re out of horizontal walls ----'), nl,
		fail.


placeWall(Player,X, Y,'v', Board, NewBoard) :-
		wallNumber(Player, _, 0), !,
		write('---- You\'re out of vertical walls ----'), nl,
		fail.


placeWall(Player,X, Y,'h',Board, NewBoard) :-
		retract(wallNumber(Player, H, V)),
		Nh is H - 1,
		assert(wallNumber(Player, Nh, V)),
		Nx is round(X/2),
    setBoardCell(Nx, Y, [horizontal, placed], Board, AuxBoard),
  	Nx2 is Nx + 1,
  	setBoardCell(Nx2, Y, [horizontal, placed], AuxBoard, NewBoard).

placeWall(Player,X, Y,'v',Board, NewBoard) :-
		retract(wallNumber(Player, H, V)),
		Nv is V - 1,
		assert(wallNumber(Player, H, Nv)),
    setBoardCell(X, Y, [vertical, placed], Board, AuxBoard),
  	Ny is Y + 2,
  	setBoardCell(X, Ny, [vertical, placed], AuxBoard, NewBoard).
