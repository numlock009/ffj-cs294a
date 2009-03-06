function blockfeature = HoG_sunny(filename)
%read image data
image = im2double(rgb2gray(imread(filename)));
% cell = 100 * 100
% block = 200 * 200
cell = 200;%
block = 4;
%height = 128;
%width = 64;
%image = image(1:height, 1:width);
height = size(image, 1);
width = size(image, 2);
%size(im)
%imshow(im);

%%gamma normalization
c = 0.9;
gamma = 0.8;
image = c .* image .^ gamma;
image = image ./ (max(max(image))-min(min(image)));

%% guassian smoothing
sigma = 1;
widthg = 3 * sigma;
support = -widthg : widthg;
gauss2D = exp( - (support / sigma).^2 / 2); 
gauss2D = gauss2D / sum(gauss2D);
%image = conv2(conv2(image, gauss2D, 'same'), gauss2D', 'same');

%% [-1 0 1] kernel gradient computation
gradkernel = [-1 0 1];
eps = 0.0000001;
dx = conv2(image , gradkernel , 'same') + eps;
dy = conv2(image , gradkernel' , 'same');
%magnitude
gradimage = sqrt( dx .^ 2 + dy .^ 2);
%orientation
oriimage = atan(dy ./ dx);
%cell
bin_num = 9;
bins=linspace( -pi/2 , pi/2 , bin_num+1);
histogram = zeros(bin_num, floor(height/cell), floor(width/cell));
for bin = 1:bin_num
    gradori = (oriimage >= bins(bin) & oriimage < bins(bin+1)).*gradimage;
    for i = 1:1:height/cell
        for j = 1:1:width/cell
            histogram( bin, i, j ) = sum(sum(gradori(i*cell - 7:i*cell, j*cell - 7:j*cell)));
        end
    end 
end
blockfeature = zeros(bin_num*block*block, floor(height/cell)-1, floor(width/cell)-1);
for i = 1:1:height/cell - 1
    for j = 1:1:width/cell - 1
        vn = sqrt(sum(histogram(  :,i, j) .^ 2) + sum(histogram( :, i, j+1 ) .^ 2) + sum(histogram( :, i+1, j ) .^ 2) + sum(histogram( :, i+1, j+1 ) .^ 2) + eps ^ 2);
        blockfeature(1:bin_num , i, j) = histogram(:, i, j) / vn;
        blockfeature(bin_num+1:2*bin_num, i, j ) = histogram(:, i, j+1) / vn;
        blockfeature(bin_num*2+1:3*bin_num, i, j ) = histogram(:, i+1, j) / vn;
        blockfeature(bin_num*3+1:4*bin_num, i, j ) = histogram(:, i+1, j+1) / vn;            
    end
end 
blockfeature=reshape(blockfeature, 1, 1, bin_num*block*block * (floor(height/cell)-1) * (floor(width/cell)-1) );




