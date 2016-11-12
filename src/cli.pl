%placing wall
getPlaceWal(Answer) :-
		out('Do you want to place a wall this turn?'),
		out('1. yes || 2. no '),
		read(Answer).

getWallCoords(X, Y, O) :-
		out('Wall coords'),
		write('Enter X coord: '),
		read(X),
		write('Enter Y coord: '),
		read(Y),
		write('Enter Orientation (h/v)'),
		read(O).

%Moving Pawn
getPawnMov(X,Y) :-
	getMovCoords(X1, Y1),
	getMovCoords(X2, Y2),
	X is X1 + X2,
	Y is Y1 + Y2.

getMovCoords(X, Y) :-
	getMovDirection(M),
	convertDirection(M,X,Y).

convertDirection(M,X,Y) :-
	((M =:= 1 , X is 0 , Y is -1);
	 (M =:= 2 , X is 0 , Y is 1);
	 (M =:= 3 , X is -1, Y is 0);
	 (M =:= 4 , X is 1,Y is 0);
	 (M =:= 5 , X is 0,Y is 0)).



getMovDirection(M) :-
		out('Direction'),
		out('1. North || 2. South || 3. West || 4. East || 5. None'),
		read(M).


getPawnNumber(N) :-
		out('Wich pawn do you want to move?'),
		out('1.Pawn number 1 || 2. Pawn number 2 '),
		read(N).



%cli utils
getNumber(N) :-
        get_code(C), %numero em ascii
        get_char(_), %para ler o enter tambem
        N is C - 48. %ascii de 0 e 48


displayLog(Message) :-
	logMessages(X),
	((X =:= 1 , out(Message)) ; (true)).
