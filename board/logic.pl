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
