function processStudy(inputPath, outputPath, decaesConfig)
%%process each patient folder in inputPath
patientDirs = dir(inputPath);
patientDirs = patientDirs([patientDirs.isdir]); % Filter to keep only directories
patientDirs = patientDirs(~ismember({patientDirs.name}, {'.', '..'})); % Remove '.' and '..'

%%setup decaes config file
dConfig = readlines(decaesConfig);
dConfig(1) = [];
dConfig(end) = [fullfile(outputPath,'decaestmp')];

for i = 1:length(patientDirs)
    % Process each patient directory
    patientDir = fullfile(inputPath, patientDirs(i).name);
    %%process each scan in each patient directory
    scanDirs = dir(patientDir);
    scanDirs = scanDirs([scanDirs.isdir]); % Filter to keep only directories
    scanDirs = scanDirs(~ismember({scanDirs.name}, {'.', '..'})); % Remove '.' and '..'
    %%make patient output directory
    patientIDtokens = regexp(patientDir,'^.*?(-)(.*)$','tokens');
    patientID = patientIDtokens{1}{2}; % Extract patient ID from tokens
    patientDirOut = fullfile(outputPath,patientID);
    mkdir(patientDirOut);

    parfor j = 1:length(scanDirs)
        % Process each scan directory
        % Run decaes based on settins file
        % OUTPUT PATH MUST BE LAST PARAMETER IN SETTINS FILE
        scanDir = fullfile(patientDir, scanDirs(j).name);
        [~, scanID] = fileparts(scanDir);
        scanDirOut = fullfile(patientDirOut,scanID);
        mkdir(scanDirOut);
        niftiwrite(dicomto4d(scanDir), fullfile(scanDirOut,patientID+"."+scanID+".nii"));
        decaes(char(fullfile(scanDirOut,patientID+"."+scanID+".nii")),'@C:\Users\chb0055\Documents\decaes\settings.txt','--output', char(scanDirOut));
        t2maps = load(fullfile(scanDirOut,patientID+"."+scanID+".t2maps.mat"));
        niftiwrite(t2maps.ggm, fullfile(scanDirOut,patientID+"."+scanID+".T2_map.nii"));
        niftiwrite(t2maps.alpha, fullfile(scanDirOut,patientID+"."+scanID+".flip_angle_map.nii"));
    end
end
disp("Finished Succesfully");
end