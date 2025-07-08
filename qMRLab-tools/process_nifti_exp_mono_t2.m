function process_nifti_exp_mono_t2(inputnii, inputmask, outputpath, et, t2, m0, snr)
%this function takes a nifti file and processes it using mono_t2 method,
%saves the processed nifti to outputpath
%must be in working directory of qMRLab v2.4.2 (only tested version)
%requires parrell computing toolbox

%help page if no args provided
if nargin < 1
  disp("Too few arguments!");
  disp("Usage: process_nifti_exp_mono_t2(inputimagenii, inputmasknii, outputniipath, echotimecolomnvector)");
  return;
end

%checking if valid nifti input was supplied
if ~exist(inputnii,'file')
    error("Error: No valid input nifti file path provided");
end

%creating mono_t2 model object from qmrlab
run("startup.m");
Model = mono_t2;

%default echo times set if not provided (10 ms spaced pulses for 70 ms)
%then setting the echotime in the mono_t2 model object
if ~exist('et','var')
    et = transpose([10:10:70]);
end
Model.Prot.SEdata.Mat = [ et ];
Model.saveObj(fullfile(outputpath, 'mono_t2_config.qmrlab.mat')); % REMOVE IN PRODUCTION

%creating the data struct, loading data from nifti,
data = struct();
data.SEdata = double(load_nii_data(inputnii));
if exist(inputmask,'file')
    data.Mask=double(load_nii_data(inputmask));
end
save(fullfile(outputpath, 'mono_t2_data.mat'), 'data'); % Save the data struct as a .mat file for later use

%checks if output path exhists and if not specifies current directory
%fitting data and saving file
fit_results = ParFitData(data, Model);
if ~exist(outputpath, 'dir')
    outputpath = pwd;
end
FitResultsSave_nii(fit_results,inputnii,outputpath);

%run simulations and save output to png
%single voxel curve
x = struct();
x.T2 = 100;
x.M0 = 1000;
Opt.SNR = 50;
svcfig = figure('Name','Single Voxel Curve Simulation','Visible','off');
FitResultsvc = Model.Sim_Single_Voxel_Curve(x,Opt);
title("Single Voxel Curve");
saveas(svcfig, fullfile(outputpath, 'single_voxel_curve.jpg'));
savefig(svcfig, fullfile(outputpath, 'single_voxel_curve.fig'));
% Close the single voxel curve figure to free up resources
close(svcfig);

%Sensitivity Analysis
OptTable.st = [1e+02         1e+03]; % nominal values
OptTable.fx = [0             1]; %vary T2...
OptTable.lb = [1             1]; %...from 1
OptTable.ub = [3e+02         1e+04]; %...to 300
Opt.SNR = 50;
Opt.Nofrun = 5;
SimResults = Model.Sim_Sensitivity_Analysis(OptTable,Opt);
sensfig = figure('Name','Sensitivity Analysis','Visible','off');
SimVaryPlot(SimResults, 'T2' ,'T2' );
saveas(sensfig, fullfile(outputpath, 'sensitivity_curve.png'));
savefig(sensfig, fullfile(outputpath, 'sensitivity_curve.fig'));

end