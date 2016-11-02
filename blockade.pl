:- dynamic(board/1).
:- dynamic(position/3).
:- use_module(library(lists)).

board([[square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square],
				[[horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty]],
				[square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square],
				[[horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty]],
				[square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square],
				[[horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty]],
				[square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], [orange,1], [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], [orange,2], [vertical, empty], square, [vertical, empty], square, [vertical, empty], square],
				[[horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty]],
				[square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square],
				[[horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty]],
				[square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square],
				[[horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty]],
				[square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square],
				[[horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty]],
				[square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square],
				[[horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty]],
				[square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square],
				[[horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty]],
				[square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square],
				[[horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty]],
				[square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], [yellow, 1], [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], [yellow, 2], [vertical, empty], square, [vertical, empty], square, [vertical, empty], square],
				[[horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty]],
				[square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square],
				[[horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty]],
				[square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square],
				[[horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty], [horizontal, empty]],
				[square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square, [vertical, empty], square] ]).


position([orange, 1],6,6).
position([orange, 2],14,6).
position([yellow, 1],6,20).
position([yellow, 1],14,20).



% 3x3 Components:
% Square
translate(square, 'top', '   ').
translate(square, 'mid', '   ').
translate(square, 'bottom', '   ').

% Orange's first pawn
translate([orange, 1], 'top', '___').
translate([orange, 1], 'mid', '|O|').
translate([orange, 1], 'bottom', '\'\'\'').

% Orange's second pawn
translate([orange, 2], 'top', '___').
translate([orange, 2], 'mid', '|O|').
translate([orange, 2], 'bottom', '^^^').

% Orange's base
translate([orange, base], 'top', '   ').
translate([orange, base], 'mid', '[O]').
translate([orange, base], 'bottom', '   ').

% Yellow's first pawn
translate([yellow, 1], 'top', '___').
translate([yellow, 1], 'mid', '|Y|').
translate([yellow, 1], 'bottom', '\'\'\'').

% Yellow's second pawn
translate([yellow, 2], 'top', '___').
translate([yellow, 2], 'mid', '|Y|').
translate([yellow, 2], 'bottom', '^^^').

% Yellow's base
translate([yellow, base], 'top', '   ').
translate([yellow, base], 'mid', '[Y]').
translate([yellow, base], 'bottom', '   ').

% Vertical wall slot
translate([vertical, empty], 'top', ' . ').
translate([vertical, empty], 'mid', ' . ').
translate([vertical, empty], 'bottom', ' . ').

% Vertical wall (placed)
translate([vertical, placed], 'top', ' X ').
translate([vertical, placed], 'mid', ' X ').
translate([vertical, placed], 'bottom', ' X ').


% 6x1 Components:
% Horizontal wall slot
translate([horizontal, empty], 'single', '----- ').

% Horizontal wall (placed)
translate([horizontal, placed], 'single', 'XXXXX ').



displayBoard(Ls) :-
	nl,
	write('******************************BLOCKADE*****************************'), nl,
	write('   0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 '), nl,
	write(' ------------------------------------------------------------------'), nl,
	displayBoardAux(Ls, 0).



displayBoardAux([L1 | Ls], Line) :-
	(display3x3(L1, Line) ; display6x1(L1, Line)),
	N is Line+1,
	displayBoardAux(Ls, N).

displayBoardAux([], Line) :-
	write(' ------------------------------------------------------------------'), nl, nl.



display3x3(L1, Line) :-
	Line mod 2 =:= 0,
	write('| '), displayLine(L1, 'top'),
	write('| '), displayLine(L1, 'mid', Line),
	write('| '), displayLine(L1, 'bottom').



display6x1(L1, Line) :-
	Line mod 2 =\= 0,
	write(' '), displayLine(L1, 'single', Line).



displayLine([E1 | Es], Type) :-
	displayElement(E1, Type),
	displayLine(Es, Type).

displayLine([], Type) :-
	write(' | '),
	nl.


displayLine([E1 | Es], Type, Line) :-
	displayElement(E1, Type),
	displayLine(Es, Type, Line).

displayLine([], Type, Line) :-
	Line mod 2 =\= 0,
	write('  '),
	write(Line),
	nl.

displayLine([], Type, Line) :-
	Line mod 2 =:= 0,
	write(' |  '),
	write(Line),
	nl.



displayElement(Element, Type) :-
	translate(Element, Type, T),
	write(T).

%jogo

game :-	repeat,
				retract(board(X)),
				once(play(orange,X,NBoard)),
				once(displayBoard(NBoard)), %não se devia ter que por ONCE ????
				once(play(yellow,NBoard,N1Board)),
				once(displayBoard(N1Board)),
				assert(board(N1Board)),
				fail.



play(Player,Board,NBoard) :-
					write(Player),nl,
					getPawnCoords(X,Y),
					move(X,Y,[Player,1],Board,AuxBoard),
					getWallCoords(X1,Y1,O),
					write('ola'),
					place_Wall(X1,Y1,O,AuxBoard,NBoard).


place_Wall(X,Y,'h',Board,NBoard) :-
					set_board_cell(X,Y,[horizontal,placed],Board,AuxBoard),
					Nx is X + 1,
					set_board_cell(Nx,Y,[horizontal,placed],AuxBoard,NBoard).

place_Wall(X,Y,'v',Board,NBoard) :-
						set_board_cell(X,Y,[vertical,placed],Board,AuxBoard),
						Ny is Y + 2,
						set_board_cell(X,Ny,[vertical,placed],AuxBoard,NBoard).


getWallCoords(X,Y,O) :-
						write('Wall coords'),nl,
						write('Enter X coord: '),
						read(X),
						write('Enter Y coord: '),
						read(Y),
						write('Enter Orientation (h/v)'),
						read(O).


getPawnCoords(X,Y) :-
				write('Pawn coords'),nl,
				write('Enter X coord: '),
				read(X),
				write('Enter Y coord: '),
				read(Y).

move(X,Y,Pawn,Board,NBoard) :-
				retract(position(Pawn,Px,Py)),
				assert(position(Pawn,X,Y)),
				set_board_cell(Px,Py,square,Board,AuxBoard),
				set_board_cell(X,Y,Pawn,AuxBoard,NBoard).



set_board_cell(X,Y,Elem,Board,NBoard) :-
			nth0(Y,Board,Line),
			setCell(X,Elem,Line,Nline),
			setCell(Y,Nline,Board,NBoard).

setCell(Index,Element,List,NList) :-
			length(AuxL,Index),
			append(AuxL, [_ | E],List),
			append(AuxL,[Element | E],NList).
