% finds the harris corner matrix for each pixel in the image
% normally make k = 0.04
% sigma = 1
% w_width - effective size of windows being examined for corners
% 
% dx = tells us what kind of gradient mask we have.

function R = harris_corner_matrix(img, k, w_width, sigma, dx)
% images: Convert image to type double and to grayscale
% we assume the image has already been loaded.
% and assume the following step has already been done;
% if ndims(img) > 2
%   im = im2double(rgb2gray(img));
% else
%   im = im2double(img);
% end

% dx = gradient mask
% gaussian = x exp( - x^2/ ( 2 sig^2 )) /( sig sig sig root(2pi))
% original = [-1 0 1];
% dx = [-1 0 1];
% prewitt  = [-1 0 1; -1 0 1; -1 0 1];
% sobel    = [-1 0 1; -2 0 2; -1 0 1];
% roberts  = [0 1 1; -1 0 1; -1 -1 0];
dy = dx';

%Ix = conv2(img, dx, 'same');
%Iy = conv2(img, dy, 'same');
Ix = do_conv(img , dx);
Iy = do_conv( img , dy);

% for the gaussian smoothing around points.
% this is our window function
G = fspecial('gaussian', w_width, sigma);

% compute the harris corner matrix M at each point of the image.
%A = conv2(Ix.^2, G, 'same');
A = do_conv( Ix .^ 2 , G);
%B = conv2(Iy.^2, G, 'same');
B = do_conv( Iy .^ 2 , G);
%C = conv2(Ix.*Iy, G, 'same');
C = do_conv( Ix .* Iy , G);

det_M = (A.*B)-(C.^2);
tr_M = A + B;
R = det_M - (k * (tr_M.^2));
