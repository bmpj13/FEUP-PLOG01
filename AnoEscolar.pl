:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- ensure_loaded('displayResults.pl').

% -------------- Estranho --------------
% cada disciplina  1 a 4 dias por semana % isto não é da responsabilidade de quem faz o horario???
%  -------------- TESTES --------------
% cada disciplina tem 2 testes por periodo(meio e fim )
% alunos não podem ter mais de 2 testes por semana
% alunos não podem ter testes em dias consecutivos
% testes de cada disciplina devem ser o mais proximo possivel em todas as turmas
%  -------------- TPC --------------
% alunos não podem ter mais de 2(Afinal é VARIAVEL) tpc por dia
% em pelo menos um dia por semana não pode haver tpc(um dia da semana que deve ser sempre o mesmo)
% em cada disciplina só pode haver tpc em metade das aulas(Afinal é VARIAVEL)


run(Days, Schedules, Classes):-
        statistics(runtime, [T0|_]),
        solve(Days, Schedules, Classes),
        statistics(runtime, [T1|_]),
        T is T1 - T0,
        format('solve/3 took ~3d sec.~n', [T]).


solve(Days, Schedules, Classes) :-
    format('~n---------------------------------- School Planning ----------------------------------~n',[]),
    % obter os id's de todas as disciplinas
    flatten(Schedules, Temp),
    sort(Temp, DisciplinesList),
    nl, displayDisciplines(DisciplinesList),

    %aplicar restricoes a cada turma
    processClasses(Days, Schedules, DisciplinesList, Classes),

    % testes de cada disciplina devem ser o mais proximo possivel entre todas as turmas
    testsCloseBetweenClasses(Classes, DisciplinesList, Sum1, Sum2),
    Sum #= Sum1 + Sum2,

    %obter lista com todas as variaveis test e tpc para label
    listClassesVars(Classes, [], R),
    !,
    labeling([ffc, down, minimize(Sum), time_out(90000, _)], R),
    (displayClasses(Classes, Days) ; true), nl, write(Sum1), nl, write(Sum2), nl.



testsCloseBetweenClasses(Classes, DisciplineIds, Sum1, Sum2) :-
    getTestDaysDiffSums(Classes, DisciplineIds, Sums1, Sums2),
    sum(Sums1, #=, Sum1),
    sum(Sums2, #=, Sum2).

getTestDaysDifferences([_], _, [], []).

getTestDaysDifferences([C1, C2 | Classes], DisciplineId, [Value1 | DiffList1], [Value2 | DiffList2]) :-
    member([DisciplineId, [Test1, Test2], _], C1),!, % isto não pode falhar / causar backtracking?
    member([DisciplineId, [Test3, Test4], _], C2),!,
    Value1 #= abs(Test3 - Test1),
    Value2 #= abs(Test4 - Test2),
    getTestDaysDifferences([C2 | Classes], DisciplineId, DiffList1, DiffList2).


getTestDaysDiffSums(Classes, [DisciplineId | DisciplineIds], [Sum1 | Sums1], [Sum2 | Sums2]) :-
    getTestDaysDifferences(Classes, DisciplineId, DiffList1, DiffList2),
    sum(DiffList1, #=, Sum1),
    sum(DiffList2, #=, Sum2),
    getTestDaysDiffSums(Classes, DisciplineIds, Sums1, Sums2).

getTestDaysDiffSums(_, [], [], []).


flatten([], []) :- !.
flatten([L|Ls], FlatL) :-
    !,
    flatten(L, NewL),
    flatten(Ls, NewLs),
    append(NewL, NewLs, FlatL).
flatten(L, [L]).


listClassesVars([Class | Classes], Acc, LabelsList) :-
    getLabelVars(Class, [], LabelVars),
    append(LabelVars, Acc, T),
    listClassesVars(Classes, T, LabelsList).

listClassesVars([], Acc, Acc).


%solver
processClasses(_, [], _, []).

processClasses(Days, [Schedule | Schedules], DisciplinesList, [Class | Classes]) :-
    solveClass(Days, Schedule, DisciplinesList, Class),
    processClasses(Days, Schedules, DisciplinesList, Classes).



%resolve problema de uma turma
solveClass(Days, Schedule, Disciplines, Class):-
  fillDisciplines(Days,Disciplines,Class),
  checkHasDiscipline(Class,Schedule), %coloca a 0 a lista de tpc e testes nos dias em que nao existem aulas dessa disciplina

  NoTpcDay = 1, % dia da semana em que nunca há tpc
  clearTpcDay(Class,NoTpcDay),
  maxNumberTpcPerDay(Class,Days,2), % alunos não podem ter mais de 2 TPCs por dia
  limitNumberOfTpcPerPeriod(Class,2,Schedule,Days),

  testPlacementRestrictions(Days,Class).


getLabelVars([], Res,Res).

getLabelVars([CurrentDiscipline | NextDiscipline], CurrentList ,Res) :-
  nth1(2,CurrentDiscipline,Test),
  nth1(3,CurrentDiscipline,Tpc),
  append(Test,Tpc,DisciplineVars),
  append(CurrentList,DisciplineVars,Nres),
  getLabelVars(NextDiscipline, Nres, Res).


%numero de aulas de uma disciplina num periodo

getNumberDisciplineLessons(_,_,N,N,0).

getNumberDisciplineLessons(Schedule,DisciplineId,N,Days,Res) :-
  Index is (N mod 5),
  nth0(Index, Schedule, L),
  N1 is N + 1,
  getNumberDisciplineLessons(Schedule,DisciplineId,N1,Days,R),
  ((member(DisciplineId, L), Res is R + 1 ,!) ; (Res is R , !)).


%tpc

% em cada disciplina só pode haver tpc em metade das aulas(Afinal é VARIAVEL)
% ratio 2 tpc no maximo em metade das aulas , ratio 3 tpc no maximo um terço das aulas
limitNumberOfTpcPerPeriod([],_,_,_).

limitNumberOfTpcPerPeriod([[DisciplineId, _, Tpc] | Tail],Ratio,Schedule,Days):-
  getNumberDisciplineLessons(Schedule,DisciplineId,0,Days,NumberLessons),
  MaxTpc is div(NumberLessons,Ratio),
  sum(Tpc,#=<,MaxTpc),
  limitNumberOfTpcPerPeriod(Tail, Ratio, Schedule, Days).



clearTpcDay([CurrentDiscipline | NextDiscipline],NoTpcDay) :-
  nth1(3,CurrentDiscipline,Tpc),
  freeTpcDay(0, Tpc, NoTpcDay),
  clearTpcDay(NextDiscipline, NoTpcDay).

clearTpcDay([], _).

freeTpcDay(N, [CurrentTpc | Tpc], NoTpcDay) :-
    Index is (N mod 5) + 1,
    (
        (Index = NoTpcDay, CurrentTpc #= 0, !) ;
        true
    ),
    N1 is N + 1,
    freeTpcDay(N1, Tpc, NoTpcDay).

freeTpcDay(_, [], _).




maxNumberTpcPerDay(Class,Days,N):-
  getDaySumList(2,Class,0,Days,Tpc), % lista com todos os dias e numero de tpc's de todas as disciplinas da turma nesse dia
  checkTpcNumber(Tpc,N).

checkTpcNumber([], _).

checkTpcNumber([CurrentTpc | NextTpc], N) :-
  CurrentTpc #=< N,
  checkTpcNumber(NextTpc, N).



%inicializacoes
fillDisciplines(_,[],[]).

% dias id das disciplinas
fillDisciplines(Days, [Dh | Dt], [H | T]):-
    getMidEndTerms(Days, MidInit, MidEnd, FinInit, FinEnd),
    Test = [Test1, Test2],
    domain([Test1], MidInit, MidEnd),
    domain([Test2], FinInit, FinEnd),
    length(Tpc,Days),
    domain(Tpc,0,1),
    H = [Dh,Test,Tpc],
    fillDisciplines(Days,Dt,T).


checkHasDiscipline([], _ ).

checkHasDiscipline([[DisciplineId,Test,Tpc] | Tail], Schedule) :-
    checkSchedule(0, DisciplineId, Test, Tpc, Schedule),
    checkHasDiscipline(Tail,Schedule).


checkSchedule(_, _, _, [], _).

checkSchedule(N, DisciplineId, [Test1, Test2], [H2|Tpc], Schedule) :-
    Index is (N mod 5) + 1,
    nth1(Index, Schedule, L),
    (
        (\+ member(DisciplineId, L), Test1 #\= N, Test2 #\= N, H2 #= 0, !)
            ; 
        true
    ),
    N1 is N+1,
    checkSchedule(N1, DisciplineId, [Test1, Test2], Tpc, Schedule).


% mid sublista de uma lista na 1 altura de testes, End na segunda altura de testes
getMidEndTerms(Days, InitMid, FinMid, InitEnd, FinEnd) :-
    InitMid is div(Days,6),
    FinMid is div(Days,2),
    InitEnd is FinMid + div(Days,6),
    FinEnd is Days.

%tests
getDaySum(_, [], _ , 0).

getDaySum(IdList,[CurrentDiscipline | NextDiscipline], Id, Value) :- !,
    nth0(IdList,CurrentDiscipline,List),
    nth0(Id,List,V),
    Value #= V1 + V,
    getDaySum(IdList,NextDiscipline, Id, V1).


getDaySumList(_, _, Days, Days, []).

%IdList 1-Test 2-Tpc
getDaySumList(IdList,Class,N,Days, Result):- !,
  getDaySum(IdList,Class, N, Val),
  N1 is N + 1,
  getDaySumList(IdList,Class,N1,Days, Val2),
  Result = [Val | Val2].

testPlacementRestrictions(Days, Class) :-
  getTestsList(Class, Tests),
  getCardinalityPairs(1, Days, Pairs, Vars),
  global_cardinality(Tests, Pairs),
  checkWeekTestNumber(Vars, 2),
  checkConsecutiveDayTests(1, Vars).


getTestsList([], []).

getTestsList([[_, [T1, T2], _] | Class], [T1, T2 | Tests]) :-
    getTestsList(Class, Tests).

getCardinalityPairs(Index, Days, [], []) :-
    Index =:= Days+1.

getCardinalityPairs(Index, Days, [Index-P | Pairs], [P | Vars]) :-
    Idx is Index + 1,
    getCardinalityPairs(Idx, Days, Pairs, Vars).


checkConsecutiveDayTests(Index, [T1, T2 | Tail]) :-
    !,
    (
        (Idx is Index mod 5, Idx =:= 0, sum([T1, T2], #=<, 2))
            ;
        (sum([T1, T2], #=<, 1))
    ),
    Index1 is Index + 1,
    checkConsecutiveDayTests(Index1, [T2 | Tail]).

checkConsecutiveDayTests(_, L) :-
    !,
    sum(L, #=<, 1).


%verifica se o num de testes por semana é menor ou igual a N
checkWeekTestNumber([T1, T2, T3, T4, T5 | Tail], N) :-
    !,
    sum([T1, T2, T3, T4, T5], #=<, N),
    checkWeekTestNumber(Tail, N).

%para quando a ultima semana nao tem 5 dias e condicao de paragem
checkWeekTestNumber(L, N) :-
    !,
    sum(L, #=<, N).
