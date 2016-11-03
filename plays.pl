:- ensure_loaded('cli.pl').



play(Player, Board, NewBoard) :-
		format('--------------Its your turn ~s ----------- ~n',[Player]),
		getPawnNumber(N),
		getPawnMov(X, Y), %mover o peao
		move(X, Y, [Player, N], Board, AuxBoard),
		getWallCoords(X1, Y1, O), %posicionar a parede
		placeWall(Player,X1, Y1, O, AuxBoard, NewBoard). %ver se o numero de paredes for 0 não perguntar as coordenadas


move(X, Y, Pawn, Board, NewBoard) :-
		retract(position(Pawn, Px, Py)),
		Nx is Px + X*2,
		Ny is Py + Y*2,
  	assert(position(Pawn, Nx, Ny)),
    emptyPosition(Px,Py,Board,AuxBoard),
    setBoardCell(Nx, Ny, Pawn, AuxBoard, NewBoard).

emptyPosition(Px,Py,Board,NBoard) :-
	(((Px =:= 6 ; Px =:= 14) , Py =:= 6) , setBoardCell(Px, Py, [orange, base], Board, NBoard));
	(((Px =:= 6 ; Px =:= 14) , Py =:= 20) , setBoardCell(Px, Py, [yellow, base], Board, NBoard));
	(setBoardCell(Px, Py, square, Board, NBoard)).

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
