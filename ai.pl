distance(X,Y,TargetX,TargetY,N) :-
  N is round(abs(X - TargetX)/2 +  abs(Y - TargetY)/2).


evaluateBestPawn(Player,N) :-
  position([Player, 1],X1,Y1),
  position([Player, 2],X2,Y2),
  getBestDistanceToTarget(X1,Y1,Player,NPlayer1),%a menor distancia para um target do player1
  getBestDistanceToTarget(X2,Y2,Player,NPlayer2),%a menor distancia para um target do player2
  getSmaller(NPlayer1,NPlayer2,Nend),%player com menor distancia para ganhar
  ((Nend =:= NPlayer1 , N is 1) ; (Nend =:= NPlayer2 , N is 2)).

getSmaller(N1,N2,N):-
  (N1 < N2, N is N1) ;
  (N1 >= N2, N is N2).

evaluateBestDirection(Player,Id,Direction):-
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
  samsort( [[N,1],[S,2],[W,3],[E,4]],  Direction),
  write(Direction).



%menor distancia das cordenadas x y a um dos target do player Player
getBestDistanceToTarget(X,Y,Player,N) :-
    targePosition([Player, 1], Tx,Ty),
    distance(X,Y,Tx,Ty,N1),
    targePosition([Player, 2], Tx2,Ty2),
    distance(X,Y,Tx2,Ty2,N2),
    getSmaller(N1,N2,N).
