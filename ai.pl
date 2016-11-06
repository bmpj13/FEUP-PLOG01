distance(Pawn,TargetX,TargetY,N) :-
  position(Pawn,X,Y),
  N is abs(X - TargetX)/2 +  abs(Y - TargetY)/2.



evaluateBestPawn(Player) :-
  distance([Player, 1],6,20,N1),
  distance([Player, 1],14.20,N2),
  distance([Player, 2],6,20,N3),
  distance([Player, 2],14.20,N4),
