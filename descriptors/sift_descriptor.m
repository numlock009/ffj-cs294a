function descriptor = sift_descriptor(img, keyptsor)
%get the feature vector for this image%%%%%%%%%%%%%%%%
for index = 1:size(keyptsor, 1)
    x = floor(keyptsor(index, 1));
    y = floor(keyptsor(index, 2));
    shift = round(keyptsor(index, 5));
    if (x == 0 || y == 0)
        x = floor(keyptsor(index, 1));
        y = floor(keyptsor(index, 2));
        shift = 1;
    end
    bin_num = 8;
    bins=linspace( -pi/2 , pi/2 , bin_num+1);
    region = img(x-8:x+7, y-8:y+7);
    gradkernel = [-1 0 1];
    dx = conv2( region , gradkernel  , 'same') + eps;
    dy = conv2( region , gradkernel' , 'same');
    gradreg = sqrt( dx.^2 + dy.^2 );
    %wsize = 16; dsigma = 2;
    %gaussian = fspecial('gaussian', wsize, dsigma );
    %gradreg = gradreg .* gaussian;
    orireg = atan( dy./dx );

    histogram = zeros(bin_num, 4, 4);

    for bin = 1:bin_num
        gradori = (orireg >= bins(bin) & orireg < bins(bin+1)).*gradreg;
        for i = 1:4
            for j = 1:4
                histogram( bin, i, j ) = sum(sum(gradori(i*4 - 3:i*4, j*4 - 3:j*4)));
            end
        end
    end
    histogramsf = circshift(histogram, -shift+1);
    feature = histogramsf(:);
    featurenor = ( feature - mean(feature(:)) ) ./ std(feature);
    descriptor(index, :) = [featurenor; 0]';
end