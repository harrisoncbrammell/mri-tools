function nii3to4d(imagein)
s = size(imagein);
out = cell(1,s(3));
mkdir("./3d_niis/");
%cd("./3d_niis/");
for i = 1:s(3)
    slice = imagein(:,:,i,:);
    out{i} = slice;
    niftiwrite(slice,"./3d_niis/slice_"+i+".nii");
end
end