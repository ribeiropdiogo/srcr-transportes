%  ___________________________________________
% |                                           |
% |  SRCR - Trabalho Individual       A84442  |
% |                                           |
% |  base.pl                                  |
% |                                           |
% |  Este ficheiro contém a base de           |
% |  conhecimento. Todos os predicados que    |
% |  são necessários para o sistema funcionar |
% |  estão declarados neste ficheiro.         |
% |___________________________________________|

% ----------- Predicados Dinâmicos ------------

% Predicado RUA possui os campos: CÓDIGO, NOME e FREGUESIA
:- dynamic(rua/3).

% Predicado PARAGEM possui os campos: ID, LATITUDE, LONGITUDE, ESTADO CONSERVAÇÃO, TIPO ABRIGO, PUBLICIDADE, OPERADORA, E CÓDIGO RUA
:- dynamic(paragem/8).


% ------- Pressuposto do Mundo Fechado --------

% Extensão do predicado RUA
-rua(Codigo,Nome,Freguesia) :-
    nao(rua(Codigo,Nome,Freguesia)),
    nao(excecao(rua(Codigo,Nome,Freguesia))).

% Extensão do predicado PARAGEM
-paragem(ID,LAT,LON,ESTADO,TIPO,PUB,OP,RUA) :-
    nao(paragem(ID,LAT,LON,ESTADO,TIPO,PUB,OP,RUA)),
    nao(excecao(paragem(ID,LAT,LON,ESTADO,TIPO,PUB,OP,RUA))).

% --------------- Invariantes -----------------
% Invariantes que garantem a consistência da informação

% Invariante Estrutural: não permite a inserção de conhecimento repetido
+rua(C,N,F) :: (findall((C,N,F),(rua(C,N,F)),S),
                length(S,R),
                R==1).

% Invariante Estrutural: não permite a inserção de conhecimento repetido
+paragem(ID,LA,LO,ES,TI,PU,OP,RU) :: (findall((ID,LA,LO,ES,TI,PU,OP,RU),(paragem(ID,LA,LO,ES,TI,PU,OP,RU)),S),
                                        length(S,N),
                                        N==1).

% ------------ Predicado Evolução -------------
% Extensão do predicado que permite a evolução de conhecimento

evolucao(Termo) :-
    findall(Invariante, +Termo::Invariante,Lista),
    insere(Termo),
    teste(Lista).

insere(Termo) :- assert(Termo).
insere(Termo) :- retract(Termo), !,fail.

% ------------ Predicado Involução ------------
% Extensão do predicado que permite a involução de conhecimento

involucao(Termo) :-
    findall(Invariante,-Termo::Invariante,Lista),
    remove(Termo),
    teste(Lista).

remove(Termo) :- retract(Termo).
remove(Termo) :- assert(Termo),!,fail.

% ----- Predicados Inserção Conhecimento ------

% Predicado RUA
insereRua(C,N,F) :- evolucao(rua(C,N,F)).
% Predicado PARAGEM
insereParagem(ID,LA,LO,ES,TI,PU,OP,RU) :- evolucao(paragem(ID,LA,LO,ES,TI,PU,OP,RU)).


% -------- Predicados Extensão Lógica ---------

nao(P) :- P, !, fail.
nao(P).

demo(P,verdadeiro) :- P.
demo(P,falso) :- -P.
demo(P,desconhecido) :- nao(P), nao(-P).

% ----------- Predicados de Escrita -----------

escreve_carreiras([]).
escreve_carreiras([[A,B]|T]) :- write('Paragem: '),write(A),
        write(' tem '), write(B),write(' carreiras'),nl,
        escreve_carreiras(T).

escreve_paragem(P) :- paragem(P,LA,LO,ES,TI,PU,OP,RU),
        write('Paragem: '),write(P), nl,
        write('Estado: '),write(ES), nl,
        write('Tipo: '),write(TI), nl,
        write('Publicidade: '),write(PU), nl,
        write('Operadora: '),write(OP), nl.

escreve_resultado([],D) :- write('Duracao estimada: '),
        write(D), write(' min'), nl.
escreve_resultado([[P1,P2,C]|L],D) :- write('Paragem '),
        write(P1), write(' -> Paragem '), write(P2),
        write(' | Carreira: '), write(C),nl,
        escreve_resultado(L,D).
escreve_resultado([]).
escreve_resultado([[P1,P2,C]|L]) :- write('Paragem '),
        write(P1), write(' -> Paragem '), write(P2),
        write(' | Carreira: '), write(C),nl,
        escreve_resultado(L).

escreve_resultado_l([],D) :- write('Duracao estimada: '),
        write(D), write(' min'), nl.
escreve_resultado_l([H|T],D) :- write('Percurso: '), nl,
                                escreve_resultado(H),
                                escreve_resultado_l(T,D).

% ----------- Predicados Informação -----------

carreiras(P,CS) :- findall(C,percurso(P,P1,C,T), L),
        findall(C,percurso(P0,P,C,T), L),
        sort(L,CS).

maiscarreiras(S) :- collectparagens(S,Paragens),
                    sort(Paragens,SParagens),
                    maiscarreirasaux(SParagens,ParCar),
                    escreve_carreiras(ParCar).

maiscarreirasaux([],[]).
maiscarreirasaux([H|T],[[H,Len]|X]) :- carreiras(H,F), length(F,Len),maiscarreirasaux(T,X).

collectparagens([],[]).
collectparagens([[P1,P2,C]|L],[P1,P2|X]) :- collectparagens(L,X).

duracao([],0).
duracao([_|Xs],L) :- duracao(Xs,N) , L is N+5 .

duracao_l([],0).
duracao_l([H|T],L) :- duracao_l(T,R), duracao(H,A), L is R + A.

operadoras(ID,L) :- paragem(ID,_,_,_,_,_,OP,_), membro(OP,L).

publicidade(ID) :- paragem(ID,_,_,_,_,'Yes',_,_).

abrigado(ID) :- paragem(ID,_,_,_,ABR,_,_,_), membro(ABR,['Fechado dos Lados','Aberto dos Lados']).

% ------------- Predicados Extra --------------

membro(H,[H|_]) :- !.
membro(H,[_|T]) :- membro(H,T).

membros([],_).
membros([X|Xs],Members) :- membro(X,Members), membros(Xs,Members).

teste([]).
teste([H|T]) :- H, teste(T).

seleciona(E, [E|Xs], Xs).
seleciona(E, [X|Xs], [X|Ys]) :- seleciona(E, Xs, Ys).

inverso(Xs, Ys) :- inverso(Xs,[],Ys).
inverso([],Xs,Xs).
inverso([X|Xs],Ys,Zs) :- inverso(Xs, [X|Ys], Zs).

max(A,B,C) :- C is max(A,B).
min(A,B,C) :- C is min(A,B).
