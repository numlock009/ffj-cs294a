% sigma is the initial sigma
% threshold is our threshold for picking corners
% k is the k used to calculate the corner matrix
% 
% returns corners with [x, y, scale]       x is the column, y is the row
% scale is the scale at which we found the corner
% 
% referenced: 
% http://www.robots.ox.ac.uk/~vgg/research/affine/det_eval_files/mikolajczyk_ijcv2004.pdf
% http://www.ece.lsu.edu/gunturk/EE7700/Lecture_feature2.ppt
% and 
% http://www.mathworks.com/matlabcentral/fileexchange/17894
function [corners] = harris_laplace(img, threshold, k, sigma)
% convert to grayscale and double
if ndims(img) > 2
  img = im2double(rgb2gray(img));
else
  img = im2double(img);
end

img_height = size(img,1);
img_width = size(img,2);

scale_factor = 1.4; % Lindeberg, Lowe
s = 0.7; % KRYSTIAN MIKOLAJCZYK AND CORDELIA SCHMID paper
num_scales = 10; % i don't know why, 10 just seems strong
scaled_sigma = (scale_factor.^(0:num_scales-1)) * sigma;
furthest_std = 3;

max_type = 'window'; % 'regular' 'disk'
harris_pts = zeros(0, 3);

% scale normalized laplacian of gaussian
norm_LoG = zeros(img_height,img_width,num_scales);
for i = 1:num_scales
  local_sigma = scaled_sigma(i);
  int_sigma  = s * local_sigma;
  scaled_width = floor(2*furthest_std*local_sigma + 1); % go furthest standard deviations away up or down
  
  % corners go by col x row
  corners = harris_corner(img, threshold, k,  ...
                          scaled_width, ...
                          local_sigma, ...
                          gaussderiv(furthest_std, int_sigma), ...
                          max_type);
  
  % harris_pts row, col, scale
  harris_pts(end+1:end + size(corners, 1), :) = ...
      [corners(:, 2), ...
       corners(:, 1), ...
       repmat(i, [size(corners,1), 1])];
  
  norm_LoG(:,:,i) = local_sigma*local_sigma*...
      imfilter(img, ...
               fspecial('log', scaled_width, local_sigma),...
               'replicate');
end

% decompose this to another function?
% check if at harris points
% the Laplacian of Gaussian attains a maximum at the
% scale of the point
pt = 0;
corners = zeros(size(harris_pts,1), 3);
for i=1:size(harris_pts,1)
  r = harris_pts(i, 1); % y_location
  c = harris_pts(i, 2); % x_location
  pt_scale = harris_pts(i, 3);
  pt_laplacian = norm_LoG(r, c, pt_scale);

  % accept if norm_LoG of pt scale is bigger then
  % the scale above and below.
  if(pt_scale < num_scales)
    above_LoG = norm_LoG(r, c, pt_scale+1);
  else
    above_LoG = 'noneabove';
  end
  if(pt_scale > 1)
    below_LoG = norm_LoG(r, c, pt_scale-1);
  else
    below_LoG = 'nonebelow';
  end  
  
  if((isequal('noneabove', above_LoG) || pt_laplacian > above_LoG) ...
     && (isequal('nonebelow', below_LoG) || pt_laplacian > below_LoG))
    pt = pt + 1;
    corners(pt, 1) = c; % x location
    corners(pt, 2) = r; % y location
    corners(pt, 3) = furthest_std * pt_scale; % for displaying the circle
                                              % around the point
  end
end
corners(pt+1:end, :)=[]; % clear off space that didn't make it
