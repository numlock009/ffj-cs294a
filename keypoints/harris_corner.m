function [corners, R] = harris_corner(img, threshold, k, w_width, sigma, ...
                                      derivative)

R = harris_corner_matrix(img, k, w_width, sigma, derivative);

% Eliminate pixels around the border, since convolution does not produce
% valid values there
border = floor((1 + w_width)/2);
bordermask = zeros(size(R));
bordermask(border+1:end-border,border+1:end-border) = 1;

maxes = local_max_matrix(R, border);

max_vals = zeros(size(R));
max_vals(maxes) = R(maxes);
% find the corners
corners = (max_vals > max(R(:)) * threshold) & bordermask;

[ycoord xcoord] = find(corners);

corners = [xcoord ycoord];
