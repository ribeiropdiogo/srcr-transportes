import math
import pandas as pd
from pandas import ExcelWriter
from pandas import ExcelFile

f = open("../dados.pl", "w")
f.write("%  ___________________________________________\n")
f.write("% |                                           |\n")
f.write("% |  SRCR - Trabalho Individual       A84442  |\n")
f.write("% |                                           |\n")
f.write("% |  dados.pl                                 |\n")
f.write("% |                                           |\n")
f.write("% |  Este ficheiro foi gerado por um parser   |\n")
f.write("% |  escrito em python que converte os dados  |\n")
f.write("% |  dos ficheiros xlsx para instruções que   |\n")
f.write("% |  podem ser importadas em prolog, seguindo |\n")
f.write("% |  as estruturas definidas.                 |\n")
f.write("% |___________________________________________|\n")

f.write("\n\n\n")

# Parsing das Estruturas
filename = '../paragens.xlsx'
fparagens = pd.ExcelFile(filename)
paragens = pd.read_excel(filename, sheet_name='Sheet 1')

f.write("% ----------- Estruturas de Dados ------------ \n\n")

f.write("% ---------------- Paragens ------------------ \n")
ruas = []

for i in paragens.index:
    gid = str(paragens['gid'][i])
    lat = str(paragens['latitude'][i])
    lon = str(paragens['longitude'][i])
    estado = str(paragens['Estado de Conservacao'][i])
    tipo = str(paragens['Tipo de Abrigo'][i])
    pub = str(paragens['Abrigo com Publicidade?'][i])
    operadora = str(paragens['Operadora'][i])
    codrua = str(paragens['Codigo de Rua'][i])
    f.write("?- insereParagem("+gid+","+lat+","+lon+",'"+estado+"'"+",'"+tipo+"','"+pub+"','"+operadora+"',"+codrua+").\n")

f.write("\n\n");

f.write("% ------------------ Ruas -------------------- \n")
ruas = []

for i in paragens.index:
    cod = str(paragens['Codigo de Rua'][i])
    if cod not in ruas:
        ruas.append(cod)
        nome      = paragens['Nome da Rua'][i]
        freguesia = str(paragens['Freguesia'][i])
        f.write("?- insereRua("+cod+",'"+nome+"','"+freguesia+"').\n")

f.write("\n\n");

# Parsing das Adjacências
filename = '../adjacencias.xlsx'
fadjacencias = pd.ExcelFile(filename)

f.write("% ----------- Lista de Adjacências ----------- \n")
f.write("% paragem - paragem - carreira - distancia\n")
for carreira in fadjacencias.sheet_names:
    paragens = pd.read_excel(filename, sheet_name=carreira)
    for i in paragens.index:
        if i != paragens.index[-1]:
            dist = math.sqrt(((paragens['latitude'][i] - paragens['latitude'][i + 1]) ** 2) + ((paragens['longitude'][i] - paragens['longitude'][i + 1]) ** 2))
            f.write("?- evolucao(percurso("+str(paragens['gid'][i])+","+str(paragens['gid'][i+1])+","+carreira+","+str(dist)+")).\n")
        if i == paragens.index[-1]:
            dist = math.sqrt(((paragens['latitude'][i] - paragens['latitude'][0]) ** 2) + ((paragens['longitude'][i] - paragens['longitude'][0]) ** 2))
            f.write("?- evolucao(percurso("+str(paragens['gid'][i])+","+str(paragens['gid'][0])+","+carreira+","+str(dist)+")).\n")

# Parsing das Estimativas
filename = '../paragens.xlsx'
fparagens = pd.ExcelFile(filename)
paragens = pd.read_excel(filename, sheet_name='Sheet 1')

f.write("% --------------- Estimativas ---------------- \n")
ruas = []
destino = int(466)


for i in paragens.index:
    if paragens['gid'][i] == destino:
        latd = paragens['latitude'][i]
        lond = paragens['longitude'][i]

f.write("% Destino => "+str(destino)+" \n")
for i in paragens.index:
    gid = str(paragens['gid'][i])
    lat = str(paragens['latitude'][i])
    lon = str(paragens['longitude'][i])
    if paragens['gid'][i] == destino:
        f.write("?- evolucao(estimativa(" + gid + ",0)).\n")
    if paragens['gid'][i] != destino:
        dist = math.sqrt(((paragens['latitude'][i] - latd) ** 2) + ((paragens['longitude'][i] - lond) ** 2))
        f.write("?- evolucao(estimativa("+gid+","+str(dist)+")).\n")

f.write("\n\n");

f.close()
