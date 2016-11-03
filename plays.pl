:- ensure_loaded('cli.pl').
:- ensure_loaded('board/logic.pl').


play(Player, Board, NewBoard) :-
		write(Player),nl,
		getPawnCoords(X, Y),
		move(X, Y, [Player, 1], Board, AuxBoard),
		getWallCoords(X1, Y1, O),
		placeWall(X1, Y1, O, AuxBoard, NewBoard).


move(X, Y, Pawn, Board, NewBoard) :-
		retract(position(Pawn, Px, Py)),
  	assert(position(Pawn, X, Y)),
    setBoardCell(Px, Py, square, Board, AuxBoard),
    setBoardCell(X, Y, Pawn, AuxBoard, NewBoard).

placeWall(X, Y,'h',Board, NewBoard) :-
		Nx is round(X/2),
    setBoardCell(Nx, Y, [horizontal, placed], Board, AuxBoard),
  	Nx2 is Nx + 1,
  	setBoardCell(Nx2, Y, [horizontal, placed], AuxBoard, NewBoard).

placeWall(X, Y,'v',Board, NewBoard) :-
    setBoardCell(X, Y, [vertical, placed], Board, AuxBoard),
  	Ny is Y + 2,
  	setBoardCell(X, Ny, [vertical, placed], AuxBoard, NewBoard).
