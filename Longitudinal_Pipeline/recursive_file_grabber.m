% --- USER INPUT ---
path='E:\Brainchild\DCM_2025\models\GLM\T3\';
%path=;
%path=;

subs=dir([path,'bc*']);

outlist={}
%for sub=1:2%length(subs)
%datadir=[path,'\',subs(sub).name];


files=recursiveDir(path, 'mask.nii');
%outlist(end+1)=files
%end
spm_check_registration(files(:).fullpath)