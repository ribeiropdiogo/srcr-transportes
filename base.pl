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

% Predicado PARAGEM possui os campos: ID, LATITUDE, LONGITUDE, ESTADO CONSERVAÇÃO, TIPO ABRIGO, PUBLICIDADE, OPERADORA, CARREIRA E CÓDIGO RUA
:- dynamic(paragem/9).


% ------- Pressuposto do Mundo Fechado --------

% Extensão do predicado RUA
-rua(Codigo,Nome,Freguesia) :-
    nao(rua(Codigo,Nome,Freguesia)),
    nao(excecao(rua(Codigo,Nome,Freguesia))).

% Extensão do predicado PARAGEM
-paragem(ID,LAT,LON,ESTADO,TIPO,PUB,OP,CARR,RUA) :-
    nao(paragem(ID,LAT,LON,ESTADO,TIPO,PUB,OP,CARR,RUA)),
    nao(excecao(paragem(ID,LAT,LON,ESTADO,TIPO,PUB,OP,CARR,RUA))).

% --------------- Invariantes -----------------
% Invariantes que garantem a consistência da informação

% Invariante Estrutural: não permite a inserção de conhecimento repetido
+rua(C,N,F) :: (findall((C,N,F),(rua(C,N,F)),S),
                length(S,R),
                R==1).

% Invariante Estrutural: não permite a inserção de conhecimento repetido
+paragem(ID,LA,LO,ES,TI,PU,OP,CA,RU) :: (findall((ID,LA,LO,ES,TI,PU,OP,CA,RU),(paragem(ID,LA,LO,ES,TI,PU,OP,CA,RU)),S),
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


% -------- Predicados Extensão Lógica ---------

nao(P) :- P, !, fail.
nao(P).

demo(P,verdadeiro) :- P.
demo(P,falso) :- -P.
demo(P,desconhecido) :- nao(P), nao(-P).

% ------------- Predicados Extra --------------

membro(H,[H|_]) :- !.
membro(H,[_|T]) :- membro(H,T).

membros([],_).
membros([X|Xs],Members) :- membro(X,Members), membros(Xs,Members).

teste([]).
teste([H|T]) :- H, teste(T).

escrever([]).
escrever([X|L]) :- write(X), nl, escrever(L).

seleciona(E, [E|Xs], Xs).
seleciona(E, [X|Xs], [X|Ys]) :- seleciona(E, Xs, Ys).
