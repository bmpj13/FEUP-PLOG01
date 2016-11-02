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
