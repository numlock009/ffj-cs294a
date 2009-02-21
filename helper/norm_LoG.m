function [norm_LoG] = norm_LoG(img, scaled_sigma, furthest_std)

img_height = size(img,1);
img_width = size(img,2);
num_scales = size(scaled_sigma, 2);

norm_LoG = zeros(img_height,img_width, num_scales);

for i = 1:num_scales
  local_sigma = scaled_sigma(i);
  scaled_width = floor(2*furthest_std*local_sigma + 1); % go furthest standard deviations away up or down
  norm_LoG(:,:,i) = local_sigma*local_sigma*...
      imfilter(img, ...
               fspecial('log', scaled_width, local_sigma),...
               'replicate');
end

