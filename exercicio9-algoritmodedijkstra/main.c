#include <stdio.h>
#define INFINITO 9999
#define MAX 10

void dijkstra(int G[MAX][MAX], int n, int noInicial, int s);
void printMatriz(int G[MAX][MAX], int n);

int main() {
    int i, j, n=10, u, s=0;

    int G[MAX][MAX] = {
        {0, 4, 0, 0, 0, 0, 0, 8, 0, 0},
        {4, 0, 8, 0, 0, 0, 0, 11, 0, 0},
        {0, 8, 0, 7, 0, 4, 0, 0, 2, 0},
        {0, 0, 7, 0, 9, 14, 0, 0, 0, 0},
        {0, 0, 0, 9, 0, 10, 0, 0, 0, 0},
        {0, 0, 4, 14, 10, 0, 2, 0, 0, 0},
        {0, 0, 0, 0, 0, 2, 0, 1, 6, 0},
        {8, 11, 0, 0, 0, 0, 1, 0, 7, 0},
        {0, 0, 2, 0, 0, 0, 6, 7, 0, 9},
        {0, 0, 0, 0, 0, 0, 0, 0, 9, 0}
    };

    puts("Representacao da matriz de adjacencia onde cada numero entre 0 e 9 \nrepresenta uma rua, os numeros na matriz representam o peso daquela \naresta, nesse caso a distancia, sendo representado por 0 as ruas que nao se ligam.");
    puts("Nesse caso a rua 0 sera o ponto de partida, \ne a rua 9 o ponto de chegada, nesse caso a empresa HortiDelivery\n");
    printMatriz(G, n);

    // definindo nó inicial como 0
    u = 0;

    puts("\n---------------------------------------------------------");
    dijkstra(G, n, u, s);
    puts("\n---------------------------------------------------------");
    puts("Digite 1 para ver o caminho do ponto inicial ate os outros nós, \nDigite qualquer outro numero para sair: ");
    scanf("%d", &s);
    if (s == 1) {
        dijkstra(G, n, u, s);
    }

    return 0;
}

void dijkstra(int G[MAX][MAX], int n, int noInicial, int s) {
    int custo[MAX][MAX], distancia[MAX], ant[MAX];
    int visitado[MAX], contagem, menorDistancia, proximoNo, i, j;

    // conta o número de nós vistos até agora e cria a matriz de custos
    for (i = 0; i < n; i++)
        for (j = 0; j < n; j++)
            if (G[i][j] == 0)
                custo[i][j] = INFINITO;
            else
                custo[i][j] = G[i][j];

    // inicializa ant[], distancia[] e visitado[]
    for (i = 0; i < n; i++) {
        distancia[i] = custo[noInicial][i];
        ant[i] = noInicial;
        visitado[i] = 0;
    }

    distancia[noInicial] = 0;
    visitado[noInicial] = 1;
    contagem = 1;

    while (contagem < n - 1) {
        menorDistancia = INFINITO;

        // distância mínima
        for (i = 0; i < n; i++)
            if (distancia[i] < menorDistancia && !visitado[i]) {
                menorDistancia = distancia[i];
                proximoNo = i;
            }

        // verifica se existe um caminho melhor através do proximoNo
        visitado[proximoNo] = 1;
        for (i = 0; i < n; i++)
            if (!visitado[i])
                if (menorDistancia + custo[proximoNo][i] < distancia[i]) {
                    distancia[i] = menorDistancia + custo[proximoNo][i];
                    ant[i] = proximoNo;
                }
        contagem++;
    }

    if (s == 0) {
        for (i = 0; i < n; i++)
            if (i != noInicial && i == 9) {
                printf("Distancia do no %d = %d", i, distancia[i]);
                printf("\nCaminho = %d", i);

                j = i;
                do {
                    j = ant[j];
                    printf(" <- %d", j);
                } while (j != noInicial);
            }
    } else if (s == 1) {
        for (i = 0; i < n; i++)
            if (i != noInicial) {
                printf("\nDistancia do no %d = %d", i, distancia[i]);
                printf("\nCaminho = %d", i);

                j = i;
                do {
                    j = ant[j];
                    printf(" <- %d", j);
                } while (j != noInicial);
            }
    }
}

// Função para imprimir a matriz de adjacência
void printMatriz(int G[MAX][MAX], int n) {
    printf("Matriz de Adjacencia:\n\n");
    printf("    ");
    int i, j;
    for (i = 0; i < n; i++) {
        printf("  %2d ", i);
    }
    printf("\n     ____________________________________________________\n");
    for (i = 0; i < n; i++) {
        printf("%2d  [ ", i);
        for (j = 0; j < n; j++) {
            printf("%2d|  ", G[i][j]);
        }
        printf(" ]\n");
    }
    printf("     ____________________________________________________\n");
}
