:-use_module(library(clpfd)).
:-use_module(library(lists)).
:- ensure_loaded('displayResults.pl').

% -------------- Estranho --------------
% cada disciplina  1 a 4 dias por semana % isto não é da responsabilidade de quem faz o horario???
%  -------------- TESTES --------------
% cada disciplina tem 2 testes por periodo(meio e fim )-> falta restringir a altura dos testes
% alunos não podem ter mais de 2 testes por semana ->feito
% alunos não podem ter testes em dias consecutivos ->feito
%  -------------- TPC --------------
% alunos não podem ter mais de 2(Afinal é VARIAVEL) tpc por dia -> feito
% em pelo menos um dia por semana não pode haver tpc(um dia da semana que deve ser sempre o mesmo)
% em cada disciplina só pode haver tpc em metade das aulas(Afinal é VARIAVEL)
% --------------- FODEU ----------------
% testes de cada disciplina devem ser o mais proximo possivel em todas as turmas


%lê o ficheiro resolve o problema para cada turma e faz output
%solveProblem().
%for each class call resolve class and display results

%solver
%resolve problema de uma turma
solveClass(Days,Schedule,Disciplines,Class):-
  fillDisciplines(Days,Disciplines,Class),
  checkHasDiscipline(Class,Schedule),%coloca a 0 a lista de tpc e testes nos dias em que nao existem aulas dessa disciplina
  domain([NoTpcDay], 1, 5), % dia da semana em que nunca há tpc

  %clearTpcDay(Class,NoTpcDay),
  maxNumberTpcPerDay(Class,Days,2), % alunos não podem ter mais de 2(Afinal é VARIAVEL) tpc por dia
  limitNumberOfTpcPerPeriod(Class,2,Schedule,Days),

  twoTestsPerPeriod(Class), % garantir 2 testes por periodo, FALTA POLOS NO MEIO/FIM do PERIODO
  testPlacementRestrictions(Days,Class),

  getLabelVars(Class,[],Res),
  append([NoTpcDay],Res,Resolution),
  write('Res'), nl,
  labeling([ff, down],Resolution),
  displayClass(Class,Days),
  format('No Tpc Day: ~w ~n',[NoTpcDay]).



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
        (Index = NoTpcDay, CurrentTpc #= 0) ;
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
    length(Test,Days),
    domain(Test,0,1),
    length(Tpc,Days),
    domain(Tpc,0,1),
    H = [Dh,Test,Tpc],
    fillDisciplines(Days,Dt,T).


checkHasDiscipline([], _ ).

checkHasDiscipline([[DisciplineId,Test,Tpc] | Tail], Schedule) :-
    checkSchedule(0, DisciplineId, Test, Tpc, Schedule),
    checkHasDiscipline(Tail,Schedule).


checkSchedule(_, _, [], [], _).

checkSchedule(N, DisciplineId, [H1|Test], [H2|Tpc], Schedule) :-
    Index is (N mod 5) + 1,
    nth1(Index, Schedule, L),
    (\+ member(DisciplineId, L),
    H1 #= 0, H2 #= 0, !; true),
    N1 is N+1,
    checkSchedule(N1, DisciplineId, Test, Tpc, Schedule).


twoTestsPerPeriod([]).

twoTestsPerPeriod([CurrentDiscipline | NextDiscipline]) :-
    nth1(2,CurrentDiscipline,Tests),
    sum(Tests,#=,2),
    %placeTests(Tests),
    twoTestsPerPeriod(NextDiscipline).

placeTests(Tests):-
  length(Tests,Days),
  InitMid is div(Days,6),
  FinMid is div(Days,2),
  InitEnd is div(Days,2) + div(Days,6),
  FinEnd is 0,
  (sublist(Tests,Mid,InitMid, _ , FinMid) ; true),
  (sublist(Tests,End,InitEnd, _ , FinEnd) ; true),
  sum(Mid, #= , 1),
  sum(End, #= , 1).

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

testPlacementRestrictions(Days,Class) :-
  getDaySumList(1,Class,0,Days, Tests), % lista com todos os dias e numero de testes de todas as disciplinas da turma nesse dia
  checkWeekTestNumber(Tests,2),
  checkConsecutiveDayTests(Tests).


checkConsecutiveDayTests([]).

checkConsecutiveDayTests([D]):-
  sum([D], #=<, 1).

checkConsecutiveDayTests([Day1 | [Day2 | Tail]]) :-
  sum([Day1,Day2], #=<, 1), % dois dias seguidos não podem ter mais do que um teste, e um dia tambem não pode ter 2 testes
  checkConsecutiveDayTests([Day2 | Tail]).



%verifica se o num de testes por semana é menor ou igual a N
checkWeekTestNumber([Tmonday, Ttuesday, Twednesday, Tthursday, Tfriday | Tail], N) :-
    sum([Tmonday, Ttuesday, Twednesday, Tthursday, Tfriday], #=<, N),
    checkWeekTestNumber(Tail,N).

%para quando a ultima semana nao tem 5 dias e condicao de paragem
checkWeekTestNumber(L, N) :-
    sum(L, #=<, N).
