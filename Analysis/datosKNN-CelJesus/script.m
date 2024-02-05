%% K-NN RSSI for Beacons Bluetooth 

% Call functions
t = cputime;
tv1 = KNNstats([ 1 2 3 4 5],5);
%tv2 = KNNstats([1 2  4 5],3)
%tv3 = KNNstats([1 2  4 5],5)
%SVMstats([1 2 3 5 ])
e = cputime -t;
%KNNstats([2 3 4 5])
%SVMstats([2 3 4 5])

%KNNstats([1 3 4 5])
%SVMstats([1 3 4 5])

%KNNstats([1 2 4 5])
%SVMstats([1 2 4 5])

%KNNstats([1 2 3 5])
%SVMstats([1 2 3 5])

%KNNstats([1 2 3 4])
%SVMstats([1 2 3 4])

%figure
%cdfplot(tv1(:,1))
%hold all
%cdfplot(tv2(:,1))
%hold all
%cdfplot(tv3(:,1))
%hold all
%title('')
%xlabel('Error (m) ','FontSize',14)
%ylabel('Cumulative Probability','FontSize',14)

%legend('k=1','k=3','k=5','FontSize',14)