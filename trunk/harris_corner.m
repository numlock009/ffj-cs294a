function [corners, R] = harris_corner(img, threshold, k, w_width, sigma, ...
                                      derivative, max_type)

R = harris_corner_matrix(img, k, w_width, sigma, derivative);

% Eliminate pixels around the border, since convolution does not produce
% valid values there
border = floor((1 + w_width)/2);
bordermask = zeros(size(R));
bordermask(border+1:end-border,border+1:end-border) = 1;

maxes = local_max_matrix(max_type, R, 2 * border + 1);

% find the corners
corners = (R > max(R(:)) * threshold) & maxes & bordermask;

[ycoord xcoord] = find(corners);

corners = [xcoord ycoord];
