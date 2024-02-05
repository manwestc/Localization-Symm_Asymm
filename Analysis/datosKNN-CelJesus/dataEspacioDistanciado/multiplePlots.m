figure

%cdfplot(ac08)
%hold all
cdfplot(ac07)
hold all
cdfplot(ac04)
hold all
%cdfplot(acC)

%title('Error by Transmission Power using 5-NN')
title('')
xlabel('Error (m) ','FontSize',14)
ylabel('Cumulative Probability','FontSize',14)

%legend('Tx0x08','Tx0x07','Tx0x04','Combined Tx')
legend('Tx0x07','Tx0x04','FontSize',14)