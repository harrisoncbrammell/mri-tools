function data = dicomto4d(path)
   %create list of 3d dicom files ordering based on name (expects 1.dcm,
   %2.dcm, etc as produced by Siemens MRI scanners in the Auburn MRI Lab
   files = natsort(dir(fullfile(path, '*.dcm')).names);
   numFiles = length(files);

   %create 4d data array based on size of a first 3d dicom array
   [x, y, z] = size(double(squeeze(dicomread(fullfile(path, files(1).name)))));
   data = double(zeros(x,y,z,numFiles));

   for i = 1:numFiles
       filePath = fullfile(directoryPath, files(i).name);
       dicom = squeeze(dicomread(filePath));
       data(:, :, :, i) = dicom;
   end
end

function sortedNames = natsort(fileNames)
    % Natural sort function to sort file names numerically
    [~, sortedIndices] = sort(str2double(regexp(fileNames, '\d+', 'match', 'once')));
    sortedNames = fileNames(sortedIndices);
end