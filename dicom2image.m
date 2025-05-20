function [image] = dicom2image(filename, color)
if nargin < 2 %default color selected if not specified
    color = 'gray';
end
fig = figure('Visible', 'off'); %explicitly create hidden fig for imagesc
a = double(dicomread(filename));
imagesc(axes(fig), a); colorbar; colormap(color);
image = fig;
end
