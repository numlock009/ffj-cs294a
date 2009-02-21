function [ pimage ] = prepare_image( image_file )
% prepares image for doing all image processing stuff -- makes a double
% black and white image
img = imread(image_file);
if ndims(img) <= 2 
  pimage =  im2double( img );
else
  pimage = im2double( rgb2gray(img) );
end
