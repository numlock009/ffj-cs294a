function [ pimage ] = prepare_image( image_file )
% prepares image for doing all image processing stuff -- makes a double
% black and white image
image = imread(image_file);
if ndims(image) <= 2 
   pimage =  im2double( image );
else
    pimage = im2double( rgb2gray(image) );
end
