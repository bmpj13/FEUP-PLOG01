:- ensure_loaded('cli.pl').



play(Player, Board, NewBoard) :-
		write(Player),nl,
		getPawnNumber(N),
		getPawnMov(X, Y), %mover o peao
		move(X, Y, [Player, N], Board, AuxBoard),
		getWallCoords(X1, Y1, O), %posicionar a parede
		placeWall(Player,X1, Y1, O, AuxBoard, NewBoard).


move(X, Y, Pawn, Board, NewBoard) :-
		retract(position(Pawn, Px, Py)),
		Nx is Px + X*2,
		Ny is Py + Y*2,
  	assert(position(Pawn, Nx, Ny)),
    setBoardCell(Px, Py, square, Board, AuxBoard),
    setBoardCell(Nx, Ny, Pawn, AuxBoard, NewBoard).

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
