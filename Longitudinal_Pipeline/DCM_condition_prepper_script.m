%BRAINCHILD 2025, run this then DCM_seup_script to create 1st lvl DCMs
%script for concatenating timeseries Y and combining Load 2 & 4 WM conditions for use during DCM spec.
spm_jobman('initcfg');

SPMdirs={'E:\Brainchild\DCM_2025\models\GLM\T1'
    'E:\Brainchild\DCM_2025\models\GLM\T2'
    'E:\Brainchild\DCM_2025\models\GLM\T3'};

for t=1:3
    SPMsdir=SPMdirs{t};



    d=dir(SPMsdir);

    for sub=3:length(d)
        t
        d(sub).name
        load([SPMsdir,'\',d(sub).name,'\SPM.mat']);

        nsess=length(SPM.Sess);

        Ynii=transpose({SPM.xY.VY.fname});

        U=struct();
        T2=[];
        WMonsets=[];
        WMdurations=[];
        lastsessfilenum=0;
        for i=1:nsess
            lastsessfilenum=lastsessfilenum+length(SPM.Sess(i).row);
            % s=strsplit(SPM.xY.VY(lastsessfilenum).fname,'\');
            % if strcmp(s{4},'MRI APPS DICOM T2 2014') || strcmp(s{4},'MRI DICOM T2 2015')
            %     %we are in a T2 session
            %     %T2=[T2;ones(length(Ynii)/nsess,1)];
            %     T2=[T2;ones(length(SPM.Sess(i).row),1)];
            % else
            %     %T1 sess
            %     %T2=[T2;zeros(length(Ynii)/nsess,1)];
            %     T2=[T2;zeros(length(SPM.Sess(i).row),1)];
            % end

            for ii=3:4 % WM2 & WM4 only
                WMonsets=[WMonsets;SPM.Sess(i).U(ii).ons+((i-1)*(length(SPM.Sess(i).row)*3))]; %adds session times to onsets as well (TR=3)
                WMdurations=[WMdurations;SPM.Sess(i).U(ii).dur];

            end

            if i==1 % concats the U.u matrix and combines conditions 3 and 4 over all sesion.
                U(1).u=SPM.Sess(i).U(3).u+SPM.Sess(i).U(4).u;
            else
                U(1).u=[U(1).u;SPM.Sess(i).U(3).u+SPM.Sess(i).U(4).u];
            end
        end
        %sorts WM onsets and durations
        [WMonsets,I]=sort(WMonsets);
        WMdurations = WMdurations(I);

        % create onset and duratio for T2 condition
        %count 0s * 2.2s and then 1s *2.2s

        % T2onset=(length(T2)-sum(T2))*2.2;
        % T2duration=sum(T2)*2.2;



        %%  old ugly cond combiner
        %     WMcond=zeros(length(SPM.xX.X),1);% reset
        %     for cn=0:nsess-1 %loop through sessions and add WM2 and WM4
        %         %WMcond=WMcond+SPM.xX.X(:,cn*10+3)+SPM.xX.X(:,cn*10+4);
        %         WMcond=WMcond+SPM.xX.X(:,cn*10+3);
        %     end
        %% New Nice cond convolver
        %-Number of scans for this session
        %----------------------------------------------------------------------
        %k = SPM.nscan(sess#);
        k=sum(SPM.nscan); %for all sessions concatenate

        %-Create convolved stimulus functions or inputs
        %======================================================================

        %-Get inputs, neuronal causes or stimulus functions U
        %----------------------------------------------------------------------
        %U = spm_get_ons(SPM,sess); %sess= session from loop

        U(1).name={'WM'};
        U(1).ons=WMonsets(:);
        U(1).dur=WMdurations(:);
        U(1).orth=1;
        U(1).P.name='none';U(1).P.h=0;U(1).P.i=1;
        U(1).dt=0.1375;

        try
            fMRI_T     = SPM.xBF.T;
            fMRI_T0    = SPM.xBF.T0;
        catch
            fMRI_T     = spm_get_defaults('stats.fmri.t');
            fMRI_T0    = spm_get_defaults('stats.fmri.t0');
            SPM.xBF.T  = fMRI_T;
            SPM.xBF.T0 = fMRI_T0;
        end
        %-Convolve stimulus functions with basis functions
        %----------------------------------------------------------------------
        [X,Xn,Fc] = spm_Volterra(U, SPM.xBF.bf, SPM.xBF.Volterra);

        %-Resample regressors at acquisition times (32 bin offset)
        %----------------------------------------------------------------------
        if ~isempty(X)
            X = X((0:(k - 1))*fMRI_T + fMRI_T0 + 32,:);
        end

        %-Orthogonalise (within trial type)
        %----------------------------------------------------------------------
        for i = 1:length(Fc)
            if i<= numel(U) && ... % for Volterra kernels
                    (~isfield(U(i),'orth') || U(i).orth)
                p = ones(size(Fc(i).i));
            else
                p = Fc(i).p;
            end
            for j = 1:max(p)
                X(:,Fc(i).i(p==j)) = spm_orth(X(:,Fc(i).i(p==j)));
            end
        end

        %%      VOI extractor, this will be done on the concatenated SPM in the next script instead
        % VOIs={'lCalc',[-8 -90 -4]
        %     'lSPL',[-18 -70 62]
        %     'rSPL',[20 -72 58]
        %     'lSFG',[-26 -4 50]
        %     'rSFG',[28 6 64]};
        % 
        % for v=1:length(VOIs)
        %     matlabbatch{v}.spm.util.voi.spmmat = {[SPMsdir,'\',d(sub).name,'\SPM.mat']};
        %     matlabbatch{v}.spm.util.voi.adjust = NaN; %0=no,Fcon index,NaN=everything
        %     matlabbatch{v}.spm.util.voi.session = Inf; %sess#
        %     matlabbatch{v}.spm.util.voi.name = VOIs{v,1};
        %     matlabbatch{v}.spm.util.voi.roi{1}.spm.spmmat = {''};
        %     matlabbatch{v}.spm.util.voi.roi{1}.spm.contrast = 1;
        %     matlabbatch{v}.spm.util.voi.roi{1}.spm.conjunction = 1;
        %     matlabbatch{v}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
        %     matlabbatch{v}.spm.util.voi.roi{1}.spm.thresh = 0.05;
        %     matlabbatch{v}.spm.util.voi.roi{1}.spm.extent = 0;
        %     matlabbatch{v}.spm.util.voi.roi{1}.spm.mask = struct('contrast', {}, 'thresh', {}, 'mtype', {});
        %     matlabbatch{v}.spm.util.voi.roi{2}.sphere.centre = VOIs{v,2};
        %     matlabbatch{v}.spm.util.voi.roi{2}.sphere.radius = 10;
        %     matlabbatch{v}.spm.util.voi.roi{2}.sphere.move.fixed = 1;
        %     matlabbatch{v}.spm.util.voi.roi{3}.sphere.centre = VOIs{v,2}; %could be 0 0 0, but set to maximum for safety
        %     matlabbatch{v}.spm.util.voi.roi{3}.sphere.radius = 4;
        %     matlabbatch{v}.spm.util.voi.roi{3}.sphere.move.global.spm = 1;%move to maximum within mask i2(8mm sphere around group avg peak)
        %     matlabbatch{v}.spm.util.voi.roi{3}.sphere.move.global.mask = 'i2';
        %     matlabbatch{v}.spm.util.voi.roi{4}.mask.image = {[SPMsdir,'\',d(sub).name,'\mask.nii,1']};
        %     matlabbatch{v}.spm.util.voi.roi{4}.mask.threshold = 0.5;
        %     matlabbatch{v}.spm.util.voi.expression = 'i1 & i3 & i4';
        % end
        % 
        % spm_jobman('run',matlabbatch);
        % 
        % 
        % % Loads VOI files and concatenate them
        % cY={}; %reset cY
        % for v=1:length(VOIs)
        % 
        %     dd=dir([SPMsdir,'\',d(sub).name,'\VOI_',VOIs{v,1},'*.mat']);
        % 
        %     cYtemp=[]; %reset cYtemp
        %     for iii=1:length(dd)
        %         load([SPMsdir,'\',d(sub).name,'\',dd(iii).name]); %loads Y, xY
        %         cYtemp=[cYtemp;Y]; %concat Y
        %     end
        %     cY{1,v}=cYtemp;
        % end

        %% Save outputs
        save([SPMsdir,'\',d(sub).name,'\DCM_conditions_concat.mat'],'Ynii','U','X');
        % cY=struct of concatenated VOI data for all VOIs.
        % Ynii=List of volume file paths.
        % U=condition structure, including onsets and durations.
        % X=convolved model from onsets and durations.
        % T2=condition/covariate vector, 0s for T1(before training) 1s for T2(after training)
        % T2nset/duration is T2 for 1st lvl SPM generation assuming one continuous block of 1s at end of vector.
    end

end