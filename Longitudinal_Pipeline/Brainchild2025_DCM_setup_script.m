%spm_jobman('initcfg');

SPMdirs={'E:\Brainchild\DCM_2025\models\GLM\T1'
    'E:\Brainchild\DCM_2025\models\GLM\T2'
    'E:\Brainchild\DCM_2025\models\GLM\T3'};

specifyGLM=0; extractVOIs=0;
modelname='WM_5nodes_rp'; DCMtemplate='E:\Brainchild\DCM_2025\DCM_template.mat';
specifyDCM=0; estimateDCM=1;

for t=1:length(SPMdirs)
    SPMsdir=SPMdirs{t};
    d=dir(SPMsdir);
    
    for sub=3:length(d)
        if specifyGLM==1
            load([SPMsdir,'\',d(sub).name,'\SPM.mat']);
            load([SPMsdir,'\',d(sub).name,'\DCM_conditions_concat.mat']);
            
            if isempty(dir([SPMsdir,'\',d(sub).name,'\DCMrp'])) %create DCM folder if not there
                mkdir([SPMsdir,'\',d(sub).name,'\DCMrp']);
            else
                if ~isempty(dir([SPMsdir,'\',d(sub).name,'\DCMrp\SPM.mat'])) %if old SPM is there, rename it to backup.
                    movefile([SPMsdir,'\',d(sub).name,'\DCMrp\SPM.mat'],[SPMsdir,'\',d(sub).name,'\DCMrp\SPM_backup.mat']);
                end %delete([SPMsdir,'\',d(sub).name,'\DCM\SPM.mat']);
            end
            
            matlabbatch={}; %reset matlabbatch
            
            matlabbatch{1}.spm.stats.fmri_spec.dir = {[SPMsdir,'\',d(sub).name,'\DCMrp\']};
            matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
            matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2.2;
            matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
            matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
            matlabbatch{1}.spm.stats.fmri_spec.sess.scans = Ynii;
            matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).name = 'WM';
            matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).onset = U.ons;
            matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).duration = U.dur;
            matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
            matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
            matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).orth = 1;
            % matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).name = 'T2';
            % matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).onset = T2onset;
            % matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).duration = T2duration;
            % matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
            % matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
            % matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).orth = 1;
            %matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
            
            
            rpreg=zeros(sum(SPM.nscan),6);
            for sess=1:length(SPM.nscan)
                rpreg=rpreg+SPM.xX.X(:,(sess-1)*10+5:(sess-1)*10+10);
            end
            
            
            matlabbatch{1}.spm.stats.fmri_spec.sess.regress(1).name = 'rp1';
            matlabbatch{1}.spm.stats.fmri_spec.sess.regress(1).val = rpreg(:,1);
            matlabbatch{1}.spm.stats.fmri_spec.sess.regress(2).name = 'rp2';
            matlabbatch{1}.spm.stats.fmri_spec.sess.regress(2).val = rpreg(:,2);
            matlabbatch{1}.spm.stats.fmri_spec.sess.regress(3).name = 'rp3';
            matlabbatch{1}.spm.stats.fmri_spec.sess.regress(3).val = rpreg(:,3);
            matlabbatch{1}.spm.stats.fmri_spec.sess.regress(4).name = 'rp4';
            matlabbatch{1}.spm.stats.fmri_spec.sess.regress(4).val = rpreg(:,4);
            matlabbatch{1}.spm.stats.fmri_spec.sess.regress(5).name = 'rp5';
            matlabbatch{1}.spm.stats.fmri_spec.sess.regress(5).val = rpreg(:,5);
            matlabbatch{1}.spm.stats.fmri_spec.sess.regress(6).name = 'rp6';
            matlabbatch{1}.spm.stats.fmri_spec.sess.regress(6).val = rpreg(:,6);
            
            
            
            
            matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {''};
            matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
            matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
            matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
            matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
            matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
            matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
            matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
            matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
            
            spm_jobman('run',matlabbatch) %run spec batch
            
            spm_fmri_concatenate([SPMsdir,'\',d(sub).name,'\DCMrp\SPM.mat'],SPM.nscan); %adjust for concatenated sessions
            
            cd([SPMsdir,'\',d(sub).name,'\DCMrp\']); % change working directory
            load([SPMsdir,'\',d(sub).name,'\DCMrp\SPM.mat']); %load DCM GLM
            
            spm_spm(SPM); %estimate GLM
            
            
            %reset matlabbatch. check for T2 and if so generate F-contrast for columns 1 &2
            matlabbatch=[];
            
            matlabbatch{1}.spm.stats.con.spmmat = {[SPMsdir,'\',d(sub).name,'\DCMrp\SPM.mat']};
            matlabbatch{1}.spm.stats.con.consess{1}.fcon.name = 'WM';
            matlabbatch{1}.spm.stats.con.consess{1}.fcon.weights = [1];
            % if T2duration==0
            %   matlabbatch{1}.spm.stats.con.consess{1}.fcon.weights = [1 0];
            % else
            %  matlabbatch{1}.spm.stats.con.consess{1}.fcon.weights = [1 1];
            % end
            matlabbatch{1}.spm.stats.con.consess{1}.fcon.sessrep = 'none';
            matlabbatch{1}.spm.stats.con.delete = 1;
            
            spm_jobman('run',matlabbatch) % run contrast batch
        end
        
        %% extract concatenated VOIs here !!!
        if extractVOIs==1
            
            VOIs={        'lCalc',[-8 -90 -4]
                'lSPL',[-18 -70 62]
                'rSPL',[20 -72 58]
                'lSFG',[-26 -4 50]
                'rSFG',[28 6 64]};
            
            matlabbatch={}; % reset matlabbatch
            
            for v=1:length(VOIs)
                matlabbatch{v}.spm.util.voi.spmmat = {[SPMsdir,'\',d(sub).name,'\DCMrp\SPM.mat']};
                matlabbatch{v}.spm.util.voi.adjust = 1; %0=no,Fcon index,NaN=everything               !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                matlabbatch{v}.spm.util.voi.session = Inf; %sess#
                matlabbatch{v}.spm.util.voi.name = VOIs{v,1};
                matlabbatch{v}.spm.util.voi.roi{1}.spm.spmmat = {''};
                matlabbatch{v}.spm.util.voi.roi{1}.spm.contrast = 1;
                matlabbatch{v}.spm.util.voi.roi{1}.spm.conjunction = 1;
                matlabbatch{v}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
                matlabbatch{v}.spm.util.voi.roi{1}.spm.thresh = 0.05;
                matlabbatch{v}.spm.util.voi.roi{1}.spm.extent = 0;
                matlabbatch{v}.spm.util.voi.roi{1}.spm.mask = struct('contrast', {}, 'thresh', {}, 'mtype', {});
                matlabbatch{v}.spm.util.voi.roi{2}.sphere.centre = VOIs{v,2};
                matlabbatch{v}.spm.util.voi.roi{2}.sphere.radius = 10;
                matlabbatch{v}.spm.util.voi.roi{2}.sphere.move.fixed = 1;
                matlabbatch{v}.spm.util.voi.roi{3}.sphere.centre = VOIs{v,2}; %could be 0 0 0, but set to maximum for safety
                matlabbatch{v}.spm.util.voi.roi{3}.sphere.radius = 4;
                matlabbatch{v}.spm.util.voi.roi{3}.sphere.move.global.spm = 1;%move to maximum within mask i2(8mm sphere around group avg peak)
                matlabbatch{v}.spm.util.voi.roi{3}.sphere.move.global.mask = 'i2';
                matlabbatch{v}.spm.util.voi.roi{4}.mask.image = {[SPMsdir,'\',d(sub).name,'\mask.nii,1']};
                matlabbatch{v}.spm.util.voi.roi{4}.mask.threshold = 0.5;
                %matlabbatch{v}.spm.util.voi.expression = 'i1 & i3 & i4';
                %matlabbatch{v}.spm.util.voi.expression = 'i3 & i4'; %no contrast mask
                matlabbatch{v}.spm.util.voi.expression = 'i3 & i4';
            end
            
            spm_jobman('run',matlabbatch); %runs first unmasked
            
            for v=1:length(VOIs)
                matlabbatch{v}.spm.util.voi.expression = 'i1 & i3 & i4';
            end
            spm_jobman('run',matlabbatch); %then again to overwrite with F-contast mask if possible
        end
        %% DCM SPEC
        if specifyDCM==1
            errors=[];
            try
                load([SPMsdir,'\',d(sub).name,'\DCMrp\SPM.mat']); %load SPM
                
                VOIxY=[];
                
                load([SPMsdir,'\',d(sub).name,'\DCMrp\VOI_lCalc_1.mat']); %VOI structure.
                VOIxY=[VOIxY,xY];
                load([SPMsdir,'\',d(sub).name,'\DCMrp\VOI_lSPL_1.mat']);
                VOIxY=[VOIxY,xY];
                load([SPMsdir,'\',d(sub).name,'\DCMrp\VOI_rSPL_1.mat']);
                VOIxY=[VOIxY,xY];
                load([SPMsdir,'\',d(sub).name,'\DCMrp\VOI_lSFG_1.mat']);
                VOIxY=[VOIxY,xY];
                load([SPMsdir,'\',d(sub).name,'\DCMrp\VOI_rSFG_1.mat']);
                VOIxY=[VOIxY,xY];
                
                if isempty(DCMtemplate)
                    a=[1,1,1,0,0; %lCalc
                        1,1,1,1,0; %lSPL
                        1,1,1,0,1; %rSPL
                        0,1,0,1,1; %lSFG
                        0,0,1,1,1];%rSFG
                    
                    % a=[1,1,1,1,1; %lCalc
                    %    1,1,1,1,1; %lSPL
                    %    1,1,1,1,1; %rSPL
                    %    1,1,1,1,1; %lSFG
                    %    1,1,1,1,1];%rSFG
                    
                    b=[0,0,0,0,0;
                        0,0,0,0,0;
                        0,0,0,0,0;
                        0,0,0,0,0;
                        0,0,0,0,0];
                    %b(:,:,1)=[0,0,0,0,0;0,0,0,0,0;0,0,0,0,0;0,0,0,0,0;0,0,0,0,0]; %WM
                    % b(:,:,2)=[0,0,0,0,0;0,0,0,0,0;0,0,0,0,0;0,0,0,0,0;0,0,0,0,0];
                    % b(:,:,2)=[1,1,1,0,0;
                    %           1,1,1,1,0;
                    %           1,1,1,0,1;
                    %           0,1,0,1,1;
                    %           0,0,1,1,1]; %T2
                    % b(:,:,2)=[1,1,1,1,1;
                    %           1,1,1,1,1;
                    %           1,1,1,1,1;
                    %           1,1,1,1,1;
                    %           1,1,1,1,1]; %T2
                    
                    c=[1;0;0;0;0]; %WM (first condition)
                    
                    s = struct();
                    s.name       = modelname;
                    s.u          = [1 1]';
                    s.delays     = [1.1 1.1 1.1 1.1];
                    s.TE         = 0.05;
                    s.nonlinear  = false;
                    s.two_state  = false;
                    s.stochastic = true;
                    s.centre     = true;
                    s.induced    = 0;
                    s.a          = a;
                    s.b          = b;
                    s.c          = c;
                    s.d          = []; %zeros(5,5,0); %five VOIs? results in empty array anyway?
                    
                else
                    load(DCMtemplate);
                    
                    s = struct();
                    s.name       = modelname;
                    s.u          = DCM.U.idx; %is this right? %[1 1]'; %this is the old one
                    s.delays     = DCM.delays;
                    s.TE         = DCM.TE;
                    s.nonlinear  = DCM.options.nonlinear;
                    s.two_state  = DCM.options.two_state;
                    s.stochastic = DCM.options.stochastic;
                    s.centre     = DCM.options.centre;
                    s.induced    = DCM.options.induced;
                    s.a          = DCM.a;
                    s.b          = DCM.b;
                    s.c          = DCM.c;
                    s.d          = DCM.d;
                end
                DCM = spm_dcm_specify(SPM,VOIxY,s);
                
                [SPMsdir,'\',d(sub).name,'\DCMrp\DCM_',s.name,'.mat']
                save([SPMsdir,'\',d(sub).name,'\DCMrp\DCM_',s.name,'.mat'],'DCM');
                
            catch
                errors=[errors;[SPMsdir,'\',d(sub).name]];
            end
            
        end
        
    end
    %% estiate DCMs
    if estimateDCM==1
        p = gcp('nocreate');
        if isempty(p)
            disp('No parallel pool is running. Starting 4 workers...');
            parpool(4)
        else
            disp('Parallel pool already running.');
            disp(p);
        end
        parfor sub=3:length(d)
            if ~isempty(dir([SPMsdir,'\',d(sub).name,'\DCMrp\DCM_',modelname,'.mat']))
                [SPMsdir,'\',d(sub).name,'\DCMrp\DCM_',modelname,'.mat']
                spm_dcm_estimate([SPMsdir,'\',d(sub).name,'\DCMrp\DCM_',modelname,'.mat']);
            end
        end
    end
    
    
end