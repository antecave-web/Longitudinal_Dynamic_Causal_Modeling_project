T1=dir('E:\Brainchild\DCM_2025\models\GLM\T1\bc*');
T2=dir('E:\Brainchild\DCM_2025\models\GLM\T2\bc*');
T3=dir('E:\Brainchild\DCM_2025\models\GLM\T3\bc*');

f=horzcat(fullfile({T1.folder},{T1.name},'SPM.mat'),    fullfile({T2.folder},{T2.name},'SPM.mat'),    fullfile({T3.folder}, {T3.name},'SPM.mat'));

for i=1:length(f)
matlabbatch{1}.spm.stats.fmri_est.spmmat = f(1,i);
matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{2}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.con.consess{1}.tcon.name = 'WM vs. Control';
matlabbatch{2}.spm.stats.con.consess{1}.tcon.weights = [-1 -1 1 1 0 0 0 0 0 0];
matlabbatch{2}.spm.stats.con.consess{1}.tcon.sessrep = 'repl';
matlabbatch{2}.spm.stats.con.delete = 1;

spm_jobman('run',matlabbatch)
end