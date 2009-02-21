function [centroid_features] = generate_features(points_files, varargin)
p = inputParser;
p.KeepUnmatched = true;
p.addRequired('points_files', @iscell);
p.addOptional('type', @(x)any(strcmpi(lower(x),{'sift', 'rift', 'spin'})));
p.addParamValue('k', 2000, @(x) x>1);
p.addParamValue('max_points', 100, @(x) x>0);
p.parse(points_files, varargin{:});
k = p.Results.k;
max_points = p.Results.max_points;

for fs = 1:size(points_files, 2)
  fid = fopen( points_files{fs} , 'r');
  index = 1 ;
  while(true)
    fname = fscanf(fid, '%s', 1);
    if(isempty(fname)), break, end;
    m = fscanf( fid , '%d' , [1 2] );
    keypoints = fscanf(fid , '%d' , m);
    keypoints = reshape(keypoints, [m(2) m(1)])';
    for j = 1 : min(max_points, size(keypoints, 1))
      descriptor = get_descriptors(prepare_image( fname ), varargin{:}, ...
                                                 'pt', keypoints(j,:));
      features(index, :) = descriptor(:)'; % same as reshaping into a 1xsize1*size2 vector
      index = index+1;
    end
  end
  fclose(fid);
end

centroid_features = kmeans(min(k, max(8, floor(size(features, 1)/8))), features);
