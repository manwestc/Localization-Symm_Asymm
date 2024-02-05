#include<bits/stdc++.h>
using namespace std;

double mapa[5][3];
int mapa2[5][3];
bool vis[5][3];
int dx[] = {-1,-1,-1,0,0,1,1,1};
int dy[] = {-1,0,1,-1,1,-1,0,1};

void dfs(int x,int y){

	vis[x][y] = true;
	for(int i=0;i<8;i++){
	
		int nx = x+ dx[i];
		int ny = y+ dy[i];
		if(nx>=0 && nx<5 && ny>=0 && ny<3 && !vis[nx][ny]){
			if(mapa2[x][y] == mapa2[nx][ny]) dfs(nx,ny);
		}

	}

}


main(){

	vector<int> v; 
	double tmp;
	for(int i=0;i<5;i++) for(int j=0;j<3;j++) {
		
		cin>>tmp;
		mapa[i][j] = tmp;
		v.push_back(floor(mapa[i][j]+0.5)); //redondea
	}

	sort(v.begin(),v.end());
	for(int i=0;i<v.size();i++) cout<<v[i]<<" ";
	cout<<endl;

	int M = *max_element(v.begin(), v.end());
	int m = *min_element(v.begin(), v.end());
	double ancho = (1.0*(M-m))/6.0; // 5*3 / 2 

	//reescribe el mapa como # de grupos
	for(int i=0;i<5;i++) for(int j=0;j<3;j++){
		int region = floor( ((mapa[i][j]-m)/ancho) + 0.5);
		mapa2[i][j] = region;
	}

	int colores = 0;
	memset(vis,false,sizeof(vis));

	for(int i=0;i<5;i++) for(int j=0;j<3;j++){
	
		if(vis[i][j]) continue;
		
		colores++;
		vis[i][j] = true;
		dfs(i,j);

	}

	cout<<"# Colores: "<<colores<<endl;

	for(int i=0;i<5;i++){
		for(int j=0;j<3;j++){
			cout<<mapa2[i][j]<<" ";
		}
		cout<<endl;
	}
	cout<<endl;
	for(int i=0;i<5;i++){
		for(int j=0;j<3;j++){
			cout<<mapa[i][j]<<" ";
		}
		cout<<endl;
	}

}
