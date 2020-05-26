%  ___________________________________________
% |                                           |
% |  SRCR - Trabalho Individual       A84442  |
% |                                           |
% |  informada.pl                             |
% |                                           |
% |  Neste ficheiro estão definidos os        |
% |  predicados relativos à pesquisa          |
% |  informada.                               |
% |___________________________________________|


% ----------- Pesquisa Depth-First ------------

pesquisapp(NodoInicial,NodoFinal) :-
        evolucao(destino(NodoFinal)),
        depthfirst(NodoInicial,S),
        involucao(destino(NodoFinal)),
        duracao(S,D),
        escreve_resultado(S,D).

depthfirst(NodoInicial,Caminho) :-
        profundidadeprimeiro(NodoInicial, Caminho).

profundidadeprimeiro(Nodo, []) :-
        destino(Nodo).

profundidadeprimeiro(Nodo, [[Nodo,ProxNodo,Carreira]|Caminho]) :-
        percurso(Nodo, ProxNodo, Carreira, _),
        profundidadeprimeiro(ProxNodo, Caminho).

caminho(Nodo, ProxNodo) :-
        percurso(Nodo, ProxNodo, _, _).

% ------------ Pesquisa A-Estrela -------------

pesquisaae(NodoInicial,NodoFinal) :-
        evolucao(destino(NodoFinal)),
        resolve_aestrela(NodoInicial,S),
        involucao(destino(NodoFinal)),
        write(S).

resolve_aestrela(Nodo, Caminho/Custo) :-
        distancia(Nodo, _,Estima),
        aestrela([[Nodo]/0/Estima], InvCaminho/Custo/_),
        inverso(InvCaminho, Caminho).

aestrela(Caminhos, Caminho) :-
        obtem_melhor(Caminhos, Caminho),
        Caminho = [Nodo|_]/_/_,
        destino(Nodo).

aestrela(Caminhos, SolucaoCaminho) :-
        obtem_melhor(Caminhos, MelhorCaminho),
        seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
        expande_aestrela(MelhorCaminho, ExpCaminhos),
        append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
        aestrela(NovoCaminhos, SolucaoCaminho).         


obtem_melhor([Caminho], Caminho) :- !.

obtem_melhor([Caminho1/Custo1/Est1,_/Custo2/Est2|Caminhos], MelhorCaminho) :-
        Custo1 + Est1 =< Custo2 + Est2, !,
        obtem_melhor([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho).
        
obtem_melhor([_|Caminhos], MelhorCaminho) :- 
        obtem_melhor(Caminhos, MelhorCaminho).

expande_aestrela(Caminho, ExpCaminhos) :-
        findall(NovoCaminho, adjacente(Caminho,NovoCaminho), ExpCaminhos).

adjacente([Nodo|Caminho]/Custo/_, [ProxNodo,Nodo|Caminho]/NovoCusto/Est) :-
        percurso(Nodo, ProxNodo, Carreira, Tempo),\+ member(ProxNodo, Caminho),
        NovoCusto is Custo + PassoCusto,
        distancia(Nodo, ProxNodo, Est).
