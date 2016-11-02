:- ensure_loaded('../utils.pl').

setBoardCell(X, Y, Elem, Board, NewBoard) :-
    nth0(Y, Board, Line),
    setCell(X, Elem, Line, Nline),
    setCell(Y, Nline, Board, NewBoard).

placeWall(X, Y,'h',Board, NewBoard) :-
    setBoardCell(X, Y, [horizontal, placed], Board, AuxBoard),
  	Nx is X + 1,
  	setBoardCell(Nx, Y, [horizontal, placed], AuxBoard, NewBoard).

placeWall(X, Y,'v',Board, NewBoard) :-
    setBoardCell(X, Y, [vertical, placed], Board, AuxBoard),
  	Ny is Y + 2,
  	setBoardCell(X, Ny, [vertical, placed], AuxBoard, NewBoard).
