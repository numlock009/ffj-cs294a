images = {'9300HarrisCorners.jpg'};

n = size(images, 1);
threshold = 0.2; % is the threshold compared to the maximum value
                  %  0.2 comes from the KRYSTIAN MIKOLAJCZYK AND CORDELIA SCHMID paper
k = 0.04;
sigma = 1.5;
w_width = 2 * sigma; 

for i = 1:n
  figure('Name', images{i});
  img = imread(images{i});
  imshow(img);
  hold on;
  axis off;
  img_keypts = harris_laplace(img, threshold, k, sigma);
  draw_pts(img_keypts);
  draw_circles(img_keypts);
end

% for i = 1:n
%   figure('Name', images{i});
%   img = imread(images{i});
%   imshow(img);
%   hold on;
%   axis off;
%   img_keypts = kp_harrislaplace(img);
%   draw_pts(img_keypts);
%   draw_circles(img_keypts);
% end