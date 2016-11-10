:- ensure_loaded('../utils.pl').


setBoardCell(X, Y, Elem, Board, NewBoard) :-
  nth0(Y, Board, Line),
  setCell(X, Elem, Line, Nline),
  setCell(Y, Nline, Board, NewBoard).


targetCoords(Pawn, X, Y, Tx, Ty) :-
	position(Pawn, Px, Py),
	Tx is Px + X*2,
	Ty is Py + Y*2.


emptyPosition(Px,Py,Board,NBoard) :-
	(((Px =:= 6 ; Px =:= 14) , Py =:= 6) , setBoardCell(Px, Py, [orange, base], Board, NBoard));
	(((Px =:= 6 ; Px =:= 14) , Py =:= 20) , setBoardCell(Px, Py, [yellow, base], Board, NBoard));
	(setBoardCell(Px, Py, square, Board, NBoard)).


hasWalls(Player) :-
	wallNumber(Player, H, V),
	(H =\= 0 ; V =\= 0).



moveOneSpace(Pawn, X, Y, Board, NewBoard) :-
	targetCoords(Pawn, X, Y, Nx, Ny),
	retract(position(Pawn, Px, Py)),
  emptyPosition(Px,Py,Board,AuxBoard),
	assert(position(Pawn, Nx, Ny)),
  setBoardCell(Nx, Ny, Pawn, AuxBoard, NewBoard).



validPosition(_, _, 0, 0) :-
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


targetIsValid(_, _, _, _) :-
	write('---- You can \'t move to that position you are either out of bonds or there is a player in that position. ----'), nl,
	fail.


inBounds(Tx, Ty) :-
	Tx >= 0, Tx < 21,
	Ty >= 0, Ty < 27.



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
