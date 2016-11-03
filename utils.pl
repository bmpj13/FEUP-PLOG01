:- dynamic(position/3).
:- dynamic(wallNumber/3).

setCell(Index, Element, List, NewList) :-
		length(AuxL, Index),
		append(AuxL, [_ | E],List),
		append(AuxL, [Element | E], NewList).


%Initial Position
position([orange, 1], 6, 6).
position([orange, 2], 14, 6).
position([yellow, 1], 6, 20).
position([yellow, 2], 14, 20).

%Initial Wall Number
%type,horizontal number, vertical number
wallNumber(orange,9,9).
wallNumber(yellow,9,9).
