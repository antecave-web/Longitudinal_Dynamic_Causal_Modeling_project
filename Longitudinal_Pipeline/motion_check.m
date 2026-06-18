% --- USER INPUT ---
path='E:\Brainchild\Round 1\T1 Imaging Data\Data_nifti\';
%path='E:\Brainchild\backup from jan 2014 disk\Round 2\raw_data_analyse\';
%path='E:\Brainchild\backup from jan 2014 disk\Round 3\raw_data_analyse\';

subs=dir([path,'bc*']);
out={};

noFig=1; %option to suppress figures
for sub=1:length(subs);
datadir=[path,'\',subs(sub).name];


files=recursiveDir(datadir, 'rp_*.txt');

fd_thresh = 0.5;                   % Framewise displacement threshold (mm)
radius = 50;                       % Brain radius in mm (for FD calculation) Power et al., 2012 (https://www.sciencedirect.com/science/article/pii/S1053811911011815)

%rp_matrix concatenator:
motion=[0,0,0,0,0,0];
for i=1:length(files)
   rp=load(files(i).fullpath);
   rp = rp + repmat(motion(end,:), size(rp,1), 1);
   motion=[motion;rp]; 
end

%for i=1:length(files)

% --- LOAD REALIGNMENT PARAMETERS ---
%motion = load(rp_file);

trans = motion(:, 1:3);                 % [x y z] translations (mm)
rot = motion(:, 4:6);                   % [pitch roll yaw] in radians
rot_deg = rad2deg(rot);                % Convert rotation to degrees

% --- COMPUTE FRAMEWISE DISPLACEMENT ---
fd_trans = [0; sqrt(sum(diff(trans).^2, 2))];   % mm
fd_rot = [0; sqrt(sum(diff(rot).^2, 2))];       % radians
fd_total = fd_trans + (radius * fd_rot);        % mm

% --- DETECT OUTLIERS ---
outlier_idx = find(fd_total > fd_thresh);
outlier_flag = fd_total > fd_thresh;

% --- DISPLAY SUMMARY ---
fprintf('\n=== MOTION SUMMARY ===\n');
fprintf('Max translation: %.2f mm\n', max(max(abs(trans))));
fprintf('Max rotation: %.2f deg\n', max(max(abs(rot_deg))));
fprintf('Mean FD: %.4f mm\n', mean(fd_total));
fprintf('Max FD: %.4f mm\n', max(fd_total));
fprintf('Volumes above %.2f mm FD: %d / %d\n', fd_thresh, numel(outlier_idx), length(fd_total));

if noFig==0
% --- PLOT TRANSLATION & ROTATION ---
figure('Position', [100 100 1000 500]);
subplot(3,1,1);
plot(trans, 'LineWidth', 1.5); grid on;
legend({'X', 'Y', 'Z'}); ylabel('Translation (mm)');
title('Translation Parameters');

subplot(3,1,2);
plot(rot_deg, 'LineWidth', 1.5); grid on;
legend({'Pitch', 'Roll', 'Yaw'}); ylabel('Rotation (°)');
xlabel('Scan'); title('Rotation Parameters');

% --- PLOT FRAMEWISE DISPLACEMENT WITH THRESHOLD ---
subplot(3,1,3);
plot(fd_total, 'k', 'LineWidth', 1.5); hold on;
line(xlim, [fd_thresh fd_thresh], 'Color', 'r', 'LineStyle', '--', 'LineWidth', 1.2);
scatter(outlier_idx, fd_total(outlier_idx), 40, 'r', 'filled');
xlabel('Scan'); ylabel('FD (mm)');
title(sprintf('Framewise Displacement (threshold: %.2f mm)', fd_thresh));
grid on;
end
% --- SAVE TO CSV ---
out_table = table((1:length(fd_total))', fd_total, outlier_flag, 'VariableNames', {'Volume', 'FD_mm', 'IsOutlier'});
%out_csv = strrep(rp_file, '.txt', '_FD.csv');
out_csv = [datadir,'\','motion_summary_concatenated_FD.csv'];
writetable(out_table, out_csv);
fprintf('Saved FD report to: %s\n', out_csv);

%  disp('Press any key to continue...');
%      waitforbuttonpress;
%  key = get(gcf, 'CurrentCharacter');
 
 out{sub,1}=subs(sub).name;
 out{sub,2}=max(max(abs(trans)));%max trans
 out{sub,3}=max(max(abs(rot_deg)));%max rot
 out{sub,4}=mean(fd_total);%mean FD
 out{sub,5}=max(fd_total);%max FD
 out{sub,6}=numel(outlier_idx)/length(fd_total);% percent outliers
end