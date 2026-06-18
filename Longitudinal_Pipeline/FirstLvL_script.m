%runs preproc for all subjs, 
T1subs=dir('E:\Brainchild\Round 1\T1 Imaging Data\Data_nifti\bc*');
T2subs=dir('E:\Brainchild\backup from jan 2014 disk\Round 2\raw_data_analyse\bc*');
T3subs=dir('E:\Brainchild\backup from jan 2014 disk\Round 3\raw_data_analyse\bc*');


spm_jobman('initcfg')
error={};

% for i=14:length(T1subs)%[1:4,6:length(T1subs)] %bc0068 missing timings. i=5
% % more errors: 'bc0164'	'bc0167'	'bc0294'	'bc0311'	'bc0325'	'bc0418'	'bc0584'	'bc0908'	'bc0909'
% 
% T1s1=dir([T1subs(i).folder,'\',T1subs(i).name,'\fMRI_VSWM_1*\swraf*.img']);
% T1s2=dir([T1subs(i).folder,'\',T1subs(i).name,'\fMRI_VSWM_2*\swraf*.img']);
% 
% T1rp1=dir([T1subs(i).folder,'\',T1subs(i).name,'\fMRI_VSWM_1*\rp_*.txt']);
% T1rp2=dir([T1subs(i).folder,'\',T1subs(i).name,'\fMRI_VSWM_2*\rp_*.txt']);
% 
% T1c1=dir(['E:\Brainchild\DCM_2025\timings\T1\VSWM_1*',T1subs(i).name,'*.mat']);
% T1c2=dir(['E:\Brainchild\DCM_2025\timings\T1\VSWM_2*',T1subs(i).name,'*.mat']);
% 
% s1=fullfile({T1s1.folder}, {T1s1.name})';
% s2=fullfile({T1s2.folder}, {T1s2.name})';
% rp1=fullfile({T1rp1.folder}, {T1rp1.name})';
% rp2=fullfile({T1rp2.folder}, {T1rp2.name})';
% c1=fullfile({T1c1.folder}, {T1c1.name})';
% c2=fullfile({T1c2.folder}, {T1c2.name})';
% sname=T1subs(i).name;
% folder='E:\Brainchild\DCM_2025\models\GLM\T1';
% 
%     if length(s1)+length(s2)+length(c1)+length(c2)+length(rp1)+length(rp2)<196
%         error{end+1}=sname;
%     else %lists subjects that miss data, else run SPM spec
%         FirstLvLspec(s1,s2,c1,c2,rp1,rp2,sname,folder)
%     end
% end

% for i=[1:31,33:length(T2subs)] %%T2 bc0421 missing session 1 files? i=32. 
% %errors: none
% 
% T2s1=dir([T2subs(i).folder,'\',T2subs(i).name,'\fMRI_VSWM_1*\swraBC*.img']);
% T2s2=dir([T2subs(i).folder,'\',T2subs(i).name,'\fMRI_VSWM_2*\swraBC*.img']);
% 
% T2rp1=dir([T2subs(i).folder,'\',T2subs(i).name,'\fMRI_VSWM_1*\rp_*.txt']);
% T2rp2=dir([T2subs(i).folder,'\',T2subs(i).name,'\fMRI_VSWM_2*\rp_*.txt']);
% 
% T2c1=dir(['E:\Brainchild\DCM_2025\timings\T2\VSWM_1*',T2subs(i).name,'*.mat']);
% T2c2=dir(['E:\Brainchild\DCM_2025\timings\T2\VSWM_2*',T2subs(i).name,'*.mat']);
% 
% s1=fullfile({T2s1.folder}, {T2s1.name})';
% s2=fullfile({T2s2.folder}, {T2s2.name})';
% rp1=fullfile({T2rp1.folder}, {T2rp1.name})';
% rp2=fullfile({T2rp2.folder}, {T2rp2.name})';
% c1=fullfile({T2c1.folder}, {T2c1.name})';
% c2=fullfile({T2c2.folder}, {T2c2.name})';
% sname=T2subs(i).name;
% folder='E:\Brainchild\DCM_2025\models\GLM\T2';
%     if length(s1)+length(s2)+length(c1)+length(c2)+length(rp1)+length(rp2)<196
%         error{end+1}=sname;
%     else %lists subjects that miss data, else run SPM spec
%         FirstLvLspec(s1,s2,c1,c2,rp1,rp2,sname,folder)
%     end
% end

for i=[1:71,73,74] %bc1126 missing T1 i=72
%error: bc0251

T3s1=dir([T3subs(i).folder,'\',T3subs(i).name,'\fMRI_VSWM_1*\swraBC*.img']);
T3s2=dir([T3subs(i).folder,'\',T3subs(i).name,'\fMRI_VSWM_2*\swraBC*.img']);

T3rp1=dir([T3subs(i).folder,'\',T3subs(i).name,'\fMRI_VSWM_1*\rp_*.txt']);
T3rp2=dir([T3subs(i).folder,'\',T3subs(i).name,'\fMRI_VSWM_2*\rp_*.txt']);

T3c1=dir(['E:\Brainchild\DCM_2025\timings\T3\VSWM_1*',T3subs(i).name,'*.mat']);
T3c2=dir(['E:\Brainchild\DCM_2025\timings\T3\VSWM_2*',T3subs(i).name,'*.mat']);

s1=fullfile({T3s1.folder}, {T3s1.name})';
s2=fullfile({T3s2.folder}, {T3s2.name})';
rp1=fullfile({T3rp1.folder}, {T3rp1.name})';
rp2=fullfile({T3rp2.folder}, {T3rp2.name})';
c1=fullfile({T3c1.folder}, {T3c1.name})';
c2=fullfile({T3c2.folder}, {T3c2.name})';
sname=T3subs(i).name;
folder='E:\Brainchild\DCM_2025\models\GLM\T3';
    if length(s1)+length(s2)+length(c1)+length(c2)+length(rp1)+length(rp2)<196
        error{end+1}=sname;
    else %lists subjects that miss data, else run SPM spec
        FirstLvLspec(s1,s2,c1,c2,rp1,rp2,sname,folder)
    end
end


