addpath('../keypoints', '../helper');

images = {'9300HarrisCorners.jpg'};

n = size(images, 1);
threshold = 0.005; % is the threshold compared to the maximum value
                  %  0.2 comes from the KRYSTIAN MIKOLAJCZYK AND CORDELIA SCHMID paper
k = 0.04;
sigma = 1.5;
w_width = 2 * sigma; 

t0 = clock;
for i = 1:n
  figure('Name', images{i});
  img = imread(images{i});
  imshow(img);
  hold on;
  axis off;
  img_keypts = harris_laplace(to_gray_double(img), threshold, k, sigma);
  draw_pts(img_keypts);
  draw_circles(img_keypts);
end
tmine = etime(clock, t0) * 1000

t0 = clock;
for i = 1:n
  figure('Name', [images{i}, 'online']);
  img = imread(images{i});
  imshow(img);
  hold on;
  axis off;
  img_keypts = kp_harrislaplace(img);
  draw_pts(img_keypts);
  draw_circles(img_keypts);
end
t_kp = etime(clock, t0) * 1000