

f1='E:\Brainchild\Chantal backup stuff\fMRI_behavioural\eprime_logfiles_BC_round1_Original\';
f2='E:\Brainchild\Chantal backup stuff\fMRI_behavioural\eprime_logfiles_BC_round2_Clean\';
%identical file structures

%arrow.RES = response, Facit = correct response.
%Cue1.onset is first time in file, ITI.offset is last. difference between them is ~4.8 minutes
%TR=3000ms, 96 volumes = 4.8 minutes.
%so first reported onset is at 0 seconds. (remove it from all timings to make it correct)
%%


% MATLAB script to create names, onsets, durations for SPM (grouped)

% Load the data

% files=dir([f1,'\VSWM*.xlsx']);
% cd('E:\Brainchild\DCM_2025\timings\T1');
files=dir([f2,'\VSWM*.xls']);
cd('E:\Brainchild\DCM_2025\timings\T2');


for i=1:length(files)

filename = fullfile(files(i).folder, files(i).name);
data = readtable(filename, 'Sheet', 'Sheet1');

% Extract columns
allNames   = data.Details;
allOnsets  = data.Cue1_OnsetTime;  % MATLAB replaces '.' with '_' in variable names

% Adjust onsets so first onset is zero
allOnsets = allOnsets - allOnsets(1);
% Adjust onsets sto seconds
allOnsets = allOnsets/1000;

% Define conditions
conditions = {'Control2','Control4','WM2','WM4'};
durValues  = [8, 10, 8, 10]; % durations for each condition

% Initialize outputs
names = cell(1, numel(conditions));
onsets = cell(1, numel(conditions));
durations = cell(1, numel(conditions));

% Loop over conditions and group onsets
for c = 1:numel(conditions)
    thisCond = strcmp(allNames, conditions{c});
    names{c} = conditions{c};
    onsets{c} = allOnsets(thisCond);
    durations{c} = repmat(durValues(c), sum(thisCond), 1);
end

% Save variables for SPM
%save([files(i).name(1:end-5),'.mat'], 'names', 'onsets', 'durations'); %for f1
save([files(i).name(1:end-4),'.mat'], 'names', 'onsets', 'durations'); %for f2


end

%%
% f3='E:\Brainchild\Chantal backup stuff\fMRI_behavioural\eprime_logfiles_BC_round3_CorrectTrialsOnsets';
% %grab onsets directly from here
% scripts=dir([f3,'\VSWM*.m']);
% cd('E:\Brainchild\Chantal backup stuff\fMRI_behavioural\eprime_logfiles_BC_round3_CorrectTrialsOnsets');
% for i=1:150
%     run(      fullfile(scripts(i).folder, scripts(i).name)     )
% end



%output folders: 
% 'E:\Brainchild\DCM_2025\timings\T1'
% 'E:\Brainchild\DCM_2025\timings\T2'
% 'E:\Brainchild\DCM_2025\timings\T3'

%durations:
%8s for '2' conds, 10s for '4' conds.