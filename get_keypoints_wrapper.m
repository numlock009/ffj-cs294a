function [keypts] = get_keypoints_wrapper(img)
% harris_laplace keypoints
threshold = 0.005; % is the threshold compared to the maximum value
k = 0.04;
sigma = 1.5;
% w_width = 2 * sigma; 
keypts = harris_laplace(img, threshold, k, sigma);

% sift keypoints
% keypts = sift_keypts(img);
