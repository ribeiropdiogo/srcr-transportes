%  ___________________________________________
% |                                           |
% |  SRCR - Trabalho Individual       A84442  |
% |                                           |
% |  dados.pl                                 |
% |                                           |
% |  Este ficheiro foi gerado por um parser   |
% |  escrito em python que converte os dados  |
% |  dos ficheiros xlsx para instruções que   |
% |  podem ser importadas em prolog, seguindo |
% |  as estruturas definidas.                 |
% |___________________________________________|



% ----------- Estruturas de Dados ------------

% ---------------- Paragens ------------------
?- insereParagem(79,-107011.55,-95214.57,'Bom','Fechado dos Lados','Yes','B',103).
?- insereParagem(593,-103777.02,-94637.67,'Bom','Sem Abrigo','No','A',300).
?- insereParagem(499,-103758.44,-94393.36,'Bom','Fechado dos Lados','Yes','A',300).
?- insereParagem(494,-106803.2,-96265.84,'Bom','Sem Abrigo','No','A',389).
?- insereParagem(480,-106757.3,-96240.22,'Bom','Sem Abrigo','No','A',389).
?- insereParagem(957,-106911.18264993648,-96261.15727273724,'Bom','Sem Abrigo','No','C',399).
?- insereParagem(366,-106021.37,-96684.5,'Bom','Fechado dos Lados','Yes','B',411).

% ----------- Lista de Adjacências -----------
% paragem - paragem - carreira - duração
% 79-B 593-A 499-A 494-A 480-A 957-C 366-B
?- evolucao(percurso(79,593,01,5)).
?- evolucao(percurso(593,499,01,5)).
?- evolucao(percurso(499,494,01,5)).
?- evolucao(percurso(494,366,01,5)).
%?- evolucao(percurso(79,957,02,5)).
?- evolucao(percurso(957,366,02,5)).


?- evolucao(distancia(79,123,15)).
?- evolucao(distancia(79,593,5)).
?- evolucao(distancia(593,499,6)).
