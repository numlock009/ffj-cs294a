function [img] = to_gray_double(imgfile)
img = imread(imgfile);
% convert to grayscale and double
if ndims(img) > 2
  img = im2double(rgb2gray(img));
else
  img = im2double(img);
end
