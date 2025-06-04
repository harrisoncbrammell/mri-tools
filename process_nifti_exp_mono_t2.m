function process_nifti_exp_mono_t2(inputnii, inputmask, outputpath, et)
%this function takes a nifti file and processes it using mono_t2 method,
%saves the processed nifti to outputpath
%must be in working directory of qMRLab v2.4.2 (only tested version)
%requires parrell computing toolbox

%checking if valid nifti input was supplied
if ~exist('inputnii','file')
    disp("Error: No valid input nifti file path provided");
    disp("Usage: process_nifti_exp_mono_t2(inputimagenii, inputmasknii, outputniipath, echotimecolomnvector)");
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

%creating the data struct, loading data from nifti, 
data = struct();
data.SEdata = double(load_nii_data(inputnii));
if exist('inputmask','var')
    data.Mask=double(load_nii_data(inputmask))l
end

%checks if output path exhists and if not specifies current directory
%fitting data and saving file
fit_results = ParFitData(data, Model);
if ~exist('outputpath', 'dir')
    outputpath = pwd;
end
FitResultsSave_nii(fit_results,inputnii,outputpath);

end