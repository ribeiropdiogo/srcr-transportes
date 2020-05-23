%  ___________________________________________
% |                                           |
% |  SRCR - Trabalho Individual       A84442  |
% |                                           |
% |  ninformada.pl                            |
% |                                           |
% |  Neste ficheiro estão definidos os        |
% |  predicados relativos à pesquisa não      |
% |  informada.                               |
% |___________________________________________|


% ----------- Pesquisa Depth-First ------------
% Parâmetros: paragem inicial e paragem final

pesquisadf(NodoInicial,NodoFinal) :-
        evolucao(destino(NodoFinal)),
        evolucao(origem(NodoInicial)),
        resolvedf(S),
        involucao(destino(NodoFinal)),
        involucao(origem(NodoInicial)),
        write(S).

resolvedf(Solucao) :-
		    origem(ParagemInicial),
        resolvedf(ParagemInicial, [ParagemInicial], Solucao).

resolvedf(Estado, _, []) :- destino(Estado),!.

resolvedf(Estado, Historico, [Carreira|Solucao]) :-
					percurso(Estado, Estado1, Carreira, Duracao),
					nao(membro(Estado1, Historico)),
					resolvedf(Estado1,[Estado1|Historico],Solucao).

% ----------- Pesquisa Breadth-First ------------
% Efetua a pesquisa breadth-first sem qualquer tipo de restrições
% Parâmetros: paragem inicial e paragem final
viagembf(ParagemI,ParagemF) :-
        pesquisabf(ParagemI,ParagemF).

pesquisabf(NodoInicial,NodoFinal) :-
        bfs(NodoInicial,NodoFinal,S),
        duracao(S,D),
        escreve_resultado(S,D).

bfs(X,Y,P) :- bfsr(Y,[n(X,[])],[n(X,[])],R),
        reverse(R,P).

bfsr(Y,[n(Y,P)|_],_,P).

bfsr(Y,[n(S,P1)|Ns],C,P) :- findall(n(S1,[A|P1]),
        (percurso(S,S1,A,T), \+ member(n(S1,_),C)), Es),
        append(Ns,Es,O),
        append(C,Es,C1),
        bfsr(Y,O,C1,P).

% Efetua a pesquisa breadth-first incluindo/excluindo as operadoras dadas
% Parâmetros: paragem inicial, paragem final, opção, lista de operadoras
viagembf(ParagemI,ParagemF,Opt,Ops) :-
        pesquisabf(ParagemI,ParagemF,Opt,Ops).

pesquisabf(NodoInicial,NodoFinal,Opt,Ops) :-
        bfs(NodoInicial,NodoFinal,Opt,Ops,S),
        duracao(S,D),
        escreve_resultado(S,D).

bfs(X,Y,Opt,Ops,P) :- bfsr(Y,[n(X,[])],[n(X,[])],Opt,Ops,R),
		reverse(R,P).

bfsr(Y,[n(Y,P)|_],_,Opt,Ops,P).

bfsr(Y,[n(S,P1)|Ns],C,'y',Ops,P) :- findall(n(S1,[A|P1]),
		(percurso(S,S1,A,T), operadoras(S,Ops),
    operadoras(S1,Ops),\+ member(n(S1,_),C)), Es),
		append(Ns,Es,O),
		append(C,Es,C1),
		bfsr(Y,O,C1,'y',Ops,P).

bfsr(Y,[n(S,P1)|Ns],C,'n',Ops,P) :- findall(n(S1,[A|P1]),
    (percurso(S,S1,A,T), nao(operadoras(S,Ops)),
    nao(operadoras(S1,Ops)),\+ member(n(S1,_),C)), Es),
    append(Ns,Es,O),
    append(C,Es,C1),
    bfsr(Y,O,C1,'n',Ops,P).

% Efetua a pesquisa breadth-first com uma determinada condição
% Parâmetros: paragem inicial, paragem final, condição
viagembf(ParagemI,ParagemF,Condicao) :-
        pesquisabf(ParagemI,ParagemF,Condicao).

pesquisabf(NodoInicial,NodoFinal,Condicao) :-
        bfs(NodoInicial,NodoFinal,Condicao,S),
        duracao(S,D),
        escreve_resultado(S,D).

bfs(X,Y,Condicao,P) :- bfsr(Y,[n(X,[])],[n(X,[])],Condicao,R),
		reverse(R,P).

bfsr(Y,[n(Y,P)|_],_,Condicao,P).

bfsr(Y,[n(S,P1)|Ns],C,'v',P) :- findall(n(S1,[A|P1]),
    (percurso(S,S1,A,T), publicidade(S),
    publicidade(S1),\+ member(n(S1,_),C)), Es),
    append(Ns,Es,O),
		append(C,Es,C1),
  	bfsr(Y,O,C1,'publicidade',P).

bfsr(Y,[n(S,P1)|Ns],C,'abrigado',P) :- findall(n(S1,[A|P1]),
    (percurso(S,S1,A,T), abrigado(S),
    abrigado(S1),\+ member(n(S1,_),C)), Es),
    append(Ns,Es,O),
    append(C,Es,C1),
    bfsr(Y,O,C1,'abrigado',P).

% Efetua a pesquisa breadth-first com lista de paragens
% Parâmetros: lista de paragens
viagembf(Lista) :-
        pesquisabf(Lista).

pesquisabf(Lista) :-
        bflists(Lista,R),
        duracao(R,D),
        escreve_resultado_l(R,D).

bflists([],[]).
bflists([N|[]],[]).
bflists([N1,N2|T],[S|R]) :-
        bfs(N1,N2,S), bflists(T,R).
