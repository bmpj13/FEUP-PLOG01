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
	displayBoard(AuxBoard),
	moveOneSpace(Pawn, AuxBoard, NewBoard),
	displayBoard(NewBoard).


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
		checkWallColision(Elem).


targetIsValid(Pawn, Board, X, Y) :-
		targetCoords(Pawn, X,Y, Tx,Ty),
		inBounds(Tx, Ty),
		elementCoords(Board, Tx, Ty, Elem),
		(Elem = square ; Elem = [orange, base] ; Elem = [yellow, base]).


targetIsValid(Pawn, Board, X, Y) :-
		write('---- You can \'t move to that position you are either out of bonds or there is a player in that position. ----'), nl,
		fail.


targetCoords(Pawn, X, Y, Tx, Ty) :-
		position(Pawn, Px, Py),
		Tx is Px + X*2,
		Ty is Py + Y*2.


inBounds(Tx, Ty) :-
		Tx >= 0, Tx < 21,
		Ty >= 0, Ty < 27.





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
		X < 20, X > 0,
		Y < 25, Y >= 0,
		X mod 2 =:= 1,
		Y mod 2 =:= 0,
		noWallPlaced(Board, X, Y, 'v'),
		Cx is X - 1,
		Cy is Y + 1,
		noWallPlaced(Board, Cx, Cy, 'h').

checkWallCoords(X, Y,'h',Board) :-
		X >= 0, X < 19,
		Y > 0, Y < 26,
		X mod 2 =:= 0,
		Y mod 2 =:= 1,
		noWallPlaced(Board, X, Y, 'h'),
		Cx is X + 1,write('como esta?4'),
		Cy is Y - 1,write('como esta?5'),
		noWallPlaced(Board, Cx, Cy, 'v').

noWallPlaced(Board, X, Y, 'h') :-
	Nx is round(X/2),
	elementCoords(Board, Nx, Y, Elem),
	Elem = [_ | [empty | _]],
	Nx2 is Nx + 1,
	elementCoords(Board, Nx2, Y, Elem),
	Elem = [_ | [empty | _]].


noWallPlaced(Board, X, Y, 'v') :-
	elementCoords(Board, X, Y, Elem),
	Elem = [_ | [empty | _]],
	Ny is Y + 2,
	elementCoords(Board, X, Ny, Elem),
	Elem = [_ | [empty | _]].


checkWallCoords(_,_,_,_) :-
		write('---- Invalid wall coordenates ----'),nl,
		fail.
