subjects={};

% X = [1, time_days];      % column1 intercept, column2 slope
design=;

for s = 1:3
    DCM{s} = specify_DCM(subject, session=s, ROIs, design);   % VOI extraction + model spec
    DCM{s} = estimate_DCM(DCM{s});                            % spm_dcm_estimate or GUI
end


PEB = specify_PEB(DCM, X, nuisance_covariates);  % create PEB structure
PEB = estimate_PEB(PEB);                         % fit hierarchical model
PEB = bayesian_model_reduction(PEB);             % prune non-important effects


contrast = [0 1];  % test slope
results = test_PEB_contrast(PEB, contrast);
report(results);   % parameters showing evidence of change with time