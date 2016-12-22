:-use_module(library(lists)).

translateDiscipline(1, 'Portuguese').
translateDiscipline(2, 'English').
translateDiscipline(3, 'Math').
translateDiscipline(4, 'Biology').
translateDiscipline(5, 'Chemistry').
translateDiscipline(6, 'Physics').
translateDiscipline(7, 'History').
translateDiscipline(_, 'Others').

translateDayToWeek(1, 'Monday').
translateDayToWeek(2, 'Tuesday').
translateDayToWeek(3, 'Wednesday').
translateDayToWeek(4, 'Thursday').
translateDayToWeek(0, 'Friday').



display(Classes, Days) :-
  format('~n---------------------------------- School Planning ----------------------------------~n',[]),
  displayClasses(Classes, Days).

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
  format('~n--------------------------------------- Tests --------------------------------------- ~n',[]),
  displayTests(Class), !,
  format('~n-------------------------------------- Homework ------------------------------------- ~n',[]),
  displayTPCs(Class, 1, Days), !.


displayTests([]).

displayTests([[DisciplineId, [T1, T2], _] | Class]) :-
  translateDiscipline(DisciplineId, Discipline),
  Week1Day is T1 mod 5,
  Week2Day is T2 mod 5,
  translateDayToWeek(Week1Day, Week1),
  translateDayToWeek(Week2Day, Week2),
  format('~w~n', [Discipline]),
  format('First test: day ~w (~w).~n', [T1, Week1]),
  format('Second test: day ~w (~w).~n~n', [T2, Week2]),
  displayTests(Class).


displayTPCs(_, Day, Days) :-
  Day =:= Days+1.

displayTPCs(Class, Day, Days) :-
  WeekDay is Day mod 5,
  translateDayToWeek(WeekDay, Week),
  getHomeworkDisciplines(Class, Day, HomeworkDisciplines),
  printHomeworkDisciplines(Day, Week, HomeworkDisciplines),
  D is Day+1,
  displayTPCs(Class, D, Days).


getHomeworkDisciplines([], _, []).

getHomeworkDisciplines([CurrentDiscipline | NextDiscipline], Index, [DisciplineString | HomeworkDisciplines]) :-
  nth1(1, CurrentDiscipline, DisciplineId),
  translateDiscipline(DisciplineId, DisciplineString),
  nth1(3,CurrentDiscipline, List),
  nth1(Index, List, HasHomework),
  HasHomework =:= 1, !,
  getHomeworkDisciplines(NextDiscipline, Index, HomeworkDisciplines).

getHomeworkDisciplines([_ | NextDiscipline], Index, HomeworkDisciplines) :-
  getHomeworkDisciplines(NextDiscipline, Index, HomeworkDisciplines).


printHomeworkDisciplines(_, _, HomeworkDisciplines) :-
  HomeworkDisciplines = [], !.

printHomeworkDisciplines(Day, Week, HomeworkDisciplines) :-
  format('Day ~w (~w): ', [Day, Week]),
  printDisciplines(HomeworkDisciplines).

printDisciplines([Discipline]) :-
  format(' ~s~n', [Discipline]).

printDisciplines([Discipline | HomeworkDisciplines]) :-
  format(' ~s |', [Discipline]),
  printDisciplines(HomeworkDisciplines).