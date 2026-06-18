function brainchildpreproc(s1,s2,anat)%%
matlabbatch{1}.spm.temporal.st.scans = {
                                        s1
                                        s2
                                        }';
%%
matlabbatch{1}.spm.temporal.st.nslices = 30;
matlabbatch{1}.spm.temporal.st.tr = 3;
matlabbatch{1}.spm.temporal.st.ta = 2.9;
matlabbatch{1}.spm.temporal.st.so = [2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 1 3 5 7 9 11 13 15 17 19 21 23 25 27 29];
matlabbatch{1}.spm.temporal.st.refslice = 15;
matlabbatch{1}.spm.temporal.st.prefix = 'a';
matlabbatch{2}.spm.spatial.realign.estimate.data{1}(1) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
matlabbatch{2}.spm.spatial.realign.estimate.data{2}(1) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 2)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{2}, '.','files'));
matlabbatch{2}.spm.spatial.realign.estimate.eoptions.quality = 0.9;
matlabbatch{2}.spm.spatial.realign.estimate.eoptions.sep = 4;
matlabbatch{2}.spm.spatial.realign.estimate.eoptions.fwhm = 5;
matlabbatch{2}.spm.spatial.realign.estimate.eoptions.rtm = 1;
matlabbatch{2}.spm.spatial.realign.estimate.eoptions.interp = 2;
matlabbatch{2}.spm.spatial.realign.estimate.eoptions.wrap = [0 0 0];
matlabbatch{2}.spm.spatial.realign.estimate.eoptions.weight = '';
matlabbatch{3}.spm.spatial.realign.write.data(1) = cfg_dep('Realign: Estimate: Realigned Images (Sess 1)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{1}, '.','cfiles'));
matlabbatch{3}.spm.spatial.realign.write.data(2) = cfg_dep('Realign: Estimate: Realigned Images (Sess 2)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{2}, '.','cfiles'));
matlabbatch{3}.spm.spatial.realign.write.roptions.which = [2 1];
matlabbatch{3}.spm.spatial.realign.write.roptions.interp = 4;
matlabbatch{3}.spm.spatial.realign.write.roptions.wrap = [0 0 0];
matlabbatch{3}.spm.spatial.realign.write.roptions.mask = 1;
matlabbatch{3}.spm.spatial.realign.write.roptions.prefix = 'r';
matlabbatch{4}.spm.spatial.coreg.estimate.ref(1) = cfg_dep('Realign: Reslice: Mean Image', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rmean'));
matlabbatch{4}.spm.spatial.coreg.estimate.source = {anat};
matlabbatch{4}.spm.spatial.coreg.estimate.other = {''};
matlabbatch{4}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{4}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{4}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{4}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
matlabbatch{5}.spm.spatial.normalise.estwrite.subj.vol = {anat};
matlabbatch{5}.spm.spatial.normalise.estwrite.subj.resample(1) = cfg_dep('Realign: Reslice: Resliced Images', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rfiles'));
matlabbatch{5}.spm.spatial.normalise.estwrite.subj.resample(2) = cfg_dep('Realign: Reslice: Mean Image', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rmean'));
matlabbatch{5}.spm.spatial.normalise.estwrite.subj.resample(3) = cfg_dep('Coregister: Estimate: Coregistered Images', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','cfiles'));
matlabbatch{5}.spm.spatial.normalise.estwrite.eoptions.biasreg = 0.0001;
matlabbatch{5}.spm.spatial.normalise.estwrite.eoptions.biasfwhm = 60;
matlabbatch{5}.spm.spatial.normalise.estwrite.eoptions.tpm = {'C:\Program Files\MATLAB\spm12\tpm\TPM.nii'};
matlabbatch{5}.spm.spatial.normalise.estwrite.eoptions.affreg = 'mni';
matlabbatch{5}.spm.spatial.normalise.estwrite.eoptions.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{5}.spm.spatial.normalise.estwrite.eoptions.fwhm = 0;
matlabbatch{5}.spm.spatial.normalise.estwrite.eoptions.samp = 3;
matlabbatch{5}.spm.spatial.normalise.estwrite.woptions.bb = [-78 -112 -70
                                                             78 76 85];
matlabbatch{5}.spm.spatial.normalise.estwrite.woptions.vox = [2 2 2];
matlabbatch{5}.spm.spatial.normalise.estwrite.woptions.interp = 4;
matlabbatch{5}.spm.spatial.normalise.estwrite.woptions.prefix = 'w';
matlabbatch{6}.spm.spatial.smooth.data(1) = cfg_dep('Coregister: Estimate: Coregistered Images', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','cfiles'));
matlabbatch{6}.spm.spatial.smooth.data(2) = cfg_dep('Normalise: Estimate & Write: Normalised Images (Subj 1)', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
matlabbatch{6}.spm.spatial.smooth.fwhm = [8 8 8];
matlabbatch{6}.spm.spatial.smooth.dtype = 0;
matlabbatch{6}.spm.spatial.smooth.im = 0;
matlabbatch{6}.spm.spatial.smooth.prefix = 's';


%%
spm_jobman('run',matlabbatch)

end