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



validPosition(_, _, 0, 0,_) :-
		true.

validPosition(Pawn, Board, X, Y,Nx,Ny) :-
	targetIsValid(Pawn, Board, X, Y,Nx,Ny).


noWallBlocking(Pawn, Board, X, Y) :-
	position(Pawn, Px, Py),
	wallCoords(X,Y, Px,Py, Wx, Wy), format('~n Wx : ~w | Wy : ~w',[Wx, Wy]),
	elementCoords(Board, Wx, Wy, Elem),
	checkWallColision(Elem).


targetIsValid(Pawn, Board, X, Y,Nx,Ny) :-
	targetCoords(Pawn, X,Y, Tx,Ty),
	inBounds(Tx, Ty),
	elementCoords(Board, Tx, Ty, Elem),
	(
    ((Elem = square ; Elem = [orange, base] ; Elem = [yellow, base]),
      Nx is X ,Ny is Y, !,
      noWallBlocking(Pawn, Board, X, Y)) ;
    ((Elem = [orange, 1] ; Elem = [orange, 2] ; Elem = [yellow, 1];Elem = [yellow, 1] ),
      checkJumpOver(Pawn,X,Y,Nx,Ny),
      Aux1 is Nx + X,
      Aux2 is Ny + Y, !,
      noWallBlocking(Pawn, Board, Aux1, Aux2), write('after wall'))
  ).


checkJumpOver(Pawn,X,Y,Nx,Ny) :-
    write('JUMP OVER'), nl, nl,
    Nx is X + X,
    Ny is Y + Y,
    targetCoords(Pawn, Nx,Ny, Tx,Ty),
  	inBounds(Tx, Ty).






targetIsValid(_, _, _, _,_) :-
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


placeWall(Player,X, Y,'h',Board, NewBoard) :-%!!! não deixar dar place se a wall bloquear todos os caminhos ao jogador
	checkWallCoords(X, Y,'h',Board),
  manageEdges(remove, X,Y,'h'),
  evaluateMinPath(Player, 1, P1, Cost1, P2, Cost2),
  evaluateMinPath(Player, 2, P3, Cost3, P4, Cost4),
  evaluateMinPath(Oponent, 1, P5, Cost5, P6, Cost6),
  evaluateMinPath(Oponent, 2, P7, Cost7, P8, Cost8), !,
  playerHasPath(X, Y, O, Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8),
	retract(wallNumber(Player, H, V)),
	Nh is H - 1,
	assert(wallNumber(Player, Nh, V)),
	Nx is round(X/2),
  setBoardCell(Nx, Y, [horizontal, placed], Board, AuxBoard),
	Nx2 is Nx + 1,
	setBoardCell(Nx2, Y, [horizontal, placed], AuxBoard, NewBoard).


placeWall(Player,X, Y,'v',Board, NewBoard) :-
  getOponent(Player, Oponent),
	checkWallCoords(X, Y,'v',Board),
  manageEdges(remove, X,Y,'v'),
  evaluateMinPath(Player, 1, P1, Cost1, P2, Cost2),
  evaluateMinPath(Player, 2, P3, Cost3, P4, Cost4),
  evaluateMinPath(Oponent, 1, P5, Cost5, P6, Cost6),
  evaluateMinPath(Oponent, 2, P7, Cost7, P8, Cost8), !,
  playerHasPath(X, Y, O, Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8),
	retract(wallNumber(Player, H, V)),
	Nv is V - 1,
	assert(wallNumber(Player, H, Nv)),
  setBoardCell(X, Y, [vertical, placed], Board, AuxBoard),
	Ny is Y + 2,
	setBoardCell(X, Ny, [vertical, placed], AuxBoard, NewBoard).


playerHasPath(_, _, _, Cost1, Cost2, Cost3, Cost4, Cost5, Cost6, Cost7, Cost8) :-
  Cost1 =\= 0,
  Cost2 =\= 0,
  Cost3 =\= 0,
  Cost4 =\= 0,
  Cost5 =\= 0,
  Cost6 =\= 0,
  Cost7 =\= 0,
  Cost8 =\= 0.

playerHasPath(X, Y, O, _, _, _, _, _, _, _, _) :-
  manageEdges(add, X, Y, O), fail.


manageEdges(Management, X,Y,'h') :-
  retract(graph(G)),
  Y1 is Y - 1,
  Y2 is Y + 1,
  NX is X + 2,
  (
    (Management = remove, del_edges(G,[[X,Y1]-[X,Y2],[X,Y2]-[X,Y1],[NX,Y1]-[NX,Y2],[NX,Y2]-[NX,Y1]], Ng)) ;
    (Management = add, add_edges(G,[[X,Y1]-[X,Y2],[X,Y2]-[X,Y1],[NX,Y1]-[NX,Y2],[NX,Y2]-[NX,Y1]], Ng))
  ),
  assert(graph(Ng)).

manageEdges(Management, X,Y,'v') :-
  retract(graph(G)),
  X1 is X - 1,
  X2 is X + 1,
  NY is Y + 2,
  (
    (Management = remove, del_edges(G,[[X1,Y]-[X2,Y],[X2,Y]-[X1,Y],[X1,NY]-[X2,NY],[X2,NY]-[X1,NY]], Ng)) ;
    (Management = add, add_edges(G,[[X1,Y]-[X2,Y],[X2,Y]-[X1,Y],[X1,NY]-[X2,NY],[X2,NY]-[X1,NY]], Ng))
  ),
  assert(graph(Ng)).


checkWallCoords(X, Y,'v',Board) :-
	X mod 2 =:= 1,
	Y mod 2 =:= 0,
	X < 20, X > 0,
	Y < 25, Y >= 0,
	noWallPlaced(Board, X, Y, 'v'),
	Cx is X - 1,
	Cy is Y + 1,
	noWallCrossing(Board, Cx, Cy, 'h').


checkWallCoords(X, Y,'h',Board) :-
	X mod 2 =:= 0,
	Y mod 2 =:= 1,
	X >= 0, X < 19,
	Y > 0, Y < 26,
	noWallPlaced(Board, X, Y, 'h'),
	Cx is X + 1,
	Cy is Y - 1,
	noWallCrossing(Board, Cx, Cy, 'v').


checkWallCoords(_,_,_,_) :-
	write('---- Invalid wall coordenates ----'),nl,
	fail.



noWallPlaced(Board, X, Y, 'h') :-
  Nx is round(X/2),
  elementCoords(Board, Nx, Y, Elem1),
  Nx2 is Nx + 1,
  elementCoords(Board, Nx2, Y, Elem2),
  (Elem1 = [_, empty] , Elem2 = [_, empty]).


noWallPlaced(Board, X, Y, 'v') :-
  elementCoords(Board, X, Y, Elem1),
  Ny is Y + 2,
  elementCoords(Board, X, Ny, Elem2),
  (Elem1 = [_, empty] , Elem2 = [_, empty]).


noWallCrossing(Board, X, Y, 'h') :-
  Nx is round(X/2),
  elementCoords(Board, Nx, Y, Elem1),
  Nx2 is Nx + 1,
  elementCoords(Board, Nx2, Y, Elem2),
  (Elem1 = [_, empty] ; Elem2 = [_, empty]).


noWallCrossing(Board, X, Y, 'v') :-
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
