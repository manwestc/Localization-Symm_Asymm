#include<bits/stdc++.h>
using namespace std;

main(){
	string nbeacons[] = {"74:DA:EA:B2:ED:76","74:DA:EA:B3:2F:4A","74:DA:EA:B4:22:18","74:DA:EA:B4:26:96","74:DA:EA:B4:3A:B3"};
	int tot,pos,x;
	cin>>tot>>pos;
	for(int i=0;i<5;i++) cout<<nbeacons[i];
	cout<<", "<<pos<<", 0";
	
	for(int i=0;i<(2*tot)/3;i++){
		for(int i=0;i<5;i++) {cin>>x; /*cout<<","<<x;*/}
	}
	for(int i=(2*tot)/3;i<tot;i++){
		for(int i=0;i<5;i++) {cin>>x; cout<<","<<x;}
	}
	cout<<endl;
}
