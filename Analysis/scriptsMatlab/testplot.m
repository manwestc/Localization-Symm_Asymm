%tt = averageDistance
%tt = completeFinalResultsDistance
%disp('test')
%100*sum(tt==0)/size(tt,2)
%for it=1:4
%    100*sum(tt<it)/size(tt,2)
%end
%return
%for it= 1:15
%    100*confussionMatrix(it,it)/sum(confussionMatrix(it,:))
%end
%return
figure
cdfplot(c12453)
hold on
cdfplot(c15453)
hold on
cdfplot(c15553)
hold on
cdfplot(c41261)
hold on
cdfplot(c41231)
hold on
cdfplot(c41211)
hold on


xlabel('Error(m)') % x-axis label
ylabel('Cumulative Probability') % y-axis label
title('')
legend('[1,2,4,5,3]','[1,5,4,5,3]','[1,5,5,5,3]','[4,1,2,6,1]','[4,1,2,3,1]','[4,1,2,1,1]')