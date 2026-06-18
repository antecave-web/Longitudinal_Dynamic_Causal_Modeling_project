function files = recursiveDir(basePath, pattern)
% basePath='E:\Nieves_pilot\data';
% pattern='rp_*.txt';

%     if nargin < 2
%         pattern = '*';
%     end

    % Initialize output
    files = struct('name',{},'date',{},'bytes',{},'isdir',{},'datenum',{},'fullpath',{});
    %currentFiles = struct('name',{},'date',{},'bytes',{},'isdir',{},'datenum',{},'fullpath',{});
    deeperFiles = struct('name',{},'date',{},'bytes',{},'isdir',{},'datenum',{},'fullpath',{});
    %files = struct([]);

    % --- Get files in current directory ---
    currentFiles = dir(fullfile(basePath, pattern));
    currentFiles = currentFiles(~[currentFiles.isdir]);  % Remove folders
    if isempty(currentFiles)
        currentFiles = struct('name',{},'date',{},'bytes',{},'isdir',{},'datenum',{},'fullpath',{});
        %currentFiles().fullpath=[];
    end
    
    % Add fullpath field manually to all files in the current directory
    for i = 1:numel(currentFiles)
        currentFiles(i).fullpath = fullfile(basePath, currentFiles(i).name);
    end

    % Concatenate current files to the output files
    
    files = [files; currentFiles];

    % --- Recurse into subdirectories ---
    subdirs = dir(basePath);
    subdirs = subdirs([subdirs.isdir]);  % Keep only folders
    subdirs = subdirs(~ismember({subdirs.name}, {'.', '..'}));  % Exclude . and ..

    for i = 1:numel(subdirs)
        subPath = fullfile(basePath, subdirs(i).name);
        deeperFiles = recursiveDir(subPath, pattern);  % Get files in subdir

        % Only concatenate non-empty deeperFiles
        if ~isempty(deeperFiles)
            % Ensure that deeperFiles have the fullpath field
            for j = 1:numel(deeperFiles)
                if ~isfield(deeperFiles(j), 'fullpath')
                    deeperFiles(j).fullpath = fullfile(subPath, deeperFiles(j).name);
                end
            end

            % Concatenate deeperFiles with current files (only if deeperFiles is valid)
            files = [files; deeperFiles]; %#ok<AGROW>
        end
    end
end