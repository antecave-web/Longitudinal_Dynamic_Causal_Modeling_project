
f='E:\Brainchild\DCM_2025\models\GLM\T1\bc0004\DCMrp\DCM_WM_5nodes_rp.mat';
DCMe=load(f);
%gcm={DCMe;DCMe;DCMe};
gcm={f;f;f};
N=length(gcm);

%%
M = struct();
M.alpha = 1;
M.beta  = 16;
M.hE    = 0;
M.hC    = 1/16;
M.Q     = 'all';
%%
M.Xnames={'Constant','Time'};
M.X(:,1)=ones(N,1); %const
M.X(1:N,2)=[0,2,4]; %time 
M.X(:,2)=meancenter(M.X(:,2)); % centering gives average change over time independent of baseline differences in group PEB?
field='All';
%%
%check for meancentering
for i=2:size(M.X,2)
    if ~(mean(M.X(:,i))<0.001)
        disp('Warning: covariate not centered')
    else
        disp('M.X is centered')
    end
end

PEB=spm_dcm_peb(gcm,M,field);

save(['E:\Brainchild\DCM_2025\models\DCM\PEB_test.mat'],'PEB');

spm_dcm_peb_review(PEB,DCMe);