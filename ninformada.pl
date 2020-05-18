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