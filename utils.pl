setCell(Index, Element, List, NewList) :-
		length(AuxL, Index),
		append(AuxL, [_ | E],List),
		append(AuxL, [Element | E], NewList).
