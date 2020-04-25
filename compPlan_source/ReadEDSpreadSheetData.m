 
SpreadSheetLocation='V:\Brendan\ED study\results\F3\IndividualPatientResults1.xlsx';
WorkSheetNames={'10001' '10002br' '10004' '10008' '10009' '10012' '10013' '10017' '10018' '10019'};
DataRange='F3:Y8';

 for i=1:numel(WorkSheetNames);
 dat = xlsread(SpreadSheetLocation,WorkSheetNames{i},DataRange);
 
 Data.PTVSyst(:,i)=dat(:,3);
 Data.PTVOpt(:,i)=dat(:,4);
 
 Data.GTVSyst(:,i)=dat(:,7);
 Data.GTVOpt(:,i)=dat(:,8);
 
 Data.BladderSyst(:,i)=dat(:,11);
 Data.BladderOpt(:,i)=dat(:,12);
 
 Data.RectumSyst(:,i)=dat(:,15);
 Data.RectumOpt(:,i)=dat(:,16);
 
 Data.FemHeadsSyst(:,i)=dat(:,19);
 Data.FemHeadsOpt(:,i)=dat(:,20);
 
 save('V:\Brendan\ED study\results\F3\AllResults.mat','Data')
 end