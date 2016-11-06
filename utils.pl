:- dynamic(position/3).
:- dynamic(wallNumber/3).
:- dynamic(currentPlayer/1).

setCell(Index, Element, List, NewList) :-
		length(AuxL, Index),
		append(AuxL, [_ | E],List),
		append(AuxL, [Element | E], NewList).


elementCoords(Board, X, Y, Elem) :-
		nth0(Y, Board, Line),
		nth0(X, Line, Elem).


%Initial Position
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

%Base position
basePosition([orange, 1], 6, 6).
basePosition([orange, 2], 14, 6).
basePosition([yellow, 1], 6, 20).
basePosition([yellow, 2], 14, 20).
