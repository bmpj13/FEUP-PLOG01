:- dynamic(position/3).
:- dynamic(wallNumber/3).
:- dynamic(currentPlayer/1).
:- dynamic(logMessages/1).

%set's a Index of a list to the Elem instatiating a NewList with the result
%setCell(+Index, +Element, +List, -NewList)
setCell(Index, Element, List, NewList) :-
		length(AuxL, Index),
		append(AuxL, [_ | E],List),
		append(AuxL, [Element | E], NewList).

%get's the Elem in the position (X,Y) of the board
%elementCoords(+Board, +X, +Y, -Elem)
elementCoords(Board, X, Y, Elem) :-
		nth0(Y, Board, Line),
		nth0(X, Line, Elem).

%get's the Oponent of the Player
%getOponent(+Player,-Oponent)
getOponent(Player,Oponent) :-
  (Player = yellow, Oponent = orange);
  (Player = orange, Oponent = yellow).

%convert's de direction M to coordinates (X,Y)
%convertDirection(+M,-X,-Y)
convertDirection(M,X,Y) :-
	((M =:= 1 , X is 0 , Y is -1);
	 (M =:= 2 , X is 0 , Y is 1);
	 (M =:= 3 , X is -1, Y is 0);
	 (M =:= 4 , X is 1,Y is 0);
	 (M =:= 5 , X is 0,Y is 0)).

%get's the minimum value on a list
%min(List,Value)
min([],X,X).
min([H|T],M,X) :- H =< M, min(T,H,X).
min([H|T],M,X) :- M < H, min(T,M,X).
min([H|T],X) :- min(T,H,X).


%writes every element of a list
%writeList(List)
writeList([]).

writeList([H | T]) :-
  write(H), nl,
  writeList(T).


%log messages
%when logMessages = 1 the error messages are displayed
logMessages(1).

%change the log message state to X
%logMessagesState(+X)
logMessagesState(X) :-
	retract(logMessages(_)),
	assert(logMessages(X)).



%Initial Position's of the pawn's
position([orange, 1], 6, 6).
position([orange, 2], 14, 6).
position([yellow, 1], 6, 20).
position([yellow, 2], 14, 20).

%Initial Wall Number
%type,horizontal number, vertical number
wallNumber(orange,9,9).
wallNumber(yellow,9,9).

%Initial Player
currentPlayer(orange).
%target position
%targePosition([player, target number], X,Y)
targePosition([yellow, 1], 6, 6).
targePosition([yellow, 2], 14, 6).
targePosition([orange, 1], 6, 20).
targePosition([orange, 2], 14, 20).
