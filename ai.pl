distance(X,Y,TargetX,TargetY,N) :-
  N is round(abs(X - TargetX)/2 +  abs(Y - TargetY)/2).


evaluateBestPawn(Player,N) :-
  position([Player, 1],X1,Y1),
  position([Player, 2],X2,Y2),
  getBestDistanceToTarget(X1,Y1,Player,NPlayer1),%a menor distancia para um target do player1
  getBestDistanceToTarget(X2,Y2,Player,NPlayer2),%a menor distancia para um target do player2
  getSmaller(NPlayer1,NPlayer2,Nend),%player com menor distancia para ganhar
  choosePlayer(Nend,NPlayer1,NPlayer2,N).


choosePlayer(Nend,NPlayer1,NPlayer2,N) :-
  Nend =:= NPlayer1 ,Nend =:= NPlayer2,random_member(RandPlayer, [1,2]), N is RandPlayer.

choosePlayer(Nend,NPlayer1,NPlayer2,N) :-
  Nend =:= NPlayer1 , N is 1.

choosePlayer(Nend,NPlayer1,NPlayer2,N) :-
  Nend =:= NPlayer2 , N is 2.


evaluateBestDirection(Player,Id,Directions):-
  position([Player,Id],X,Y),
  %calcular distancia a que fica do targer
  %North
  Xn is X,Yn is Y - 1,
  getBestDistanceToTarget(Xn,Yn,Player,N),
  %South
  Xs is X,Ys is Y + 1,
  getBestDistanceToTarget(Xs,Ys,Player,S),
  %West
  Xw is X - 1,Yw is Y,
  getBestDistanceToTarget(Xw,Yw,Player,W),
  %East
  Xe is X + 1,Ye is Y,
  getBestDistanceToTarget(Xe,Ye,Player,E),
  %ordenar distancias
  samsort( [[N,1],[S,2],[W,3],[E,4]],  AuxDirections),
  shuffleList(AuxDirections,Directions).

shuffleList([H|T],Nlist):-
  random_permutation(T, NewT),
  Nlist = [H|NewT].

evaluateBestWall(Player,Walls) :-
  getOponent(Player,Oponent),
  evaluateBestPawn(Oponent,Id),
  evaluateBestDirection(Oponent,Id,Direction),
  nth0(0,Direction,Elem1),
  createWallCoords([Oponent,Id],Elem1,W1,W2),
  nth0(1,Direction,Elem2),
  createWallCoords([Oponent,Id],Elem2,W3,W4),
  nth0(2,Direction,Elem3),
  createWallCoords([Oponent,Id],Elem3,W5,W6),
  nth0(3,Direction,Elem4),
  createWallCoords([Oponent,Id],Elem4,W7,W8),
  Walls = [W1,W2,W3,W4,W5,W6,W7,W8].

%north/south
createWallCoords(Pawn,[_ , Direction],Wall1,Wall2) :-
  (Direction = 1 ; Direction = 2 ),
  position(Pawn,Px,Py),
  convertDirection(Direction,X,Y),
  Wx is Px + X , Wy is Py + Y,
  O = h ,
  Wall1 = [Wx,Wy,O],
  Wx2 is Wx - 1,
  Wall2 = [Wx2,Wy,O].

%east/west
createWallCoords(Pawn,[_ , Direction],Wall1,Wall2) :-
  (Direction = 3 ; Direction = 4 ),
  position(Pawn,Px,Py),
  convertDirection(Direction,X,Y),
  Wx is Px + X , Wy is Py + Y,
  O = v ,
  Wall1 = [Wx,Wy,O],
  Wy2 is Wy - 2,
  Wall2 = [Wx,Wy2,O].


getOponent(Player,Oponent):-
  (Player = yellow, Oponent = orange);
  (Player = orange, Oponent = yellow).


%menor distancia das cordenadas x y a um dos target do player Player
getBestDistanceToTarget(X,Y,Player,N) :-
    targePosition([Player, 1], Tx,Ty),
    distance(X,Y,Tx,Ty,N1),
    targePosition([Player, 2], Tx2,Ty2),
    distance(X,Y,Tx2,Ty2,N2),
    getSmaller(N1,N2,N).


getSmaller(N1,N2,N):-
  (N1 < N2, N is N1) ;
  (N1 >= N2, N is N2).
