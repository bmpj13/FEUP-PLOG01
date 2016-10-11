board([ [0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0],
	  		[h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h],
				[0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0],
				[h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h],
				[0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0],
				[h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h],
				[0, v, 0, v, 0, v, ob, v, 0, v, 0, v, 0, v, ob, v, o2, v, 0, v, 0],
				[h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h],
				[0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0],
				[h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h],
				[0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0],
				[h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h],
				[0, v, 0, v, 0, v, 0, v, o1, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0],
				[h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h],
				[0, v, 0, v, 0, v, 0, v, 0, v, 0, v, y2, v, 0, v, 0, v, 0, v, 0],
				[h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h],
				[0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0],
				[h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h],
				[0, v, y1, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0],
				[h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h],
				[0, v, 0, v, 0, v, yb, v, 0, v, 0, v, 0, v, yb, v, 0, v, 0, v, 0],
				[h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h],
				[0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0],
				[h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h],
				[0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0],
				[h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h, h],
				[0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0, v, 0] ]).


% 3x3 Components:
% Square
translate(0, 'top', '   ').
translate(0, 'mid', '   ').
translate(0, 'bottom', '   ').

% Orange's first pawn
translate(o1, 'top', '/ \\').
translate(o1, 'mid', '|1|').
translate(o1, 'bottom', '\\ /').

% Orange's second pawn
translate(o2, 'top', '/ \\').
translate(o2, 'mid', '|1|').
translate(o2, 'bottom', '\\ /').

% Orange's base
translate(ob, 'top', '   ').
translate(ob, 'mid', ' O ').
translate(ob, 'bottom', '   ').

% Yellow's first pawn
translate(y1, 'top', '/ \\').
translate(y1, 'mid', '|2|').
translate(y1, 'bottom', '\\ /').

% Yellow's second pawn
translate(y2, 'top', '/ \\').
translate(y2, 'mid', '|2|').
translate(y2, 'bottom', '\\ /').

% Yellow's base
translate(yb, 'top', '   ').
translate(yb, 'mid', ' Y ').
translate(yb, 'bottom', '   ').

% Vertical wall slot
translate(v, 'top', '   ').
translate(v, 'mid', '   ').
translate(v, 'bottom', '   ').

% Vertical wall (placed)
translate(wv, 'top', ' | ').
translate(wv, 'mid', ' | ').
translate(wv, 'bottom', ' | ').


% 3x1 Components:
% Horizontal wall slot
translate(h, 'single', '   ').

% Horizontal wall (placed)
translate(wh, 'single', '---').



displayBoard(Ls) :-
	write('   1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21'), nl,
	write('  ---------------------------------------------------------------'), nl,
	displayBoardAux(Ls, 1).



displayBoardAux([L1 | Ls], Number) :-
	(display3x3(L1, Number) ; display3x1(L1, Number)),
	N is Number+1,
	displayBoardAux(Ls, N).

displayBoardAux([], Number) :-
	write(' -----------------------------------------------------------------'), nl.



display3x3(L1, Number) :-
	Number mod 2 =\= 0,
	write('||'), displayLine(L1, 'top'),
	write('||'), displayLine(L1, 'mid', Number),
	write('||'), displayLine(L1, 'bottom').



display3x1(L1, Number) :-
	Number mod 2 =:= 0,
	write('||'), displayLine(L1, 'single', Number).



displayLine([E1 | Es], Type) :-
	displayElement(E1, Type),
	displayLine(Es, Type).

displayLine([], Type) :-
	write('||'),
	nl.


displayLine([E1 | Es], Type, Number) :-
	displayElement(E1, Type),
	displayLine(Es, Type, Number).

displayLine([], Type, Number) :-
	write('||'),
	write(Number),
	nl.



displayElement(Element, Type) :-
	translate(Element, Type, T),
	write(T).
