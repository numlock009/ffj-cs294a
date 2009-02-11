% finds the harris corner poitns
% normally make k = 0.04
% sigma = 1
% w_width - effective size of windows being examined for corners
% threshold should be greater than 0, determines the cutoff point for
% being a corner


function [corners] = harris_corner(img, threshold, k, w_width, sigma)
% Convert image to type double and to grayscale if needed.
% assume the image has already been loaded.
if ndims(img) > 2
  im = im2double(rgb2gray(img));
else
  im = im2double(img);
end

% gradient masks
% original = [-1 0 1];
% prewitt  = [-1 0 1; -1 0 1; -1 0 1];
% sobel    = [-1 0 1; -2 0 2; -1 0 1];
% roberts  = [0 1 1; -1 0 1; -1 -1 0];
dx = [-1 0 1];
dy = dx';

Ix = conv2(im, dx, 'same');
Iy = conv2(im, dy, 'same');

% for the gaussian smoothing around points.
% this is our window function
G = fspecial('gaussian', w_width, sigma);

% compute the harris corner matrix M at each point of the image.
A = conv2(Ix.^2, G, 'same');
B = conv2(Iy.^2, G, 'same');
C = conv2(Ix.*Iy, G, 'same');

det_M = (A.*B)-(C.^2);
tr_M = A + B;
R = det_M - (k * (tr_M.^2));

% Eliminate pixels around the border, since convolution does not produce
% valid values there
border = (1 + w_width)/2;
bordermask = zeros(size(R));
bordermask(border+1:end-border,border+1:end-border) = 1;

radius = 2 * border + 1;
maxes = ordfilt2(R, radius^2, ones(radius));  % find the maxes of R in a radius
                                              % of the width

% find the corners
corners = (R > threshold) & (R == maxes) & bordermask;
[ycoord xcoord] = find(corners);

corners = [xcoord ycoord];
