:- ensure_loaded('cli.pl').



play(Player, Board, NewBoard) :-
		format('--------------Its your turn ~s ----------- ~n',[Player]),
		getPawnNumber(N),
	  %mover o peao
		move([Player, N], Board, AuxBoard),
		getWallCoords(X1, Y1, O), %posicionar a parede
		placeWall(Player,X1, Y1, O, AuxBoard, NewBoard). %ver se o numero de paredes for 0 não perguntar as coordenadas

move(Pawn, Board, NewBoard) :-
	moveOneSpace(Pawn, Board, AuxBoard),
	moveOneSpace(Pawn, AuxBoard, NewBoard).

moveOneSpace(Pawn, Board, NewBoard) :-%secalhar o move vai ter que ser uma posição de cada vez para verificar colisoes com paredes
		repeat, %verificar colisoes
			getMovCoords(X,Y),
			position(Pawn, Px, Py),
			wallCoords(X,Y,Px,Py,Wx,Wy),
			nth0(Wy, Board, Line),
			nth0(Wx, Line, WallElem),
		checkWall(WallElem),
		retract(position(Pawn, Xtmp , Ytmp )),
		Nx is Px + X*2, % * 2 por causa da parede
		Ny is Py + Y*2,
  	assert(position(Pawn, Nx, Ny)),
    emptyPosition(Px,Py,Board,AuxBoard),
    setBoardCell(Nx, Ny, Pawn, AuxBoard, NewBoard).

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
