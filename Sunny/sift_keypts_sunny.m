function keyptsor = sift_keypts_sunny(filename)
%read image%%%%%%%%%%%%%%%%
if (size(filename, 1) == 1)
    img = imread(filename);
else
    img = filename;
end
%img = img;
if ndims(img) > 2
    img = im2double(rgb2gray(img));
else
    img = im2double(img);
end
[height, width] = size(img);
[M, N] = size(img);
%equalization
img = img - min(img(:));
if max(img(:)) ~= 0
    img = img / max(img(:));
else
    img = img;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%parameters%%%%%%%%%%%%%%%%
S      =  3 ;
omin   = -1 ;
O      = floor(log2(min(M,N)))-omin-3 ; % Octave
sigma0 = 1.6*2^(1/S) ;                  % initial sigma
sigman = 0.5 ;
k = 2^(1/S) ;
dsigma0 = sigma0 * sqrt(1 - 1/k^2) ; % Scale step factor
sigman  = 0.5 ;                      % Nominal smoothing of the image
smin = -1;
smax = S+1;
%thresh = 0.04 / S / 2 ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%double size img to get more details about DoG%%%%%%%%%%%%%%%%
image = zeros(2*height, 2*width);
image(1:2:end,1:2:end) = img;
image(2:2:end-1,2:2:end-1) = ...
0.25*img(1:end-1,1:end-1) + ...
0.25*img(2:end,1:end-1) + ...
0.25*img(1:end-1,2:end) + ...
0.25*img(2:end,2:end) ;
image(2:2:end-1,1:2:end) = ...
0.5*img(1:end-1,:) + ...
0.5*img(2:end,:) ;
image(1:2:end,2:2:end-1) = ...
0.5*img(:,1:end-1) + ...
0.5*img(:,2:end) ;
image(end, 1:2:end) = img(end, :);
image(end, 2:2:end) = img(end, :);
image(1:2:end, end) = img(:, end);
image(2:2:end, end) = img(:, end);
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Octave 1%%%%%%%%%%%%%%%%%%%%%%%%%%
[M, N] = size(image);
o=1;
SS.octave{1} = zeros(M,N,smax-smin+1) ;
wsize = 64 / 2 ^ o;
gaussian = fspecial('gaussian', wsize, sqrt( (sigma0*k^smin)^2  - (sigman/2^omin)^2) );
SS.octave{1}(:,:,1)  = imfilter(image, gaussian, 'replicate');
for s=smin+1:smax
dsigma = k^s * dsigma0 ;
gaussian = fspecial('gaussian', wsize, dsigma );
SS.octave{1}(:,:,s + 2) = imfilter(image, gaussian, 'replicate');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Octave 2-Omax%%%%%%%%%%%%%%%%%%%%%%%%%%
for o=2:O
    wsize = 64 / 2 ^ o;
    sbest = min(smin + S, smax) ;
    timg = SS.octave{o-1}(1:2:end,1:2:end,sbest+2);
    [M,N] = size(timg) ;
    target_sigma = sigma0 * k^smin ;
    prev_sigma = sigma0 * k^(sbest - S) ;
    SS.octave{o} = zeros(M,N,smax-smin+1) ;
    if(target_sigma > prev_sigma)
        gaussian = fspecial('gaussian', wsize, sqrt(target_sigma^2 - prev_sigma^2) );
        SS.octave{o}(:,:,1)  = imfilter(timg, gaussian, 'replicate');
    else
        SS.octave{o}(:,:,1)  = timg;
    end
    for s=smin+1:smax
    % The other levels are determined as above for the first octave.
        dsigma = k^s * dsigma0 ;
        gaussian = fspecial('gaussian', wsize, dsigma );
        SS.octave{o}(:,:,s + 2) = imfilter(timg, gaussian, 'replicate');
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for o=1:O
    [M,N,newS] = size(SS.octave{o}) ;
    dss.octave{o} = zeros(M,N,newS-1) ;
    for s=1:newS-1
        dss.octave{o}(:,:,s) = SS.octave{o}(:,:,s+1) - SS.octave{o}(:,:,s) ;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Show gaussian and dog%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%figure(101)
%for o=1:O
%    for s=1:newS
%        subplot(O, newS, (o-1)*newS+s), imshow( SS.octave{o}(:,:,s) );
%    end
%end
%figure(102)
%for o=1:O
%    for s=1:newS-1
%        subplot(O, newS-1, (o-1)*(newS-1)+s), ...
%            imshow( ( dss.octave{o}(:,:,s) - min( min (dss.octave{o}(:,:,s)) ) ) / ...
%            ( max( max (dss.octave{o}(:,:,s)) ) - min( min (dss.octave{o}(:,:,s)) ) ) );
%    end
%end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for o=1:O
    for s=1:newS-1
        maxdss{o}(:, :, s) = ordfilt2(dss.octave{o}(:,:,s), 9, true(3));
        mindss{o}(:, :, s) = ordfilt2(dss.octave{o}(:,:,s), 1, true(3));
        maxdss2{o}(:, :, s) = ordfilt2(dss.octave{o}(:,:,s), 8, true(3));
        mindss2{o}(:, :, s) = ordfilt2(dss.octave{o}(:,:,s), 2, true(3));
    end
end
%get keypoints%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mythresh = 0.0001;
count = 0;
keypts = [];
edge = 32; %remove boundary points
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for o=1:O
    for s=2:newS-2
        for m = 1 + 1 + edge / 2^o: size( dss.octave{o}(:,:,s) , 1) - edge / 2^o
            for n = 1 + 1 + edge / 2^o: size( dss.octave{o}(:,:,s) , 2) - edge / 2^o
                if ( dss.octave{o}(m,n,s) >= maxdss{o}(m, n, s-1) + mythresh && ...
                     dss.octave{o}(m,n,s) >= maxdss2{o}(m, n, s) + mythresh && ...
                     dss.octave{o}(m,n,s) >= maxdss{o}(m, n, s+1) + mythresh )
                    count = count + 1;
                    strcat('max o=', num2str(o, '%d'), ' s=', num2str(s, '%d'), ' m=', num2str(m, '%d'), ' n=', num2str(n, '%d'));
                    keypts = [keypts; [m, n, o, s, 1, 0]];
                end
                if ( dss.octave{o}(m,n,s) <= mindss{o}(m, n, s-1) - mythresh && ...
                     dss.octave{o}(m,n,s) <= mindss2{o}(m, n, s) - mythresh && ...
                     dss.octave{o}(m,n,s) <= mindss{o}(m, n, s+1) - mythresh )
                    count = count + 1;
                    strcat('min o=', num2str(o, '%d'), ' s=', num2str(s, '%d'), ' m=', num2str(m, '%d'), ' n=', num2str(n, '%d'));
                    keypts = [keypts; [m, n, o, s, 1, 0]];
                end
            end
        end
    end
end
count;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Interpolation of nearby data for accurate position? has problems on this
%part. not used here
% remove high edge response points, not used here.
% 50*50 could not get many points. so we reserve these and do k-means
% cluster
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%dx = [-1 0 1];
%dy = dx';

%Dx = conv2(dss.octave{o}(:,:,s), dx, 'same');
%Dy = conv2(dss.octave{o}(:,:,s), dy, 'same');

%Dxx = conv2(Dx, dx, 'same');
%Dyy = conv2(Dy, dy, 'same');

%Dxy = conv2(Dx, dy, 'same');
%Dyx = conv2(Dy, dx, 'same');
%Det = Dxx .* Dyy - Dxy .* Dyx;
%Trace = ( Dxx + Dyy) ^ 2;
%R = Trace ./ Det;
%r = 10;
%R > (r+1)^2/r; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:size(keypts,  1)
    x = keypts(i, 1);
    y = keypts(i, 2);
    o = keypts(i, 3);
    s = keypts(i, 4);
    region = SS.octave{o}(x-4:x+3,y-4:y+3,s);
    %no gaussian smooth useless
    gradkernel = [-1 0 1];
    dx = conv2( region , gradkernel  , 'same') + eps;
    dy = conv2( region , gradkernel' , 'same');
    gradreg = sqrt( dx.^2 + dy.^2 );
    %wsize = 16; dsigma = 2;
    %gaussian = fspecial('gaussian', wsize, dsigma );
    %gradreg = gradreg .* gaussian;
    orireg = atan( dy./dx );

    bin_num = 8;%8 is ok for relative rotation, 36 is useless.
    bins=linspace( -pi/2 , pi/2 , bin_num+1);
    histogram = zeros(bin_num, 1);
    for bin = 1:bin_num
        index = find( orireg >= bins(bin) & orireg < bins(bin+1) );
        histogram(bin) = sum(gradreg(index));
    end
    [mv, mi] = max(histogram);
    keypts(i, 5) = mi;%orientation for keypoint
end
%tic another way to calculate histogram
%for bin = 1:bin_num
%    gradmix = (orireg >= bins(bin) & orireg < bins(bin+1)).*gradreg;
%    histogram( bin ) = sum(sum(gradmix));
%end
%toc

%save to original points%%%%%%%%%%%
keyptsor = keypts;
for i = 1:size(keypts,  1)
    o = keypts(i, 3);
    keyptsor(i, 1) = 2^(o-2) * keypts(i, 1);
    keyptsor(i, 2) = 2^(o-2) * keypts(i, 2);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%