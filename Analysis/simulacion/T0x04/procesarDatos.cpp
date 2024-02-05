#include<bits/stdc++.h>
using namespace std;

main(){
	string str,fecha1,fecha2;
	//string nbeacons[] = {"74:DA:EA:B2:ED:76","74:DA:EA:B3:2F:4A","74:DA:EA:B4:22:18","74:DA:EA:B4:26:96","74:DA:EA:B4:3A:B3"};
	string nbeacons[] = {"C8:5B:EA:43:6F:75","FB:D3:B5:B9:89:F2","F7:24:98:9B:B6:EA","C9:EC:7A:17:D8:D5","EA:EF:87:2F:4D:93"};
	int beacons[5], cnt[5],cur=0,tot=0;
	int x;
	for(int i=0;i<5;i++) beacons[i]=cnt[i]=0;
	while(cin>>fecha1>>fecha2){
		cin>>str>>x;
		for(int i=0;i<5;i++) 
			if( str.compare(nbeacons[i]) ==0){
				if(cnt[i]==0) cur++;
				cnt[i]++;
				beacons[i]+= x;
				if(cur==5){
					cout<<fecha1<<" "<<fecha2<<" ";
					for(int i=0;i<5;i++){
						cout<<(beacons[i]/cnt[i])<<" ";
					}
					cout<<endl;
					tot++;
					cur = 0;
					for(int i=0;i<5;i++) beacons[i]=0, cnt[i]=0;
				}
				break;
			}
	}
	cout<<tot<<endl;
}
