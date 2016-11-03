:- ensure_loaded('../utils.pl').

setBoardCell(X, Y, Elem, Board, NewBoard) :-
    nth0(Y, Board, Line),
    setCell(X, Elem, Line, Nline),
    setCell(Y, Nline, Board, NewBoard).
