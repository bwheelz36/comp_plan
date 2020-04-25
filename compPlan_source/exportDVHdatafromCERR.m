function []=exportDVHdatafromCERR (numstructures,numdoses,Opt,varargin)
%written Lois Holloway Jan2009
% function to export a number of DVH files from a given CERR plan

%BWedit: took savepath out of inputs; must now be written in code. Replaced
%dose num with number of doses so it can loop over multiple files.
%TO BE DONE: make it save in a folder with dosename instead of dose number

%numstructures is the number of structures that DVH data will be exported
%for

%varargin is a list of numbers representing the structure numbers within
%CERR e.g. exportDVHdatafromCERR (3,1,'abs','C:\desktop',1,2,5) where the first 3 is the number
%of structures, 1 represents the dose plan used ( as per CERR drop down menu), 
%opt represented absolute or normalised dose as detailed in CERR DVH help,
%savepath is the path in which the files are saved
%and the structures are numbered 1 say spinal cord, 2 say
%PTV70 and 5, say parotid
% it's possible this function also requires the function
% 'runCERRCommand.m', but it doesn't seem to.
for i=1:numdoses
    a=num2str(i);
    a=strcat('G:\ED study\DICOM export\IMRT plans\10002br\DVH\',a) %make sure the string ends in a slash
    mkdir(a)
    savepath=a; 
for k=1:numstructures
    exportDVHloisedit(varargin{k},i,Opt,savepath)
   
end
end
%%
%Get it to spit out dose at ref point at end
% fprintf('\n DoseNumber    DOSE AT REF POINT')
% for i=1:numdoses, dose=getDoseAt(i, 1.20,1.25,-1.75);
% 
% fprintf('\n   %d           %f        ',i,dose);
% end
% fprintf('\n')