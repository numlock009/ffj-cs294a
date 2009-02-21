function [img] = to_gray_double(im)
% convert to grayscale and double
if ndims(img) > 2
  img = im2double(rgb2gray(im));
else
  img = im2double(im);
end
