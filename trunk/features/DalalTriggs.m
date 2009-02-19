function result = DalalTriggs(image_file , width , length , scale )
%% intializations
binsize = 9;
gradkernel = [-1 0 1];
cellsize = 25;
blocksize = 2;
bins=linspace( -pi/2 , pi/2 , binsize+1);
originalImage = imresize(imread(image_file) , scale );
width = ceil( width * scale);
length = ceil(length * scale);
originalsize = size(originalImage);
if( size(originalsize,2) > 2 )
    grayImageFile = rgb2gray( originalImage );
else
    grayImageFile = originalImage;
end
if( size(grayImageFile , 1) < length || size(grayImageFile , 2) < width )
    result = [];
    return
end
image = prepareImage (im2double(grayImageFile) , width , length);
%% gamma normalization
c = 1;
gamma = 0.6;
image = c .* image .^ 0.8;
image = image ./ (max(max(image))-min(min(image)));
%% guassian smoothing -- better to be removed decreases significancy
sigma = 3;
width = 3 * sigma;
support = -width : width;
gauss2D = exp( - (support / sigma).^2 / 2); 
gauss2D = gauss2D / sum(gauss2D);
%image = conv2(conv2(image, gauss2D, 'same'), gauss2D', 'same');
%% [-1 0 1] kernel gradient computation
dx = conv2(image , gradkernel , 'same');
dy = conv2(image , gradkernel' , 'same');
gradimage = sqrt( dx .^ 2 + dy .^ 2);
%% orientation and spatial binning
epmatrix = ones(size(dx)) .* eps;
dx = dx + epmatrix;
orientation = atan(dy ./ dx);
fun = @processHistogram;
cellBinImage = myblkproc( orientation , gradimage , cellsize , cellsize , 0 , 0 , fun , bins );
%% block normalization
L2normfun = @(x) x ./sqrt( ( sum(sum( x .^ 2)) + eps  ) );
blocknormalized = blkproc(cellBinImage , [blocksize * binsize , blocksize * binsize ] , L2normfun );
result = blocknormalized;
end

%% process histograms
function result = processHistogram( orientation , weight , bins)
    result = zeros(1 , size(bins,2)-1 );
    oo=reshape(orientation , 1 , size(orientation,1) * size(orientation,2));
    ww=reshape(weight , 1 , size(weight,1) * size(weight,2));
    for i=1 : size(bins,2)-1
        index = find( oo >= bins(i) & oo < bins(i+1) );
        result(i) = result(i)+sum(ww(index));
    end
end


%% prepare image
function croppedImage = prepareImage( image , width , length)
    [m  n] = size(image);
    xcrop = ceil((n-width)/2);
    ycrop = ceil((m-length)/2);
    croppedImage = image( ycrop+1 : m-ycrop , xcrop+1 : n-xcrop );
end