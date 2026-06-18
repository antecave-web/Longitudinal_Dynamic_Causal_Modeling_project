%runs preproc for all subjs, 
T1subs=dir('E:\Brainchild\Round 1\T1 Imaging Data\Data_nifti\bc*');
T2subs=dir('E:\Brainchild\backup from jan 2014 disk\Round 2\raw_data_analyse\bc*');
T3subs=dir('E:\Brainchild\backup from jan 2014 disk\Round 3\raw_data_analyse\bc*');


spm_jobman('initcfg')


for i=[1:4,6:14,16:length(T1subs)] %bc0068 missing s2. i=5 bc0167 no data i=15
T1anat=dir([T1subs(i).folder,'\',T1subs(i).name,'\tfl3d*\s*.img'])

T1s1=dir([T1subs(i).folder,'\',T1subs(i).name,'\fMRI_VSWM_1*\f*.img']);
T1s2=dir([T1subs(i).folder,'\',T1subs(i).name,'\fMRI_VSWM_2*\f*.img']);

anat=[T1anat.folder,'\',T1anat.name];
s1=fullfile({T1s1.folder}, {T1s1.name});
s2=fullfile({T1s2.folder}, {T1s2.name});
brainchildpreproc(s1,s2,anat); 
end

% for i=[1:31,33:length(T2subs)] %%T2 bc0421 missing session 1 files? i=32
% T2anat=dir([T2subs(i).folder,'\',T2subs(i).name,'\tfl3d*\BC*.img'])
% 
% T2s1=dir([T2subs(i).folder,'\',T2subs(i).name,'\fMRI_VSWM_1*\BC*.img']);
% T2s2=dir([T2subs(i).folder,'\',T2subs(i).name,'\fMRI_VSWM_2*\BC*.img']);
% 
% anat=[T2anat.folder,'\',T2anat.name];
% s1=fullfile({T2s1.folder}, {T2s1.name});
% s2=fullfile({T2s2.folder}, {T2s2.name});
% brainchildpreproc(s1,s2,anat); 
% end
% 
% for i=[1:71,73,74] %bc1126 missing T1 i=72
% T3anat=dir([T3subs(i).folder,'\',T3subs(i).name,'\tfl3d*\BC*.img'])
% 
% T3s1=dir([T3subs(i).folder,'\',T3subs(i).name,'\fMRI_VSWM_1*\BC*.img']);
% T3s2=dir([T3subs(i).folder,'\',T3subs(i).name,'\fMRI_VSWM_2*\BC*.img']);
% 
% anat=[T3anat.folder,'\',T3anat.name];
% s1=fullfile({T3s1.folder}, {T3s1.name});
% s2=fullfile({T3s2.folder}, {T3s2.name});
% brainchildpreproc(s1,s2,anat); 
% end


