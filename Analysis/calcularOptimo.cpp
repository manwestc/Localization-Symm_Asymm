#include<bits/stdc++.h>
#define N 25
using namespace std;

double MAT[N][N];
int vis[N][N];
double nivel;
int dy[] = {1,1,1,0,0,-1,-1,-1};
int dx[] = {1,0,-1,1,-1,1,0,-1};
map< int, vector<double>  > M;
int n,m;

struct nodo{
    int x,y,d;
    nodo() {}
    nodo(int x,int y,int d): x(x),y(y),d(d) {}
};


main(){
	memset(MAT,0,sizeof(MAT));

	for(int i=0;i<N;i++) for(int j=0;j<N;j++) vis[i][j]=-1;

	queue<nodo > Q; 
	//cin>>n>>m; //n filas m columnas
	n=5; m=3;

	for(int i=0;i<n;i++) for(int j=0;j<m;j++) cin>>MAT[i][j];
	//for(int i=0;i<n;i++) for(int j=0;j<m;j++) cout<<MAT[i][j];

	//Empieza algoritmo
	//busca el mayor
	int px=-1,py=-1;
	double mayor = -1000.0;
	for(int i=0;i<n;i++) for(int j=0;j<m;j++){
		if(mayor<MAT[i][j]) {
			px=i; py=j;
			mayor = MAT[i][j];
			//cout<<px<<" "<<py<<" "<<mayor<<endl;
		}
	}
	
	//encontrar rango de valores
	double minimo=10000.0;
	double maximo = mayor;
	for(int i=0;i<n;i++) for(int j=0;j<m;j++){
		if(minimo>MAT[i][j]) minimo = MAT[i][j];
	}	
	
	double rango = maximo - minimo;
	
	//empieza a calcular niveles de vecinos
	int lvl = 1;
	double valor  = 0.0;

	
	Q.push(nodo(px,py,1));
	M[1].push_back(MAT[px][py]);

	while(!Q.empty()){
		nodo q= Q.front(); Q.pop(); 

		//if(vis[q.x][q.y]!=-1) continue;
		vis[q.x][q.y]= q.d;
		
		//buscar el menor de los vecinos
		for(int i=0;i<8;i++){
			int nx = q.x+dx[i];
			int ny = q.y+dy[i];

			if(nx>=0 && nx<n && ny>=0 && ny<m && vis[nx][ny]==-1){
				vis[nx][ny] = q.d+1;
				M[q.d+1].push_back(MAT[nx][ny]);
				Q.push(nodo(nx,ny,q.d+1));				
			}

		}
		//cout<<q.x<<" "<<q.y<<endl;		
	}

	//for(int i=0;i<n;i++) {for(int j=0;j<m;j++) cout<<vis[i][j]<<" "; cout<<endl;}

	//calcula valor segun niveles
	for (std::map<int,vector<double> >::iterator it=M.begin(); it!=M.end(); ++it){
		vector<double> tmp = it->second;
		if(it->first == 1) continue;

		//halla minimo del nivel anterior
		double tmin = M[it->first -1][0];
		for(int i = 1 ;i<M[it->first -1].size();i++) if(tmin>M[it->first-1][i]) tmin = M[it->first-1][i];
		//halla maximo del nivel actual
		double tmax = M[it->first][0];
		for(int i = 1 ;i<M[it->first].size();i++) if(tmax>M[it->first][i]) tmax = M[it->first][i];
	
		valor += 1.0/(it->first) *((tmax-tmin)/rango);
	}
	cout<<valor<<endl;
	cout<<rango<<endl;
}


