:-use_module(library(lists)).

%solveClass(13,[[1],[2],[2],[1,5],[1,5]],[1,2,5],L).

translateDiscipline(1,'Portugues').
translateDiscipline(2,'Ingles').
translateDiscipline(3,'Matematica').
translateDiscipline(4,'Biologia').
translateDiscipline(5,'Quimica').
translateDiscipline(6,'Ed.Fisica').
translateDiscipline(7,'Historia').
translateDiscipline(_,'Vida').

displayDisciplines([]).

displayDisciplines([DisciplineH | DisciplineT]) :-
  translateDiscipline(DisciplineH,DisciplineString),
  format('Discipline Index(~w) - ~s ~n',[DisciplineH,DisciplineString]),
  displayDisciplines(DisciplineT),!.

displayClasses([Class | Classes], Days) :-
  format('~n--------------------------------------- Class ---------------------------------------~n',[]),
  displayClass(Class, Days),
  displayClasses(Classes, Days).

displayClasses([], []).


displayClass(Class, Days):-
  format('~n--------------------------------------- Tests ---------------------------------------- ~n',[]),
  displayTests(Class),!,
  format('~n---------------------------------------- Tpc ----------------------------------------- ~n',[]),
  displayDayList(Class,3,0,Days),!.


displayTests([]).

displayTests([[_, T, _] | Class]) :-
  write(T), nl,
  displayTests(Class).

displayDayList(_,_,N,N).

displayDayList(Class,Val,N,Days) :-
  displayNday(N),
  printValueTranslated(Class,Val,N),nl,
  N1 is N + 1,
  displayDayList(Class,Val,N1,Days).

printValueTranslated([],_,_).

printValueTranslated([CurrentDiscipline | NextDiscipline],Val,Index):-
  nth1(1,CurrentDiscipline, DisciplineId),
  translateDiscipline(DisciplineId,DisciplineString),
  nth1(Val,CurrentDiscipline, List),
  nth0(Index,List,Bool),
  ((Bool =:= 1, format(' ~s |',[DisciplineString])) ; true),
  printValueTranslated(NextDiscipline,Val,Index).


displayNday(N) :-
  Day is (N mod 5),
  (
    (Day =:= 0, nl, format('Day ~w - Monday -> ',[N]));
    (Day =:= 1, format('Day ~w - Tuesday -> ',[N]));
    (Day =:= 2, format('Day ~w - Wednesday -> ',[N]));
    (Day =:= 3, format('Day ~w - Thursday -> ',[N]));
    (Day =:= 4, format('Day ~w - Friday -> ',[N]))
  ).
